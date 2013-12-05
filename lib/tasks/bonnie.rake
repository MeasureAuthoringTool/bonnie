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
  end

  namespace :db do
    desc 'Reset DB; by default pulls from bonnie-dev.mitre.org:bonnie-production-gold; use HOST=<host> DB=<db> for another; DEMO=true prunes measures'
    task :reset => :environment do
      host = ENV['HOST'] || 'bonnie-dev.mitre.org'
      source_db = ENV['DB'] || 'bonnie-production-gold'
      dest_db = Mongoid.default_session.options[:database]
      puts "Resetting #{dest_db} from #{host}:#{source_db}"
      Mongoid.default_session.with(database: dest_db) { |db| db.drop }
      Mongoid.default_session.with(database: 'admin') { |db| db.command copydb: 1, fromhost: host, fromdb: source_db, todb: dest_db }
      Rake::Task['bonnie:patients:update_measure_ids'].invoke
      if ENV['DEMO'] == 'true'
        puts "Deleting non-demo measures and patients"
        demo_measure_ids = Measure.in(measure_id: ['0105', '0069']).pluck('hqmf_set_id') # Note: measure_id is nqf, id is hqmf_set_id!
        Measure.nin(hqmf_set_id: demo_measure_ids).delete
        Record.nin(measure_ids: demo_measure_ids).delete
      end
      Rake::Task['bonnie:patients:reset_expected_values'].invoke # FIXME: We shouldn't need to do this once we refactor expected values
      if ENV['DEMO'] == 'true'
        puts "Updating expected values for demo"
        measure_id = Measure.where(measure_id: '0105').first.hqmf_set_id
        patient = Record.where(first: 'BH_Adult', last: 'C').first
        [['a', 'IPP'], ['a', 'DENOM'], ['b', 'IPP'], ['b', 'DENOM']].each do |sub, pop|
          patient.expected_values[measure_id][sub][pop] = 1
        end
        patient.save!
        patient = Record.where(first: 'BH_Adult', last: 'D').first
        [['a', 'IPP'], ['a', 'DENOM'], ['a', 'NUMER'], ['b', 'IPP'], ['b', 'DENOM']].each do |sub, pop|
          patient.expected_values[measure_id][sub][pop] = 1
        end
        patient.save!
      end
      Rake::Task['bonnie:measures:pregenerate_js'].invoke
    end
  end

  namespace :measures do
    desc 'Pre-generate measure JavaScript and cache in the DB'
    task :pregenerate_js => :environment do
      puts "Pre-generating measure JavaScript"
      Measure.each do |measure|
        puts "Generating JavaScript for '#{measure.title}'"
        measure.pregenerate_js
      end
    end
  end

  namespace :patients do

    desc 'Update measure ids from NQF to HQMF.'
    task :update_measure_ids => :environment do
      puts "Updating patient measure_ids from NQF to HQMF"
      Record.each do |patient|
        patient.measure_ids.map! { |id| Measure.or({ measure_id: id }, { hqmf_id: id }, { hqmf_set_id: id }).first.try(:hqmf_set_id) }.compact!
        patient.save
        puts "Updated patient #{patient.first} #{patient.last}."
      end
    end

    desc 'Reset expected_values hash.'
    task :reset_expected_values => :environment do
      sub_ids = ("a".."z").to_a
      measureHash = Hash.new
      Record.each do |patient|
        patient.expected_values = Hash.new
        if patient.measure_ids.blank?
          patient.save
          puts "Warning! Patient #{patient.first} #{patient.last} (#{patient.medical_record_number}) has no associated measures!"
        else
          patient.measure_ids.each do |mid|
            if measureHash.include? mid
              patient.expected_values[mid] = measureHash[mid]
            else
              patient.expected_values[mid] = Hash.new
              if measure = Measure.where(hqmf_set_id: mid).first
                measure.populations.each_with_index do |populations, index|
                  # Initialize all population expected values to 0 (excluded from all populations)
                  patient.expected_values[mid][sub_ids[index]] = Hash.new
                  validPopulations = populations.keys & Measure.where(hqmf_set_id: mid).first.population_criteria.keys
                  validPopulations.each do |population|
                    patient.expected_values[mid][sub_ids[index]][population] = 0
                  end
                end
                measureHash[mid] = patient.expected_values[mid]
              end
            end
          end
          patient.save
          puts "Reset expected_values for patient #{patient.first} #{patient.last}."
        end
      end
    end
  end
end
