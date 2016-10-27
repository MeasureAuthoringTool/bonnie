namespace :upgrade_add_hx_tracks do
  namespace :patients do

    desc "Calculate all patients against their measures, yielding the results or, if there's an error, the error"
    def calculate_all(options = {})
      calculator = BonnieBackendCalculator.new
      query = {}
      query[:user_id] = User.where(email: options[:user_email]).first.try(:id) if options[:user_email]
      query[:cms_id] = options[:cms_id] if options[:cms_id]
      measures = Measure.where(query)
      puts "There are #{measures.count} measures to process."
      processed_measure_counter = 1
      measures.each do |measure|
        puts "\nProcessing measure #{processed_measure_counter} of #{measures.count}.\t(cms_id: #{measure.cms_id} for user: #{measure.user_id})"
        puts "This measure has #{measure.populations.count} population sets."
        measure.populations.each_with_index do |population, population_index|
          puts "\tProcessing population set #{(population_index + 1)} of #{measure.populations.count}.\n"
          # Set up calculator for this measure and population, making sure we regenerate the javascript
          begin
            calculator.set_measure_and_population(measure, population_index, clear_db_cache: true, rationale: true)
          rescue => e
            setup_exception = "Measure setup exception: #{e.message}"
          end
          populations_to_process = population.keys.reject { |k| k == 'id' || k == 'title' }
          populations_to_process.push('rationale', 'finalSpecifics')
          patients = Record.where(user_id: measure.user_id, measure_ids: measure.hqmf_set_id)
          puts "\t\tThere are #{patients.count} patients for this this measure." if population_index == 0
          print "\t\t"
          processed_patients_counter = 0
          processed_patients_array = []
          patients.each_with_index do |patient, index|
            next if processed_patients_array.include?(patient)
            processed_patients_array << patient
            unless setup_exception
              begin
                result = calculator.calculate(patient).slice(*populations_to_process)
              rescue => e
                calculation_exception = "Measure calculation exception: #{e.message}"
              end
            end
            next unless result
            result['population_index'] = population_index
            result['measure_id'] = measure.hqmf_set_id
            patient.calc_results << result
            patient.save!
            processed_patients_counter += 1
            if processed_patients_counter % 10 == 0 || processed_patients_counter == patients.count
              print processed_patients_counter.to_s
              print "\n" if processed_patients_counter == patients.count
            else
              print '=' unless processed_patients_counter > patients.count
            end
            yield measure, population_index, patient, result, setup_exception || calculation_exception
          end
        end
        processed_measure_counter += 1
      end # mesuares
    end # calculate_all

    desc 'Clear any existing actual values'
    task :clear_actuals => :environment do
      STDOUT.sync = true
      # patients = Record
      puts "There are #{Record.count} patients"
      cleaned_patients = 0
      Record.each do |patient|
        patient.calc_results = []
        patient.save!
        cleaned_patients += 1
        if cleaned_patients % 10 == 0
          print cleaned_patients.to_s
          print "\n" if cleaned_patients % 100 == 0
        else
          print '='
        end
      end
    end

    desc 'Align expected values on patients with the populations defined on the measure.'
    task :sync_expected => :environment do
      STDOUT.sync = true
      puts 'Align expected values on patients with the populations defined on the measure.'
      processed_measure_counter = 0
      Measure.each do |measure|
        processed_measure_counter += 1
        patients = Record.where(user_id: measure.user_id, measure_ids: measure.hqmf_set_id)
        next if patients.count == 0
        corrected_expected = []
        measure.populations.each_with_index do |pop, idx|
          currentPopulations = {measure_id: measure.hqmf_set_id, population_index: idx}
          pop.slice(*HQMF::PopulationCriteria::ALL_POPULATION_CODES).each do |my_code, _v|
            # The populations are a key, value pair; slice returns this as an array.  Only the key.
            # Setting the value to 0 because if this is a new population for the population set
            # we have to assume that existing test patients won't meet the population.
            currentPopulations[my_code] = 0
          end
          corrected_expected << currentPopulations
        end

        processed_patients_counter = 0

        puts "\nWorking on #{measure.title} (_id: ObjectId('#{measure.id}'))"
        puts "  There are #{patients.count} patients to work on."
        patients.each do |patient|
          #For each patient make a new copy of the current expected population sets and populations
          new_expected_values = corrected_expected.dup
          new_expected_values.each_with_index do |population_set, ps_index|
            # Copy any existing values to the new expected values but only
            # if it exists in the new expected values
            population_set.each_key { |population| population_set[population] = patient.expected_values[ps_index][population] unless patient.expected_values[ps_index].nil? }
          end
          # Only need to more if there is a difference between the new_expected_values and existing patient.expected_values
          unless patient.expected_values == new_expected_values
            patient.expected_values = new_expected_values
            patient.calc_results = []
            patient.save!
          end
          processed_patients_counter += 1
          if processed_patients_counter % 10 == 0 || processed_patients_counter == patients.count
            print processed_patients_counter.to_s
            print "\n" if processed_patients_counter == patients.count
          else
            print '=' unless processed_patients_counter > patients.count
          end
        end # patients

        puts "#{processed_measure_counter} measures of #{Measure.count} completed." if processed_measure_counter % 10 == 0
      end # measures
      log_file.close
      puts 'Done with task :sync_expected'
    end # task

    desc 'Calculate every patient in the database and display any errors (does not test for correct results)'
    task :calculate_all => :environment do
      STDOUT.sync = true
      start = Time.now
      log_file = File.open("./log/calculate_all_log_#{start.strftime("%Y%m%d_%H%M%S")}.txt", "w")
      errors_occurred = false
      calculate_all do |measure, population_index, patient, result, error|
        if error
          errors_occurred = true
          log_file.puts "\n\n  Error with user #{measure.user.email} measure #{measure.cms_id} population set #{population_index} patient '#{patient.first} #{patient.last}' (_id: ObjectId('#{patient.id}')):"
          log_file.puts "  #{error}\n\n"
        end
      end
      puts
      finish = Time.now
      puts "It took #{finish - start} seconds to run this."
      puts "There are errors. Please view ./log/calculate_all_log_#{start.strftime("%Y%m%d_%H%M%S")}.txt the details." if errors_occurred
    end

  end
end
