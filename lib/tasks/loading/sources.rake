require File.expand_path('../../../../config/environment',  __FILE__)

namespace :bonnie do
  namespace :load do
  
    desc 'Load measures from HQMF and VSAC'
    task :sources, [:sources_dir, :email, :measures_yml, :vsac_user, :vsac_password, :clear_vs_cache?, :drop_db?] do |t, args|
      raise "The sources directory containing measure definitions must be specified" unless args.sources_dir
      raise "The user email to load the measures for must be specified" unless args.email
      raise "Measures YML file must be specified" unless args.measures_yml

      email = args.email
      measures_yml = args.measures_yml

      if (args.clear_vs_cache == 'true')
        puts "Clearing value set cache"
        FileUtils.rm_r Measures::Loader::VALUE_SET_PATH
      else
        puts "Using value set cache at: #{Measures::Loader::VALUE_SET_PATH}"
      end

      if args.drop_db? != 'false'
        Mongoid.default_session['draft_measures'].drop()
        Mongoid.default_session['health_data_standards_svs_value_sets'].drop()
      end

      user = User.by_email(email).first
      Measures::SourcesLoader.load(args.sources_dir, user, measures_yml, args.vsac_user, args.vsac_password)
      puts "done loading measure sources"
    end

    desc 'Load measures from HQMF and VSAC with white and black lists'
    task :sources_w_white_black, [:sources_dir, :email, :measures_yml, :vsac_user, :vsac_password, :white, :black, :drop_db?] do |t, args|
      Rake::Task["bonnie:load:sources"].invoke(args.sources_dir, args.email, args.measures_yml, args.vsac_user, args.vsac_password, args.drop_db?)
      Rake::Task["bonnie:load:white_black_list"].invoke(args.white, args.black)
    end

  end
end