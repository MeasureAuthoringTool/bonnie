namespace :bonnie do
  namespace :fixtures do

    def get_measure(user, cms_hqmf, measure_id)
      if (cms_hqmf.downcase  == 'cms')  
        measure = user.measures.find_by(cms_id: measure_id)
      elsif (cms_hqmf == 'hqmf')
        measure = user.measures.find_by(hqmf_id: measure_id)
      else
        throw('Argument: "' + cms_hqmf + '" does not match expected: cms or hqmf') 
      end
      measure
    end

    def convert_times(json)
      if json.kind_of?(Hash)
        json.each_pair do |k,v|
          if k.ends_with?("_at")
            json[k] = Time.parse(v)
          end
        end
      end
    end

    def set_mongoid_ids(json)
      if json.kind_of?( Hash)
        json.each_pair do |k,v|
          if v && v.kind_of?( Hash )
            if v["$oid"]
              json[k] = BSON::ObjectId.from_string(v["$oid"])
            else
              set_mongoid_ids(v)
            end
          elsif k == '_id' || k == 'bundle_id' || k == 'user_id'
            puts "Converting #{k} : value #{v}"
            json[k] = BSON::ObjectId.from_string(v)   
            puts "Converted: #{k} to #{json[k]}"   
          end
        end
      end
    end
    
    def collection_fixtures(*collection_names)
      collection_names.each do |collection|
        collection_name = collection.split(File::SEPARATOR)[0]
        Mongoid.default_session[collection_name].drop
        Dir.glob(File.join(Rails.root, 'test', 'fixtures', collection, '*.json')).each do |json_fixture_file|
          fixture_json = JSON.parse(File.read(json_fixture_file))
          convert_times(fixture_json)
          set_mongoid_ids(fixture_json)
          # Mongoid names collections based off of the default_session argument.
          # With nested folders,the collection name is “records/X” (for example).
          # To ensure we have consistent collection names in Mongoid, we need to take the file directory as the collection name.
          puts "Inserting into collection #{collection}"
          Mongoid.default_session[collection_name].insert(fixture_json)
        end
      end
    end

    def create_fixture_file(file_path, fixture_json)
      FileUtils.mkdir_p(File.dirname(file_path)) unless Dir.exists? File.dirname(file_path)
      File.new(file_path, "w+")
      File.write(file_path, fixture_json)
    end

    ###
    # cms_hqmf: indicates if a CMS id or an HQMF id is used.
    #   values: cms, hqmf
    # path: Path to fixture files, derived from the data-type directories (EX: measure_data/${path}).
    # user_email: email of user to export
    # measure_id: id of measuer to export
    # bundle exec rake HDS:test:generate_frontend_fixtures[cms,test/CMSFakevFake,initialLoad,fake@fake,CMSFakevFake]
    ###
    task :generate_frontend_fixtures, [:cms_hqmf, :path, :user_email, :measure_id] => [:environment] do |t, args|
      user = User.find_by email: args[:user_email]
      measure = get_measure(user, args[:cms_hqmf], args[:measure_id])
      
      
      measure_summaries = UploadSummary::MeasureSummary.by_user_and_hqmf_set_id(user, measure.hqmf_set_id).desc(:created_at)
      archived_measures = ArchivedMeasure.by_user_and_hqmf_set_id(user, measure.hqmf_set_id)
      
      fixtures_path = File.join('spec', 'javascripts', 'fixtures', 'json')
      
      measure_file = File.join(fixtures_path, 'measure_data', args[:path], 'measures.json')
      create_fixture_file(measure_file, JSON.pretty_generate(JSON.parse([measure].to_json)))

      oid_to_vs_map = {}
      
      value_sets = measure.value_sets.each do |vs|
        oid_to_vs_map[vs.oid] = vs
      end

      records = Record.by_user_and_hqmf_set_id(user, measure.hqmf_set_id)
      record_file = File.join(fixtures_path, 'records', args[:path], "patients.json")
      create_fixture_file(record_file, JSON.pretty_generate(JSON.parse(records.to_json)))
      
      value_sets_file = File.join(fixtures_path, 'measure_data', args[:path], 'value_sets.json')
      create_fixture_file(value_sets_file, JSON.pretty_generate(JSON.parse(oid_to_vs_map.to_json)))
    
      upload_summaries_file = File.join(fixtures_path, 'upload_summaries', args[:path], "upload_summaries.json")
      create_fixture_file(upload_summaries_file, JSON.pretty_generate(JSON.parse(measure_summaries.to_json)))
    
      archived_measures_file = File.join(fixtures_path, 'archived_measures', args[:path], "archived_measures.json")
      arc_measures = []
      archived_measures.each do |am|
        arc_measures.push(am)
      end
      create_fixture_file(archived_measures_file, JSON.pretty_generate(JSON.parse(archived_measures.to_json)))
    end

    ###
    # cms_hqmf: indicates if a CMS id or an HQMF id is used.
    #   values: cms, hqmf
    # path: Path to fixture files, derived from the data-type directories (EX: measure_data/${path}).
    # user_email: email of user to export
    # measure_id: id of measuer to export
    # bundle exec rake HDS:test:generate_backend_fixtures[cms,test/CMSFakevFake,initialLoad,fake@fake,CMSFakevFake]
    ###
    desc "Exports a set of fixtures that can be loaded for testing purposes"
    task :generate_backend_fixtures, [:cms_hqmf, :path, :user_email, :measure_id] => [:environment] do |t, args|
      user = User.find_by email: args[:user_email]
      measure = get_measure(user, args[:cms_hqmf], args[:measure_id])
      
      measure_summaries = UploadSummary::MeasureSummary.by_user_and_hqmf_set_id(user, measure.hqmf_set_id).desc(:created_at)
      archived_measures = ArchivedMeasure.by_user_and_hqmf_set_id(user, measure.hqmf_set_id)
      
      fixtures_path = File.join('test', 'fixtures')
      
      measure_name = measure.cms_id + ".json"
      measure_file = File.join(fixtures_path, 'draft_measures', args[:path], measure_name)
      create_fixture_file(measure_file, JSON.pretty_generate(JSON.parse(measure.to_json)))

      records = Record.by_user_and_hqmf_set_id(user, measure.hqmf_set_id).each do |rec|
        rec_name = rec.first + "_" + rec.last + ".json"
        record_file = File.join(fixtures_path, 'records', args[:path], rec_name)
        create_fixture_file(record_file, JSON.pretty_generate(JSON.parse(rec.to_json)))
      end
      
      value_sets_file = File.join(fixtures_path, 'health_data_standards_svs_value_sets', args[:path], 'value_sets.json')
      create_fixture_file(value_sets_file, JSON.pretty_generate(JSON.parse(measure.value_sets.to_json)))
    
      upload_summaries_file = File.join(fixtures_path, 'upload_summaries', args[:path], "upload_summaries.json")
      create_fixture_file(upload_summaries_file, JSON.pretty_generate(JSON.parse(measure_summaries.to_json)))
    
      archived_measures_file = File.join(fixtures_path, 'archived_measures', args[:path], "archived_measures.json")
      arc_measures = []
      archived_measures.each do |am|
        arc_measures.push(am)
      end
      create_fixture_file(archived_measures_file, JSON.pretty_generate(JSON.parse(archived_measures.to_json)))
    end
    
    desc "Generates oid to valueset dictonary from directory"
    task :generate_oid_to_valuesets => [:environment] do 
      fileset_dir = File.join("test", "fixtures", "health_data_standards_svs_value_sets", ENV['fileset_dir'])
      output_dir = File.join("spec", "javascripts", "fixtures", "json", "measure_data", ENV['output_dir'])
      dict = {}
      Dir.glob(File.join(fileset_dir, "*.json")).each do |file|
        vs = JSON.parse(File.read(file))
        dict[vs['oid']] = vs
      end
      output = File.join(output_dir, "value_sets.json")
      File.new(output, "w+")
      File.write(output, JSON.pretty_generate(dict))
    end
    
    desc "Loads set of fixtures into a running instance of BONNIE"
    task :load_backend_fixtures, [:path] => [:environment] do |t, args|
      archived_measures_collection = File.join 'archived_measures', args[:path]
      measure_collection = File.join 'draft_measures', args[:path]
      value_sets_collection = File.join 'health_data_standards_svs_value_sets', args[:path]
      records_collection = File.join 'records', args[:path]
      upload_summaries_collection = File.join 'upload_summaries', args[:path]
      users_collection = File.join 'users', args[:path]
      collection_fixtures(archived_measures_collection, measure_collection, value_sets_collection, records_collection, upload_summaries_collection, users_collection)
    end
    
  end
end
