require File.expand_path('../../../../config/environment',  __FILE__)

namespace :bonnie do
  namespace :load do
  
    desc 'Load Exported MITRE measure bundle'
    task :mitre_bundle, [:file, :username, :reparse_hqmf?, :measures_yml, :drop_db?] do |t, args|
      raise "The file to measure definition must be specified" unless args.file
      raise "The username to load the measures for must be specified" unless args.username

      username = args.username || 'bonnie'
      load_from_hqmf = args.reparse_hqmf? == 'true'
      measures_yml = args.measures_yml unless measures_yml.nil? || measures_yml.empty?

      if args.drop_db? != 'false'
        Rake::Task["db:drop"].invoke()
      end

      password = "#{username}1234"
      User.create!({agree_license: true, approved: true, password: password, password_confirmation: password, email: "#{username}@example.com", first_name: username, last_name: username, username: username})
      puts "created user #{username}@example.com/#{password}"

      Rake::Task["bundle:import"].invoke(args.file,'true','true',nil,'false')

      puts "dropping unneeded collections: measures, bundles, patient_cache, query_cache..."
      MONGO_DB['bundles'].drop()
      MONGO_DB['measures'].drop()
      MONGO_DB['query_cache'].drop()
      MONGO_DB['patient_cache'].drop()

      puts "clearing out system.js"
      MONGO_DB['system.js'].find({}).remove_all

      user = User.by_username username
      Measures::BundleLoader.load(args.file, user, measures_yml, load_from_hqmf)

    end
  end
end