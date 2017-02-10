# NOTE: Tasks use array arguments to execute.
# In order for z-shell to execute, noglob is required.
# e.g., noglob bundle exec rake bonnie:fixtures:load_backend_fixtures[test/fake]
namespace :bonnie do
  namespace :fixtures do
    ###
    # Generates a set of front end fixtures representing a specific database state.
    #
    # cms_hqmf: indicates if a CMS id or an HQMF id is used.
    #   values: cms, hqmf
    # path: Path to fixture files, derived from the data-type directories (EX: measure_data/${path}).
    # user_email: email of user to export.  Measure and patients exported will be taken from this user account.
    # measure_id: id of measuer to export, taken from account of given user.
    #
    # e.g., bundle exec rake bonnie:fixtures:generate_frontend_fixtures[cms,test/fake,bonnie@test.org,CMS68v5]
    task :generate_frontend_fixtures, [:cms_hqmf, :path, :user_email, :measure_id] => [:environment] do |t, args|
      fixtures_path = File.join('spec', 'javascripts', 'fixtures', 'json')

      user = User.find_by email: args[:user_email]

      #Exporting the fixtures for the measure. these go in a measure_data parent directory. the measure file is called measures.json. The accompanying value sets file is called value_sets.json
      measure = get_measure(user, args[:cms_hqmf], args[:measure_id])
      measure_file = File.join(fixtures_path, 'measure_data', args[:path], 'measures.json')
      create_fixture_file(measure_file, JSON.pretty_generate(JSON.parse([measure].to_json)))
      puts 'exported measure to ' + measure_file

      oid_to_vs_map = {}
      value_sets = measure.value_sets.each do |vs|
        oid_to_vs_map[vs.oid] = vs
      end
      
      value_sets_file = File.join(fixtures_path, 'measure_data', args[:path], 'value_sets.json')
      create_fixture_file(value_sets_file, JSON.pretty_generate(JSON.parse(oid_to_vs_map.to_json)))
      puts 'exported value sets to ' + value_sets_file

      #Exports patient data
      records = Record.by_user_and_hqmf_set_id(user, measure.hqmf_set_id)
      record_file = File.join(fixtures_path, 'records', args[:path], "patients.json")
      create_fixture_file(record_file, JSON.pretty_generate(JSON.parse(records.to_json)))
      puts 'exported patient records to ' + record_file
    
      #Exports the upload_summary data
      measure_summaries = UploadSummary::MeasureSummary.by_user_and_hqmf_set_id(user, measure.hqmf_set_id).desc(:created_at)
      upload_summaries_file = File.join(fixtures_path, 'upload_summaries', args[:path], "upload_summaries.json")
      create_fixture_file(upload_summaries_file, JSON.pretty_generate(JSON.parse(measure_summaries.to_json)))
      puts 'exported upload summaries to ' + upload_summaries_file

      #Exports the archived_measure data
      archived_measures = ArchivedMeasure.by_user_and_hqmf_set_id(user, measure.hqmf_set_id)
      archived_measures_file = File.join(fixtures_path, 'archived_measures', args[:path], "archived_measures.json")
      arc_measures = []
      archived_measures.each do |am|
        arc_measures.push(am)
      end
      create_fixture_file(archived_measures_file, JSON.pretty_generate(JSON.parse(archived_measures.to_json)))
      puts 'exported archived measures to ' + archived_measures_file
    end

    ###
    # Generates a set of back end fixtures representing a specific database state.
    # Generated fixtures will be associated with
    #
    # cms_hqmf: indicates if a CMS id or an HQMF id is used.
    #   values: cms, hqmf
    # path: Path to fixture files, derived from the data-type directories (EX: measure_data/${path}).
    # user_email: email of user to export.  Measure and patients exported will be taken from this user account.
    # measure_id: id of measuer to export, taken from account of given user.
    #
    # e.g., bundle exec rake bonnie:fixtures:generate_backend_fixtures[cms,test/fake,bonnie@test.org,CMS68v5]
    desc "Exports a set of fixtures that can be loaded for testing purposes"
    task :generate_backend_fixtures, [:cms_hqmf, :path, :user_email, :measure_id] => [:environment] do |t, args|
      fixtures_path = File.join('test', 'fixtures')
      #Exports the user
      user = User.find_by email: args[:user_email]
      bonnie_user_id = '501fdba3044a111b98000001'

      #Exports the measure
      measure = get_measure(user, args[:cms_hqmf], args[:measure_id])
      measure.user_id = bonnie_user_id
      measure_name = measure.cms_id + ".json"
      measure_file = File.join(fixtures_path, 'draft_measures', args[:path], measure_name)
      create_fixture_file(measure_file, JSON.pretty_generate(JSON.parse(measure.to_json)))
      puts 'exported measure to ' + measure_file
      
      #Exports the measure's value_sets
      value_sets_file = File.join(fixtures_path, 'health_data_standards_svs_value_sets', args[:path], 'value_sets.json')
      value_sets = measure.value_sets
      vs_export = []
      value_sets.each do |vs|
        vs.user_id = bonnie_user_id
        vs_export.push(vs)
      end
      create_fixture_file(value_sets_file, JSON.pretty_generate(JSON.parse(vs_export.to_json)))
      puts 'exported value sets to ' + value_sets_file

      #Exports the patients on the selected measure
      records = Record.by_user_and_hqmf_set_id(user, measure.hqmf_set_id).each do |rec|
        rec.user_id = bonnie_user_id
        rec_name = rec.first + "_" + rec.last + ".json"
        record_file = File.join(fixtures_path, 'records', args[:path], rec_name)
        create_fixture_file(record_file, JSON.pretty_generate(JSON.parse(rec.to_json)))
        puts 'exported patient records to ' + record_file
      end

      #Exports the upload_summaries associated with the measure
      measure_summaries = UploadSummary::MeasureSummary.by_user_and_hqmf_set_id(user, measure.hqmf_set_id).desc(:created_at)
      ms_export = []
      measure_summaries.each do |ms|
        ms.user_id = bonnie_user_id
        ms_export.push(ms)
      end
      upload_summaries_file = File.join(fixtures_path, 'upload_summaries', args[:path], "upload_summaries.json")
      create_fixture_file(upload_summaries_file, JSON.pretty_generate(JSON.parse(ms_export.to_json)))
      puts 'exported upload summaries to ' + upload_summaries_file

      #Exports the archived_measures associated with the measure
      archived_measures = ArchivedMeasure.by_user_and_hqmf_set_id(user, measure.hqmf_set_id)
      am_export = []
      archived_measures.each do |am| 
        am.user_id = bonnie_user_id 
        am_export.push(am)
      end
      archived_measures_file = File.join(fixtures_path, 'archived_measures', args[:path], "archived_measures.json")
      create_fixture_file(archived_measures_file, JSON.pretty_generate(JSON.parse(am_export.to_json)))
      puts 'exported archived measures to ' + archived_measures_file
    end
    
    ###
    # Takes a set of valueset json files, creates a dictionary of oid to valueset
    #
    # fileset_dir: directory containing input filesd.
    # output_dir: directory where output will be stored.
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
    
    ###
    # Loads a set of back end fixtures into the active database.
    # NOTE: This task will fail if documents in the database with the same ids already exist.
    # It is strongly recomended that you alter the config/mongoid.yml file so that the development:sessions:default:database points
    # to a new database (running bonnie will create a new database if the database config is pointed at one that does not exist)
    # path: the path to the files that comes after the fixture type directory
    #
    # e.g., bundle exec rake bonnie:fixtures:load_backend_fixtures[test/fake]
    desc "Loads set of fixtures into a running instance of BONNIE"
    task :load_backend_fixtures, [:path] => [:environment] do |t, args|
      archived_measures_collection = File.join 'archived_measures', args[:path]
      measure_collection = File.join 'draft_measures', args[:path]
      value_sets_collection = File.join 'health_data_standards_svs_value_sets', args[:path]
      records_collection = File.join 'records', args[:path]
      upload_summaries_collection = File.join 'upload_summaries', args[:path]
      users_collection = File.join 'users', 'export_user'
      collection_fixtures(archived_measures_collection, measure_collection, value_sets_collection, records_collection, upload_summaries_collection, users_collection)
    end

    def get_measure(user, cms_hqmf, measure_id)
      if (cms_hqmf.downcase  == 'cms')
        measure = user.measures.find_by(cms_id: measure_id)
      elsif (cms_hqmf.downcase == 'hqmf')
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

    ###
    # Creates and writes a fixture file.
    #
    # file_path: path of file to be written
    # fixture_json: json to be written
    def create_fixture_file(file_path, fixture_json)
      FileUtils.mkdir_p(File.dirname(file_path)) unless Dir.exists? File.dirname(file_path)
      File.new(file_path, "w+")
      File.write(file_path, fixture_json)
    end
    
    ###
    # TODO: duplicate functions, long term goal is to export them to test_helper
    # Parses json object for id fields and converts them to bson objects
    #
    # json: The json object to parse
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
            json[k] = BSON::ObjectId.from_string(v)
          end
        end
      end
    end

    ##
    # TODO: duplicate functions, long term goal is to export them to test_helper
    # Loads fixtures into the active database.
    #
    # collection_names: array of paths leading to the relevant collections.
    def collection_fixtures(*collection_names)
      collection_names.each do |collection|
        collection_name = collection.split(File::SEPARATOR)[0]
        Dir.glob(File.join(Rails.root, 'test', 'fixtures', collection, '*.json')).each do |json_fixture_file|
          fixture_json = JSON.parse(File.read(json_fixture_file))
          if fixture_json.length > 0
            convert_times(fixture_json)
            set_mongoid_ids(fixture_json)
            # The first directory layer after test/fixtures is used to determine what type of fixtures they are.
            # The directory name is used as the name of the collection being inserted into.
            Mongoid.default_session[collection_name].insert(fixture_json)
          end
        end
      end
    end
    
  end
end
