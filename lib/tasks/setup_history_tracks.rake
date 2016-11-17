namespace :bonnie do
  namespace :setup_history_tracks do

    desc 'Calculate every patient in the database and stores their calculation results'
    task :store_calculation_results => :environment do
      STDOUT.sync = true
      
      calculator = BonnieBackendCalculator.new
      puts "There are #{Measure.count} measures to process."
      Measure.each_with_index do |measure, measure_index|
        patients = Record.where(user_id: measure.user_id, measure_ids: measure.hqmf_set_id)
        measure.populations.each_with_index do |population_set, population_index|
          begin
            calculator.set_measure_and_population(measure, population_index, clear_db_cache: true, rationale: true)
          rescue => e
            puts "\nError setting up calculator for #{measure.user.email} measure #{measure.cms_id} population set #{population_index}:"
            puts "Measure setup exception: #{e.message}."
            next # Move onto the next population set
          end
          
          patient_fields_to_process = HQMF::PopulationCriteria::ALL_POPULATION_CODES | ['rationale', 'finalSpecifics']

          processed_patients_array = []
          patients.each_with_index do |patient, patient_index|
            if processed_patients_array.include?(patient)
              puts "\nPatient repeated for #{measure.user.email} measure #{measure.cms_id} population set #{population_index}."
              puts "\tID: #{patient.id}\tName: #{patient.first} #{patient.last}"
              next
            end
            processed_patients_array << patient
            
            begin
              result = calculator.calculate(patient).slice(*patient_fields_to_process)
            rescue => e
              puts "\nError calculating for user #{measure.user.email} measure #{measure.cms_id} population set #{population_index} patient '#{patient.first} #{patient.last}' (_id: ObjectId('#{patient.id}')):"
              puts "Measure calculation exception: #{e.message}"
              next # Move onto the next patient
            end

            result['population_index'] = population_index
            result['measure_id'] = measure.hqmf_set_id
            patient.calc_results << result
            patient.save!
          end
        end
        print "."
      end # measures
    end # calculate_all

    desc 'Clear any existing actual values'
    task :clear_calculation_results => :environment do
      STDOUT.sync = true
      puts "There are #{Record.count} patients to process"
      Record.each do |patient|
        patient.calc_results = []
        patient.save!
        print '.'
      end
      puts
    end

    desc 'Align expected values on patients with the populations defined on the measure.'
    task :sync_expected_values => :environment do
      STDOUT.sync = true
      puts 'Align expected values on patients with the populations defined on the measure.'
      puts "There are #{Measure.count} measures to process."
      Measure.each do |measure|
        patients = Record.where(user_id: measure.user_id, measure_ids: measure.hqmf_set_id)
        next if patients.count == 0
        
        patients.each do |patient|
          patient.expected_values.each do |expected_value_set|
            # ignore if expected values related to other measure (could happen with portfolio users)
            next if expected_value_set['measure_id'] != measure.hqmf_set_id
            # ignore if there's a mismatch population count
            next unless measure.populations[expected_value_set['population_index']]

            # add population sets that didn't exist
            population_set = measure.populations[expected_value_set['population_index']].slice(*HQMF::PopulationCriteria::ALL_POPULATION_CODES)
            population_set.keys.each do |population|
              unless expected_value_set.include? population
                expected_value_set[population] = 0
              end
            end
            
            # delete population sets that no longer exist
            expected_value_set_populations = expected_value_set.slice(*HQMF::PopulationCriteria::ALL_POPULATION_CODES).keys
            rejected_populations = []
            expected_value_set_populations.each do |population|
              unless population_set.include? population
                rejected_populations << population
              end
            end
            expected_value_set.except!(*rejected_populations)
          end
          patient.save!
        end # patients
        print "."
      end # measures
      puts
    end # task

  end
end
