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
      puts
    end # calculate_all

    desc 'Clear the calculation results.'
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
      puts "There are #{Record.count} patients to process."
      Measure.each do |measure|
        patients = Record.where(user_id: measure.user_id, measure_ids: measure.hqmf_set_id)
        next if patients.count == 0
        
        measure_population_sets = measure.populations.map { |population_set| population_set.slice(*HQMF::PopulationCriteria::ALL_POPULATION_CODES) }

        patients.each do |patient|
          # get only the expected values related to this measure. Necessary to handle portfolio users.
          expected_values = patient.expected_values.select { |expected_value_set| expected_value_set[:measure_id] == measure.hqmf_set_id }

          # ensure there's the correct number of population sets
          patient_population_count = expected_values.count
          measure_population_count = measure_population_sets.count
          # add new population sets. the rest of the data gets added below.
          if patient_population_count < measure_population_count
            (patient_population_count..measure_population_count-1).each do |index|
              expected_values << {measure_id: measure.hqmf_set_id, population_index: index}
            end
          end
          # delete old population sets
          if measure_population_count < patient_population_count
            expected_values = expected_values[measure_population_count..-1]
          end

          expected_values.each do |expected_value_set|
            # ignore if there's a mismatch population count
            next unless measure_population_sets[expected_value_set[:population_index]]

            expected_value_population_set = expected_value_set.slice(*HQMF::PopulationCriteria::ALL_POPULATION_CODES).keys
            measure_population_set = measure_population_sets[expected_value_set[:population_index]].keys

            # add population sets that didn't exist (populations in the measure that don't exist in the expected values)
            added_populations = measure_population_set - expected_value_population_set
            added_populations.each do |population|
              expected_value_set[population] = 0
            end

            # delete populations that no longer exist (populations in the expected values that don't exist in the measure)
            removed_populations = expected_value_population_set - measure_population_set
            expected_value_set.except!(*removed_populations)
          end

          patient.expected_values = expected_values
          patient.save!
          print "."
        end # patients
      end # measures
      puts
    end # task

  end
end
