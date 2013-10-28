module Measures
  
  # Utility class for loading measure definitions into the database from MITRE bundles
  class BundleLoader 

    SOURCE_PATH = File.join(".", "db", "measures")
    VALUE_SET_PATH = File.join(".", "db", "value_sets")
    
    def self.load(bundle_path, username, measure_details)
      user = User.by_username(username).first
      measures = []
      Dir.mktmpdir do |tmp_dir|
        measures = load_bundle(user, bundle_path, tmp_dir, measure_details)
      end
      measures
    end

    def self.load_bundle(user, bundle_path, tmp_dir, measure_details)

      paths = Set.new
      type = nil
      json_draft_measures = true

      # remove existing code_sets directory
      FileUtils.rm_r VALUE_SET_PATH if File.exist? VALUE_SET_PATH
      FileUtils.mkdir_p(VALUE_SET_PATH)

      measure_root = File.join('sources','*','*')
      value_set_root = File.join('value_sets','xml')

      Zip::ZipFile.open(bundle_path) do |zip_file|
        # entries = zip_file.glob(File.join(source_root,'**.html')) + zip_file.glob(File.join(source_root,'**1.xml'))
        # entries += zip_file.glob(File.join(source_root,'**.json')) if json_draft_measures

        value_set_entries = zip_file.glob(File.join(value_set_root,'**.xml'))
        value_set_entries.each do |vs_entry|
          vs_entry.extract(File.join(VALUE_SET_PATH,Pathname.new(vs_entry.name).basename.to_s))
        end
        puts "copied XML for #{value_set_entries.count} value sets to #{VALUE_SET_PATH}"

        measure_root_entries = zip_file.glob(File.join('sources','*','*'))
        measure_root_entries.each_with_index do |measure_entry, index|
          measure = load_measure_from_hqmf(zip_file, measure_entry, user,tmp_dir)
          puts "(#{index+1},#{measure_root_entries.count}): measure #{measure.measure_id} successfully loaded from HQMF"
        end
      end


    end

    def self.load_measure_from_hqmf(zip_file, measure_entry, user, tmp_dir)

      hash = Digest::MD5.hexdigest(measure_entry.to_s)
      outdir = File.join(tmp_dir, hash)
      FileUtils.mkdir_p(outdir)

      hqmf_entry = zip_file.glob(File.join(measure_entry.to_s,'hqmf1.xml')).first
      hqmf_path = File.join(outdir,'hqmf1.xml')
      hqmf_entry.extract(hqmf_path)

      html_entry = zip_file.glob(File.join(measure_entry.to_s,'*.html')).first
      html_path = File.join(outdir,Pathname.new(html_entry.name).basename.to_s)
      html_entry.extract(html_path)

      json_entry = zip_file.glob(File.join(measure_entry.to_s,'*.json')).first
      json_path = File.join(outdir,Pathname.new(json_entry.name).basename.to_s)
      json_entry.extract(json_path)

      value_set_models = Measures::Loader.get_value_sets(hqmf_path)

      measure = Measures::Loader.load(user, hqmf_path, value_set_models)
      Measures::Loader.save_sources(measure, hqmf_path, html_path)

#      Measures::ADEHelper.update_if_ade(measure)
      measure.populations.each_with_index do |population, population_index|
        measure.map_fns[population_index] = HQMF2JS::Generator::Execution.logic(measure, population_index, true, false)
      end

      measure.save!
      measure

    end

  end

end