namespace :bonnie do
  namespace :calculation_tests do

    # Store results in Mongo for regression
    class CalculationRegressionResult
      include Mongoid::Document
      field :measure_id, type: BSON::ObjectId
      field :population_index, type: Integer
      field :patient_id, type: BSON::ObjectId
      field :result, type: Hash
      field :error, type: String
    end

    # Calculate all patients against their measures, yielding the results or, if there's an error, the error
    def calculate_all(options = {})
      calculator = BonnieBackendCalculator.new
      query = {}
      query[:user_id] = User.where(email: options[:user_email]).first.try(:id) if options[:user_email]
      query[:cms_id] = options[:cms_id] if options[:cms_id]
      measures = Measure.where(query)
      measures.each do |measure|
        measure.populations.each_with_index do |population, population_index|
          # Set up calculator for this measure and population, making sure we regenerate the javascript
          begin
            calculator.set_measure_and_population(measure, population_index, clear_db_cache: true)
          rescue => e
            setup_exception = "Measure setup exception: #{e.message}"
          end
          patients = Record.where(user_id: measure.user_id, measure_ids: measure.hqmf_set_id)
          patients.each do |patient|
            unless setup_exception
              begin
                result = calculator.calculate(patient).slice(*HQMF::PopulationCriteria::ALL_POPULATION_CODES)
              rescue => e
                calculation_exception = "Measure calculation exception: #{e.message}"
              end
            end
            yield measure, population_index, patient, result, setup_exception || calculation_exception
          end
        end
      end
    end

    desc 'Calculate every patient in the database and store the result for later regression'
    task :prime_regression => :environment do
      STDOUT.sync = true
      CalculationRegressionResult.delete_all
      calculate_all do |measure, population_index, patient, result, error|
        # Just store the result and/or any error
        CalculationRegressionResult.create(measure_id: measure.id, population_index: population_index,
                                           patient_id: patient.id, result: result, error: error)
        print '>'
      end
      puts
    end

    desc 'Calculate every patient in the database and compare against stored results for regression'
    task :test_regression => :environment do
      passed = failed = nogold = 0
      STDOUT.sync = true
      calculate_all(user_email: ENV['USER_EMAIL'], cms_id: ENV['CMS_ID']) do |measure, population_index, patient, result, error|
        gold = CalculationRegressionResult.where(measure_id: measure.id, population_index: population_index, patient_id: patient.id).first
        if gold
          # See if result and/or error are the same (it's a regression, so we don't care about errors, just change)
          if gold.result == result && gold.error == error
            passed += 1
            print '.'
          else
            failed += 1
            # Display error immediately instead of waiting 'till end, it's a long wait...
            puts "\n\n  FAILURE: User #{measure.user.email} measure #{measure.cms_id} population #{population_index + 1} patient '#{patient.first} #{patient.last}'\n\n"
            puts "             Expected: #{gold.result} #{gold.error}"
            puts "                Found: #{result} #{error}"
            puts
          end
        else
          nogold += 1
          print '?'
        end
      end
      puts
      puts "#{passed+failed+nogold} tests, #{passed} passed, #{failed} failures, #{nogold} without gold data"
    end

    desc 'Calculate every patient in the database and display any errors (does not test for correct results)'
    task :calculate_all => :environment do
      STDOUT.sync = true
      in_error = 0
      good = 0
      calculate_all do |measure, population_index, patient, result, error|
        if error
          in_error += 1
          value_sets = measure.value_sets
          if (value_sets.length != measure.bonnie_hashes.length)
            puts "\n\nversion_oid: #{measure.bonnie_hashes.length} ||| set length #{value_sets.length}"
            puts "#{measure.value_set_oids}"
            puts "#{measure.bonnie_hashes}"
          end
          puts "\n\n  Error with user #{measure.user.email} measure #{measure.cms_id} patient '#{patient.first} #{patient.last}':"
          puts "  #{error}\n\n"
        else
          good += 1
          print '.'
        end
      end
      puts "#{in_error} in error vs #{good} working"
    end

  end
end
