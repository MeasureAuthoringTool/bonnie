require 'test_helper'
require './app/helpers/patient_helper'

class PatientHelperTest < ActionView::TestCase

  test 'No Patients Sent To convert_patient_models' do
    qdm_records = PatientHelper.convert_patient_models([])
    assert_equal [], qdm_records
  end

  test 'Correct Number Of Patients Recieved From convert_patient_models' do
    records_set = File.join("records","base_set")
    hds_records = Record.all
    qdm_records = PatientHelper.convert_patient_models(hds_records)
    assert_equal hds_records.count, qdm_records.count
  end

  test 'Calculations Are Unaffected By HDS to QDM Conversion' do
    skip('TODO Implement this test once backend calculator is implemented')
    # Run backend calculation on patient before and after conversion
    # Assert calculations are equal
  end

end
