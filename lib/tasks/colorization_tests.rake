# These rake tasks allow regression testing of the colorization code used for highlighting measures to match
# calculation results. To run them:
#
#   1) Using the code base as it looks before making any changes, run the prime_regression task, using a user
#      account with a good representative sample of measures and patients; this calculates all the patients
#      and stores the rationale and specificsRationale (used for colorization) for later use in regression
#
#   2) With the desired code changes in place, run the test_regression task using the same user account; this
#      calculates all the patients again and compares the rationale and specificsRationale against the results
#      stored in step 1

namespace :bonnie do
  namespace :colorization_tests do

    # Store results in Mongo for regression
    class ColorizationRegressionResult
      include Mongoid::Document
      field :measure_id, type: BSON::ObjectId
      field :population_index, type: Integer
      field :patient_id, type: BSON::ObjectId
      field :result, type: Hash
    end

    # Compare two hashes; adapted from https://gist.github.com/henrik/146844
    def hash_diff(a, b)
      (a.keys | b.keys).inject({}) do |diff, k|
        if a[k] != b[k]
          if a[k].is_a?(Hash) && b[k].is_a?(Hash)
            diff[k] = hash_diff(a[k], b[k])
          else
            diff[k] = [a[k], b[k]]
          end
        end
        diff
      end
    end

    # Given a measure, population index, and an array of patients, calculate the patients against the
    # population and return a matching array of results, including the specificsRationale which gets
    # calculated on the front end (ie in a browser) for use in colorization; this makes use of PhantomJS to
    # simulate a browser environment so we can run the front end code without using a browser.
    def calculate_in_frontend(measure, population_index, patients)

      results = nil

      # Set up code for calculating with colorization results to be evaluated in PhantomJS; for this we write
      # JS to a temp file, this is needed because PhantomJS is an external process (launched via the phantomjs
      # Gem) that requires JS to be loaded from a file.
      Tempfile.open('calculate_in_frontend.js') do |f|

        # Write all the application front end JS to the file
        f.puts Rails.application.assets.find_asset('application.js').source

        # Bootstrap the measure and patients; we use the same approach as in app/views/layouts/debug.html.erb
        measure_json = MultiJson.encode(measure.as_json(except: [:map_fns, :record_ids, :measure_attributes], methods: [:value_sets]))
        f.puts "var measure = new Thorax.Models.Measure(#{measure_json.html_safe}, { parse: true });"
        patients_json = MultiJson.encode(patients.as_json(except: :results))
        f.puts "var patients = new Thorax.Collections.Patients(#{patients_json.html_safe}, { parse: true });"
        f.puts "measure.set('patients', patients);"
        f.puts "bonnie.measures.add(measure);"

        # Overwrite calculation infrastructure as necessary to make calculation be synchronous; again same
        # approach as in app/views/layouts/debug.html.erb
        f.puts "bonnie.calculator.setCalculator = function(population, calcFunction) {"
        f.puts "  population.calculate = function(patient) {"
        f.puts "    result = calcFunction(patient.toJSON());"
        f.puts "    result = new Thorax.Models.Result(result, { population: population, patient: patient });"
        f.puts "    result.state = 'complete';"
        f.puts "    return result;"
        f.puts "  }"
        f.puts "};"

        # Add the calculation JS for the desired population; in the browser this would come from the
        # PopulationsController#calculate_code
        f.puts BonnieMeasureJavascript.generate_for_population(measure, population_index)

        # Perform the calculations and output the results as JSON; the result includes the specificsRationale,
        # which has the colorization information
        f.puts "var population = measure.get('populations').at(#{population_index});"
        f.puts "var results = patients.map(function(patient) { return population.calculate(patient); });"
        f.puts "console.log(JSON.stringify(results));"

        # Make sure the PhantomJS process terminates
        f.puts "phantom.exit(0);"
        f.flush

        # Evaluate the resulting pile of JS in PhantomJS, and grab the JSON encoded results
        # NOTE: It's difficult to debug JS running in PhantomJS; if that's something you need to do, the best
        # bet is to grab the contents of the temp file containing the JS and evaluate it in a browser
        results = JSON.parse Phantomjs.run(f.path)
      end

      # We just care about the rationale and specificsRationale for colorization
      return results.map { |r| r.slice('rationale', 'specificsRationale') }
    end

    desc 'Calculate every patient in the database along with desired colorization and store the result for later regression'
    task :prime_regression => :environment do
      raise "Please supply an EMAIL option to run tests agasint a single account" unless ENV['EMAIL']
      STDOUT.sync = true
      ColorizationRegressionResult.delete_all
      user = User.where(email: ENV['EMAIL']).first
      measures = Measure.where(user_id: user.id)
      measures.each do |measure|
        patients = Record.where(user_id: measure.user_id, measure_ids: measure.hqmf_set_id)
        measure.populations.each_with_index do |population, population_index|
          # Calculate the results and store for later regression
          results = calculate_in_frontend(measure, population_index, patients)
          patients.zip(results).each do |patient, result|
            ColorizationRegressionResult.create(measure_id: measure.id, population_index: population_index, patient_id: patient.id, result: result)
            print '>'
          end
        end
      end
      puts
    end

    desc 'Calculate every patient in the database along with desired colorization and compare against stored results for regression'
    task :test_regression => :environment do
      raise "Please supply an EMAIL option to run tests agasint a single account" unless ENV['EMAIL']
      passed = failed = nogold = 0
      STDOUT.sync = true
      user = User.where(email: ENV['EMAIL']).first
      measures = Measure.where(user_id: user.id)
      measures.each do |measure|
        patients = Record.where(user_id: measure.user_id, measure_ids: measure.hqmf_set_id)
        measure.populations.each_with_index do |population, population_index|
          # Calculate the results and compare to the stored results for regression
          results = calculate_in_frontend(measure, population_index, patients)
          patients.zip(results).each do |patient, result|
            gold = ColorizationRegressionResult.where(measure_id: measure.id, population_index: population_index, patient_id: patient.id).first
            if gold
              if gold.result == result
                passed += 1
                print '.'
              else
                failed += 1
                puts "\n\n  FAILURE: User #{measure.user.email} measure #{measure.cms_id} population #{population_index + 1} patient '#{patient.first} #{patient.last}'\n\n"
                puts "             Difference:"
                puts
                puts hash_diff(result, gold.result).pretty_inspect.gsub(/^/, '               ')
                puts
              end
            else
              nogold += 1
              print '?'
            end
          end
        end
      end
      puts
      puts "#{passed+failed+nogold} tests, #{passed} passed, #{failed} failures, #{nogold} without gold data"
    end

  end
end
