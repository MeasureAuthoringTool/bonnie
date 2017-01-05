require 'test_helper'

class PatientTest < ActionController::TestCase  #ActiveSupport::TestCase
  include Devise::TestHelpers
  
  tests MeasuresController
  # TODO: See if the can be set to tests Record

  setup do
    @error_dir = File.join('log', 'load_errors')
    FileUtils.rm_r @error_dir if File.directory?(@error_dir)
    dump_database
    users_set = File.join('users', 'base_set')
    collection_fixtures(users_set)
    @user = User.by_email('bonnie@example.com').first
    sign_in @user

    # TODO: When measure fixtures are available switchh to loading them
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'base_example', 'CMS68v6.zip'), 'application/zip')
    # Load the measure
    post :create, measure_file: measure_file, measure_type: 'ep', calculation_type: 'proportional'

    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'multi_population', 'CMS160v3.zip'), 'application/zip')
    # Load the measure
    post :create, measure_file: measure_file, measure_type: 'ep', calculation_type: 'proportional'

    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'update_change', 'CMS104v3.zip'), 'application/zip')
    # Load the measure
    post :create, measure_file: measure_file, measure_type: 'ep', calculation_type: 'proportional'

    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'continuous_variable', 'EH_CMS32v4.zip'), 'application/zip')
    # Load the measure
    post :create, measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'
    post :finalize, {"t551"=>{"hqmf_id"=>"40280381-43DB-D64C-0144-6A8B0A3B30C6", "episode_ids"=>["OccurrenceAEmergencyDepartmentVisit1"], "titles"=>{"0"=>"Population 1 k", "1"=>"Stratification 1 k", "2"=>"Stratification 2 k", "3"=>"Stratification 3 k", "4"=>"foo"}}}

    @golden_results = {}

    records_set = File.join('records', "measure_history_set", "base_example")
    collection_fixtures(records_set)
    @golden_results.store(BSON::ObjectId('58514916e76e941a3d000489'), [{'IPP'=> 1, 'DENOM'=> 1, 'NUMER'=> 1, 'DENEX'=> 0, 'DENEXCEP'=> 0, 'NUMEX'=> 0, 'status'=> 'pass'}])
    @golden_results.store(BSON::ObjectId('58514954e76e941a3d0004c4'), [{'IPP'=> 0, 'DENOM'=> 0, 'DENEX'=> 0, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'pass'}])

    records_set = File.join('records', "measure_history_set", "multi_population")
    collection_fixtures(records_set)
    @golden_results.store(BSON::ObjectId('58515844e76e941a3d0004fa'), [ {'IPP'=> 1, 'DENOM'=> 1, 'DENEX'=> 1, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'pass'},
      {'IPP'=> 0, 'DENOM'=> 0, 'DENEX'=> 0, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'pass'},
      {'IPP'=> 0, 'DENOM'=> 0, 'DENEX'=> 0, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'pass'} ] )
    @golden_results.store(BSON::ObjectId('58515899e76e941a3d000543'), [ {'IPP'=> 0, 'DENOM'=> 0, 'DENEX'=> 0, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'pass'},
      {'IPP'=> 0, 'DENOM'=> 0, 'DENEX'=> 0, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'pass'},
      {'IPP'=> 0, 'DENOM'=> 0, 'DENEX'=> 0, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'pass'} ] )
    @golden_results.store(BSON::ObjectId('585158c2e76e941a3d00057b'), [ {'IPP'=> 0, 'DENOM'=> 0, 'DENEX'=> 0, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'pass'},
      {'IPP'=> 0, 'DENOM'=> 0, 'DENEX'=> 0, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'pass'},
      {'IPP'=> 0, 'DENOM'=> 0, 'DENEX'=> 0, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'pass'} ] )

    records_set = File.join('records', "measure_history_set", "update_change")
    collection_fixtures(records_set)
    @golden_results.store(BSON::ObjectId('5852fa58e76e94e528001e9d'), [ {'IPP'=> 0, 'DENOM'=> 0, 'DENEX'=> 0, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'fail'} ] )

    records_set = File.join('records', "measure_history_set", "continuous_variable")
    collection_fixtures(records_set)
    # TODO
    # Add the golden results for the continuous variable measure

    associate_user_with_measures(@user, Measure.all)
    # associate_measures_with_patients([@measure], Record.all)
    associate_user_with_patients(@user, Record.all)

  end

  def calculation_results (measure) 
    # Remove any calc results and related fields that might have been loaded
    Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id).each do |patient|
      patient.unset(:calc_results) unless patient[:calc_results].nil? 
      patient.save!
      assert patient[:calc_results].nil?, "Failed nil calc_results on patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}"
      # The patient has before_save actions
      assert_not patient[:results_exceed_storage], "Failed results_exceed_storage == false on patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}"
      assert_equal 4, patient[:results_size], "Failed results_size == 4 on patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}"
    end

    # TODO: Make this a method
    calculator = BonnieBackendCalculator.new
    patients = Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id)
    # Move on if there are no patients associated with this measure for this user
    if patients.count == 0
      flunk "No patients for measure #{measure.cms_id}"
    end
    measure.populations.each_with_index do |population_set, population_index|
      begin
        calculator.set_measure_and_population(measure, population_index, clear_db_cache: true, rationale: true)
      rescue => e
        puts "\nError for #{measure.user.email if measure.user?} measure #{measure.cms_id} population set #{population_index}:"
        puts "Calculator setup exception: #{e.message}."
        next
      end
      processed_patients_array = []
      patients.no_timeout.each_with_index do |patient, patient_index|

        # For some reason, patients show up multiple times during this iteration.
        # This checks for that and skips those patients to reduce the number of calculations.
        if processed_patients_array.include?(patient)
          next
        end
        processed_patients_array << patient

        begin
          patient.update_calc_results!(measure, population_index, calculator)
        rescue => e
          puts "\nError for #{measure.user.email if measure.user?} measure #{measure.cms_id} population set #{population_index} patient '#{patient.first} #{patient.last}' (_id: ObjectId('#{patient.id}')):"
          puts "Calculation exception: #{e.message}."
          next # Move onto the next patient
        end
      end
    end

    # TODO: This list needs to be maintained.
    calc_results_keys = ['IPP', 'rationale', 'finalSpecifics', 'measure_id', 'population_index', 'status', 'values', 'STRAT']
    unless measure.continuous_variable
      calc_results_keys = calc_results_keys + ['DENOM', 'DENEX', 'NUMER', 'NUMEX', 'DENEXCEP']
    else
      calc_results_keys = calc_results_keys + ['MSRPOPL', 'MSRPOPLEX']
    end

    Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id).each do |patient|
      assert_not_nil @golden_results[patient.id], "Missing golden result for patient name #{patient.first} #{patient.last} (patient.id: #{patient.id.to_s}) for measure #{measure.cms_id}."
      assert_equal measure.populations.length, patient[:calc_results].count, "Failed calc_results count on patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}"
      assert_operator 4, :<, patient[:results_size]
      assert patient[:results_exceed_storage] if patient[:results_size] > APP_CONFIG['record']['max_size_in_bytes']
      assert_not patient[:results_exceed_storage] if patient[:results_size] <= APP_CONFIG['record']['max_size_in_bytes']
      assert_not_nil patient[:calc_results], "Failed not_nil calc_results exists on patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}"
      measure.populations.each_with_index do |population_set, population_index|
        assert_empty (patient[:calc_results][population_index].keys - calc_results_keys), "Failed calc_results keys on patient name #{patient.first} #{patient.last}.\npatient[:calc_results][0].keys = #{patient[:calc_results][population_index].keys} for measure #{measure.cms_id}"
        assert_equal measure.hqmf_set_id, patient[:calc_results][population_index][:measure_id], "Failed measure_id on patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}"
        # Make sure that the calculations are correct
        assert_not_nil @golden_results[patient.id][population_index], "Missing golden result for patient name #{patient.first} #{patient.last} (patient.id: #{patient.id.to_s}) for measure #{measure.cms_id} for population_set: [#{population_index}]."
        @golden_results[patient.id][population_index].each do |result_population, result_value|
          assert_equal result_value, patient.calc_results[population_index][result_population], "Failed correct calc_result on patient name #{patient.first} #{patient.last} (patient.id: #{patient.id.to_s}) for measure #{measure.cms_id} for population_set: [#{population_index}], population: [#{result_population}].\n#{patient.calc_results[population_index]}"
        end
      end
    end

  end

  def expected_values_empty_properly_populated (measure)

    # Set the expected values to be empty
    Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id).each do |patient|
      patient.expected_values = []
      patient.save!
    end

    Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id).each do |patient|
      assert patient[:expected_values].empty?, "Failed empty expected_values on patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}"
      patient.update_expected_value_structure!(measure) 
      assert_not patient[:expected_values].nil?, "Failed not nil expected_values on patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}"
      # Test that the number of populations match
      assert_equal measure.populations.length, patient.expected_values.length
      measure.populations.each_with_index do |population_set, population_index|
        # Test that the population set is filled with the correct populations
        assert_equal [:measure_id, :population_index], (patient[:expected_values][population_index].keys - population_set.keys), "Failed population set is filled with the correct populations on patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}"
        # Test that all the populations that were added were added with a value of 0
        # The exception is OBSERV which is set to []
        (population_set.keys- ['title', 'id', 'stratification']).each do |key|
          unless key == 'OBSERV'
            assert_equal 0, patient[:expected_values][population_index][key], "Failed populations that were added were added with a value of 0 for populaton set #{population_index} and key: [#{key}] on patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}\nPatient: #{patient[:expected_values][population_index].keys}\nPopulation Set: #{population_set.keys}"
          else
            assert_equal [], patient[:expected_values][population_index][key], "Failed populations that were added were added with a value of 0 for populaton #{population_index} and key: [#{key}] on patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}\nPatient: #{patient[:expected_values][population_index].keys}\nPopulation Set: #{population_set.keys}"
          end
        end
      end
    end

  end

  def expected_values_values_retained (measure)

    Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id).each do |patient|
      measure.populations.each_with_index do |population_set, population_index|
        (population_set.keys- ['title', 'id']).each_with_index do |population, index|
          patient.expected_values[population_index][population] = 999000 + (population_index * 100) + index unless population == 'OBSERV' || population == 'OBSERV_UNIT'
          patient.save!
        end
      end
    end

    Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id).each do |patient|
      patient.update_expected_value_structure!(measure) 
      assert_not patient[:expected_values].nil?, "Failed nil expected_values (expected_values_values_retained) on patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}"
      measure.populations.each_with_index do |population_set, population_index|
        (population_set.keys - ['title', 'id']).each_with_index do |population, index|
          # binding.pry
          unless measure.continuous_variable
            assert_equal ['measure_id', 'population_index'], (patient[:expected_values][population_index].keys - population_set.keys)
          else
            # The OBSERV_UNIT is not defined as part of the measure populaton but rather on each test patient
            assert_equal ['measure_id', 'population_index', 'OBSERV_UNIT'], (patient[:expected_values][population_index].keys - population_set.keys), "Fail retain expected_values keys on population_set [#{population_index}] of patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}\nPatient: #{patient[:expected_values][population_index].keys}\nPopulation Set: #{population_set.keys}"
          end
          assert_equal 999000 + (population_index * 100) + index, patient[:expected_values][population_index][population], "Fail retain expected_values value on population [#{population}] of patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}" unless population == 'OBSERV' || population == 'OBSERV_UNIT'
        end
      end
    end

  end

  # TODO: For continuous variables make sure that the OBSERV population is set '[]'
  def expected_values_missing_populations_added_back (measure)

    # Remove the IPP and DENOM populations
    # Continuous variable measures have MSRPOPL (instead of DENOM)
    Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id).each do |patient|
      patient.expected_values[0].reject! { |population_key| population_key == 'IPP' || population_key == 'DENOM' || population_key == 'MSRPOPL' }
      patient.save!
    end

    Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id).each do |patient|
      patient.update_expected_value_structure!(measure) 
      assert_not patient[:expected_values].nil?, "Failed nil expected_values on patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}"
      measure.populations.each_with_index do |population_set, population_index|
        assert_equal ['measure_id', 'population_index'], (patient[:expected_values][0].keys - measure.populations[0].keys)
        assert_equal 0, patient[:expected_values][population_index][:IPP], "Fail add expected_value[IPP] on patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}"
        unless measure.continuous_variable
          assert_equal 0, patient[:expected_values][population_index][:DENOM], "Fail add expected_value[DENOM] on patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}"
        else
          assert_equal 0, patient[:expected_values][population_index][:MSRPOPL], "Fail add expected_value[MSRPOPL] on patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}"
        end
      end
    end

  end

  def expected_values_reduce_number_population_sets (measure)

    # Add a bogus population set to the expected values
    Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id).each_with_index do |patient, index|
      patient.expected_values << { measure_id: measure.hqmf_set_id, population_index: measure.populations.length, fruit: "bananna_#{index}", veggie: "pickle_#{index}" }
      patient.save!
    end

    Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id).each do |patient|
      assert_equal measure.populations.length + 1, patient.expected_values.length, "Fail expected_values_reduce_number_population_sets extra population exists on patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}"
      patient.update_expected_value_structure!(measure)
      measure.populations.each_index do |population_index|
        assert_not_nil patient.expected_values[population_index], "Fail expected_values_reduce_number_population_sets existing population exists on patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}"
      end
      assert_nil patient.expected_values[measure.populations.length], "Fail expected_values_reduce_number_population_sets extra population removed on patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}"
    end

  end

  test 'CMS68v6' do
    measure = Measure.where({"cms_id" => "CMS68v6"}).first
    calculation_results(measure)
    expected_values_values_retained(measure)
    expected_values_empty_properly_populated(measure)
    expected_values_missing_populations_added_back(measure)
    expected_values_reduce_number_population_sets(measure)
  end

  test 'CMS160v3' do
    measure = Measure.where({"cms_id" => "CMS160v3"}).first
    calculation_results(measure)
    expected_values_values_retained(measure)
    expected_values_empty_properly_populated(measure)
    expected_values_missing_populations_added_back(measure)
    expected_values_reduce_number_population_sets(measure)
  end

  test 'CMS104v3' do
    measure = Measure.where({"cms_id" => "CMS104v3"}).first
    calculation_results(measure)
    expected_values_values_retained(measure)
    expected_values_empty_properly_populated(measure)
    expected_values_missing_populations_added_back(measure)
    expected_values_reduce_number_population_sets(measure)
  end

  test 'CMS32v4' do
    measure = Measure.where({"cms_id" => "CMS32v4"}).first
    # TODO: Complete method `calculation_results` to handle continuous_variable measures
    # calculation_results(measure)
    expected_values_values_retained(measure)
    expected_values_empty_properly_populated(measure)
    expected_values_missing_populations_added_back(measure)
    expected_values_reduce_number_population_sets(measure)
  end

end # class
