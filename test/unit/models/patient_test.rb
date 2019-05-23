require 'test_helper'

class RecordTest < ActiveSupport::TestCase
  setup do
    dump_database
    load_measure_fixtures_from_folder(File.join('measures', 'CMS72v7'))
    load_measure_fixtures_from_folder(File.join('measures', 'CMS890_v5_6'))

    patients_set = File.join('cqm_patients', 'expected_values_set')
    @measure_set_id = '93F3479F-75D8-4731-9A3F-B7749D8BCD37'
    @measure = CQM::Measure.where(hqmf_set_id: @measure_set_id).first
    collection_fixtures(patients_set)

    @composite_measure = CQM::Measure.where(hqmf_set_id: '244B4F52-C9CA-45AA-8BDB-2F005DA05BFC').first
  end

  # Runs the update_expected_value_structure! method on the patient and collects the changes it yields.
  def collect_expected_changes_and_verify_block_no_block(patient, measure)
    patient_clone = Marshal.load(Marshal.dump(patient))
    changes = []
    patient.update_expected_value_structure!(measure) do |change_type, change_reason, expected_value_set|
      changes << {
        change_type: change_type,
        change_reason: change_reason,
        expected_value_set: expected_value_set
      }
    end
    patient_clone.update_expected_value_structure!(measure)
    # always make sure function works the same way whether passed blocks for yielding or not
    assert_equal patient.expectedValues, patient_clone.expectedValues
    changes
  end

  test 'Good Expecteds' do
    patient = CQM::Patient.where(familyName: 'Expecteds', givenNames: 'Good').first
    changes = collect_expected_changes_and_verify_block_no_block(patient, @measure)
    assert_equal 0, changes.count
    assert_equal 1, patient.expectedValues.count
  end

  test 'Multiple Measures Good Expecteds (Composite Measure)' do
    patient = CQM::Patient.where(familyName: 'Measures', givenNames: 'Multiple').first
    changes = collect_expected_changes_and_verify_block_no_block(patient, @composite_measure)
    assert_equal 0, changes.count
    assert_equal 8, patient.expectedValues.count
  end

  test 'Duplicate Expecteds' do
    patient = CQM::Patient.where(familyName: 'Expecteds', givenNames: 'Duplicate').first
    changes = collect_expected_changes_and_verify_block_no_block(patient, @measure)
    assert_equal 1, changes.count

    # check duplicate population set removal
    assert_equal :population_set_removal, changes[0][:change_type]
    assert_equal :dup_population, changes[0][:change_reason]
    expected_value_set = { 'measure_id' => @measure_set_id, 'population_index' => 0,
      'IPP' => 1, 'DENOM' => 1, 'DENEX' => 1, 'NUMER' => 0, 'DENEXCEP' => 0}
    assert_equal expected_value_set, changes[0][:expected_value_set]

    # check final expecteds structure
    expected_value_sets = [{ 'measure_id' => @measure_set_id, 'population_index' => 0,
      'IPP' => 1, 'DENOM' => 1, 'DENEX' => 1, 'NUMER' => 0, 'DENEXCEP' => 0}]
    assert_equal 1, patient.expectedValues.count
    assert_equal expected_value_sets, patient.expectedValues
  end

  test 'Extra Population Set Expecteds' do
    patient = CQM::Patient.where(familyName: 'Expecteds', givenNames: 'Extra Population Set').first
    changes = collect_expected_changes_and_verify_block_no_block(patient, @measure)
    assert_equal 1, changes.count

    # check extra population set removal
    assert_equal :population_set_removal, changes[0][:change_type]
    assert_equal :extra_population, changes[0][:change_reason]
    expected_value_set = { 'measure_id' => @measure_set_id, 'population_index' => 1,
      'IPP' => 1, 'DENOM' => 1, 'DENEX' => 1, 'NUMER' => 0, 'DENEXCEP' => 1}
    assert_equal expected_value_set, changes[0][:expected_value_set]

    # check final expecteds structure
    expected_value_sets = [{ 'measure_id' => @measure_set_id, 'population_index' => 0,
      'IPP' => 1, 'DENOM' => 1, 'DENEX' => 1, 'NUMER' => 0, 'DENEXCEP' => 1}]
    assert_equal 1, patient.expectedValues.count
    assert_equal expected_value_sets, patient.expectedValues
  end

  test 'Extra Population Set Multiple Measure Expecteds' do
    patient = CQM::Patient.where(familyName: 'Expecteds', givenNames: 'Extra Population Set Multiple Measure').first
    changes = collect_expected_changes_and_verify_block_no_block(patient, @measure)
    assert_equal 1, changes.count

    # check extra population set removal
    assert_equal :population_set_removal, changes[0][:change_type]
    assert_equal :extra_population, changes[0][:change_reason]
    expected_value_set = { 'measure_id' => @measure_set_id, 'population_index' => 1,
      'IPP' => 1, 'DENOM' => 1, 'DENEX' => 1, 'NUMER' => 0, 'DENEXCEP' => 0}
    assert_equal expected_value_set, changes[0][:expected_value_set]

    # check final expecteds structure
    expected_value_sets = [{ 'measure_id' => @measure_set_id, 'population_index' => 0,
      'IPP' => 1, 'DENOM' => 1, 'DENEX' => 1, 'NUMER' => 0, 'DENEXCEP' => 0},
      { 'measure_id' => '4DF3479F-82F4-183B-9254-F2492BA43523', 'population_index' => 0,
        'IPP' => 1, 'DENOM' => 1, 'DENEX' => 1, 'NUMER' => 0, 'DENEXCEP' => 0}]
    assert_equal 2, patient.expectedValues.count
    assert_equal expected_value_sets, patient.expectedValues
  end

  test 'Garbage and Duplicate Expecteds' do
    patient = CQM::Patient.where(familyName: 'Expecteds', givenNames: 'Garbage and Duplicate').first
    changes = collect_expected_changes_and_verify_block_no_block(patient, @measure)
    assert_equal 2, changes.count

    # check garbage data removal
    assert_equal :population_set_removal, changes[0][:change_type]
    assert_equal :garbage_data, changes[0][:change_reason]
    expected_value_set = { 'measure_id' => '93F3479F-75D8-4731-9A3F-B7749D8BCD37' }
    assert_equal expected_value_set, changes[0][:expected_value_set]

    # check duplicate population set removal
    assert_equal :population_set_removal, changes[1][:change_type]
    assert_equal :dup_population, changes[1][:change_reason]
    expected_value_set = { 'measure_id' => @measure_set_id, 'population_index' => 0,
      'IPP' => 1, 'DENOM' => 1, 'DENEX' => 1, 'NUMER' => 0, 'DENEXCEP' => 0}
    assert_equal expected_value_set, changes[1][:expected_value_set]

    # check final expecteds structure
    expected_value_sets = [{ 'measure_id' => @measure_set_id, 'population_index' => 0,
      'IPP' => 1, 'DENOM' => 1, 'DENEX' => 1, 'NUMER' => 0, 'DENEXCEP' => 0}]
    assert_equal 1, patient.expectedValues.count
    assert_equal expected_value_sets, patient.expectedValues
  end

  test 'Garbage Expecteds' do
    patient = CQM::Patient.where(familyName: 'Expecteds', givenNames: 'Garbage').first
    changes = collect_expected_changes_and_verify_block_no_block(patient, @measure)
    assert_equal 1, changes.count

    # check garbage data removal
    assert_equal :population_set_removal, changes[0][:change_type]
    assert_equal :garbage_data, changes[0][:change_reason]
    expected_value_set = { 'measure_id' => '93F3479F-75D8-4731-9A3F-B7749D8BCD37' }
    assert_equal expected_value_set, changes[0][:expected_value_set]

    # check final expecteds structure
    expected_value_sets = [{ 'measure_id' => @measure_set_id, 'population_index' => 0,
      'IPP' => 1, 'DENOM' => 1, 'DENEX' => 0, 'NUMER' => 1, 'DENEXCEP' => 0}]
    assert_equal 1, patient.expectedValues.count
    assert_equal expected_value_sets, patient.expectedValues
  end

  test 'Garbage Empty Expecteds' do
    patient = CQM::Patient.where(familyName: 'Expecteds', givenNames: 'Garbage Empty').first
    changes = collect_expected_changes_and_verify_block_no_block(patient, @measure)
    assert_equal 1, changes.count

    # check garbage data removal of a blank set
    assert_equal :population_set_removal, changes[0][:change_type]
    assert_equal :garbage_data, changes[0][:change_reason]
    expected_value_set = { }
    assert_equal expected_value_set, changes[0][:expected_value_set]

    # check final expecteds structure
    expected_value_sets = [{ 'measure_id' => @measure_set_id, 'population_index' => 0,
      'IPP' => 1, 'DENOM' => 1, 'DENEX' => 0, 'NUMER' => 1, 'DENEXCEP' => 0}]
    assert_equal 1, patient.expectedValues.count
    assert_equal expected_value_sets, patient.expectedValues
  end

  test 'Missing Population Set Expecteds' do
    patient = CQM::Patient.where(familyName: 'Expecteds', givenNames: 'Missing Population Set').first
    changes = collect_expected_changes_and_verify_block_no_block(patient, @measure)
    assert_equal 2, changes.count

    # check missing population set addition
    assert_equal :population_set_addition, changes[0][:change_type]
    assert_equal :missing_population, changes[0][:change_reason]
    expected_value_set = { 'measure_id' => @measure_set_id, 'population_index' => 0 }
    assert_equal expected_value_set, changes[0][:expected_value_set]

    # check missing populations additions
    assert_equal :population_addition, changes[1][:change_type]
    assert_equal :missing_population, changes[1][:change_reason]
    expected_value_set = { 'measure_id' => @measure_set_id, 'population_index' => 0,
      'IPP' => 0, 'DENOM' => 0, 'DENEX' => 0, 'NUMER' => 0, 'DENEXCEP' => 0}
    assert_equal expected_value_set, changes[1][:expected_value_set]

    # check final expecteds structure
    expected_value_sets = [{ 'measure_id' => @measure_set_id, 'population_index' => 0,
      'IPP' => 0, 'DENOM' => 0, 'DENEX' => 0, 'NUMER' => 0, 'DENEXCEP' => 0}]
    assert_equal 1, patient.expectedValues.count
    assert_equal expected_value_sets, patient.expectedValues
  end

  test 'Missing Population Set With Garbage Expecteds' do
    patient = CQM::Patient.where(familyName: 'Expecteds', givenNames: 'Missing Population Set With Garbage').first
    changes = collect_expected_changes_and_verify_block_no_block(patient, @measure)
    assert_equal 3, changes.count

    # check garbage data removal
    assert_equal :population_set_removal, changes[0][:change_type]
    assert_equal :garbage_data, changes[0][:change_reason]
    expected_value_set = { 'measure_id' => '93F3479F-75D8-4731-9A3F-B7749D8BCD37' }
    assert_equal expected_value_set, changes[0][:expected_value_set]

    # check missing population set addition
    assert_equal :population_set_addition, changes[1][:change_type]
    assert_equal :missing_population, changes[1][:change_reason]
    expected_value_set = { 'measure_id' => @measure_set_id, 'population_index' => 0 }
    assert_equal expected_value_set, changes[1][:expected_value_set]

    # check missing populations additions
    assert_equal :population_addition, changes[2][:change_type]
    assert_equal :missing_population, changes[2][:change_reason]
    expected_value_set = { 'measure_id' => @measure_set_id, 'population_index' => 0,
      'IPP' => 0, 'DENOM' => 0, 'DENEX' => 0, 'NUMER' => 0, 'DENEXCEP' => 0}
    assert_equal expected_value_set, changes[2][:expected_value_set]

    # check final expecteds structure
    expected_value_sets = [{ 'measure_id' => @measure_set_id, 'population_index' => 0,
      'IPP' => 0, 'DENOM' => 0, 'DENEX' => 0, 'NUMER' => 0, 'DENEXCEP' => 0}]
    assert_equal 1, patient.expectedValues.count
    assert_equal expected_value_sets, patient.expectedValues
  end

  test 'Missing Population Expecteds' do
    patient = CQM::Patient.where(familyName: 'Expecteds', givenNames: 'Missing Population').first
    changes = collect_expected_changes_and_verify_block_no_block(patient, @measure)
    assert_equal 1, changes.count

    # check missing population addition
    assert_equal :population_addition, changes[0][:change_type]
    assert_equal :missing_population, changes[0][:change_reason]
    expected_value_set = { 'measure_id' => @measure_set_id, 'population_index' => 0,
      'DENEXCEP' => 0}
    assert_equal expected_value_set, changes[0][:expected_value_set]

    # check final expecteds structure
    expected_value_sets = [{ 'measure_id' => @measure_set_id, 'population_index' => 0,
      'IPP' => 1, 'DENOM' => 1, 'DENEX' => 1, 'NUMER' => 0, 'DENEXCEP' => 0}]
    assert_equal 1, patient.expectedValues.count
    assert_equal expected_value_sets, patient.expectedValues
  end

  test 'Extra Population Expecteds' do
    patient = CQM::Patient.where(familyName: 'Expecteds', givenNames: 'Extra Population').first
    changes = collect_expected_changes_and_verify_block_no_block(patient, @measure)
    assert_equal 1, changes.count

    # check missing population set addition
    assert_equal :population_removal, changes[0][:change_type]
    assert_equal :extra_population, changes[0][:change_reason]
    expected_value_set = { 'measure_id' => @measure_set_id, 'population_index' => 0,
      'NUMEX' => 0 }
    assert_equal expected_value_set, changes[0][:expected_value_set]

    # check final expecteds structure
    expected_value_sets = [{ 'measure_id' => @measure_set_id, 'population_index' => 0,
      'IPP' => 0, 'DENOM' => 0, 'DENEX' => 0, 'NUMER' => 0, 'DENEXCEP' => 0}]
    assert_equal 1, patient.expectedValues.count
    assert_equal expected_value_sets, patient.expectedValues
  end
end
