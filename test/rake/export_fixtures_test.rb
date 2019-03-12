require 'test_helper'

class ExportFixturesTest < ActiveSupport::TestCase
  setup do
    dump_database
    measure_set = File.join('cql_measures', 'core_measures', 'CMS32v7')
    simple_measure_set = File.join('cql_measures', 'core_measures', 'CMS134v6')
    users_set = File.join('users', 'base_set')
    records_set = File.join('records','core_measures', 'CMS32v7')
    simple_records_set = File.join('records','core_measures', 'CMS134v6')
    collection_fixtures(users_set, measure_set, simple_measure_set, records_set, simple_records_set)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_patients(@user, Record.all)
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
      system('mv test/fixtures/patients test/fixtures/patients.back')
      system('mv spec/javascripts/fixtures/json/patients spec/javascripts/fixtures/json/patients.back')

      assert_output(
        "exported a patient record to test/fixtures/patients/CMS32v7/Visit_1 ED.json
exported a patient record to spec/javascripts/fixtures/json/patients/CMS32v7/Visit_1 ED.json
exported a patient record to test/fixtures/patients/CMS32v7/Visits_2 ED.json
exported a patient record to spec/javascripts/fixtures/json/patients/CMS32v7/Visits_2 ED.json
exported a patient record to test/fixtures/patients/CMS32v7/Visits 2 Excl_2 ED.json
exported a patient record to spec/javascripts/fixtures/json/patients/CMS32v7/Visits 2 Excl_2 ED.json
exported a patient record to test/fixtures/patients/CMS32v7/Visits 1 Excl_2 ED.json
exported a patient record to spec/javascripts/fixtures/json/patients/CMS32v7/Visits 1 Excl_2 ED.json
exported a patient record to test/fixtures/patients/CMS134v6/Elements_Test.json
exported a patient record to spec/javascripts/fixtures/json/patients/CMS134v6/Elements_Test.json
exported a patient record to test/fixtures/patients/CMS134v6/Fail_Hospice_Not_Performed_Denex.json
exported a patient record to spec/javascripts/fixtures/json/patients/CMS134v6/Fail_Hospice_Not_Performed_Denex.json
Failed to export the following patients:
measure.hqmf_set_id: 7B2A9277-43DA-4D99-9BEE-6AC271A07747
\trecord._id: 5a58f001942c6d500fc8cb92
\terror: Error: 'cc' is not a valid UCUM unit.
"
      ) { Rake::Task['bonnie:fixtures:generate_cqm_patient_fixtures_from_cql_patients'].invoke('bonnie@example.com') }
      assert_equal 11, `ls -l test/fixtures/patients/CMS* | wc -l`.to_i
      assert_equal 11, `ls -l spec/javascripts/fixtures/json/patients/CMS* | wc -l`.to_i
    ensure
      system('mv test/fixtures/patients.back test/fixtures/patients')
      system('mv spec/javascripts/fixtures/json/patients.back spec/javascripts/fixtures/json/patients')
    end
  end
end
