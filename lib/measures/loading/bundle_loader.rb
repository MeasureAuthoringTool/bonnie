module Measures
  
  # Utility class for loading measure definitions into the database from MITRE bundles
  class BundleLoader 

    def self.load(bundle_path, username, measures_yml=nil, load_from_hqmf=false)
      user = User.by_username(username).first
      measures = []
      Dir.mktmpdir do |tmp_dir|
        measures = load_bundle(user, bundle_path, tmp_dir, load_from_hqmf, measures_yml)
      end
      measures
    end

    def self.load_bundle(user, bundle_path, tmp_dir, load_from_hqmf, measures_yml)

      # remove existing code_sets directory
      FileUtils.rm_r Measures::Loader::VALUE_SET_PATH if File.exist? Measures::Loader::VALUE_SET_PATH
      FileUtils.mkdir_p(Measures::Loader::VALUE_SET_PATH)

      measure_root = File.join('sources','*','*')
      value_set_root = File.join('value_sets','xml')

      Zip::ZipFile.open(bundle_path) do |zip_file|

        value_set_entries = zip_file.glob(File.join(value_set_root,'**.xml'))
        value_set_entries.each do |vs_entry|
          vs_entry.extract(File.join(Measures::Loader::VALUE_SET_PATH,Pathname.new(vs_entry.name).basename.to_s))
        end
        puts "copied XML for #{value_set_entries.count} value sets to #{Measures::Loader::VALUE_SET_PATH}"

        if (measures_yml.nil?)
          puts "finding measure yml by version"
          measures_yml = find_measure_yml(zip_file)
          raise "no measure yml file could be found" if measures_yml.nil?
        end
        measure_details_hash = parse_measures_yml(measures_yml)

        measure_root_entries = zip_file.glob(File.join('sources','*','*'))
        measure_root_entries.each_with_index do |measure_entry, index|
          measure = load_measure(zip_file, measure_entry, user,tmp_dir, load_from_hqmf, measure_details_hash)
          puts "(#{index+1}/#{measure_root_entries.count}): measure #{measure.measure_id} successfully loaded from #{load_from_hqmf ? 'HQMF' : 'JSON'}"
        end
      end
    end

    def self.load_measure(zip_file, measure_entry, user, tmp_dir, load_from_hqmf, measure_details_hash)

      hash = Digest::MD5.hexdigest(measure_entry.to_s)
      outdir = File.join(tmp_dir, hash)
      FileUtils.mkdir_p(outdir)

      hqmf_path = extract_entry(zip_file, measure_entry, outdir, 'hqmf1.xml')
      html_path = extract_entry(zip_file, measure_entry, outdir, '*.html')
      json_path = extract_entry(zip_file, measure_entry, outdir, '*.json')

      hqmf_set_id = HQMF::Parser.parse_fields(File.read(hqmf_path),HQMF::Parser::HQMF_VERSION_1)['set_id']
      measure_details = measure_details_hash[hqmf_set_id]

      if (load_from_hqmf)
        value_set_models = Measures::Loader.get_value_sets_from_hqmf(hqmf_path)
        measure = Measures::Loader.load(user, hqmf_path, value_set_models, measure_details)
      else
        measure_json = JSON.parse(File.read(json_path), max_nesting: 250)
        hqmf_model = HQMF::Document.from_json(measure_json)
        measure = Measures::Loader.load_hqmf_json(measure_json, user, hqmf_model.all_code_set_oids, measure_details)
      end

      Measures::Loader.save_sources(measure, hqmf_path, html_path)

#      Measures::ADEHelper.update_if_ade(measure)
      measure.populations.each_with_index do |population, population_index|
        measure.map_fns[population_index] = HQMF2JS::Generator::Execution.logic(measure, population_index, true, false)
      end

      measure.save!
      measure

    end

    private

    def self.parse_measures_yml(measures_yml)
      YAML.load_file(measures_yml)['measures']
    end

    def self.find_measure_yml(zip_file)
      bundle_entry = zip_file.glob('bundle.json').first
      version = JSON.parse(bundle_entry.get_input_stream.read)['version']
      file = "config/measures/measures_#{version.gsub('.','_')}.yml"
      if File.exists?(file)
        puts "using measures details from: #{file}"
        file
      end 
    end

    def self.extract_entry(zip_file, measure_entry, outdir, qualifier)
      entry = zip_file.glob(File.join(measure_entry.to_s,qualifier)).first
      path = File.join(outdir,Pathname.new(entry.name).basename.to_s)
      entry.extract(path)
      path
    end

  end

end