namespace :HDS do
  namespace :test do

    ###
    # frontend_backend: Should fixtures be generated for frontend or backend.
    #   values: frontend, backend
    # cms_hqmf: Use cms or hqmf id.
    #   values: cms, hqmf
    # path: Fixture path.
    # user_email: email of user to export
    # measure_id: id of measuer to export
    # patients: which patients should be exported.
    #   values: each element should have three fields, firstname, lastname, displayname
    #   ex: [[first1, last1, patient1], [first2, last2, patient2]]
    ###
    task :generate_frontend_fixture, [:cms_hqmf, :path, :test_name, :user_email, :measure_id] => [:environment] do |t, args|
      user = User.find_by email: args[:user_email]
      if (args[:cms_hqmf].downcase  == 'cms')  
        measure = user.measures.find_by(cms_id: args[:cms_id])
      elsif (args[:cms_hqmf] == 'hqmf')
        measure = user.measures.find_by(hqmf_id: args[:cms_id])
      else
      end
      measure_summaries = UploadSummary::MeasureSummary.by_user_and_hqmf_set_id(user, measure.hqmf_id)
      archived_measures = ArchivedMeasure.by_user_and_hqmf_set_id(user, measure.hqmf_id)
      
      fixtures_path = File.join('spec', 'javascripts', 'fixtures', 'json')
      
      measure_file = File.join(fixtures_path, 'measure_data', args[:path], args[:test_name], 'measures.json')
      create_fixture_file(measure_file, JSON.pretty_generate(JSON.parse([measure].to_json)))

      Record.by_user_and_hqmf_set_id(user, measure.hqmf_id).each do |rec|
        name = rec.first + "_" + rec.last + ".json"
        record_file = File.join(fixtures_path, 'records', args[:path], args[:test_name], name)
        create_fixture_file(record_file, JSON.pretty_generate(JSON.parse(rec.to_json)))
      end
      
      oid_to_vs_map = {}
      
      value_sets = measure.value_sets.each do |vs|
        oid_to_vs_map[vs.oid] = vs
      end
      value_sets_file = File.join(fixture_path, 'measure_data', args[:path], args[:test_name], 'value_sets.json')
      create_fixture_file(value_sets_file, JSON.pretty_generate(JSON.parse(oid_to_vs_map.to_json)))
    
      us_filename = "#{args[:test_name]}.json"
      upload_summaries_file = File.join(fixture_path, 'upload_summaries', args[:path], us_filename)
      create_fixture_file(upload_summaries_file, JSON.pretty_generate(JSON.parse(measure_summaries.to_json)))
    
    end

    def create_fixture_file(file_path, fixture_json)
      FileUtils.mkdir_p(File.dirname(file_path)) unless Dir.exists? File.dirname(file_path)
      File.new(file_path, "w+")
      File.write(file_path, fixture_json)
    end
    
    #Usage
    # bundle exec rake HDS:test:generate_fixtures
    # use_hqmf: used when cms_id is CMSv0, allows you to use the hqmf_id to identify the measure to be exported.
    # user_email: email of user to be exported
    # cms_id: id of mesaure to be exported
    # patient_first_name, patient_last_name: identify patient to be exported
    # test_set: what component is the test being generted for? will place created fixtures in subdirectories named after test_set
    # test_name: the name of the directories that will contain test files.  If not set, will be generated from user, measure and record details.
    desc "Exports a set of fixtures that can be loaded for testing purposes"
    task :generate_fixtures, [:use_hqmf, :user_email, :cms_id, :patient_first_name, :patient_last_name, :test_set, :test_name] => [:environment] do |t, args|
      test_name = args[:test_name]
      if (test_name.nil?)
        tmp_email = args[:user_email].split("@")[0]
        test_name = "#{tmp_email}_#{args[:cms_id]}_#{args[:patient_first_name]}_#{args[:patient_last_name]}"
        test_name["\."] = "_"
      end
      
      user = User.find_by email: args[:user_email]
      if (args[:use_hqmf] == true)
        measure = user.measures.find_by(hqmf_id: args[:cms_id])
      else
        measure = user.measures.find_by(cms_id: args[:cms_id])
      end
      patient = Record.find_by(user: user, first: args[:patient_first_name], last: args[:patient_last_name])
      measure_summaries = UploadSummary::MeasureSummary.by_user_and_hqmf_set_id(user, measure.hqmf_id)
      archived_measures = ArchivedMeasure.by_user_and_hqmf_set_id(user, measure.hqmf_id)
      
      fixtures_directory = File.join("test", "fixtures")
      output_directory = File.join(fixtures_directory, args[:test_set], test_name)
      FileUtils.mkdir_p(output_directory) unless Dir.exists? output_directory

      user_file = File.join(fixtures_directory, "users", args[:test_set], test_name, "user.json") 
      patient_file = File.join(fixtures_directory, "records", args[:test_set], test_name, "patient.json")
      measure_file = File.join(fixtures_directory, "draft_measures", args[:test_set], test_name, "measures.json")
      upload_summaries_file = File.join(fixtures_directory, "upload_summaries", args[:test_set], test_name, "upload_summaries.json")
      archive_measures_file = File.join(fixtures_directory, "archived_measures", args[:test_set], test_name, "archived_measures.json")
      value_sets_dir = File.join(fixtures_directory, "health_data_standards_svs_value_sets", args[:test_set], test_name)

      FileUtils.mkdir_p(File.dirname(user_file)) unless Dir.exists? File.dirname(user_file)
      FileUtils.mkdir_p(File.dirname(patient_file)) unless Dir.exists? File.dirname(patient_file)
      FileUtils.mkdir_p(File.dirname(measure_file)) unless Dir.exists? File.dirname(measure_file)
      FileUtils.mkdir_p(upload_summaries_file) unless Dir.exists? upload_summaries_file
      FileUtils.mkdir_p(archive_measures_file) unless Dir.exists? archive_measures_file
      FileUtils.mkdir_p(value_sets_dir) unless Dir.exists? value_sets_dir

      File.new(user_file, "w+")
      File.write(user_file, JSON.pretty_generate(JSON.parse(user.to_json)))
      File.new(patient_file, "w+")
      File.write(patient_file, JSON.pretty_generate(JSON.parse(patient.to_json)))
      File.new(measure_file, "w+")
      File.write(measure_file, JSON.pretty_generate(JSON.parse(measure.to_json(except: [:map_fns, :record_ids], methods: [:value_sets]))))
      File.new(upload_summaries_file, "w+")
      File.write(upload_summaries_file, JSON.pretty_generate(JSON.parse(measure_summaries.to_json)))
      File.new(archive_measures_file, "w+")
      File.write(archive_measures_file, JSON.pretty_generate(JSON.parse(archived_measures.to_json)))

      value_sets = measure.value_sets

      value_sets.each do |vs|
        vs_file_name = vs.oid + ".json"
        value_sets_file = File.join(value_sets_dir, vs_file_name)
        File.new(value_sets_file, "w+")
        File.write(value_sets_file, JSON.pretty_generate(JSON.parse(vs.to_json)))
      end
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
    
  end
end
