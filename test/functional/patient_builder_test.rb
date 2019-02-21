require 'rake'
require 'test_helper'

class PatientBuilderFunctionalTest < ActionController::TestCase

  setup do
    dump_database
  end

  test "UnixTime results are in seconds" do
    records_set = File.join("records", "special_measures", "CMS878")
    users_set = File.join("users", "base_set")
    collection_fixtures(users_set, records_set)
    @user = User.by_email('bonnie@example.com').first
    load_measure_fixtures_from_folder(File.join("measures", "CMS878v0"), @user)
    associate_user_with_patients(@user, Record.all)

    record = Record.where(last: 'NoNumerator').first
    # clear calculated value from fixture
    record.assessments[0]['values'][0]['scalar'] = '0'
    Measures::PatientBuilder.rebuild_patient(record)
    assert_equal('UnixTime', record.assessments[0]['values'][0]['units'])
    # this new calculated value should be in seconds
    assert_equal(1337932800, record.assessments[0]['values'][0]['scalar'])
  end

  test "Components' UnixTime results are in seconds" do
    records_set = File.join("records", "special_measures", "CMS879")
    users_set = File.join("users", "base_set")
    collection_fixtures(users_set, records_set)
    @user = User.by_email('bonnie@example.com').first
    load_measure_fixtures_from_folder(File.join("measures", "CMS879v0"), @user)
    associate_user_with_patients(@user, Record.all)

    record = Record.where(last: 'NoNumerator').first
    # clear calculated value from fixture
    record.vital_signs[0]['components']['values'][0]['result']['scalar'] = '0'
    Measures::PatientBuilder.rebuild_patient(record)
    assert_equal('UnixTime', record.vital_signs[0]['components']['values'][0]['result']['units'])
    # this new calculated value should be in seconds
    assert_equal(1310889600, record.vital_signs[0]['components']['values'][0]['result']['scalar'])
  end
end
