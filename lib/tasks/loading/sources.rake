require File.expand_path('../../../../config/environment',  __FILE__)

namespace :bonnie do
  namespace :load do

    desc 'Load measures from HQMF and VSAC'
    task :sources, [:sources_dir, :email, :measures_yml, :vsac_user, :vsac_password, :clear_vs_cache?, :drop_db?] do |t, args|
      raise "The sources directory containing measure definitions must be specified" unless args.sources_dir
      raise "The user email to load the measures for must be specified" unless args.email
      raise "Measures YML file must be specified" unless args.measures_yml

      Rake::Task['bonnie:load:backup_white_black'].invoke

      email = args.email
      ENV['EMAIL'] = email

      measures_yml = args.measures_yml

      if (args.clear_vs_cache? == 'true')
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
      raise "user #{email} could not be found" unless user
      Measures::SourcesLoader.load(args.sources_dir, user, measures_yml, args.vsac_user, args.vsac_password)
      Rake::Task['bonnie:load:restore_white_black'].invoke

      puts "done loading measure sources"
    end

    desc 'Load measures from HQMF and VSAC with white and black lists'
    task :sources_w_white_black, [:sources_dir, :email, :measures_yml, :vsac_user, :vsac_password, :white, :black, :drop_db?] do |t, args|
      Rake::Task["bonnie:load:sources"].invoke(args.sources_dir, args.email, args.measures_yml, args.vsac_user, args.vsac_password, args.drop_db?)
      Rake::Task["bonnie:load:white_black_list"].invoke(args.white, args.black)
    end


    desc 'save white/black list to json'
    task :backup_white_black => :environment do
      user_email = ENV['EMAIL'] || User.first.email
      white_black = []
      HealthDataStandards::SVS::ValueSet.by_user(User.where({email: user_email}).first).each do |vs|
        vs.concepts.each do |c|
          white_black << {oid: vs.oid, code_system_name: c.code_system_name, code: c.code, white_list: c.white_list, black_list: c.black_list} if c.white_list || c.black_list
        end
      end
      Dir.mkdir('tmp') unless Dir.exist?('tmp')
      outfile = File.join('tmp','white_black_backup.json')
      File.open(outfile, 'w') {|f| f.write(JSON.pretty_generate(JSON.parse(white_black.to_json))) }
      puts "wrote white/black list to #{outfile}"
    end
    desc 'restore white/black list from json'
    task :restore_white_black => :environment do
      infile = File.join('tmp','white_black_backup.json')

      user_email = ENV['EMAIL'] || User.first.email
      user = User.where({email: user_email}).first
      white_black = JSON.parse(File.read infile)

      white_black.each do |wb|
        vs = HealthDataStandards::SVS::ValueSet.by_user(user).where(oid: wb['oid']).first
        if (vs)
          concepts = vs.concepts
          match = false
          concepts.each do |c|
            if (c.code_system_name == wb['code_system_name'] && c.code == wb['code'])
              c.white_list=wb['white_list']
              c.black_list=wb['black_list']
              match=true
            end
          end
          if match
            vs.concepts = concepts
            vs.save!
          else
            puts "\tWhite/Black entry could not be restored: #{wb}"
          end
        # else
        #     puts "\tWhite/Black entry could not be found: #{wb}"
        end
      end

      puts "restored white/black list from #{infile}"
    end


  end
end
