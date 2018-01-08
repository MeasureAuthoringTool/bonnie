namespace :bonnie do
  namespace :users do

    desc %{Grant an existing bonnie user administrator privileges.

    You must identify the user by USER_ID or EMAIL:

    $ rake bonnie:users:grant_admin USER_ID=###
    or
    $ rake bonnie:users:grant_admin EMAIL=xxx}
    task :grant_admin => :environment do
      user = User.find_by email: ENV['EMAIL']
      user.grant_admin()
      puts "#{ENV['EMAIL']} is now an administrator."
    end

    desc %{Remove the administrator role from an existing bonnie user.

    You must identify the user by USER_ID or EMAIL:

    $ rake bonnie:users:revoke_admin USER_ID=###
    or
    $ rake bonnie:users:revoke_admin EMAIL=xxx}
    task :revoke_admin => :environment do
      user = User.find_by email: ENV["EMAIL"]
      user.revoke_admin()
      puts "#{ENV['EMAIL']} is no longer an administrator."
    end

    desc %{Grant an existing bonnie user portfolio privileges.

    You must identify the user by USER_ID or EMAIL:

    $ rake bonnie:users:grant_portfolio USER_ID=###
    or
    $ rake bonnie:users:grant_portfolio EMAIL=xxx}
    task :grant_portfolio => :environment do
      user = User.find_by email: ENV['EMAIL']
      user.grant_portfolio()
      puts "#{ENV['EMAIL']} is now a portfolio user."
    end

    desc %{Remove the portfolio role from an existing bonnie user.

    You must identify the user by USER_ID or EMAIL:

    $ rake bonnie:users:revoke_portfolio USER_ID=###
    or
    $ rake bonnie:users:revoke_portfolio EMAIL=xxx}
    task :revoke_portfolio => :environment do
      user = User.find_by email: ENV["EMAIL"]
      user.revoke_portfolio()
      puts "#{ENV['EMAIL']} is no longer a portfolio user."
    end

    desc %{Grant an existing bonnie user dashboard privileges.

    You must identify the user by USER_ID or EMAIL:

    $ rake bonnie:users:grant_dashboard USER_ID=###
    or
    $ rake bonnie:users:grant_dashboard EMAIL=xxx}
    task :grant_dashboard => :environment do
      user = User.find_by email: ENV['EMAIL']
      user.grant_dashboard()
      puts "#{ENV['EMAIL']} is now a dashboard user."
    end

    desc %{Remove the dashboard role from an existing bonnie user.

    You must identify the user by USER_ID or EMAIL:

    $ rake bonnie:users:revoke_dashboard USER_ID=###
    or
    $ rake bonnie:users:revoke_dashboard EMAIL=xxx}
    task :revoke_dashboard => :environment do
      user = User.find_by email: ENV["EMAIL"]
      user.revoke_dashboard()
      puts "#{ENV['EMAIL']} is no longer a dashboard user."
    end

    desc %{Grant an existing bonnie user dashboard_set privileges.

    You must identify the user by USER_ID or EMAIL:

    $ rake bonnie:users:grant_dashboard_set USER_ID=###
    or
    $ rake bonnie:users:grant_dashboard_set EMAIL=xxx}
    task :grant_dashboard_set => :environment do
      user = User.find_by email: ENV['EMAIL']
      user.grant_dashboard_set()
      puts "#{ENV['EMAIL']} is now a dashboard_set user."
    end

    desc %{Remove the dashboard_set role from an existing bonnie user.

    You must identify the user by USER_ID or EMAIL:

    $ rake bonnie:users:revoke_dashboard_set USER_ID=###
    or
    $ rake bonnie:users:revoke_dashboard_set EMAIL=xxx}
    task :revoke_dashboard_set => :environment do
      user = User.find_by email: ENV["EMAIL"]
      user.revoke_dashboard_set()
      puts "#{ENV['EMAIL']} is no longer a dashboard_set user."
    end

    desc 'Associate the currently loaded measures with the first User; use EMAIL=<user email> to select another user'
    task :associate_user_with_measures => :environment do
      user_email = ENV['EMAIL'] || User.first.email
      user = User.where(email: user_email).first
      puts "Associating measures with #{user.email}"
      Measure.all.update_all(user_id: user.id, bundle_id: user.bundle_id)
    end

    desc 'Associate the currently loaded measures with the first User; use EMAIL=<user email> to select another user'
    task :associate_user_with_valuesets => :environment do
      user_email = ENV['EMAIL'] || User.first.email
      user = User.where(email: user_email).first
      puts "Associating Valuesets with #{user.email}"
      HealthDataStandards::SVS::ValueSet.all.update_all(user_id: user.id, bundle_id: user.bundle_id)
    end

    desc 'Associate the currently loaded patients with the first User; use EMAIL=<user email> to select another user'
    task :associate_user_with_patients => :environment do
      user_email = ENV['EMAIL'] || User.first.email
      user = User.where(email: user_email).first
      puts "Associating patients with #{user.email}"
      Record.all.update_all(user_id: user.id, bundle_id: user.bundle_id)
    end


    desc 'Make sure all of the users in the system have a bundle'
    task :ensure_users_have_bundles => :environment do
      User.all.each do |u|
        unless u.bundle
            b = HealthDataStandards::CQM::Bundle.new(title: "Bundle for user #{u.id.to_s}", version: "1")
            b.save
            u.bundle = b
            u.save
        end
      end
    end

    desc 'Move a measure from one user account to another'
    task :move_measure => :environment do
      source_email = ENV['SOURCE_EMAIL']
      dest_email = ENV['DEST_EMAIL']
      cms_id = ENV['CMS_ID']

      puts "Moving '#{cms_id}' from '#{source_email}' to '#{dest_email}'..."

      # Find source and destination user accounts
      raise "#{source_email} not found" unless source = User.find_by(email: source_email)
      raise "#{dest_email} not found" unless dest = User.find_by(email: dest_email)

      # Find the measure and associated records we're moving
      raise "#{cms_id} not found" unless measure = source.measures.find_by(cms_id: cms_id)
      records = source.records.where(measure_ids: measure.hqmf_set_id)

      # Find the value sets we'll be *copying* (not moving!)
      value_sets = measure.value_sets.map(&:clone) # Clone ensures we save a copy and don't overwrite original

      # Write the value set copies, updating the user id and bundle
      raise "No destination user bundle" unless dest.bundle
      puts "Copying value sets..."
      value_sets.each do |vs|
        vs.user = dest
        vs.bundle = dest.bundle
        vs.save
      end

      # Update the user id and bundle for the existing records
      puts "Moving patient records..."
      records.each do |r|
        puts "  #{r.first} #{r.last}"
        r.user = dest
        r.bundle = dest.bundle
        r.save
      end

      # Same for the measure
      puts "Moving measure..."
      measure.user = dest
      measure.bundle = dest.bundle
      measure.save

      puts "Done!"
    end

    desc 'Export spreadsheets for all measures loaded by a user'
    task :export_spreadsheets => :environment do
      user_email = ENV['USER_EMAIL']
      raise "#{user_email} not found" unless user = User.find_by(email: user_email)
      Measure.where(user_id: user.id).each do |measure|
        records = Record.by_user(user).where({:measure_ids.in => [measure.hqmf_set_id]})
        next unless records.size > 0
        File.open("#{measure.cms_id}.xlsx", "w") { |f| f.write(PatientExport.export_excel_file(measure, records).to_stream.read) }
      end
    end

    desc %{Export Bonnie patients to a JSON file.

    You must identify the user by EMAIL, include a HQMF_SET_ID, and
    an output filename using FILENAME
    
    $ rake bonnie:users:export_patients EMAIL=xxx HQMF_SET_ID=1948-138412-1414 FILENAME=CMS100_pations.json}
    task :export_patients => :environment do
      # Grab user account
      user_email = ENV['EMAIL']
      raise "#{user_email} not found" unless user = User.find_by(email: user_email)

      # Grab user measure to pull patients from
      raise "#{ENV['HQMF_SET_ID']} hqmf_set_id not found" unless measure = Measure.find_by(user_id: user._id, hqmf_set_id: ENV['HQMF_SET_ID'])

      # Grab the patients
      patients = Record.where(user_id: user._id, :measure_ids => measure.hqmf_set_id)
        .or(Record.where(user_id: user._id, :measure_ids => measure.hqmf_id))
        .or(Record.where(user_id: user._id, measure_id: measure.hqmf_id))

      # Write patient objects to file in JSON format
      puts "Exporting patients..."
      raise "FILENAME not specified" unless output_file = ENV['FILENAME']
      File.open(File.join(Rails.root, output_file), "w") do |f|
        patients.each do |patient|
          f.write(patient.to_json)
          f.write("\r\n")
        end
      end

      puts "Done!"
    end

    desc %{Import Bonnie patients from a JSON file.
    The JSON file must be the one that is generated using the export_patients rake task.

    You must identify the user by EMAIL, include a HQMF_SET_ID,
    the name of the file to be imported using FILENAME, and the type of measure using MEASURE_TYPE
    
    $ rake bonnie:users:import_patients EMAIL=xxx HQMF_SET_ID=1924-55295295-23425 FILENAME=CMS100_patients.json MEASURE_TYPE=CQL}
    task :import_patients => :environment do
      # Grab user account
      user_email = ENV['EMAIL']
      raise "#{user_email} not found" unless user = User.find_by(email: user_email)

      # Grab user measure to add patients to
      user_measure = ENV['HQMF_SET_ID']

      # Check if MEASURE_TYPE is a CQL Based Measure
      if ENV['MEASURE_TYPE'] == 'CQL'
        raise "#{user_measure} not found" unless measure = CqlMeasure.find_by(user_id: user._id, hqmf_set_id: user_measure)
      else
        raise "#{user_measure} not found" unless measure = Measure.find_by(user_id: user._id, hqmf_set_id: user_measure)
      end

      # Import patient objects from JSON file and save
      puts "Importing patients..."
      raise "FILENAME not specified" unless input_file = ENV['FILENAME']
      File.foreach(File.join(Rails.root, input_file)) do |p|
        next if p.blank?
        patient = Record.new.from_json p.strip

        patient['user_id'] = user._id

        patient['measure_ids'] = []
        patient['measure_ids'] << measure.hqmf_set_id
        patient['measure_ids'] << nil # Need to add a null value at the end of the array.

        # Modifiying hqmf_set_id and cms_id for source data criteria
        unless patient['source_data_criteria'].nil?
          patient['source_data_criteria'].each do |source_criteria|
            source_criteria['hqmf_set_id'] = measure.hqmf_set_id
            source_criteria['cms_id'] = measure.cms_id
          end
        end
        # Modifying measure_id for expected values
        unless patient['expected_values'].nil?
          patient['expected_values'].each do |expected_value|
            expected_value['measure_id'] = measure.hqmf_set_id
          end
        end

        all_codes = HQMF::PopulationCriteria::ALL_POPULATION_CODES
        all_codes.each do |code|
          if !patient.expected_values[0][code].nil? && measure.populations[0][code].nil?
            patient.expected_values.each do |expected_value|
              expected_value.delete(code)
            end
          end
        end

        patient.dup.save!
      end

      puts "Done!"
    end

  end

  namespace :db do

    desc 'Reset DB; by default pulls from bonnie-dev.mitre.org:bonnie-production-gold; use HOST=<host> DB=<db> for another; DEMO=true prunes measures'
    task :reset_legacy => :environment do

      host = ENV['HOST'] || 'bonnie-dev.mitre.org'
      source_db = ENV['DB'] || 'bonnie-production-gold'
      dest_db = Mongoid.default_client.options[:database]
      puts "Resetting #{dest_db} from #{host}:#{source_db}"
      Mongoid.default_client.with(database: dest_db) { |db| db.drop }
      Mongoid.default_client.with(database: 'admin') { |db| db.command copydb: 1, fromhost: host, fromdb: source_db, todb: dest_db }
      puts "Dropping unneeded collections: measures, bundles, patient_cache, query_cache..."

      Mongoid.default_client['bundles'].drop()
      Mongoid.default_client['measures'].drop()
      Mongoid.default_client['query_cache'].drop()
      Mongoid.default_client['patient_cache'].drop()
      Rake::Task['bonnie:users:ensure_users_have_bundles'].invoke
      Rake::Task['bonnie:patients:update_measure_ids'].invoke
      Rake::Task['bonnie:users:associate_user_with_measures'].invoke
      Rake::Task['bonnie:users:associate_user_with_patients'].invoke
      Rake::Task['bonnie:users:associate_user_with_valuesets'].invoke
      Rake::Task["bonnie:patients:update_source_data_criteria"].invoke
      if ENV['DEMO'] == 'true'
        puts "Deleting non-demo measures and patients"
        demo_measure_ids = Measure.in(measure_id: ['0105', '0069']).pluck('hqmf_set_id') # Note: measure_id is nqf, id is hqmf_set_id!
        Measure.nin(hqmf_set_id: demo_measure_ids).delete
        Record.nin(measure_ids: demo_measure_ids).delete
      end
      Rake::Task['bonnie:patients:reset_expected_values'].invoke
      if ENV['DEMO'] == 'true'
        puts "Updating expected values for demo"
        measure_id = Measure.where(measure_id: '0105').first.hqmf_set_id
        patient = Record.where(first: 'BH_Adult', last: 'C').first
        patient.expected_values << {measure_id: measure_id, population_index: 0, IPP: 1, DENOM: 1, NUMER: 0, DENEX: 0}
        patient.expected_values << {measure_id: measure_id, population_index: 1, IPP: 1, DENOM: 1, NUMER: 0, DENEX: 0}
        patient.save!
        patient = Record.where(first: 'BH_Adult', last: 'D').first
        patient.expected_values << {measure_id: measure_id, population_index: 0, IPP: 1, DENOM: 1, NUMER: 1, DENEX: 0}
        patient.expected_values << {measure_id: measure_id, population_index: 1, IPP: 1, DENOM: 1, NUMER: 0, DENEX: 0}
        patient.save!
      end
      Rake::Task['bonnie:measures:pregenerate_js'].invoke
      User.each do |u|
        u.approved = true
        u.save
      end
    end

    desc 'Reset DB; by default pulls from a local dump under the db directory; use HOST=<host> DB=<db> for another; DEMO=true prunes measures'
    task :reset => :environment do
      if ENV['HOST'] || ENV['DB']
        Rake::Task['bonnie:db:reset_legacy'].invoke
      else
        dump_archive = File.join('db','bonnie_reset.tar.gz')
        dump_extract = File.join('tmp','bonnie_reset')
        target_db = Mongoid.default_client.options[:database]
        puts "Resetting #{target_db} from #{dump_archive}"
        Mongoid.default_client.with(database: target_db) { |db| db.drop }
        system "tar xf #{dump_archive} -C tmp"
        system "mongorestore -d #{target_db} #{dump_extract}"
        FileUtils.rm_r dump_extract
        if ENV['DEMO'] == 'true'
          puts "Deleting non-demo measures and patients"
          demo_measure_ids = Measure.in(measure_id: ['0105', '0069']).pluck('hqmf_set_id') # Note: measure_id is nqf, id is hqmf_set_id!
          Measure.nin(hqmf_set_id: demo_measure_ids).delete
          Record.nin(measure_ids: demo_measure_ids).delete
        end
        Rake::Task['bonnie:db:resave_measures'].invoke # Updates the complexity data to most recent format
      end
    end

    desc 'Re-save all measures, ensuring that all post processing steps (like calculating complexity) are performed again'
    task :resave_measures => :environment do
      Measure.each do |m|
        puts "Re-saving \"#{m.title}\" [#{ m.user ? m.user.email : 'deleted user' }]"
        begin
          m.save
        rescue => e
          puts "ERROR re-saving measure!"
          puts e.message
        end
      end
    end

    DUMP_TIME_FORMAT = "%Y-%m-%d-%H-%M-%S"

    desc 'Dumps the local database matching the supplied RAILS_ENV'
    task :dump => :environment do
      db = Mongoid.default_client.options[:database]
      datestamp = Time.now.strftime(DUMP_TIME_FORMAT)
      path = Rails.root.join 'db', 'backups'
      file = "#{db}-#{datestamp}"
      command = "mkdir -p #{path} && mongodump --db #{db} --out #{path.join(file)} && cd #{path} && tar czf #{file}.tgz #{file} && rm -r #{file}"
      puts command
      system command
    end

    desc 'Prune database dumps to keep daily dumps for last month, weekly dumps before that, for the supplied RAILS_ENV'
    task :prune_dumps => :environment do
      puts "Pruning database dumps for #{Rails.env}"
      def file_time(filename)
        return unless match = filename.match(%r(-([0-9-]+).tgz))
        Time.strptime(match[1], DUMP_TIME_FORMAT)
      end
      path = Rails.root.join 'db', 'backups', '*.tgz'
      files = Dir.glob(path).select { |f| file_time(f) } # Only interested in files where we can determine time
      # File from older than past month, keep most recent weekly
      files.select { |f| file_time(f) < 1.month.ago }.group_by { |f| file_time(f).strftime('%Y week %V') }.each do |week, ff|
        sorted = ff.sort_by { |f| file_time(f) }
        sorted[0..-2].each do |f|
          puts "Deleting #{f}"
          system "rm #{f}"
        end
        puts "Keeping #{sorted.last}"
      end
      # Files from past month, keep most recent daily
      files.select { |f| file_time(f) >= 1.month.ago }.group_by { |f| file_time(f).strftime('%Y-%m-%d') }.each do |day, ff|
        sorted = ff.sort_by { |f| file_time(f) }
        sorted[0..-2].each do |f|
          puts "Deleting #{f}"
          system "rm #{f}"
        end
        puts "Keeping #{sorted.last}"
      end
    end

  end

  namespace :test do
    desc 'Deletes all measures except for failing Cypress measures and CV measures; Use after running a bonnie:load:mitre_bundle rake task.'
    task :prune_db => :environment do
      puts "Reducing imported measures"
      # some_measure_ids = Measure.in(measure_id: ['0710', '0389', 'ADE_TTR', '0497', '0495', '0496']).pluck('hqmf_set_id')
      some_measure_ids = Measure.in(cms_id: ['CMS179v2', 'CMS159v2', 'CMS129v3', 'CMS111v2', 'CMS55v2', 'CMS32v3']).pluck('hqmf_set_id')
      Measure.nin(hqmf_set_id: some_measure_ids).delete
    end
  end

  namespace :test do
    desc 'Delete all non-CV measures after importing from bonnie-production-eh'
    task :clean_up => :environment do
      puts "Reducing imported measures"
      some_measure_ids = Measure.in(cms_id: ['CMS111v2', 'CMS55v2', 'CMS32v3']).pluck('hqmf_set_id')
      Measure.nin(hqmf_set_id: some_measure_ids).delete
    end
  end

  namespace :measures do
    desc 'Pre-generate measure JavaScript and cache in the DB'
    task :pregenerate_js => :environment do
      user = User.find_by email: ENV["EMAIL"] if ENV["EMAIL"]
      measures = user ? Measure.by_user(user) : Measure.all
      puts "Pre-generating measure JavaScript for #{ user ? user.email : 'all users'}"
      measures.each do |measure|
        puts "\tGenerating JavaScript [ #{ measure.user ? measure.user.email : 'deleted user' } ] '#{measure.title}'"
        measure.generate_js
      end
    end

    desc 'Clear generated measure cache for a user'
    task :clear_js => :environment do
      user = User.find_by email: ENV["EMAIL"] if ENV["EMAIL"]
      measures = user ? Measure.by_user(user) : Measure.all
      puts "Clearing measure JavaScript for #{ user ? user.email : 'all users'}"
      measures.each do |measure|
        puts "\tClearing JavaScript [ #{ measure.user ? measure.user.email : 'deleted user' } ] '#{measure.title}'"
        measure.clear_cached_js
      end
    end

    desc 'Reset measure JavaScript -- clears existing cache and regenerates JavaScript and cache in the DB'
    task :reset_js => :environment do
      Rake::Task['bonnie:measures:clear_js'].invoke
      Rake::Task['bonnie:measures:pregenerate_js'].invoke
    end
  end

  namespace :patients do

    desc %{Copy measure patients from one user account to another

    You must identify the source user by SOURCE_EMAIL,
    the destination user account by DEST_EMAIL,
    the source measure by SOURCE_HQMF_SET_ID,
    and the destination measure by DEST_HQMF_SET_ID

    $ rake bonnie:patients:copy_measure_patients SOURCE_EMAIL=xxx DEST_EMAIL=yyy SOURCE_HQMF_SET_ID=100 DEST_HQMF_SET_ID=101}
    task :copy_measure_patients => :environment do
      source_email = ENV['SOURCE_EMAIL']
      dest_email = ENV['DEST_EMAIL']
      source_hqmf_set_id = ENV['SOURCE_HQMF_SET_ID']
      dest_hqmf_set_id = ENV['DEST_HQMF_SET_ID']

      is_error = false

      unless is_error
        begin
          source = User.find_by(email: source_email)
        rescue
          print_error "#{source_email} not found"
          is_error = true
        end
      end

      unless is_error
        begin
          dest = User.find_by(email: dest_email)
        rescue
          print_error "#{dest_email} not found"
          is_error = true
        end
      end

      unless is_error
        begin
          source_measure = CqlMeasure.find_by(user_id: source.id, hqmf_set_id: source_hqmf_set_id)
        rescue
          print_error "measure with HQFM set id #{source_hqmf_set_id} not found for account #{source_email}"
          is_error = true
        end
      end

      unless is_error
        begin
          dest_measure = CqlMeasure.find_by(user_id: dest.id, hqmf_set_id: dest_hqmf_set_id)
        rescue
          print_error "measure with HQFM set id #{dest_hqmf_set_id} not found for account #{dest_email}"
          is_error = true
        end
      end

      unless is_error
        puts "Copying patients from '#{source_hqmf_set_id}' in '#{source_email}' to '#{dest_hqmf_set_id}' in '#{dest_email}'"

        move_patients(source, dest, source_measure, dest_measure, true)

        print_success "Successfully copied patients from '#{source_hqmf_set_id}' in '#{source_email}' to '#{dest_hqmf_set_id}' in '#{dest_email}'"
      end
    end

    desc %{Move measure patients from one user account to another

    You must identify the source user by SOURCE_EMAIL,
    the destination user account by DEST_EMAIL,
    the source measure by SOURCE_HQMF_SET_ID,
    and the destination measure by DEST_HQMF_SET_ID

    $ rake bonnie:patients:move_measure_patients SOURCE_EMAIL=xxx DEST_EMAIL=yyy SOURCE_HQMF_SET_ID=100 DEST_HQMF_SET_ID=101}
    task :move_measure_patients => :environment do
      source_email = ENV['SOURCE_EMAIL']
      dest_email = ENV['DEST_EMAIL']
      source_hqmf_set_id = ENV['SOURCE_HQMF_SET_ID']
      dest_hqmf_set_id = ENV['DEST_HQMF_SET_ID']

      is_error = false

      unless is_error
        begin
          source = User.find_by(email: source_email)
        rescue
          print_error "#{source_email} not found"
          is_error = true
        end
      end

      unless is_error
        begin
          dest = User.find_by(email: dest_email)
        rescue
          print_error "#{dest_email} not found"
          is_error = true
        end
      end

      unless is_error
        begin
          source_measure = CqlMeasure.find_by(user_id: source.id, hqmf_set_id: source_hqmf_set_id)
        rescue
          print_error "measure with HQFM set id #{source_hqmf_set_id} not found for account #{source_email}"
          is_error = true
        end
      end

      unless is_error
        begin
          dest_measure = CqlMeasure.find_by(user_id: dest.id, hqmf_set_id: dest_hqmf_set_id)
        rescue
          print_error "measure with HQFM set id #{dest_hqmf_set_id} not found for account #{dest_email}"
          is_error = true
        end
      end

      unless is_error
        puts "Moving patients from '#{source_hqmf_set_id}' in '#{source_email}' to '#{dest_hqmf_set_id}' in '#{dest_email}'"

        move_patients(source, dest, source_measure, dest_measure)

        print_success "Successfully moved patients from '#{source_hqmf_set_id}' in '#{source_email}' to '#{dest_hqmf_set_id}' in '#{dest_email}'"
      end
    end

    desc %{Move measure patients from measure to another measure within the same account,
      specified by a CSV file.

      The CSV file is expected to have a header row. If a header row is not provided, then
      the first row will get skipped when processing.

      column 0: original measure title
      column 1: new measure title
      column 2: original measure CMS id
      column 3: new measure CMS id
      column 4: account email

      You must identify the CSV file by CSV_PATH
      $ rake bonnie:patients:move_measure_patients CSV_PATH=/Users/edeyoung/Documents/projects/bonnie/EH_transfer.csv}

    task :move_patients_csv => :environment do
      csv_path = ENV['CSV_PATH']

      is_first = true
      CSV.foreach(csv_path) do |row|
        if is_first
          is_first = false
          next
        end

        is_error = false

        unless is_error
          email = row[4].downcase

          begin
            user = User.find_by(email: email)
          rescue
            print_error "#{email} not found"
            is_error = true
          end
        end

        unless is_error
          orig_measure = nil
          orig_measure_title = row[0]
          orig_measure_id = row[2]

          new_measure = nil
          new_measure_title = row[1]
          new_measure_id = row[3]

          orig_measure = find_measure(user, orig_measure_title, orig_measure_id)
          new_measure = find_measure(user, new_measure_title, new_measure_id)

          if orig_measure && new_measure
            move_patients(user, user, orig_measure, new_measure)
            print_success "moved records in #{email} from #{orig_measure_id}:#{orig_measure_title} to #{new_measure_id}:#{new_measure_title}"
          else
            print_error "unable to move records in #{email} from #{orig_measure_id}:#{orig_measure_title} to #{new_measure_id}:#{new_measure_title}"
          end

          puts ""
        end

      end
    end

    desc "Share a random set of patients to the patient bank"
    task :share_with_bank=> :environment do
      Record.where(is_shared: true).update_all(is_shared: false) # reset everyone to not shared.
      # share specified number of patients if possible, else share 25% of all existing patients
      to_share = ((ENV["NUMBER"].to_i > 0) && (ENV["NUMBER"].to_i <= Record.count)) ? ENV["NUMBER"].to_i : (Record.count*0.25).round
      patients = Record.all.sample(to_share)
      patients.each do |patient|
        patient['is_shared'] = true
        patient.save
      end
      puts "Shared patients to the patient bank."
    end

    desc "Materialize all patients"
    task :materialize_all => :environment do
      user = User.find_by email: ENV["EMAIL"] if ENV["EMAIL"]
      records = user ? user.records : Record.all
      count = 0
      records.each do |r|
        puts "Materializing #{r.last} #{r.first}"
        begin
          r.rebuild!
          count += 1
        rescue => e
          puts "Error materializing #{r.first} #{r.last}: #{e.message}"
        end
      end
      puts "Materialized #{count} of #{records.count} patients"
    end

    desc 'Update measure ids from NQF to HQMF.'
    task :update_measure_ids => :environment do
      puts "Updating patient measure_ids from NQF to HQMF"
      Record.each do |patient|
        patient.measure_ids.map! { |id| Measure.or({ measure_id: id }, { hqmf_id: id }, { hqmf_set_id: id }).first.try(:hqmf_set_id) }.compact!
        patient.save
        puts "\tUpdated patient #{patient.first} #{patient.last}."
      end
    end

    desc 'Reset expected_values hash.'
    task :reset_expected_values => :environment do
      puts "Resetting expected_values hash for all patients to []"
      Record.each do |patient|
        patient.expected_values = []
        patient.save
        puts "\tReset expected_values for patient #{patient.first} #{patient.last}."
      end
    end

    desc %{Date shift patient records for a given user.
      Use EMAIL to denote the user to scope the date_shift for all associated patients' source data criteria; first user by default.
      Use DIR to denote direction [forward, backward]; direction is forward by default.
      Use SECONDS, MINUTES, HOURS, DAYS, WEEKS, MONTHS, YEARS to denote time offset [###]; offsets are 0 by default.

      e.g., rake bonnie:patients:date_shift DIR=backward YEARS=2 MONTHS=2 will shift the first user's patients' source data criteria start/stop dates and birth/death dates backwards by 2 years and 2 months.
    }
    task :date_shift => :environment do
      user_email = ENV['EMAIL'] || User.first.email
      user = User.where(email: user_email).first
      direction = ENV['DIR'] || 'forward'
      direction = 'forward' if !direction.downcase == 'backward'
      seconds, minutes, hours, days, weeks, months, years = ENV['SECONDS'] || 0, ENV['MINUTES'] || 0, ENV['HOURS'] || 0, ENV['DAYS'] || 0, ENV['WEEKS'] || 0, ENV['MONTHS'] || 0, ENV['YEARS'] || 0
      puts "Shifting dates #{direction} [ #{years}ys, #{months}mos, #{weeks}wks, #{days}d, #{hours}hrs, #{minutes}mins, #{seconds}s ] for source_data_criteria start/stop dates and birth/death dates on all associated patient records for #{user.email}"
      direction.downcase == 'backward' ? dir = -1 : dir = 1
      seconds, minutes, hours, days, weeks, months, years = dir * seconds.to_i, dir * minutes.to_i, dir * hours.to_i, dir * days.to_i, dir * weeks.to_i, dir * months.to_i, dir * years.to_i
      timestamps = ['FACILITY_LOCATION_ARRIVAL_DATETIME','FACILITY_LOCATION_DEPARTURE_DATETIME','DISCHARGE_DATETIME','ADMISSION_DATETIME','START_DATETIME','STOP_DATETIME','INCISION_DATETIME','REMOVAL_DATETIME', 'TRANSFER_TO_DATETIME', 'TRANSFER_FROM_DATETIME']
      Record.by_user(user).each do |patient|
        patient.birthdate = ( Time.at( patient.birthdate ).utc.advance( :years => years, :months => months, :weeks => weeks, :days => days, :hours => hours, :minutes => minutes, :seconds => seconds ) ).to_i
        if patient.expired
          patient.deathdate = ( Time.at( patient.deathdate ).utc.advance( :years => years, :months => months, :weeks => weeks, :days => days, :hours => hours, :minutes => minutes, :seconds => seconds ) ).to_i
        end
        patient.source_data_criteria.each do |sdc|
          unless sdc["start_date"].blank?
            sdc["start_date"] = ( Time.at( sdc["start_date"] / 1000 ).utc.advance( :years => years, :months => months, :weeks => weeks, :days => days, :hours => hours, :minutes => minutes, :seconds => seconds ) ).to_i * 1000
          end
          unless sdc["end_date"].blank?
            sdc["end_date"] = ( Time.at( sdc["end_date"] / 1000 ).utc.advance( :years => years, :months => months, :weeks => weeks, :days => days, :hours => hours, :minutes => minutes, :seconds => seconds ) ).to_i * 1000
          end
          unless sdc['field_values'].blank?
            sdc_timestamps = timestamps & sdc['field_values'].keys
            sdc_timestamps.each do |sdc_timestamp|
              sdc['field_values'][sdc_timestamp]['value'] = ( Time.at( sdc['field_values'][sdc_timestamp]['value'] / 1000 ).utc.advance( :years => years, :months => months, :weeks => weeks, :days => days, :hours => hours, :minutes => minutes, :seconds => seconds ) ).to_i * 1000
            end
          end
          unless sdc["fulfillments"].blank?
            sdc["fulfillments"].each do |fulfillment|
              dispense_datetime = fulfillment["dispense_datetime"].to_i
              changed_time = Time.at( dispense_datetime ).utc.advance( :years => years, :months => months, :weeks => weeks, :days => days, :hours => hours, :minutes => minutes, :seconds => seconds )
              fulfillment["dispense_time"] = changed_time.strftime('%I:%M:%p')
              fulfillment["dispense_date"] = changed_time.strftime('%m/%d/%Y')
              fulfillment["dispense_datetime"] = changed_time.to_i.to_s
            end
          end
        end
        Measures::PatientBuilder.rebuild_patient(patient)
        patient.save!
      end
    end

    desc 'Re-save all patient records'
    task :resave_patient_records => :environment do
      STDOUT.sync = true
      index = 0
      Record.each do |r|
        r.save
        index += 1
        print '.' if index % 500 == 0
      end
      puts
    end

    # Helper functions

    # Moves patients from src_user and src_measure to dest_user and dest_measure.
    # if copy=false, moves the existing patients. if copy=true, creates copies
    # of the patients to move.
    # If you are moving patients to different measures in the same account, just
    # pass in the same user information for both src_user and dest_user.
    def move_patients(src_user, dest_user, src_measure, dest_measure, copy=false)
      records = []
      src_user.records.where(measure_ids: src_measure.hqmf_set_id).each do |r|
        if copy
          records.push(r.dup)
        else
          records.push(r)
        end
      end

      records.each do |r|
        r.user = dest_user
        r.bundle = dest_user.bundle
        r.measure_ids.map! { |x| x == src_measure.hqmf_set_id ? dest_measure.hqmf_set_id : x }
        r.expected_values.each do |expected_value|
          if expected_value['measure_id'] == src_measure.hqmf_set_id
            expected_value['measure_id'] = dest_measure.hqmf_set_id
          end
        end
        r.source_data_criteria.each do |sdc|
          if sdc['hqmf_set_id'] && sdc['hqmf_set_id'] != dest_measure.hqmf_set_id
            sdc['hqmf_set_id'] = dest_measure.hqmf_set_id
          end
        end
        r.save
      end
    end

    # Finds a measuer based off of the user information, measure title, and
    # measure id.
    # First searches based off of the user and measure id. However, the id is
    # not always unique. If there are multiple measures returned with the id,
    # it then uses the measure title to refine the list.
    #
    # It does this two pronged approach to searching because the measure information
    # is provided by users, and there may be small differences in the measure title
    # (small typo, capitalization, etc.).
    def find_measure(user, measure_title, measure_id)
      measure = nil

      # try to find the measure just based off of the CMS id to avoid chance of typos
      # in the title
      measures = CqlMeasure.where(user_id: user._id, cms_id: measure_id)
      if measures.count == 0
        print_error "#{user.email}: #{measure_id}:#{measure_title} not found"
      elsif measures.count == 1
        measure = measures.first
      else
        # if there are duplicate CMS ids (CMSv0, for example), use the title as well
        measures = CqlMeasure.where(user_id: user._id, title: measure_title, cms_id: measure_id)
        if measures.count == 0
          print_error "#{user.email}: #{measure_id}:#{measure_title} not found"
        elsif measures.count == 1
          measure = measures.first
        else
          print_error "#{user.email}: #{measure_id}:#{measure_title} not unique"
        end
      end

      if measure
        print_success "#{user.email}: #{measure_id}:#{measure_title} found"
      end

      return measure
    end

    # Prints a message with a red "[Error]" string ahead of it.
    def print_error(error_string)
      print "\e[#{31}m#{"[Error]"}\e[0m\t\t"
      puts error_string
    end

    # Prints a message with a green "[Success]" string ahead of it.
    def print_success(success_string)
      print "\e[#{32}m#{"[Success]"}\e[0m\t"
      puts success_string
    end

    # Prints a message with a warning "[Warning]" string ahead of it.
    def print_warning(warning_string)
      print "\e[#{33}m#{"[Warning]"}\e[0m\t"
      puts warning_string
    end

  end
end
