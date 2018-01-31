require 'test_helper'
require 'vcr_setup.rb'

class BonniePatientsTest < ActiveSupport::TestCase
  setup do
    dump_database

    records_set = File.join("records", "CMS347v1")
    users_set = File.join("users", "base_set")
    cql_measures_set_1 = File.join("cql_measures", "CMS347v1")
    cql_measures_set_2 = File.join("cql_measures", "CMS160v6")
    cql_measures_set_3 = File.join("cql_measures", "CMS72v5")
    collection_fixtures(users_set, records_set)
    add_collection(cql_measures_set_1)
    add_collection(cql_measures_set_2)
    add_collection(cql_measures_set_3)

    @source_email = 'bonnie@example.com'
    @dest_email = 'user_admin@example.com'
    @source_hqmf_set_id = '5375D6A9-203B-4FFF-B851-AFA9B68D2AC2'
    @dest2_hqmf_set_id = '93F3479F-75D8-4731-9A3F-B7749D8BCD37'
    @dest_hqmf_set_id = 'A4B9763C-847E-4E02-BB7E-ACC596E90E2C'

    @source_user = User.by_email('bonnie@example.com').first
    @dest_user = User.by_email('user_admin@example.com').first

    associate_user_with_measures(@source_user, CqlMeasure.where(hqmf_set_id: @source_hqmf_set_id))
    associate_user_with_measures(@source_user, CqlMeasure.where(hqmf_set_id: @dest2_hqmf_set_id))
    associate_user_with_measures(@dest_user, CqlMeasure.where(hqmf_set_id: @dest_hqmf_set_id))
    # these patients are already associated with the source measure in the json file
    associate_user_with_patients(@source_user, Record.all)
  end


  test "move_measure_patients bad environment variables" do
    # Bad source email
    ENV['SOURCE_EMAIL'] = 'asdf@example.com'
    ENV['DEST_EMAIL'] = @dest_email
    ENV['SOURCE_HQMF_SET_ID'] = @source_hqmf_set_id
    ENV['DEST_HQMF_SET_ID'] = @dest_hqmf_set_id

    assert_output("\e[#{31}m#{"[Error]"}\e[0m\t\tasdf@example.com not found\n") { Rake::Task['bonnie:patients:move_measure_patients'].execute }

    # Bad destination email
    ENV['SOURCE_EMAIL'] = @source_email
    ENV['DEST_EMAIL'] = 'fdsa@example.com'
    ENV['SOURCE_HQMF_SET_ID'] = @source_hqmf_set_id
    ENV['DEST_HQMF_SET_ID'] = @dest_hqmf_set_id

    assert_output("\e[#{31}m#{"[Error]"}\e[0m\t\tfdsa@example.com not found\n") { Rake::Task['bonnie:patients:move_measure_patients'].execute }

    # Bad source hqmf_set_id
    ENV['SOURCE_EMAIL'] = @source_email
    ENV['DEST_EMAIL'] = @dest_email
    ENV['SOURCE_HQMF_SET_ID'] = '5375D6A9-203B-4FFF-B851-AFA9B68Dzzz'
    ENV['DEST_HQMF_SET_ID'] = @dest_hqmf_set_id

    assert_output("\e[#{31}m#{"[Error]"}\e[0m\t\tmeasure with HQFM set id 5375D6A9-203B-4FFF-B851-AFA9B68Dzzz not found for account bonnie@example.com\n") { Rake::Task['bonnie:patients:move_measure_patients'].execute }

    # Bad destination hqmf_set_id
    ENV['SOURCE_EMAIL'] = @source_email
    ENV['DEST_EMAIL'] = @dest_email
    ENV['SOURCE_HQMF_SET_ID'] = @source_hqmf_set_id
    ENV['DEST_HQMF_SET_ID'] = 'A4B9763C-847E-4E02-BB7E-ACC596E9zzzz'

    assert_output("\e[#{31}m#{"[Error]"}\e[0m\t\tmeasure with HQFM set id A4B9763C-847E-4E02-BB7E-ACC596E9zzzz not found for account user_admin@example.com\n") { Rake::Task['bonnie:patients:move_measure_patients'].execute }
  end

  test "copy_measure_patients bad environment variables" do
    # Bad source email
    ENV['SOURCE_EMAIL'] = 'asdf@example.com'
    ENV['DEST_EMAIL'] = @dest_email
    ENV['SOURCE_HQMF_SET_ID'] = @source_hqmf_set_id
    ENV['DEST_HQMF_SET_ID'] = @dest_hqmf_set_id

    assert_output("\e[#{31}m#{"[Error]"}\e[0m\t\tasdf@example.com not found\n") { Rake::Task['bonnie:patients:copy_measure_patients'].execute }

    # Bad destination email
    ENV['SOURCE_EMAIL'] = @source_email
    ENV['DEST_EMAIL'] = 'fdsa@example.com'
    ENV['SOURCE_HQMF_SET_ID'] = @source_hqmf_set_id
    ENV['DEST_HQMF_SET_ID'] = @dest_hqmf_set_id

    assert_output("\e[#{31}m#{"[Error]"}\e[0m\t\tfdsa@example.com not found\n") { Rake::Task['bonnie:patients:copy_measure_patients'].execute }

    # Bad source hqmf_set_id
    ENV['SOURCE_EMAIL'] = @source_email
    ENV['DEST_EMAIL'] = @dest_email
    ENV['SOURCE_HQMF_SET_ID'] = '5375D6A9-203B-4FFF-B851-AFA9B68Dzzz'
    ENV['DEST_HQMF_SET_ID'] = @dest_hqmf_set_id

    assert_output("\e[#{31}m#{"[Error]"}\e[0m\t\tmeasure with HQFM set id 5375D6A9-203B-4FFF-B851-AFA9B68Dzzz not found for account #{@source_email}\n") { Rake::Task['bonnie:patients:copy_measure_patients'].execute }

    # Bad destination hqmf_set_id
    ENV['SOURCE_EMAIL'] = @source_email
    ENV['DEST_EMAIL'] = @dest_email
    ENV['SOURCE_HQMF_SET_ID'] = @source_hqmf_set_id
    ENV['DEST_HQMF_SET_ID'] = 'A4B9763C-847E-4E02-BB7E-ACC596E9zzzz'

    assert_output("\e[#{31}m#{"[Error]"}\e[0m\t\tmeasure with HQFM set id A4B9763C-847E-4E02-BB7E-ACC596E9zzzz not found for account #{@dest_email}\n") { Rake::Task['bonnie:patients:copy_measure_patients'].execute }
  end

  test "move_measure_patients moves patients" do
    ENV['SOURCE_EMAIL'] = @source_email
    ENV['DEST_EMAIL'] = @dest_email
    ENV['SOURCE_HQMF_SET_ID'] = @source_hqmf_set_id
    ENV['DEST_HQMF_SET_ID'] = @dest_hqmf_set_id

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest_hqmf_set_id)

    assert_equal(7, source_patients.count)
    assert_equal(0, dest_patients.count)

    source_patients = Record.where(user_id:@source_user.id)
    dest_patients = Record.where(user_id:@dest_user.id)

    assert_equal(7, source_patients.count)
    assert_equal(0, dest_patients.count)

    assert_output(
                  "Moving patients from '5375D6A9-203B-4FFF-B851-AFA9B68D2AC2' in 'bonnie@example.com' to 'A4B9763C-847E-4E02-BB7E-ACC596E90E2C' in 'user_admin@example.com'\n" +
                  "\e[#{32}m#{"[Success]"}\e[0m\tSuccessfully moved patients from '5375D6A9-203B-4FFF-B851-AFA9B68D2AC2' in 'bonnie@example.com' to 'A4B9763C-847E-4E02-BB7E-ACC596E90E2C' in 'user_admin@example.com'\n"
                 ) { Rake::Task['bonnie:patients:move_measure_patients'].execute }

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest_hqmf_set_id)

    assert_equal(0, source_patients.count)
    assert_equal(7, dest_patients.count)

    source_patients = Record.where(user_id:@source_user.id)
    dest_patients = Record.where(user_id:@dest_user.id)

    assert_equal(0, source_patients.count)
    assert_equal(7, dest_patients.count)
  end

  test "copy_measure_patients moves patients" do
    ENV['SOURCE_EMAIL'] = @source_email
    ENV['DEST_EMAIL'] = @dest_email
    ENV['SOURCE_HQMF_SET_ID'] = @source_hqmf_set_id
    ENV['DEST_HQMF_SET_ID'] = @dest_hqmf_set_id

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest_hqmf_set_id)

    assert_equal(7, source_patients.count)
    assert_equal(0, dest_patients.count)

    source_patients = Record.where(user_id:@source_user.id)
    dest_patients = Record.where(user_id:@dest_user.id)

    assert_equal(7, source_patients.count)
    assert_equal(0, dest_patients.count)

    assert_output(
                  "Copying patients from '5375D6A9-203B-4FFF-B851-AFA9B68D2AC2' in 'bonnie@example.com' to 'A4B9763C-847E-4E02-BB7E-ACC596E90E2C' in 'user_admin@example.com'\n" +
                  "\e[#{32}m#{"[Success]"}\e[0m\tSuccessfully copied patients from '5375D6A9-203B-4FFF-B851-AFA9B68D2AC2' in 'bonnie@example.com' to 'A4B9763C-847E-4E02-BB7E-ACC596E90E2C' in 'user_admin@example.com'\n"
                 ) { Rake::Task['bonnie:patients:copy_measure_patients'].execute }

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest_hqmf_set_id)

    assert_equal(7, source_patients.count)
    assert_equal(7, dest_patients.count)

    source_patients = Record.where(user_id:@source_user.id)
    dest_patients = Record.where(user_id:@dest_user.id)

    assert_equal(7, source_patients.count)
    assert_equal(7, dest_patients.count)
  end

  test "copy_measure_patients updates source data criteria" do
    ENV['SOURCE_EMAIL'] = @source_email
    ENV['DEST_EMAIL'] = @dest_email
    ENV['SOURCE_HQMF_SET_ID'] = @source_hqmf_set_id
    ENV['DEST_HQMF_SET_ID'] = @dest_hqmf_set_id

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_measures = CqlMeasure.where(hqmf_set_id:@dest_hqmf_set_id)
    assert_equal dest_measures.length, 1
    dest_measure = dest_measures.first

    # Make fake sdc items in measure as if measure has relevant sdc
    source_patients.each do |record|
      record.source_data_criteria.each do |sdc|
        fake_sdc = {cms_id: 'Testv1', title: 'FakeTitle', description: 'FakeDescription', type: 'FakeType'}
        dest_measure.source_data_criteria[sdc['id']] = fake_sdc
      end
      dest_measure.save
    end

    assert_output(
                  "Copying patients from '5375D6A9-203B-4FFF-B851-AFA9B68D2AC2' in 'bonnie@example.com' to 'A4B9763C-847E-4E02-BB7E-ACC596E90E2C' in 'user_admin@example.com'\n" +
                  "\e[#{32}m#{"[Success]"}\e[0m\tSuccessfully copied patients from '5375D6A9-203B-4FFF-B851-AFA9B68D2AC2' in 'bonnie@example.com' to 'A4B9763C-847E-4E02-BB7E-ACC596E90E2C' in 'user_admin@example.com'\n"
                 ) { Rake::Task['bonnie:patients:copy_measure_patients'].execute }

    dest_patients = Record.where(measure_ids:@dest_hqmf_set_id)
    dest_patients.each do |record|
      record.source_data_criteria.each do |sdc|
        assert_equal(sdc['hqmf_set_id'], @dest_hqmf_set_id) if sdc['hqmf_set_id']
      end
    end
  end

  test "move_patients_csv moves patients" do
    ENV['CSV_PATH'] = File.join(Rails.root, 'test', 'fixtures', 'csv', 'good_transfers.csv')

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = Record.where(user_id:@source_user.id)

    assert_equal(7, source_patients.count)
    assert_equal(0, dest_patients.count)
    assert_equal(7, user_patients.count)

    assert_output(
                  "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS347v1:Statin Therapy for the Prevention and Treatment of Cardiovascular Disease found\n" +
                  "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS72v5:Depression Utilization of the PHQ-9 Tool found\n" +
                  "\e[#{32}m#{"[Success]"}\e[0m\tmoved records in bonnie@example.com from CMS347v1:Statin Therapy for the Prevention and Treatment of Cardiovascular Disease to CMS72v5:Depression Utilization of the PHQ-9 Tool\n\n"
                 ) { Rake::Task['bonnie:patients:move_patients_csv'].execute }

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = Record.where(user_id:@source_user.id)

    assert_equal(0, source_patients.count)
    assert_equal(7, dest_patients.count)
    assert_equal(7, user_patients.count)

  end

  test "move_patients_csv with bad information" do
    ENV['CSV_PATH'] = File.join(Rails.root, 'test', 'fixtures', 'csv', 'bad_transfers.csv')


    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = Record.where(user_id:@source_user.id)

    assert_equal(7, source_patients.count)
    assert_equal(0, dest_patients.count)
    assert_equal(7, user_patients.count)

    assert_output(
                  # test 1 user not found failure
                  "\e[#{31}m#{"[Error]"}\e[0m\t\ttest1@example.com not found\n" +
                  # test 2 dest measure not found
                  "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS347v1:Statin Therapy for the Prevention and Treatment of Cardiovascular Disease found\n" +
                  "\e[#{31}m#{"[Error]"}\e[0m\t\tbonnie@example.com: test2:Depression Utilization of the PHQ-9 Tool not found\n" +
                  "\e[#{31}m#{"[Error]"}\e[0m\t\tunable to move records in bonnie@example.com from CMS347v1:Statin Therapy for the Prevention and Treatment of Cardiovascular Disease to test2:Depression Utilization of the PHQ-9 Tool\n\n" +
                  # test 3 source measure not found
                  "\e[#{31}m#{"[Error]"}\e[0m\t\tbonnie@example.com: test3:Statin Therapy for the Prevention and Treatment of Cardiovascular Disease not found\n" +
                  "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS72v5:Depression Utilization of the PHQ-9 Tool found\n" +
                  "\e[#{31}m#{"[Error]"}\e[0m\t\tunable to move records in bonnie@example.com from test3:Statin Therapy for the Prevention and Treatment of Cardiovascular Disease to CMS72v5:Depression Utilization of the PHQ-9 Tool\n\n"
                 ) { Rake::Task['bonnie:patients:move_patients_csv'].execute }

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = Record.where(user_id:@source_user.id)

    assert_equal(7, source_patients.count)
    assert_equal(0, dest_patients.count)
    assert_equal(7, user_patients.count)

  end

  test "move_patients_csv with bad duplicate information" do
    ENV['CSV_PATH'] = File.join(Rails.root, 'test', 'fixtures', 'csv', 'bad_duplicate_transfers.csv')

    # need to associate the last measure with this user account to test duplicate cms ids
    associate_user_with_measures(@source_user, CqlMeasure.where(hqmf_set_id: @dest_hqmf_set_id))
    measure = CqlMeasure.where(hqmf_set_id: @dest_hqmf_set_id).first
    measure.cms_id = "CMS347v1"
    measure.title = "Statin Therapy for the Prevention and Treatment of Cardiovascular Disease"
    measure.save

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = Record.where(user_id:@source_user.id)

    assert_equal(7, source_patients.count)
    assert_equal(0, dest_patients.count)
    assert_equal(7, user_patients.count)

    assert_output(
                  # test 1 source title incorrect for duplicate cms ids
                  "\e[#{31}m#{"[Error]"}\e[0m\t\tbonnie@example.com: CMS347v1:Test 1 Therapy for the Prevention and Treatment of Cardiovascular Disease not found\n" +
                  "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS72v5:Depression Utilization of the PHQ-9 Tool found\n" +
                  "\e[#{31}m#{"[Error]"}\e[0m\t\tunable to move records in bonnie@example.com from CMS347v1:Test 1 Therapy for the Prevention and Treatment of Cardiovascular Disease to CMS72v5:Depression Utilization of the PHQ-9 Tool\n\n" +
                  # test 2 destination title incorrect for duplicate cms ids
                  "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS72v5:Depression Utilization of the PHQ-9 Tool found\n" +
                  "\e[#{31}m#{"[Error]"}\e[0m\t\tbonnie@example.com: CMS347v1:Test 2 Therapy for the Prevention and Treatment of Cardiovascular Disease not found\n" +
                  "\e[#{31}m#{"[Error]"}\e[0m\t\tunable to move records in bonnie@example.com from CMS72v5:Depression Utilization of the PHQ-9 Tool to CMS347v1:Test 2 Therapy for the Prevention and Treatment of Cardiovascular Disease\n\n" +
                  # test 3 measure title and cms id are duplicates
                  "\e[#{31}m#{"[Error]"}\e[0m\t\tbonnie@example.com: CMS347v1:Statin Therapy for the Prevention and Treatment of Cardiovascular Disease not unique\n" +
                  "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS72v5:Depression Utilization of the PHQ-9 Tool found\n" +
                  "\e[#{31}m#{"[Error]"}\e[0m\t\tunable to move records in bonnie@example.com from CMS347v1:Statin Therapy for the Prevention and Treatment of Cardiovascular Disease to CMS72v5:Depression Utilization of the PHQ-9 Tool\n\n"
                 ) { Rake::Task['bonnie:patients:move_patients_csv'].execute }

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = Record.where(user_id:@source_user.id)

    assert_equal(7, source_patients.count)
    assert_equal(0, dest_patients.count)
    assert_equal(7, user_patients.count)

  end

  test "move_patients_csv with duplicate information" do
    ENV['CSV_PATH'] = File.join(Rails.root, 'test', 'fixtures', 'csv', 'duplicate_transfers.csv')

    # need to associate the last measure with this user account to test duplicate cms ids
    associate_user_with_measures(@source_user, CqlMeasure.where(hqmf_set_id: @dest_hqmf_set_id))
    measure = CqlMeasure.where(hqmf_set_id: @dest_hqmf_set_id).first
    measure.cms_id = "CMS347v1"
    measure.save

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = Record.where(user_id:@source_user.id)

    assert_equal(7, source_patients.count)
    assert_equal(0, dest_patients.count)
    assert_equal(7, user_patients.count)

    assert_output(
                  "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS347v1:Statin Therapy for the Prevention and Treatment of Cardiovascular Disease found\n" +
                  "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS72v5:Depression Utilization of the PHQ-9 Tool found\n" +
                  "\e[#{32}m#{"[Success]"}\e[0m\tmoved records in bonnie@example.com from CMS347v1:Statin Therapy for the Prevention and Treatment of Cardiovascular Disease to CMS72v5:Depression Utilization of the PHQ-9 Tool\n\n"
                 ) { Rake::Task['bonnie:patients:move_patients_csv'].execute }

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = Record.where(user_id:@source_user.id)

    assert_equal(0, source_patients.count)
    assert_equal(7, dest_patients.count)
    assert_equal(7, user_patients.count)

  end

  test "successful export of patients" do
    measures_set = File.join("draft_measures", "base_set")
    add_collection(measures_set)
    hqmf_set_id =  '42BF391F-38A3-TEST-9ECE-DCD47E9609D9'

    associate_user_with_measures(@source_user, Measure.where(hqmf_set_id: hqmf_set_id))
    associate_measures_with_patients(Measure.where(hqmf_set_id: hqmf_set_id), Record.all)

    ENV['EMAIL'] = @source_user.email
    ENV['HQMF_SET_ID'] = hqmf_set_id
    ENV['FILENAME'] = 'cms104v2_export_patients_test.json'
    Rake::Task['bonnie:patients:export_patients'].execute

    assert File.exist? File.expand_path'cms104v2_export_patients_test.json'

    # Open up the file and assert the file contains 7 lines, one for each patient.
    f = File.open('cms104v2_export_patients_test.json', "r")
    assert_equal 7, f.readlines.size
    File.delete('cms104v2_export_patients_test.json') if File.exist?('cms104v2_export_patients_test.json')
  end

  test "successful import of patients"  do
    dump_database
    users_set = File.join("users", "base_set")
    measures_set = File.join("cql_measures", "CMS347v1")
    add_collection(measures_set)
    collection_fixtures(users_set)

    hqmf_set_id =  '5375D6A9-203B-4FFF-B851-AFA9B68D2AC2'
    associate_user_with_measures(@source_user, CqlMeasure.where(hqmf_set_id: hqmf_set_id))

    ENV['EMAIL'] = @source_user.email
    ENV['HQMF_SET_ID'] = hqmf_set_id
    ENV['FILENAME'] = File.join('test','fixtures','patient_export','cms104v2_export_patients_test.json')
    ENV['MEASURE_TYPE'] = 'CQL'
    Rake::Task['bonnie:patients:import_patients'].execute
    # Confirm that there are 7 patients now associated with this measure.
    assert_equal 7, Record.where(measure_ids: hqmf_set_id, user_id: @source_user._id).count
  end

  test "materialize all of patients" do
    ENV['EMAIL'] = @source_user.email
    assert_output(/Materialized 7 of 7/) { Rake::Task['bonnie:patients:materialize_all'].execute }
  end

  test "materialize all of patients for user with no patients" do
    ENV['EMAIL'] = @dest_user.email
    assert_output(/Materialized 0 of 0/) { Rake::Task['bonnie:patients:materialize_all'].execute }
  end

  test "date shift forward for all associated patients' source data criteria by one year" do
    ENV['EMAIL'] = @source_user.email
    ENV['YEARS'] = '1'
    ENV['DIR'] = 'forward'
    p = Record.where(user_id:@source_user.id).first
    before_birth_date = p.birthdate
    before_dc_start_date = p.source_data_criteria[0]['start_date']
    before_dc_end_date = p.source_data_criteria[0]['end_date']
    Rake::Task['bonnie:patients:date_shift'].execute
    p = Record.where(user_id:@source_user.id).first

    # Assert the before date + a year, equals the new birthdate of the patient and the new start and end dates of the data criteria.
    after_birth_date = (Time.at( before_birth_date ).utc.advance( :years => 1, :months => 0, :weeks => 0, :days => 0, :hours => 0, :minutes => 0, :seconds => 0 ) ).to_i
    after_dc_start_date = ( Time.at( before_dc_start_date / 1000 ).utc.advance( :years => 1, :months => 0, :weeks => 0, :days => 0, :hours => 0, :minutes => 0, :seconds => 0 ) ).to_i * 1000
    after_dc_end_date = ( Time.at( before_dc_end_date / 1000 ).utc.advance( :years => 1, :months => 0, :weeks => 0, :days => 0, :hours => 0, :minutes => 0, :seconds => 0 ) ).to_i * 1000
    assert_equal after_birth_date, p.birthdate
    assert_equal after_dc_start_date, p.source_data_criteria[0]['start_date']
    assert_equal after_dc_end_date, p.source_data_criteria[0]['end_date']
  end

  test "date shift backward for all associated patients' source data criteria by one year" do
    ENV['EMAIL'] = @source_user.email
    ENV['YEARS'] = '1'
    ENV['DIR'] = 'backward'
    p = Record.where(user_id:@source_user.id).first
    before_birth_date = p.birthdate
    before_dc_start_date = p.source_data_criteria[0]['start_date']
    before_dc_end_date = p.source_data_criteria[0]['end_date']
    Rake::Task['bonnie:patients:date_shift'].execute
    p = Record.where(user_id:@source_user.id).first

    # Assert the before date - a year, equals the new birthdate of the patient and the new start and end dates of the data criteria.
    after_birth_date = (Time.at( before_birth_date ).utc.advance( :years => -1, :months => 0, :weeks => 0, :days => 0, :hours => 0, :minutes => 0, :seconds => 0 ) ).to_i
    after_dc_start_date = ( Time.at( before_dc_start_date / 1000 ).utc.advance( :years => -1, :months => 0, :weeks => 0, :days => 0, :hours => 0, :minutes => 0, :seconds => 0 ) ).to_i * 1000
    after_dc_end_date = ( Time.at( before_dc_end_date / 1000 ).utc.advance( :years => -1, :months => 0, :weeks => 0, :days => 0, :hours => 0, :minutes => 0, :seconds => 0 ) ).to_i * 1000
    assert_equal after_birth_date, p.birthdate
    assert_equal after_dc_start_date, p.source_data_criteria[0]['start_date']
    assert_equal after_dc_end_date, p.source_data_criteria[0]['end_date']
  end

end
