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
        /CMS32/
      ) { Rake::Task['bonnie:fixtures:generate_cqm_patient_fixtures_from_cql_patients'].invoke('bonnie@example.com') }
      assert_equal 11, `ls -l test/fixtures/patients/CMS* | wc -l`.to_i
      assert_equal 7, `ls -l spec/javascripts/fixtures/json/patients/CMS* | wc -l`.to_i
    ensure
      system('rm -rf test/fixtures/patients')
      system('rm -rf spec/javascripts/fixtures/json/patients')
      system('mv test/fixtures/patients.back test/fixtures/patients')
      system('mv spec/javascripts/fixtures/json/patients.back spec/javascripts/fixtures/json/patients')
    end
  end
end
