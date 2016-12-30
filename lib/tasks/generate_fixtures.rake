namespace :HDS do
  namespace :test do
    
    #Usage
    # bundle exec rake HDS:test:generate_fixtures
    # use_hqmf: used when cms_id is CMSv0, allows you to use the hqmf_id to identify the measure to be exported.
    # gen_test: if true, will distribute fixtures into appropriate test/fixtures directories
    # user_email: email of user to be exported
    # cms_id: id of mesaure to be exported
    # patient_first_name, patient_last_name: identify patient to be exported
    # test_set: what component is the test being generted for? will place created fixtures in subdirectories named after test_set
    # test_name: the name of the directories that will contain test files.  If not set, will be generated from user, measure and record details.
    desc "Exports a set of fixtures that can be loaded for testing purposes"
    task :generate_fixtures, [:gen_test, :use_hqmf, :user_email, :cms_id, :patient_first_name, :patient_last_name, :test_set, :test_name] => [:environment] do |t, args|
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
      
      fixtures_directory = File.join("test", "fixtures")
      output_directory = File.join(fixtures_directory, args[:test_set], test_name)
      FileUtils.mkdir_p(output_directory) unless Dir.exists? output_directory

      user_file = args[:gen_test] ? File.join(fixtures_directory, "users", args[:test_set], test_name, "user.json") : File.join(output_directory, "user.json")
      patient_file = args[:gen_test] ? File.join(fixtures_directory, "records", args[:test_set], test_name, "patient.json") : File.join(output_directory, "patient.json")
      measure_file = args[:gen_test] ? File.join(fixtures_directory, "draft_measures", args[:test_set], test_name, "measures.json") : File.join(output_directory, "measure.json")
      value_sets_dir = args[:gen_test] ? File.join(fixtures_directory, "health_data_standards_svs_value_sets", args[:test_set], test_name) : File.join(output_directory, "value_sets")


      if args[:gen_test]
        FileUtils.mkdir_p(File.dirname(user_file)) unless Dir.exists? File.dirname(user_file)
        FileUtils.mkdir_p(File.dirname(patient_file)) unless Dir.exists? File.dirname(patient_file)
        FileUtils.mkdir_p(File.dirname(measure_file)) unless Dir.exists? File.dirname(measure_file)
        FileUtils.mkdir_p(value_sets_dir) unless Dir.exists? value_sets_dir
      end

      File.new(user_file, "w+")
      File.write(user_file, JSON.pretty_generate(JSON.parse(user.to_json)))
      File.new(patient_file, "w+")
      File.write(patient_file, JSON.pretty_generate(JSON.parse(patient.to_json)))
      File.new(measure_file, "w+")
      File.write(measure_file, JSON.pretty_generate(JSON.parse(measure.to_json(except: [:map_fns, :record_ids], methods: [:value_sets]))))

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
