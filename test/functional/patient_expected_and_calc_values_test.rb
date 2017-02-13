require 'test_helper'

class PatientTest < ActionController::TestCase  #ActiveSupport::TestCase
  include Devise::TestHelpers
  
  tests MeasuresController
  # TODO: Consider converting this to a test of Record instead of the MeasuresController.
  # The MeasuresController is only needed for the loading of the measure zip files and the plan is to move to fixtures.

  setup do
    @error_dir = File.join('log', 'load_errors')
    FileUtils.rm_r @error_dir if File.directory?(@error_dir)
    dump_database
    users_set = File.join('users', 'base_set')
    collection_fixtures(users_set)
    @user = User.by_email('bonnie@example.com').first
    sign_in @user

    # load_measures
    # load_patients
    # load_golden_results
    
  end

  def load_test_suite_files (path)
    measure_collection = File.join 'draft_measures', path
    value_sets_collection = File.join 'health_data_standards_svs_value_sets', path
    records_collection = File.join 'records', path
    collection_fixtures(measure_collection, value_sets_collection, records_collection)
    associate_user_with_measures(@user, Measure.all)
    associate_user_with_patients(@user, Record.all)
  end

  def load_measures
    # TODO: When measure fixtures are available switchh to loading them
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'base_example', 'CMS68v6.zip'), 'application/zip')
    
    # Load the measure
    post :create, measure_file: measure_file, measure_type: 'ep', calculation_type: 'episode'
    post :finalize, {"t551"=>{"hqmf_id"=>"40280381-51F0-825B-0152-227DFBAC15AA", "episode_ids"=>["OccurrenceA_MedicationsEncounterCodeSet_EncounterPerformed_40280381_3e93_d1af_013e_a36090dc2cf5_source"], "titles"=>{"0"=>"Population Criteria Section"}}}

    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'multi_population', 'CMS160v3.zip'), 'application/zip')
    
    # Load the measure
    post :create, measure_file: measure_file, measure_type: 'ep', calculation_type: 'patient'

    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'update_change', 'CMS104v3.zip'), 'application/zip')
    
    # Load the measure
    post :create, measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'
    post :finalize, {"t551"=>{"hqmf_id"=>"40280381-446B-B8C2-0144-9E6E127929E3", "episode_ids"=>["OccurrenceANonElectiveInpatientEncounter2"]}}

    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'continuous_variable', 'EH_CMS32v4.zip'), 'application/zip')
    
    # Load the measure
    post :create, measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'
    post :finalize, {"t551"=>{"hqmf_id"=>"40280381-43DB-D64C-0144-6A8B0A3B30C6", "episode_ids"=>["OccurrenceAEmergencyDepartmentVisit1"], "titles"=>{"0"=>"Population 1 k", "1"=>"Stratification 1 k", "2"=>"Stratification 2 k", "3"=>"Stratification 3 k", "4"=>"foo"}}}
  end

  # When adding patients ensure that there is a making entry in the load_golden_results method
  def load_patients
    # Patients for CMS68v6
    records_set = File.join('records', "measure_history_set", "base_example")
    collection_fixtures(records_set)

    # Patients for CMS160v3
    records_set = File.join('records', "measure_history_set", "multi_population")
    collection_fixtures(records_set)

    # Patients for CMS104v3
    records_set = File.join('records', "measure_history_set", "update_change")
    collection_fixtures(records_set)

    # Patients for CMS32v4
    records_set = File.join('records', "measure_history_set", "continuous_variable")
    collection_fixtures(records_set)

    associate_user_with_measures(@user, Measure.all)
    associate_user_with_patients(@user, Record.all)
  end

  def load_golden_results
    # The golden_results are the the 'gold standard' calcuation results that will be used to test that the measure is
    # is calculating correctly.  It is best that these values are validated and recorded at the same time as the patient
    # test fixtures are created.
    # The format for loading is to use the BSON::ObjectId of the patient.  This ensures that there is no confusion when comparing the values.
    # This approach does require that the patient fixtures are loaded with static _ids.


    @golden_results = {}
    
    # Golden results for CMS68v6
    @golden_results.store(BSON::ObjectId('58514916e76e941a3d000489'), [{'IPP'=> 1, 'DENOM'=> 1, 'NUMER'=> 1, 'DENEX'=> 0, 'DENEXCEP'=> 0, 'NUMEX'=> 0, 'status'=> 'pass'}])
    @golden_results.store(BSON::ObjectId('58514954e76e941a3d0004c4'), [{'IPP'=> 0, 'DENOM'=> 0, 'DENEX'=> 0, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'pass'}])
    
    # Golden results for CMS160v3
    @golden_results.store(BSON::ObjectId('58515844e76e941a3d0004fa'), [ {'IPP'=> 1, 'DENOM'=> 1, 'DENEX'=> 1, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'pass'},
      {'IPP'=> 0, 'DENOM'=> 0, 'DENEX'=> 0, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'pass'},
      {'IPP'=> 0, 'DENOM'=> 0, 'DENEX'=> 0, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'pass'} ] )
    @golden_results.store(BSON::ObjectId('58515899e76e941a3d000543'), [ {'IPP'=> 0, 'DENOM'=> 0, 'DENEX'=> 0, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'pass'},
      {'IPP'=> 0, 'DENOM'=> 0, 'DENEX'=> 0, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'pass'},
      {'IPP'=> 0, 'DENOM'=> 0, 'DENEX'=> 0, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'pass'} ] )
    @golden_results.store(BSON::ObjectId('585158c2e76e941a3d00057b'), [ {'IPP'=> 0, 'DENOM'=> 0, 'DENEX'=> 0, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'pass'},
      {'IPP'=> 0, 'DENOM'=> 0, 'DENEX'=> 0, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'pass'},
      {'IPP'=> 0, 'DENOM'=> 0, 'DENEX'=> 0, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'pass'} ] )
    
    # Golden results for CMS104v3
    @golden_results.store(BSON::ObjectId('5852fa58e76e94e528001e9d'), [ {'IPP'=> 0, 'DENOM'=> 0, 'DENEX'=> 0, 'NUMER'=> 0, 'NUMEX'=> 0, 'DENEXCEP'=> 0, 'status'=> 'fail'} ] )
    
    # TODO
    # Add the golden results for the continuous variable measure
  end

  # This test looks for the proper calculation of the results for each measure.  It is looks to make sure that all of the expected fields related to
  # the calculated results are present in the entry in the record collection.
  def calculation_results (measure) 
    # Remove any calc results and related fields that might have been loaded.
    # We want to ensure that any results used in the testing are those generated by the test
    # as opposed to results that might have been loaded from the text fixtures.

    assert_not_empty Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id), "No patients for measure #{measure.cms_id} for the `calculation_results` test!!"

    Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id).each do |patient|
      patient.unset(:calc_results) unless patient[:calc_results].nil? 
      patient.save!
      assert patient[:calc_results].nil?, "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} has non-nil calc_results."
      # The patient has before_save actions that affect the values of results_exceed_storage and results_size
      assert_not patient[:results_exceed_storage], "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} did not have the `results_exceed_storage` field set to false after saving."
      assert_equal 4, patient[:results_size], "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} does not have a `results_size` of 4."
    end

    calculator = BonnieBackendCalculator.new
    patients = Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id)

    measure.populations.each_with_index do |population_set, population_index|
      calculator.set_measure_and_population(measure, population_index, clear_db_cache: true, rationale: true)
      patients.each do |patient|
        patient.update_calc_results!(measure, population_index, calculator)
      end
    end

    # TODO: This list needs to be maintained.
    calc_results_keys = HQMF::PopulationCriteria::ALL_POPULATION_CODES + ['rationale', 'finalSpecifics', 'measure_id', 'population_index', 'status', 'values', 'STRAT']

    Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id).each do |patient|
      assert_not_nil @golden_results[patient.id], "Missing golden result for patient name #{patient.first} #{patient.last} (patient.id: #{patient.id.to_s}) for measure #{measure.cms_id}."
      
      assert_not_nil patient[:calc_results], "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} does has nil for their `calc_results`."
      assert_equal measure.populations.length, patient[:calc_results].count, "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} does not have a matching count of `calc_results` and measure populations."
      # calc_results has a default of [] than when serialized to json is "[]", the size of which 4.
      assert_operator 4, :<, patient[:results_size]
      assert patient[:results_exceed_storage] if patient[:results_size] > APP_CONFIG['record']['max_size_in_bytes']
      assert_not patient[:results_exceed_storage] if patient[:results_size] <= APP_CONFIG['record']['max_size_in_bytes']
      
      measure.populations.each_with_index do |population_set, population_index|
        assert_equal measure.hqmf_set_id, patient[:calc_results][population_index][:measure_id], "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} has a mismatch between the hqmf_set_id in the `calc_results` and measure."
        assert_empty (patient[:calc_results][population_index].keys - calc_results_keys), "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} has a mismatch in the population keys between the measure and the `calc_results`.\npatient[:calc_results][0].keys = #{patient[:calc_results][population_index].keys}"
        
        # Make sure that the calculations are correct
        assert_not_nil @golden_results[patient.id][population_index], "Missing golden result for patient name #{patient.first} #{patient.last} (patient.id: #{patient.id.to_s}) for measure #{measure.cms_id} for population_set: [#{population_index}]."
        @golden_results[patient.id][population_index].each do |result_population, result_value|
          assert_equal result_value, patient.calc_results[population_index][result_population], "Patient #{patient.first} #{patient.last} (patient.id: #{patient.id.to_s}) for measure #{measure.cms_id} has a mismatch between the returned `calc_results` and the golden results for population_set: [#{population_index}], population: [#{result_population}].\n#{patient.calc_results[population_index]}"
        end
      end
    end

  end

  # The focus of the test is the `update_expected_value_structure!` method of the record class.
  # For this test we want to see that it is properly filling in the expected_values array of the record when expacted_values is empty.
  # Test that all the populations that were added were added with a value of 0.  The exception is OBSERV which is set to [].
  def expected_values_properly_populated_when_empty (measure)
    assert_not_empty Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id), "No patients for measure #{measure.cms_id} for the `expected_values_properly_populated_when_empty` test!!"

    # Set the expected values to be empty
    Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id).each do |patient|
      patient.expected_values = []
      patient.save!
    end

    Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id).each do |patient|
      assert patient[:expected_values].empty?, "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} does not have empty `expected_values`."
      patient.update_expected_value_structure!(measure) 
      assert_not patient[:expected_values].nil?, "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} has nil for `expected_values.`"
      
      # Test that the number of populations match
      assert_equal measure.populations.length, patient.expected_values.length
      
      measure.populations.each_with_index do |population_set, population_index|
        population_set_expected_values = patient[:expected_values].select { |pev| pev[:measure_id] == measure.hqmf_set_id && pev[:population_index] == population_index }.first

        # Test that the population set is filled with the correct populations
        assert_equal [:measure_id, :population_index], (population_set_expected_values.keys - population_set.keys), "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} does not have the correct keys for the population set."

        # Test that values are correct
        (population_set.keys- ['title', 'id', 'stratification']).each do |key|
          unless key == 'OBSERV'
            assert_equal 0, population_set_expected_values[key], "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} for populaton set #{population_index} and key: [#{key}] has `expected_values` that were not added with value of 0.\nPatient: #{population_set_expected_values.keys}\nPopulation Set: #{population_set.keys}"
          else
            assert_equal [], population_set_expected_values[key], "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} for populaton set #{population_index} and key: [#{key}] has `expected_values` that were not added with value of []\nPatient: #{population_set_expected_values.keys}\nPopulation Set: #{population_set.keys}"
          end
        end
      end
    end

  end

  # The focus of the test is the `update_expected_value_structure!` method of the record class.
  # For this test we want to see that when it is called it will leave the existing expected_values in place.
  # Running `update_expected_value_structure!` is supposed to be undestructive to existing values.
  def expected_values_values_retained (measure)
    assert_not_empty Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id), "No patients for measure #{measure.cms_id} for the `expected_values_values_retained` test!!"

    Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id).each do |patient|
      measure.populations.each_with_index do |population_set, population_index|
        (population_set.keys- ['title', 'id']).each_with_index do |population, index|
          # Set the expect values to some value that wouldn't occur otherwise.  This will make it obvious whether or not it has been changed.
          patient.expected_values[population_index][population] = 999000 + (population_index * 100) + index unless population == 'OBSERV' || population == 'OBSERV_UNIT'
          patient.save!
        end
      end
    end

    Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id).each do |patient|
      patient.update_expected_value_structure!(measure) 
      assert_not patient[:expected_values].nil?, "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} has nil for `expected_values instead of empty.`"
      
      measure.populations.each_with_index do |population_set, population_index|
        population_set_expected_values = patient[:expected_values].select { |pev| pev[:measure_id] == measure.hqmf_set_id && pev[:population_index] == population_index }.first
        (population_set.keys - ['title', 'id']).each_with_index do |population, index|
          unless measure.continuous_variable
            assert_equal ['measure_id', 'population_index'], (population_set_expected_values.keys - population_set.keys)
          else
            # The OBSERV_UNIT is not defined as part of the measure populaton but rather on each test patient
            assert_equal ['measure_id', 'population_index', 'OBSERV_UNIT'], (population_set_expected_values.keys - population_set.keys), "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} population_set [#{population_index}] did not retain its `expected_values` keys.\nPatient: #{population_set_expected_values.keys}\nPopulation Set: #{population_set.keys}"
          end
          assert_equal 999000 + (population_index * 100) + index, population_set_expected_values[population], "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} population_set [#{population_index}] did not retain its `expected_values` values." unless population == 'OBSERV' || population == 'OBSERV_UNIT'
        end
      end
    end

  end

  # TODO: For continuous variables make sure that the OBSERV population is set '[]'
  # The focus of the test is the `update_expected_value_structure!` method of the record class.
  # For this test we want to see that if a population is missing from a population set that it gets added back in.
  def expected_values_missing_populations_added_back (measure)
    assert_not_empty Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id), "No patients for measure #{measure.cms_id} for the `expected_values_missing_populations_added_back` test!!"

    # Remove the IPP and DENOM populations.  Continuous variable measures have MSRPOPL (instead of DENOM)
    # For the purpose of this test removing these populations can be considered the same a new population being added
    # to a population set on the measure.
    Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id).each do |patient|
      patient.expected_values[0].reject! { |population_key| population_key == 'IPP' || population_key == 'DENOM' || population_key == 'MSRPOPL' }
      patient.save!
    end

    Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id).each do |patient|
      patient.update_expected_value_structure!(measure) 
      assert_not patient[:expected_values].nil?, "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} has nil `expected_values`; should be empty."

      measure.populations.each_with_index do |population_set, population_index|
        population_set_expected_values = patient[:expected_values].select { |pev| pev[:measure_id] == measure.hqmf_set_id && pev[:population_index] == population_index }.first
        assert_equal ['measure_id', 'population_index'], (population_set_expected_values.keys - measure.populations[population_index].keys), "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} has a mismatch between their expected_values and those on the measure.\n\tPatient: #{population_set_expected_values.keys}\n\tMeasure: #{measure.populations[population_index].keys}"
        assert_equal 0, population_set_expected_values[:IPP], "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} does not have IPP=0 for populaton [#{population_index}]."
        unless measure.continuous_variable
          assert_equal 0, population_set_expected_values[:DENOM], "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} does not have DENOM=0 for populaton [#{population_index}]."
        else
          assert_equal 0, population_set_expected_values[:MSRPOPL], "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} does not have MSRPOPL=0 for populaton [#{population_index}]."
        end
      end
    end

  end

  # The focus of the test is the `update_expected_value_structure!` method of the record class.
  # For this test we want to see that an extra population sets are removed from the expected_values.
  def expected_values_reduce_number_population_sets (measure)
    assert_not_empty Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id), "No patients for measure #{measure.cms_id} for the `expected_values_missing_populations_added_back` test!!"

    # Add a bogus population set to the expected values
    Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id).each_with_index do |patient, index|
      patient.expected_values << { measure_id: measure.hqmf_set_id, population_index: measure.populations.length, fruit: "bananna_#{index}", veggie: "pickle_#{index}" }
      patient.save!
    end

    Record.where(user_id: @user.id, measure_ids: measure.hqmf_set_id).each do |patient|
      assert_equal measure.populations.length + 1, patient.expected_values.length, "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} does not have the expected extra population set."
      patient.update_expected_value_structure!(measure)
      measure.populations.each_index do |population_index|
        assert_not_nil patient.expected_values.select{|ev| ev[:population_index] == population_index && ev[:measure_id] == measure.hqmf_set_id}.first, "Patient #{patient.first} #{patient.last} for measure #{measure.cms_id} is missing population set [#{population_index}]."
      end
      assert_nil patient.expected_values[measure.populations.length], "Fail expected_values_reduce_number_population_sets extra population removed on patient name #{patient.first} #{patient.last} for measure #{measure.cms_id}"
    end

  end

  test 'CMS68v6' do
    load_test_suite_files('measure_history_set/base_example')
    measure = Measure.where({"cms_id" => "CMS68v6"}).first
    calculation_results(measure)
    expected_values_values_retained(measure)
    expected_values_properly_populated_when_empty(measure)
    expected_values_missing_populations_added_back(measure)
    expected_values_reduce_number_population_sets(measure)
  end

  test 'CMS160v3' do
    load_test_suite_files('measure_history_set/multi_population')
    measure = Measure.where({"cms_id" => "CMS160v3"}).first
    calculation_results(measure)
    expected_values_values_retained(measure)
    expected_values_properly_populated_when_empty(measure)
    expected_values_missing_populations_added_back(measure)
    expected_values_reduce_number_population_sets(measure)
  end

  test 'CMS104v3' do
    load_test_suite_files('measure_history_set/update_change')
    measure = Measure.where({"cms_id" => "CMS104v3"}).first
    calculation_results(measure)
    expected_values_values_retained(measure)
    expected_values_properly_populated_when_empty(measure)
    expected_values_missing_populations_added_back(measure)
    expected_values_reduce_number_population_sets(measure)
  end

  test 'CMS32v4' do
    load_test_suite_files('measure_history_set/continuous_variable')
    measure = Measure.where({"cms_id" => "CMS32v4"}).first
    # TODO: Complete method `calculation_results` to handle continuous_variable measures
    # calculation_results(measure)
    expected_values_values_retained(measure)
    expected_values_properly_populated_when_empty(measure)
    expected_values_missing_populations_added_back(measure)
    expected_values_reduce_number_population_sets(measure)
  end

end # class