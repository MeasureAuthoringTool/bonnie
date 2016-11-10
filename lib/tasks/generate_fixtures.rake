namespace :HDS do
  namespace :test do
    
    task :generateFixture, [:user_email, :cms_id, :patient_first_name, :patient_last_name, :output_dir] => [:environment] do |t, args|
      user = User.find_by email: args[:user_email]
      measure = user.measures.find_by(cms_id: args[:cms_id])
      patient = Record.find_by(user: user, first: args[:patient_first_name], last: args[:patient_last_name])
      
      output_directory = File.join("test", "fixtures", args[:output_dir])
      Dir.mkdir(output_directory) unless Dir.exists? output_directory

      user_file = File.join(output_directory, "user.json")
      patient_file = File.join(output_directory, "patient.json")
      measure_file = File.join(output_directory, "measure.json")

      File.new(user_file, "w+")
      File.write(user_file, JSON.pretty_generate(JSON.parse(user.to_json)))
      File.new(patient_file, "w+")
      File.write(patient_file, JSON.pretty_generate(JSON.parse(patient.to_json)))
      File.new(measure_file, "w+")
      File.write(measure_file, JSON.pretty_generate(JSON.parse(measure.to_json)))

      value_sets_file = File.join(output_directory, "value_sets.json")

      value_sets = HealthDataStandards::SVS::ValueSet.in(oid: measure.value_set_oids).index_by(&:oid)
      
      File.new(value_sets_file, "w+")
      File.write(value_sets_file, JSON.pretty_generate(JSON.parse(value_sets.to_json)))
      
      
      bundle_file = File.join(output_directory, "bundle.json")
      bundle = HealthDataStandards::CQM::Bundle.where(_id: user.bundle_id)
      
      File.new(bundle_file, "w+")
      File.write(bundle_file, JSON.pretty_generate(JSON.parse(bundle.to_json)))
      
    end
    
  end
end
