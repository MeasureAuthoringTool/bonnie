require File.expand_path('../../../../config/environment',  __FILE__)

namespace :bonnie do
  namespace :load do
  
    desc 'Load measures from HQMF and VSAC'
    task :sources, [:sources_dir, :username, :measures_yml, :vsac_user, :vsac_password, :drop_db?] do |t, args|
      raise "The sources directory containing measure definitions must be specified" unless args.sources_dir
      raise "The username to load the measures for must be specified" unless args.username
      raise "Measures YML file must be specified" unless args.measures_yml

      username = args.username
      measures_yml = args.measures_yml

      if args.drop_db? != 'false'
        MONGO_DB['draft_measures'].drop()
        MONGO_DB['health_data_standards_svs_value_sets'].drop()
      end

      user = User.by_username username
      Measures::SourcesLoader.load(args.sources_dir, user, measures_yml, args.vsac_user, args.vsac_password)

    end
  end
end