namespace :HDS do
  namespace :test do
    
    
    task :generate_fixtures, [:gen_test, :user_email, :cms_id, :patient_first_name, :patient_last_name, :test_set, :test_name] => [:environment] do |t, args|
      test_name = args[:test_name]
      if (test_name.nil?)
        tmp_email = args[:user_email].split("@")[0]
        test_name = "#{tmp_email}_#{args[:cms_id]}_#{args[:patient_first_name]}_#{args[:patient_last_name]}"
        test_name["\."] = "_"
      end
      
      user = User.find_by email: args[:user_email]
      measure = user.measures.find_by(cms_id: args[:cms_id])
      patient = Record.find_by(user: user, first: args[:patient_first_name], last: args[:patient_last_name])
      
      fixtures_directory = File.join("test", "fixtures")
      output_directory = File.join(fixtures_directory, args[:test_set], test_name)
      Dir.mkdir(output_directory) unless Dir.exists? output_directory

      user_file = args[:gen_test] ? File.join(fixtures_directory, "users", args[:test_set], test_name, "user.json") : File.join(output_directory, "user.json")
      patient_file = args[:gen_test] ? File.join(fixtures_directory, "records", args[:test_set], test_name, "patient.json") : File.join(output_directory, "patient.json")
      measure_file = args[:gen_test] ? File.join(fixtures_directory, "draft_measures", args[:test_set], test_name, "measures.json") : File.join(output_directory, "measure.json")
      value_sets_file = args[:gen_test] ? File.join(fixtures_directory, "health_data_standards_svs_value_sets", args[:test_set], test_name, "value_sets.json") : File.join(output_directory, "value_sets.json")

      if args[:gen_test]
        Dir.mkdir(File.dirname(user_file)) unless Dir.exists? File.dirname(user_file)
        Dir.mkdir(File.dirname(patient_file)) unless Dir.exists? File.dirname(patient_file)
        Dir.mkdir(File.dirname(measure_file)) unless Dir.exists? File.dirname(measure_file)
        Dir.mkdir(File.dirname(value_sets_file)) unless Dir.exists? File.dirname(value_sets_file)
      end

      File.new(user_file, "w+")
      File.write(user_file, JSON.pretty_generate(JSON.parse(user.to_json)))
      File.new(patient_file, "w+")
      File.write(patient_file, JSON.pretty_generate(JSON.parse(patient.to_json)))
      File.new(measure_file, "w+")
      File.write(measure_file, JSON.pretty_generate(JSON.parse(measure.to_json(except: [:map_fns, :record_ids], methods: [:value_sets]))))

      value_sets = HealthDataStandards::SVS::ValueSet.in(oid: measure.value_set_oids).index_by(&:oid)
      
      File.new(value_sets_file, "w+")
      File.write(value_sets_file, JSON.pretty_generate(JSON.parse(value_sets.to_json)))
      
    end
    
  end
end
