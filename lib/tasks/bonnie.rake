namespace :bonnie do
  namespace :users do

    desc %{Grant an existing bonnie user administrator privileges.

    You must identify the user by EMAIL:

    $ rake bonnie:users:grant_admin EMAIL=xxx}
    task :grant_admin => :environment do
      user = User.find_by email: ENV['EMAIL']
      user.grant_admin()
      puts "#{ENV['EMAIL']} is now an administrator."
    end

    desc %{Remove the administrator role from an existing bonnie user.

    You must identify the user by EMAIL:

    $ rake bonnie:users:revoke_admin EMAIL=xxx}
    task :revoke_admin => :environment do
      user = User.find_by email: ENV["EMAIL"]
      user.revoke_admin()
      puts "#{ENV['EMAIL']} is no longer an administrator."
    end

    desc %{Grant an existing bonnie user portfolio privileges.

    You must identify the user by EMAIL:

    $ rake bonnie:users:grant_portfolio EMAIL=xxx}
    task :grant_portfolio => :environment do
      user = User.find_by email: ENV['EMAIL']
      user.grant_portfolio()
      puts "#{ENV['EMAIL']} is now a portfolio user."
    end

    desc %{Remove the portfolio role from an existing bonnie user.

    You must identify the user by EMAIL:

    $ rake bonnie:users:revoke_portfolio EMAIL=xxx}
    task :revoke_portfolio => :environment do
      user = User.find_by email: ENV["EMAIL"]
      user.revoke_portfolio()
      puts "#{ENV['EMAIL']} is no longer a portfolio user."
    end

    desc %{Grant an existing bonnie user dashboard privileges.

    You must identify the user by EMAIL:

    $ rake bonnie:users:grant_dashboard EMAIL=xxx}
    task :grant_dashboard => :environment do
      user = User.find_by email: ENV['EMAIL']
      user.grant_dashboard()
      puts "#{ENV['EMAIL']} is now a dashboard user."
    end

    desc %{Remove the dashboard role from an existing bonnie user.

    You must identify the user by EMAIL:

    $ rake bonnie:users:revoke_dashboard EMAIL=xxx}
    task :revoke_dashboard => :environment do
      user = User.find_by email: ENV["EMAIL"]
      user.revoke_dashboard()
      puts "#{ENV['EMAIL']} is no longer a dashboard user."
    end

    desc %{Grant an existing bonnie user dashboard_set privileges.

    You must identify the user by EMAIL:

    $ rake bonnie:users:grant_dashboard_set EMAIL=xxx}
    task :grant_dashboard_set => :environment do
      user = User.find_by email: ENV['EMAIL']
      user.grant_dashboard_set()
      puts "#{ENV['EMAIL']} is now a dashboard_set user."
    end

    desc %{Remove the dashboard_set role from an existing bonnie user.

    You must identify the user by EMAIL:

    $ rake bonnie:users:revoke_dashboard_set EMAIL=xxx}
    task :revoke_dashboard_set => :environment do
      user = User.find_by email: ENV["EMAIL"]
      user.revoke_dashboard_set()
      puts "#{ENV['EMAIL']} is no longer a dashboard_set user."
    end

    desc 'Move a measure from one user account to another'
    task :move_measure => :environment do
      source_email = ENV['SOURCE_EMAIL']
      dest_email = ENV['DEST_EMAIL']
      cms_id = ENV['CMS_ID']

      puts "Moving '#{cms_id}' from '#{source_email}' to '#{dest_email}'..."

      # Find source and destination user accounts
      raise "#{source_email} not found" unless source = User.find_by(email: source_email) rescue nil

      raise "#{dest_email} not found" unless dest = User.find_by(email: dest_email) rescue nil

      # Find the measure and associated records we're moving
      raise "#{cms_id} not found" unless measure = find_measure(source, "", cms_id)
      if find_measure(dest, "", cms_id, false)
        raise "#{cms_id} already exists in destination account #{dest_email}. Cannot complete move."
      end
      move_patients(source, dest, measure, measure)
      print_success("Moved patients")

      # Find the value sets we'll be *copying* (not moving!)
      value_sets = measure.value_sets.map(&:clone) # Clone ensures we save a copy and don't overwrite original

      # Write the value set copies, updating the user id and bundle
      raise "No destination user bundle" unless dest.bundle
      copy_value_sets(dest, value_sets)
      print_success("Copied value sets")

      # Same for the measure
      measure.user = dest
      measure.bundle = dest.bundle
      measure.save

      print_success "Moved measure"
    end

  end

  namespace :db do

    desc 'Re-save all measures, ensuring that all post processing steps (like calculating complexity) are performed again'
    task :resave_measures => :environment do
      CqlMeasure.each do |m|
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

    desc 'Downloads a measure package for a particular measure'
    task :download_measure_package => :environment do
      email = ENV['EMAIL']
      cms_id = ENV['CMS_ID']
      hqmf_set_id = ENV['HQMF_SET_ID']

      is_error = false

      unless is_error
        begin
          user = User.find_by(email: email)
        rescue Mongoid::Errors::DocumentNotFound
          print_error "#{email} not found"
          is_error = true
        end
      end

      unless is_error
        if hqmf_set_id
          begin
            measure = CqlMeasure.find_by(user_id: user.id, hqmf_set_id: hqmf_set_id)
            print_success "#{user.email}: measure with HQMF set id #{hqmf_set_id} found"
          rescue Mongoid::Errors::DocumentNotFound
            print_error "measure with HQFM set id #{hqmf_set_id} not found for account #{email}"
            is_error = true
          end
        elsif cms_id
          measure = find_measure(user, '', cms_id)
          unless measure
            print_error "measure with CMS id #{cms_id} not found for account #{email}"
            is_error = true
          end
        else
          print_error 'Expected CMS_ID or HQMF_SET_ID environment variables'
          is_error = true
        end
      end

      unless is_error
        if measure.package
          filename = "#{measure.cms_id}_#{email}_#{measure.package.created_at.to_date}.zip"
          file = open(filename, 'wb')
          file.write(measure.package.file.data)
          file.close
          print_success "Successfully wrote #{measure.cms_id}_#{email}_#{measure.package.created_at.to_date}.zip"
        else
          print_error 'No package found for this measure.'
        end
      end
    end
  end

  namespace :patients do

    desc %{Update Facilities and Diagnoses on all patients

    $ rake bonnie:patients:update_facilities_and_diagnoses_on_all_patients}
    task :update_facilities_and_diagnoses_on_all_patients => :environment do
      printf "%-22s", "\e[#{32}m#{"[TITLE] "}\e[0m"
      printf "| %-80s", "\e[#{36}m#{"FIRST LAST"}\e[0m"
      printf "| %-35s", "ACCOUNT"
      puts "| MEASURE ID"
      puts "-"*157
      Record.all.each do |patient|
        update_facilities_and_diagnoses_on_patient(patient)
      end
    end

    desc %{Export Bonnie patients to a JSON file.

    You must identify the user by EMAIL, include a HQMF_SET_ID, and
    an output filename using FILENAME

    $ rake bonnie:patients:export_patients EMAIL=xxx HQMF_SET_ID=1948-138412-1414 FILENAME=CMS100_pations.json}
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

    $ rake bonnie:patients:import_patients EMAIL=xxx HQMF_SET_ID=1924-55295295-23425 FILENAME=CMS100_patients.json MEASURE_TYPE=CQL}
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

        patient = update_facilities_and_diagnoses_on_patient(patient)
        patient.dup.save!
      end

      puts "Done!"
    end

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
  def find_measure(user, measure_title, measure_id, expect_to_find=true)
    measure = nil

    # try to find the measure just based off of the CMS id to avoid chance of typos
    # in the title
    measures = CqlMeasure.where(user_id: user._id, cms_id: measure_id)
    if measures.count == 0
      print_error "#{user.email}: #{measure_id}:#{measure_title} not found" if expect_to_find
    elsif measures.count == 1
      measure = measures.first
    else
      # if there are duplicate CMS ids (CMSv0, for example), use the title as well
      measures = CqlMeasure.where(user_id: user._id, title: measure_title, cms_id: measure_id)
      if measures.count == 0
        print_error "#{user.email}: #{measure_id}:#{measure_title} not found" if expect_to_find
      elsif measures.count == 1
        measure = measures.first
      else
        print_error "#{user.email}: #{measure_id}:#{measure_title} not unique" if expect_to_find
      end
    end

    if measure
      if expect_to_find
        print_success "#{user.email}: #{measure_id}:#{measure_title} found"
      else
        print_error "#{user.email}: #{measure_id}:#{measure_title} found"
      end
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

  # Copies value sets to a new user. Only copies the value set if that value set
  # with that version does not already exist for the user.
  def copy_value_sets(dest_user, value_sets)
    user_value_sets = HealthDataStandards::SVS::ValueSet.where({user_id: dest_user.id})
    value_sets.each do |vs|
      set = user_value_sets.where({oid: vs.oid, version: vs.version})

      # if value set doesn't exist, copy it and add it
      if set.count == 0
        vs = vs.dup
        vs.user = dest_user
        vs.bundle = dest_user.bundle
        vs.save
      end
    end
  end

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
end

# Updates any facility or diagnosis objects on given patient to be
# collections (type == COL)
def update_facilities_and_diagnoses_on_patient(patient)
  # For any relevant datatypes, update old facilities and diagnoses to be collections with single elements
  if patient.source_data_criteria
    patient.source_data_criteria.each do |source_data_criterium|
      new_source_data_criterium_field_values = {}
      if source_data_criterium['field_values']
        source_data_criterium['field_values'].each do |field_value_key, field_value_value|
          # update any 'DIAGNOSIS' field values that aren't collections
          if field_value_key == 'DIAGNOSIS' && (source_data_criterium['field_values']['DIAGNOSIS']['type'] != 'COL')
            new_diagnosis = {}
            new_diagnosis['type'] = 'COL'
            if source_data_criterium['field_values']['DIAGNOSIS']['field_title']
              new_diagnosis['field_title'] = source_data_criterium['field_values']['DIAGNOSIS']['field_title']
            end
            new_diagnosis['values'] = [{}]
            new_diagnosis['values'][0]['type'] = 'CD'
            new_diagnosis['values'][0]['key'] = 'DIAGNOSIS'
            if source_data_criterium['field_values']['DIAGNOSIS']['field_title']
              new_diagnosis['values'][0]['field_title'] = source_data_criterium['field_values']['DIAGNOSIS']['field_title']
            end
            new_diagnosis['values'][0]['code_list_id'] = source_data_criterium['field_values']['DIAGNOSIS']['code_list_id']
            new_diagnosis['values'][0]['field_title'] = source_data_criterium['field_values']['DIAGNOSIS']['field_title']
            new_diagnosis['values'][0]['title'] = source_data_criterium['field_values']['DIAGNOSIS']['title']
            new_source_data_criterium_field_values['DIAGNOSIS'] = new_diagnosis 

          # update any 'FACILITY_LOCATION' field values that aren't collections
          elsif field_value_key == 'FACILITY_LOCATION' && (source_data_criterium['field_values']['FACILITY_LOCATION']['type'] != 'COL')
            new_facility_location = {}
            new_facility_location['type'] = 'COL'
            new_facility_location['values'] = [{}]
            new_facility_location['values'][0]['type'] = 'FAC'
            new_facility_location['values'][0]['key'] = 'FACILITY_LOCATION'
            new_facility_location['values'][0]['code_list_id'] = source_data_criterium['field_values']['FACILITY_LOCATION']['code_list_id']
            new_facility_location['values'][0]['field_title'] = source_data_criterium['field_values']['FACILITY_LOCATION']['field_title']
            new_facility_location['values'][0]['title'] = source_data_criterium['field_values']['FACILITY_LOCATION']['title']

            # Convert times
            converted_start_date = nil
            converted_start_time = nil
            if source_data_criterium['field_values']['FACILITY_LOCATION_ARRIVAL_DATETIME']
              old_start_time = source_data_criterium['field_values']['FACILITY_LOCATION_ARRIVAL_DATETIME']['value']
              converted_start_date = Time.at(old_start_time / 1000).getutc().strftime('%m/%d/%Y')
              converted_start_time = Time.at(old_start_time / 1000).getutc().strftime('%l:%M %p')
              if source_data_criterium['field_values']['FACILITY_LOCATION_ARRIVAL_DATETIME']['value']
                new_facility_location['values'][0]['value'] = source_data_criterium['field_values']['FACILITY_LOCATION_ARRIVAL_DATETIME']['value']
              end
            end
            new_facility_location['values'][0]['start_date'] = converted_start_date
            new_facility_location['values'][0]['start_time'] = converted_start_time

            converted_end_date = nil
            converted_end_time = nil
            if source_data_criterium['field_values']['FACILITY_LOCATION_DEPARTURE_DATETIME']
              old_end_time = source_data_criterium['field_values']['FACILITY_LOCATION_DEPARTURE_DATETIME']['value']
              converted_end_date = Time.at(old_end_time / 1000).getutc().strftime('%m/%d/%Y')
              converted_end_time = Time.at(old_end_time / 1000).getutc().strftime('%l:%M %p')
              if source_data_criterium['field_values']['FACILITY_LOCATION_DEPARTURE_DATETIME']['value']
                new_facility_location['values'][0]['end_value'] = source_data_criterium['field_values']['FACILITY_LOCATION_DEPARTURE_DATETIME']['value']
              end
            end
            new_facility_location['values'][0]['end_date'] = converted_end_date
            new_facility_location['values'][0]['end_time'] = converted_end_time

            new_location_period_low = nil
            new_location_period_high = nil
            if converted_start_date
              new_location_period_low = converted_start_date.to_s
              new_location_period_low += " #{converted_start_time}" if converted_start_time
            end
            if converted_end_date
              new_location_period_high = converted_end_date.to_s
              new_location_period_high += " #{converted_end_time}" if converted_end_time
            end
            new_facility_location['values'][0]['locationPeriodLow'] = new_location_period_low if new_location_period_low
            new_facility_location['values'][0]['locationPeriodHigh'] = new_location_period_high if new_location_period_high

            # Reassign
            new_source_data_criterium_field_values['FACILITY_LOCATION'] = new_facility_location
          elsif !(field_value_key == 'FACILITY_LOCATION_ARRIVAL_DATETIME' || field_value_key == 'FACILITY_LOCATION_DEPARTURE_DATETIME')
            # add unaltered field value to new structure, unless it's a time we already used above
            new_source_data_criterium_field_values[field_value_key] = field_value_value
          else
            # There was an arrival/depature time without a code, remove them
            if field_value_key == 'FACILITY_LOCATION_ARRIVAL_DATETIME' && !source_data_criterium['field_values']['FACILITY_LOCATION']
              print_helper("-Arrival", patient)
              new_source_data_criterium_field_values.delete(field_value_key)
            elsif field_value_key == 'FACILITY_LOCATION_DEPARTURE_DATETIME' && !source_data_criterium['field_values']['FACILITY_LOCATION']
              print_helper("-Departure", patient)
              new_source_data_criterium_field_values.delete(field_value_key)
            end
          end
        end
        source_data_criterium['field_values'] = new_source_data_criterium_field_values
      end
    end
  end

  if patient.encounters
    patient.encounters.each do |encounter|
      if encounter.facility && !encounter.facility['type']
        update_facility(patient, encounter)
      end

      # Diagnosis is only for encounter
      if encounter.diagnosis && !encounter.diagnosis['type']
        print_helper("Diagnosis", patient)
        new_encounter_diagnosis = {}
        new_encounter_diagnosis['type'] = 'COL'
        new_encounter_diagnosis['values'] = [{}]
        new_encounter_diagnosis['values'][0]['title'] = encounter.diagnosis['title']
        new_encounter_diagnosis['values'][0]['code'] = encounter.diagnosis['code']
        new_encounter_diagnosis['values'][0]['code_system'] = encounter.diagnosis['code_system']
        encounter.diagnosis = new_encounter_diagnosis
      end
    end
  end

  if patient.adverse_events
    patient.adverse_events.each do |adverse_event|
      if adverse_event.facility && !adverse_event.facility['type']
        update_facility(patient, adverse_event)
      end
    end
  end

  if patient.procedures
    patient.procedures.each do |procedure|
      if procedure.facility && !procedure.facility['type']
        update_facility(patient, procedure)
      end
    end
  end
  patient
end

# Update the facility on provided datatype if it has one.
def update_facility(patient, datatype)
  return nil unless datatype['facility']
  return nil if datatype.facility['type']
  # Need to build new facility and assign it in order to actually save it in DB
  new_datatype_facility = {}

  # Assign type to be 'COL' for collection
  new_datatype_facility['type'] = 'COL'
  new_datatype_facility['values'] = [{}]

  # Convert single facility into collection containing 1 facility
  start_time = datatype.facility['start_time']
  end_time = datatype.facility['end_time']

  # Convert times from 1505203200 format to  09/12/2017 8:00 AM format
  if start_time
    converted_start_time = Time.at(start_time).getutc().strftime("%m/%d/%Y %l:%M %p")
  else
    converted_start_time = nil
  end

  if end_time
    converted_end_time = Time.at(end_time).getutc().strftime("%m/%d/%Y %l:%M %p")
  else
    converted_end_time = nil
  end

  # start/end time -> locationPeriodLow/High
  new_datatype_facility['values'][0]['locationPeriodLow'] = converted_start_time
  new_datatype_facility['values'][0]['locationPeriodHigh'] = converted_end_time

  # name -> display
  new_datatype_facility['values'][0]['display'] = datatype.facility['name']

  # code
  if datatype.facility['code']
    code_system = datatype.facility['code']['code_system']
    code = datatype.facility['code']['code']
    new_datatype_facility['values'][0]['code'] = {'code_system'=>code_system, 'code'=>code}
    print_helper("Facility", patient)
    datatype.facility = new_datatype_facility
  else
    print_helper("-Facility", patient)
    datatype.remove_attribute(:facility)
  end
end

def print_helper(title, patient)
  if %w(-Facility -Arrival -Departure).include?(title)
    printf "%-22s", "\e[#{31}m#{"[#{title}] "}\e[0m"
  else
    printf "%-22s", "\e[#{32}m#{"[#{title}] "}\e[0m"
  end
  printf "%-80s", "\e[#{36}m#{"#{patient.first} #{patient.last}"}\e[0m"
  begin
    account = User.find(patient.user_id).email
    printf "%-35s %s", account.to_s, " #{patient.measure_ids[0]}\n"
  rescue Mongoid::Errors::DocumentNotFound
    puts "ORPHANED"
  end
end
