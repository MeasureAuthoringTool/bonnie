module Measures
  # Utility class for loading measure definitions into the database
  class Loader

    SOURCE_PATH = File.join(".", "db", "measures")
    
    def self.load(user, hqmf_path, value_set_models)
      
      hqmf_contents = Nokogiri::XML(File.new hqmf_path).to_s
      measure_id = HQMF::Parser.parse_fields(hqmf_contents, HQMF::Parser::HQMF_VERSION_1)['id']

      codes_by_oid = HQMF2JS::Generator::CodesToJson.from_value_sets(value_set_models)  if value_set_models

      # Parsed HQMF
      measure = Measures::Loader.load_hqmf(hqmf_contents, user, codes_by_oid)

      measure
    end


    def self.load_hqmf(hqmf_contents, user, codes_by_oid)
      hqmf = HQMF::Parser.parse(hqmf_contents, HQMF::Parser::HQMF_VERSION_1, codes_by_oid)
      # go into and out of json to make sure that we've converted all the symbols to strings, this will happen going to mongo anyway if persisted
      json = JSON.parse(hqmf.to_json.to_json, max_nesting: 250)

      measure_oids = codes_by_oid.keys if codes_by_oid
      Measures::Loader.load_hqmf_json(json, user, measure_oids)
    end

    def self.load_hqmf_json(json, user, measure_oids)

      measure = Measure.new
      measure.user = user

      measure.id = json["hqmf_id"]
      measure.measure_id = json["id"]
      measure.hqmf_id = json["hqmf_id"]
      measure.hqmf_set_id = json["hqmf_set_id"]
      measure.hqmf_version_number = json["hqmf_version_number"]
      measure.cms_id = json["cms_id"]
      measure.title = json["title"]
      measure.description = json["description"]
      measure.measure_attributes = json["attributes"]
      measure.populations = json['populations']
      measure.value_set_oids = measure_oids

      metadata = APP_CONFIG["measures"][measure.hqmf_set_id] if APP_CONFIG['measures']
      if metadata
        measure.type = metadata["type"]
        measure.category = metadata["category"]
        measure.episode_of_care = metadata["episode_of_care"]
        measure.continuous_variable = metadata["continuous_variable"]
        measure.episode_ids = metadata["episode_ids"]
        puts "\tWARNING: Episode of care does not align with episode ids existance" if ((!measure.episode_ids.nil? && measure.episode_ids.length > 0) ^ measure.episode_of_care)
        if (measure.populations.count > 1)
          sub_ids = ('a'..'az').to_a
          measure.populations.each_with_index do |population, population_index|
            sub_id = sub_ids[population_index]
            population_title = metadata['subtitles'][sub_id] if metadata['subtitles']
            measure.populations[population_index]['title'] = population_title if population_title
          end
        end
        measure.custom_functions = metadata["custom_functions"]
        measure.force_sources = metadata["force_sources"]
      else
        measure.type = "unknown"
        measure.category = "Miscellaneous"
        measure.episode_of_care = false
        measure.continuous_variable = false
        puts "\tWARNING: Could not find metadata for measure: #{measure.hqmf_set_id}"
      end

      measure.population_criteria = json["population_criteria"]
      measure.data_criteria = json["data_criteria"]
      measure.source_data_criteria = json["source_data_criteria"]
      puts "\tCould not find episode ids #{measure.episode_ids} in measure #{measure.measure_id}" if (measure.episode_ids && measure.episode_of_care && (measure.episode_ids - measure.source_data_criteria.keys).length > 0)
      measure.measure_period = json["measure_period"]
      measure
    end
    
    def self.save_sources(measure, hqmf_path, html_path, xls_path=nil)
      # Save original files
      if (html_path)
        html_out_path = File.join(SOURCE_PATH, "html")
        FileUtils.mkdir_p html_out_path
        FileUtils.cp(html_path, File.join(html_out_path,"#{measure.hqmf_id}.html"))
      end
      
      if (xls_path)
        value_set_out_path = File.join(SOURCE_PATH, "value_sets")
        FileUtils.mkdir_p value_set_out_path
        FileUtils.cp(xls_path, File.join(value_set_out_path,"#{measure.hqmf_id}.xls"))
      end
      
      hqmf_out_path = File.join(SOURCE_PATH, "hqmf")
      FileUtils.mkdir_p hqmf_out_path
      FileUtils.cp(hqmf_path, File.join(hqmf_out_path, "#{measure.hqmf_id}.xml"))
    end

    def self.save_value_sets(value_set_models)
      loaded_value_sets = HealthDataStandards::SVS::ValueSet.all.map(&:oid)
      value_set_models.each { |vsm| vsm.save! unless loaded_value_sets.include? vsm.oid }
    end

    def self.get_value_sets(hqmf_path)
        original_stdout = $stdout
        $stdout = StringIO.new
        begin
          measure = Measures::Loader.load(nil, hqmf_path, nil)
        ensure
          $stdout = original_stdout
        end
        value_set_oids = measure.as_hqmf_model.all_code_set_oids
        HealthDataStandards::SVS::ValueSet.in(oid: value_set_oids)
    end
  end
end
