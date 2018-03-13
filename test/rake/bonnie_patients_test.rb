require 'test_helper'
require 'vcr_setup.rb'

class BonniePatientsTest < ActiveSupport::TestCase
  setup do
    dump_database

    records_set = File.join("records", "base_set")
    users_set = File.join("users", "base_set")
    measures_set = File.join("draft_measures", "base_set")
    collection_fixtures(users_set, records_set, measures_set)

  end


  test "successful export of patients" do
    hqmf_set_id =  '42BF391F-38A3-TEST-9ECE-DCD47E9609D9'

    user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(user, Measure.where(hqmf_set_id: hqmf_set_id))
    associate_measures_with_patients(Measure.where(hqmf_set_id: hqmf_set_id), Record.all)

    ENV['EMAIL'] = user.email
    ENV['HQMF_SET_ID'] = hqmf_set_id
    ENV['FILENAME'] = 'cms104v2_export_patients_test.json'
    Rake::Task['bonnie:patients:export_patients'].execute

    assert File.exist? File.expand_path'cms104v2_export_patients_test.json'

    # Open up the file and assert the file contains 4 lines, one for each patient.
    f = File.open('cms104v2_export_patients_test.json', "r")
    assert_equal 4, f.readlines.size
    File.delete('cms104v2_export_patients_test.json') if File.exist?('cms104v2_export_patients_test.json')
  end

  test "successful import of patients"  do
    hqmf_set_id =  '42BF391F-38A3-TEST-9ECE-DCD47E9609D9'
    user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(user, Measure.where(hqmf_set_id: hqmf_set_id))

    ENV['EMAIL'] = user.email
    ENV['HQMF_SET_ID'] = hqmf_set_id
    ENV['FILENAME'] = File.join('test','fixtures','patient_export','cms104v2_export_patients_test.json')
    Rake::Task['bonnie:patients:import_patients'].execute
    # Confirm that there are 4 patients now associated with this measure.
    assert_equal 4, Record.where(measure_ids: hqmf_set_id, user_id: user._id).count
  end

end
