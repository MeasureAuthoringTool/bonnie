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
            calculator.set_measure_and_population(measure, population_index, clear_db_cache: true, rationale: true)
          rescue => e
            setup_exception = "Measure setup exception: #{e.message}"
          end
          strat_pops = population.keys.reject { |k| k == 'id' || k == 'title' }
          strat_pops.push('rationale', 'finalSpecifics')
          patients = Record.where(user_id: measure.user_id, measure_ids: measure.hqmf_set_id)
          patients.each do |patient|
            unless setup_exception
              begin
                result = calculator.calculate(patient).slice(*strat_pops)
              rescue => e
                calculation_exception = "Measure calculation exception: #{e.message}"
              end
            end
            next unless result
            result['population_index'] = population_index
            result['measure_id'] = measure.hqmf_set_id
            attempts = 0
            begin
              # The size of the results will be checked by the before_save in record.rb
              patient.calc_results << result
              patient.save!
            rescue Exception => e
              puts e.message
              puts e.backtrace.inspect
              patient.calc_results = []
              attempts += 1
              if attempts < 2
                retry
              else
                raise
              end
            end
            yield measure, population_index, patient, result, setup_exception || calculation_exception
          end
        end
      end # mesuares
    end # calculate_all
    
    desc 'Clear any existing actual values'
    task :clear_actuals => :environment do
      STDOUT.sync = true
      patients = Record
      patients.each do |patient|
        patient.unset(:calc_results)
        patient.save!
      end
    end
    
    desc 'Align expected values on patients with the populations defined on the measure.'
    task :sync_expected => :environment do
      STDOUT.sync = true
      puts 'Align expected values on patients with the populations defined on the measure.'
      measures = Measure
      mdone = 1
      measures.each do |measure|
        corrected_expected = []
        measure.populations.each_with_index do |pop, idx|
          currentPopulations = {"measure_id" => measure.hqmf_set_id, "population_index" => idx}
          pop.slice(*HQMF::PopulationCriteria::ALL_POPULATION_CODES).each do |my_code, _v|
          # The populations are a key, value pair; slice returns this as an array.  We want the key.
            currentPopulations[my_code] = 0
          end
          corrected_expected << currentPopulations
        end
        patients = Record.where({'user_id'=>measure.user_id, 'measure_ids'=>{'$in'=>[measure.hqmf_set_id]} })
        pdone = 1

        puts "\t#{measure.title}"
        patients.each do |patient|
          begin
          extraPopulationSets = []
          patient.expected_values.each_with_index do |ev, i|

            if measure.hqmf_set_id == ev['measure_id']
              # Check if the population set exists
              if corrected_expected.fetch(ev['population_index'], 'gone') == 'gone'
                # It does not
                extraPopulationSets.push(i)
              else
                # It does so make sure the populations within the set match
                ev.keep_if { |k,v| corrected_expected[ev['population_index']].has_key?(k) } # Remove any extra populations
                ev.merge!(corrected_expected[ev['population_index']]) { |key, e, c| e } # merge in any missing values
              end
            end
          end
          if !extraPopulationSets.empty?
            # Remove any extra population sets
            # Walking the array backwards so as not to get an index violation
            extraPopulationSets.reverse!.each { |tm| patient.expected_values.delete_at(tm) }
          end
          patient.calc_results = nil
          patient.save!
          rescue
            puts patient.id
          end
          pdone += 1
          puts "\t\t#{pdone} patients of #{patients.count} completed." if pdone%10 == 0
        end # patients
        mdone += 1
        puts "#{mdone} measures of #{measures.count} completed." if mdone%10 == 0
      end # measures
      puts "Done with task :sync_expected"
    end # task

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
       puts "Measure: #{measure.cms_id}\n\tPatient: #{patient.first} #{patient.last} (#{patient._id})\n\t\tPopulation Index: #{population_index}"
      end
      puts
      finish = Time.now
      puts "It took #{finish - start} seconds to run this."
    end
  
  end
end