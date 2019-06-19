require 'test_helper'

class ExportFixturesTest < ActiveSupport::TestCase
  setup do
    dump_database
    measure_set = File.join('cql_measures', 'core_measures', 'CMS32v7')
    simple_measure_set = File.join('cql_measures', 'core_measures', 'CMS134v6')
    users_set = File.join('users', 'base_set')
    records_set = File.join('records','core_measures', 'CMS32v7')
    simple_records_set = File.join('records','core_measures', 'CMS134v6')
    packages_set = File.join('cql_measure_packages','core_measures','CMS32v7')
    collection_fixtures(users_set, measure_set, simple_measure_set, records_set, simple_records_set, packages_set)
    cms_32 = CqlMeasure.find_by(cms_id: 'CMS32v7')
    @cms32_file = cms_32.package.file
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_patients(@user, CQM::Patient.all)
  end

  test "measures convert to CQM format properly" do
    measure = CqlMeasure.by_user(@user).first
    assert_equal CQM::Measure.count, 0
    assert_equal measure[:hqmf_set_id], '3FD13096-2C8F-40B5-9297-B714E8DE9133'
    assert_nil measure[:measure_scoring]
    assert_nil measure[:calculation_method]
    assert_equal measure[:continuous_variable], true
    assert_equal measure[:episode_of_care], true
    ENV['EMAIL'] = 'bonnie@example.com'
    Rake::Task['bonnie:cql:convert_measures'].execute
    converted_measure = CQM::Measure.by_user(@user).first
    assert_equal converted_measure[:hqmf_set_id], '3FD13096-2C8F-40B5-9297-B714E8DE9133'
    assert_equal converted_measure[:measure_scoring], 'CONTINUOUS_VARIABLE'
    assert_equal converted_measure[:calculation_method], 'EPISODE_OF_CARE'
    assert_nil converted_measure[:continuous_variable]
    assert_nil converted_measure[:episode_of_care]

    assert_equal CQM::Measure.find_by(cms_id: 'CMS32v7').package.file, @cms32_file
    assert_nil CQM::Measure.find_by(cms_id: 'CMS134v6').package
  end

  test "patients convert to CQM format properly" do
    patient = Record.where(first: 'Visits').first
    assert_equal CQM::Patient.count, 0
    assert_equal patient[:bundle_id], BSON::ObjectId('5a57e977942c6d1e61d32f14')
    assert_equal patient[:last], "2 ED"
    assert_equal patient[:notes], ''
    assert_equal patient[:measure_ids], ["3FD13096-2C8F-40B5-9297-B714E8DE9133", nil]
    assert_nil patient[:qdmPatient]
    ENV['EMAIL'] = 'bonnie@example.com'
    Rake::Task['bonnie:cql:convert_measures'].execute
    Rake::Task['bonnie:cql:convert_patients'].execute
    converted_patient = CQM::Patient.where(givenNames: ['Visits']).first
    assert_equal converted_patient[:bundleId], '5a57e977942c6d1e61d32f14'
    assert_equal converted_patient[:familyName], "2 ED"
    assert_equal converted_patient[:notes], ''
    assert_equal converted_patient.measure_ids.length, 1
    assert_not_nil converted_patient[:measure_ids]
    assert_not_nil converted_patient[:qdmPatient]
  end

  test "generate_cqm_patient_fixtures description" do
    rake_task_descriptions = capture(:stdout) do
      system('rake -T')
    end
    assert rake_task_descriptions.include? 'rake bonnie:fixtures:generate_cqm_patient_fixtures_from_cql_patients[email]'
    assert rake_task_descriptions.include? '# Export patient fixtures for a given account'
  end

  test "export single patient from account" do
    begin
      FileUtils.mv 'test/fixtures/cqm_patients', 'test/fixtures/cqm_patients.back'
      FileUtils.mv 'spec/javascripts/fixtures/json/patients', 'spec/javascripts/fixtures/json/patients.back'

      assert_output(
        /CMS32/
      ) { Rake::Task['bonnie:fixtures:generate_cqm_patient_fixtures_from_cql_patients'].invoke('bonnie@example.com') }
      assert_equal 11, `ls -l test/fixtures/cqm_patients/CMS* | wc -l`.to_i
      assert_equal 11, `ls -l spec/javascripts/fixtures/json/patients/CMS* | wc -l`.to_i
    ensure
      FileUtils.rm_r 'test/fixtures/cqm_patients'
      FileUtils.mv 'test/fixtures/cqm_patients.back', 'test/fixtures/cqm_patients'
      FileUtils.rm_r 'spec/javascripts/fixtures/json/patients'
      FileUtils.mv 'spec/javascripts/fixtures/json/patients.back', 'spec/javascripts/fixtures/json/patients'
    end
  end
end
