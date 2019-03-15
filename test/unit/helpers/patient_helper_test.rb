require 'test_helper'
require './app/helpers/patient_helper'

class PatientHelperTest < ActionView::TestCase

  test 'No Patients Sent To convert_patient_models' do
    qdm_records = PatientHelper.convert_patient_models([])
    assert_equal [[], []], qdm_records
  end

  test 'Using core_measures set, Correct Number Of Patients Recieved From convert_patient_models with one failed patient' do
    # load all of the core_measures fixture patients
    dump_database
    cms32_records_set = File.join('records','core_measures','CMS32v7')
    cms134_records_set = File.join('records','core_measures','CMS134v6')
    cms158_records_set = File.join('records','core_measures','CMS158v6')
    cms160_records_set = File.join('records','core_measures','CMS160v6')
    cms177_records_set = File.join('records','core_measures','CMS177v6')
    collection_fixtures(cms32_records_set, cms134_records_set, cms158_records_set, cms160_records_set, cms177_records_set)

    hds_records = Record.all
    # make sure we have a total of 13 records and run conversion
    assert_equal 13, hds_records.count
    qdm_records, failed_records = PatientHelper.convert_patient_models(hds_records)

    # 12 of the 13 patient are expected to convert without error
    assert_equal 12, qdm_records.count

    # Pass Numer from CMS134v6 has a component with a unit "cc". This is not valid UCUM so it will show up in the list of failed records.
    assert_equal 1, failed_records.count
    assert_equal 'Pass', failed_records[0][:hds_record].first
    assert_equal 'Numer', failed_records[0][:hds_record].last
    assert_equal "Error: 'cc' is not a valid UCUM unit.", failed_records[0][:error_message]
  end

  test 'Using special_measures set, Correct Number Of Patients Recieved From convert_patient_models' do
    # load all of the special_measures fixture patients
    dump_database
    cms347_records_set = File.join('records','deprecated_measures','CMS347v1')
    collection_fixtures(cms347_records_set)

    hds_records = Record.all
    # make sure we have a total of 7 records and run converson
    assert_equal 7, hds_records.count
    qdm_records, failed_records = PatientHelper.convert_patient_models(hds_records)

    # expect all 7 to convert without issue
    assert_equal 7, qdm_records.count

    # expect there to be no failed records
    assert_empty failed_records
  end

  test 'Calculations Are Unaffected By HDS to QDM Conversion' do
    skip('TODO Implement this test once backend calculator is implemented')
    # Run backend calculation on patient before and after conversion
    # Assert calculations are equal
  end

end
