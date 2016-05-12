namespace :upgrade_add_hx_tracks do
  namespace :patients do
    
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
            res = []
            result.store('measure_id',measure.hqmf_set_id)
            result.store('population_index', population_index)
            res << result
            if !patient.actual_values.present?
              patient.write_attribute(:actual_values, res)
              else
                patient.actual_values[population_index] = result
              end
            patient.save!
            yield measure, population_index, patient, result, setup_exception || calculation_exception
          end
        end
      end
    end
    
    desc 'Calculate every patient in the database and display any errors (does not test for correct results)'
    task :calculate_all => :environment do
      STDOUT.sync = true
      start = Time.now
      calculate_all do |measure, population_index, patient, result, error|
        if error
          puts "\n\n  Error with user #{measure.user.email} measure #{measure.cms_id} patient '#{patient.first} #{patient.last}':"
          puts "  #{error}\n\n"
        else
          print '.'
        end
        puts "Measure: #{measure.cms_id}\n\tPatient: #{patient.first} #{patient.last} (#{patient._id})\n\t\tPopulation Index: #{population_index}\n\t\t\tResult #{result}"
        ptt = Record.find(patient._id)
        # res = []
        # res << result
        # ptt.write_attribute(:actual_values, res)
        # ptt.save!
      end
      puts
      finish = Time.now
      puts "It took #{finish - start} seconds to run this."
    end
    
  end
end