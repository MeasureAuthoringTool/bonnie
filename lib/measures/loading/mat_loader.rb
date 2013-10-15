module Measures
  # Utility class for loading measure definitions into the database
  class MATLoader 

    SOURCE_PATH = File.join(".", "db", "measures")
    
    def self.load(files, username)
      user = User.by_username(username).first
      Dir.mktmpdir do |dir|
        data = load_mat_exports(user, files, dir)
      end
    end

    def self.load_mat_exports(user, files, dir)
        files.each do |file|
          Zip::ZipFile.open(file.path) do |zip_file|

            hqmf_entry = zip_file.glob(File.join('**','**.xml')).select {|x| x.name.match(/.*eMeasure.xml/) && !x.name.starts_with?('__MACOSX') }.first
            html_entry = zip_file.glob(File.join('**','**.html')).select {|x| x.name.match(/.*HumanReadable.html/) && !x.name.starts_with?('__MACOSX') }.first
            xls_entry = zip_file.glob(File.join('**','**.xls')).select {|x| !x.name.starts_with?('__MACOSX') }.first

            fields = HQMF::Parser.parse_fields(hqmf_entry.get_input_stream.read, HQMF::Parser::HQMF_VERSION_1)
            measure_id = fields['id']

            out_dir=File.join(dir, measure_id)
            FileUtils.mkdir_p(out_dir)

            hqmf_path = extract(zip_file, hqmf_entry, out_dir)
            html_path = extract(zip_file, html_entry, out_dir)
            xls_path = extract(zip_file, xls_entry, out_dir)

# AQ: NEED TO FIGURE OUT APP_CONFIG
#            measure_data = fields.merge(APP_CONFIG["measures"][fields['set_id']]) if APP_CONFIG["measures"][fields['set_id']]
#           If we need to pull from vsac then we need to first parse and load the measure codes
#            oids = {measure.hqmf_id => measure.as_hqmf_model.all_code_set_oids} unless (xls_path)

            # handle value sets
            value_set_models = Measures::MATLoader.load_value_sets_from_xls(xls_path)
            Measures::Loader.save_value_sets(value_set_models)

            measure = Measures::Loader.load(user, hqmf_path, value_set_models, html_path=nil)
            puts "measure #{measure.measure_id} successfully loaded."

          end
        end

    end

    def self.extract(zip_file, entry, out_dir) 
      out_file = File.join(out_dir,Pathname.new(entry.name).basename.to_s)
      zip_file.extract(entry, out_file)
      out_file
    end

    def self.load_value_sets_from_xls(value_set_path)
      value_set_parser = HQMF::ValueSet::Parser.new()
      value_sets = value_set_parser.parse(value_set_path)
      value_sets
    end
    

  end

end
