require 'rake'
require 'test_helper'

class PatientBuilderFunctionalTest < ActionController::TestCase

  setup do
    dump_database
  end

  test "UnixTime results are in seconds" do
    records_set = File.join("records", "special_measures", "CMS878")
    users_set = File.join("users", "base_set")
    cql_measures_set = File.join("cql_measures", "special_measures", "CMS878")
    collection_fixtures(users_set, records_set)
    add_collection(cql_measures_set)

    @user = User.by_email('bonnie@example.com').first

    associate_user_with_measures(@user, CqlMeasure.where(hqmf_set_id: '50901F2E-3715-462B-87C1-2AD9B9B1CDE7'))
    associate_user_with_patients(@user, Record.all)

    record = Record.where(last: 'Numerator').first
    # clear calculated value
    record.assessments[0]['values'][0]['scalar'] = '0'
    Measures::PatientBuilder.rebuild_patient(record)
    assert_equal('UnixTime', record.assessments[0]['values'][0]['units'])
    assert_equal(1341129600, record.assessments[0]['values'][0]['scalar'])

    record = Record.where(last: 'NoNumerator').first
    # clear calculated value
    record.assessments[0]['values'][0]['scalar'] = '0'
    Measures::PatientBuilder.rebuild_patient(record)
    assert_equal('UnixTime', record.assessments[0]['values'][0]['units'])
    assert_equal(1337932800, record.assessments[0]['values'][0]['scalar'])
  end

  test "Components' UnixTime results are in seconds" do
    records_set = File.join("records", "special_measures", "CMS879")
    users_set = File.join("users", "base_set")
    cql_measures_set = File.join("cql_measures", "special_measures", "CMS879")
    collection_fixtures(users_set, records_set)
    add_collection(cql_measures_set)

    @user = User.by_email('bonnie@example.com').first

    associate_user_with_measures(@user, CqlMeasure.where(hqmf_set_id: 'D5355200-50C1-4A79-8983-8617B93FE6C1'))
    associate_user_with_patients(@user, Record.all)

    record = Record.where(last: 'Numerator').first
    # clear calculated value
    record.assessments[0]['values'][0]['scalar'] = '0'
    Measures::PatientBuilder.rebuild_patient(record)
    assert_equal('UnixTime', record.vital_signs[0]['components']['values'][0]['result']['units'])
    assert_equal(1342512000, record.vital_signs[0]['components']['values'][0]['result']['scalar'])

    record = Record.where(last: 'NoNumerator').first
    # clear calculated value
    record.assessments[0]['values'][0]['scalar'] = '0'
    Measures::PatientBuilder.rebuild_patient(record)
    assert_equal('UnixTime', record.vital_signs[0]['components']['values'][0]['result']['units'])
    assert_equal(1310889600, record.vital_signs[0]['components']['values'][0]['result']['scalar'])
  end
end
