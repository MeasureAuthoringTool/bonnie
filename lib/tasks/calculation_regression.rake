namespace :bonnie do
  namespace :calculation_regression do

    # Store results in Mongo for regression
    class CalculationRegressionResult
      include Mongoid::Document
      field :measure_id, type: BSON::ObjectId
      field :population_index, type: Integer
      field :patient_id, type: BSON::ObjectId
      field :result, type: Hash
    end

    # Calculate all patients against their measures, yielding the results
    def calculate_all
      calculator = BonnieBackendCalculator.new
      Measure.each do |measure|
        measure.populations.each_with_index do |population, population_index|
          calculator_ok = calculator.set_measure_and_population(measure, population_index)
          patients = Record.where(user_id: measure.user_id, measure_ids: measure.hqmf_set_id)
          patients.each do |patient|
            if calculator_ok
              result = calculator.calculate(patient).slice(*HQMF::PopulationCriteria::ALL_POPULATION_CODES) rescue {}
            else
              result = {}
            end
            yield measure, population_index, patient, result
          end
        end
      end
    end

    desc 'Calculate every patient in the database and store the result for later regression'
    task :prime_results => :environment do
      STDOUT.sync = true
      CalculationRegressionResult.delete_all
      calculate_all do |measure, population_index, patient, result|
        CalculationRegressionResult.create(measure_id: measure.id, population_index: population_index,
                                           patient_id: patient.id, result: result)
        print '>'
      end
      puts
    end

    desc 'Calculate every patient in the database and compare against stored results for regression'
    task :test_results => :environment do
      passed = failed = nogold = 0
      STDOUT.sync = true
      calculate_all do |measure, population_index, patient, result|
        gold = CalculationRegressionResult.where(measure_id: measure.id, population_index: population_index, patient_id: patient.id).first
        if gold
          if gold.result == result
            passed += 1
            print '.'
          else
            failed += 1
            # Display error immediately instead of waiting 'till end, it's a long wait...
            puts "\n\n  FAILURE: User #{measure.user.email} measure #{measure.cms_id} patient '#{patient.first} #{patient.last}'\n\n"
            puts "             Expected #{gold.result}"
            puts "                Found #{result}"
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

  end
end
