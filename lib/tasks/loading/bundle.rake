require File.expand_path('../../../../config/environment',  __FILE__)

namespace :bonnie do
  namespace :load do
  
    desc 'Load Exported MITRE measure bundle'
    task :mitre_bundle, [:file, :email, :measure_type, :reparse_hqmf?, :measures_yml, :drop_db?] do |t, args|
      raise "The file to measure definition must be specified" unless args.file
      raise "The user email to load the measures for must be specified" unless args.email

      email = args.email || 'bonnie@example.com'
      load_from_hqmf = args.reparse_hqmf? == 'true'
      measures_yml = args.measures_yml unless measures_yml.nil? || measures_yml.empty?
      measure_type = args.measure_type
      unless measure_type.nil?
        measure_type.downcase!
        # If we're not given eh or ep, set to nil for bundle:import
        if measure_type != 'ep' && measure_type != 'eh'
          measure_type = nil
        end
      end

      if args.drop_db? != 'false'
        Rake::Task["db:drop"].invoke()
      end

      Rake::Task["bundle:import"].invoke(args.file,'true','true',measure_type,'false')

      puts "dropping unneeded collections: measures, bundles, patient_cache, query_cache..."
      Mongoid.default_client['bundles'].drop()
      Mongoid.default_client['measures'].drop()
      Mongoid.default_client['query_cache'].drop()
      Mongoid.default_client['patient_cache'].drop()

      puts "clearing out system.js"
      Mongoid.default_client['system.js'].delete_many({})

      username = email.split('@')[0]
      password = "#{username}1234"
      user = User.create!({agree_license: true, password: password, password_confirmation: password, email: email, first_name: username, last_name: username})
      user.approved = true
      user.save!
      puts "created user #{email}/#{password}"

      user = User.by_email(email).first
      Measures::BundleLoader.load(args.file, user, measures_yml, load_from_hqmf, measure_type)

      Rake::Task['bonnie:patients:update_measure_ids'].invoke
      Rake::Task['bonnie:users:associate_user_with_measures'].invoke(EMAIL: email)
      Rake::Task['bonnie:users:associate_user_with_patients'].invoke(EMAIL: email)
      Rake::Task["bonnie:patients:update_source_data_criteria"].invoke
      Rake::Task['bonnie:users:associate_user_with_valuesets'].invoke(EMAIL: email)
      Rake::Task['bonnie:measures:pregenerate_js'].invoke

    end
  end
end
