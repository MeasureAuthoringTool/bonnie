require 'test_helper'
require 'vcr_setup.rb'

class BonniePatientsTest < ActiveSupport::TestCase
  setup do
    dump_database

    records_set = File.join("records", "core_measures", "CMS32v7")
    users_set = File.join("users", "base_set")
    collection_fixtures(users_set, records_set)

    @source_email = 'bonnie@example.com'
    @dest_email = 'user_admin@example.com'
    @source_hqmf_set_id = '3FD13096-2C8F-40B5-9297-B714E8DE9133'
    @dest2_hqmf_set_id = 'A4B9763C-847E-4E02-BB7E-ACC596E90E2C'
    @dest_hqmf_set_id = '848D09DE-7E6B-43C4-BEDD-5A2957CCFFE3'

    @source_user = User.by_email('bonnie@example.com').first
    @dest_user = User.by_email('user_admin@example.com').first

    load_measure_fixtures_from_folder(File.join("measures", "CMS32v7"), @source_user) # '3FD13096-2C8F-40B5-9297-B714E8DE9133'
    load_measure_fixtures_from_folder(File.join("measures", "CMS160v6"), @source_user) # 'A4B9763C-847E-4E02-BB7E-ACC596E90E2C'
    load_measure_fixtures_from_folder(File.join("measures", "CMS177v6"), @dest_user) # '848D09DE-7E6B-43C4-BEDD-5A2957CCFFE3'

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

    assert_equal(4, source_patients.count)
    assert_equal(0, dest_patients.count)

    source_patients = Record.where(user_id:@source_user.id)
    dest_patients = Record.where(user_id:@dest_user.id)

    assert_equal(4, source_patients.count)
    assert_equal(0, dest_patients.count)

    assert_output(
      "Moving patients from '#{@source_hqmf_set_id}' in '#{@source_email}' to '#{@dest_hqmf_set_id}' in '#{@dest_email}'\n" +
      "\e[#{32}m#{"[Success]"}\e[0m\tSuccessfully moved patients from '#{@source_hqmf_set_id}' in '#{@source_email}' to '#{@dest_hqmf_set_id}' in '#{@dest_email}'\n"
                 ) { Rake::Task['bonnie:patients:move_measure_patients'].execute }

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest_hqmf_set_id)

    assert_equal(0, source_patients.count)
    assert_equal(4, dest_patients.count)

    source_patients = Record.where(user_id:@source_user.id)
    dest_patients = Record.where(user_id:@dest_user.id)

    assert_equal(0, source_patients.count)
    assert_equal(4, dest_patients.count)
  end

  test "copy_measure_patients moves patients" do
    ENV['SOURCE_EMAIL'] = @source_email
    ENV['DEST_EMAIL'] = @dest_email
    ENV['SOURCE_HQMF_SET_ID'] = @source_hqmf_set_id
    ENV['DEST_HQMF_SET_ID'] = @dest_hqmf_set_id

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest_hqmf_set_id)

    assert_equal(4, source_patients.count)
    assert_equal(0, dest_patients.count)

    source_patients = Record.where(user_id:@source_user.id)
    dest_patients = Record.where(user_id:@dest_user.id)

    assert_equal(4, source_patients.count)
    assert_equal(0, dest_patients.count)

    assert_output(
      "Copying patients from '#{@source_hqmf_set_id}' in '#{@source_email}' to '#{@dest_hqmf_set_id}' in '#{@dest_email}'\n" +
      "\e[#{32}m#{"[Success]"}\e[0m\tSuccessfully copied patients from '#{@source_hqmf_set_id}' in '#{@source_email}' to '#{@dest_hqmf_set_id}' in '#{@dest_email}'\n"
                 ) { Rake::Task['bonnie:patients:copy_measure_patients'].execute }

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest_hqmf_set_id)

    assert_equal(4, source_patients.count)
    assert_equal(4, dest_patients.count)

    source_patients = Record.where(user_id:@source_user.id)
    dest_patients = Record.where(user_id:@dest_user.id)

    assert_equal(4, source_patients.count)
    assert_equal(4, dest_patients.count)
  end

  test "copy_measure_patients updates source data criteria" do
    ENV['SOURCE_EMAIL'] = @source_email
    ENV['DEST_EMAIL'] = @dest_email
    ENV['SOURCE_HQMF_SET_ID'] = @source_hqmf_set_id
    ENV['DEST_HQMF_SET_ID'] = @dest_hqmf_set_id

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_measures = CQM::Measure.where(hqmf_set_id:@dest_hqmf_set_id)
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
      "Copying patients from '#{@source_hqmf_set_id}' in '#{@source_email}' to '#{@dest_hqmf_set_id}' in '#{@dest_email}'\n" +
      "\e[#{32}m#{"[Success]"}\e[0m\tSuccessfully copied patients from '#{@source_hqmf_set_id}' in '#{@source_email}' to '#{@dest_hqmf_set_id}' in '#{@dest_email}'\n"
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

    assert_equal(4, source_patients.count)
    assert_equal(0, dest_patients.count)
    assert_equal(4, user_patients.count)

    assert_output(
      "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS32v7:Median Time from ED Arrival to ED Departure for Discharged ED Patients found\n" +
      "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS160v6:Depression Utilization of the PHQ-9 Tool found\n" +
      "\e[#{32}m#{"[Success]"}\e[0m\tmoved records in bonnie@example.com from CMS32v7:Median Time from ED Arrival to ED Departure for Discharged ED Patients to CMS160v6:Depression Utilization of the PHQ-9 Tool\n\n"
                 ) { Rake::Task['bonnie:patients:move_patients_csv'].execute }

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = Record.where(user_id:@source_user.id)

    assert_equal(0, source_patients.count)
    assert_equal(4, dest_patients.count)
    assert_equal(4, user_patients.count)

  end

  test "move_patients_csv with bad information" do
    ENV['CSV_PATH'] = File.join(Rails.root, 'test', 'fixtures', 'csv', 'bad_transfers.csv')


    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = Record.where(user_id:@source_user.id)

    assert_equal(4, source_patients.count)
    assert_equal(0, dest_patients.count)
    assert_equal(4, user_patients.count)

    assert_output(
      # test 1 user not found failure
      "\e[#{31}m#{"[Error]"}\e[0m\t\ttest1@example.com not found\n" +
      # test 2 dest measure not found
      "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS32v7:Median Time from ED Arrival to ED Departure for Discharged ED Patients found\n" +
      "\e[#{31}m#{"[Error]"}\e[0m\t\tbonnie@example.com: test2:Depression Utilization of the PHQ-9 Tool not found\n" +
      "\e[#{31}m#{"[Error]"}\e[0m\t\tunable to move records in bonnie@example.com from CMS32v7:Median Time from ED Arrival to ED Departure for Discharged ED Patients to test2:Depression Utilization of the PHQ-9 Tool\n\n" +
      # test 3 source measure not found
      "\e[#{31}m#{"[Error]"}\e[0m\t\tbonnie@example.com: test3:Median Time from ED Arrival to ED Departure for Discharged ED Patients not found\n" +
      "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS160v6:Depression Utilization of the PHQ-9 Tool found\n" +
      "\e[#{31}m#{"[Error]"}\e[0m\t\tunable to move records in bonnie@example.com from test3:Median Time from ED Arrival to ED Departure for Discharged ED Patients to CMS160v6:Depression Utilization of the PHQ-9 Tool\n\n"
                 ) { Rake::Task['bonnie:patients:move_patients_csv'].execute }

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = Record.where(user_id:@source_user.id)

    assert_equal(4, source_patients.count)
    assert_equal(0, dest_patients.count)
    assert_equal(4, user_patients.count)

  end

  test "move_patients_csv with bad duplicate information" do
    ENV['CSV_PATH'] = File.join(Rails.root, 'test', 'fixtures', 'csv', 'bad_duplicate_transfers.csv')

    # need to associate the last measure with this user account to test duplicate cms ids
    associate_user_with_measures(@source_user, CQM::Measure.where(hqmf_set_id: @dest_hqmf_set_id))
    measure = CQM::Measure.where(hqmf_set_id: @dest_hqmf_set_id).first
    measure.cms_id = "CMS32v7"
    measure.title = "Median Time from ED Arrival to ED Departure for Discharged ED Patients"
    measure.save

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = Record.where(user_id:@source_user.id)

    assert_equal(4, source_patients.count)
    assert_equal(0, dest_patients.count)
    assert_equal(4, user_patients.count)

    assert_output(
      # test 1 source title incorrect for duplicate cms ids
      "\e[#{31}m#{"[Error]"}\e[0m\t\tbonnie@example.com: CMS32v7:Test 1 Median Time from ED Arrival to ED Departure for Discharged ED Patients not found\n" +
      "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS160v6:Depression Utilization of the PHQ-9 Tool found\n" +
      "\e[#{31}m#{"[Error]"}\e[0m\t\tunable to move records in bonnie@example.com from CMS32v7:Test 1 Median Time from ED Arrival to ED Departure for Discharged ED Patients to CMS160v6:Depression Utilization of the PHQ-9 Tool\n\n" +
      # test 2 destination title incorrect for duplicate cms ids
      "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS160v6:Depression Utilization of the PHQ-9 Tool found\n" +
      "\e[#{31}m#{"[Error]"}\e[0m\t\tbonnie@example.com: CMS32v7:Test 2 Median Time from ED Arrival to ED Departure for Discharged ED Patients not found\n" +
      "\e[#{31}m#{"[Error]"}\e[0m\t\tunable to move records in bonnie@example.com from CMS160v6:Depression Utilization of the PHQ-9 Tool to CMS32v7:Test 2 Median Time from ED Arrival to ED Departure for Discharged ED Patients\n\n" +
      # test 3 measure title and cms id are duplicates
      "\e[#{31}m#{"[Error]"}\e[0m\t\tbonnie@example.com: CMS32v7:Median Time from ED Arrival to ED Departure for Discharged ED Patients not unique\n" +
      "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS160v6:Depression Utilization of the PHQ-9 Tool found\n" +
      "\e[#{31}m#{"[Error]"}\e[0m\t\tunable to move records in bonnie@example.com from CMS32v7:Median Time from ED Arrival to ED Departure for Discharged ED Patients to CMS160v6:Depression Utilization of the PHQ-9 Tool\n\n"
                 ) { Rake::Task['bonnie:patients:move_patients_csv'].execute }

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = Record.where(user_id:@source_user.id)

    assert_equal(4, source_patients.count)
    assert_equal(0, dest_patients.count)
    assert_equal(4, user_patients.count)

  end

  test "move_patients_csv with duplicate information" do
    ENV['CSV_PATH'] = File.join(Rails.root, 'test', 'fixtures', 'csv', 'duplicate_transfers.csv')

    # need to associate the last measure with this user account to test duplicate cms ids
    associate_user_with_measures(@source_user, CQM::Measure.where(hqmf_set_id: @dest_hqmf_set_id))
    measure = CQM::Measure.where(hqmf_set_id: @dest_hqmf_set_id).first
    measure.cms_id = "CMS32v7"
    measure.save

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = Record.where(user_id:@source_user.id)

    assert_equal(4, source_patients.count)
    assert_equal(0, dest_patients.count)
    assert_equal(4, user_patients.count)

    assert_output(
      "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS32v7:Median Time from ED Arrival to ED Departure for Discharged ED Patients found\n" +
      "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS160v6:Depression Utilization of the PHQ-9 Tool found\n" +
      "\e[#{32}m#{"[Success]"}\e[0m\tmoved records in bonnie@example.com from CMS32v7:Median Time from ED Arrival to ED Departure for Discharged ED Patients to CMS160v6:Depression Utilization of the PHQ-9 Tool\n\n"
                 ) { Rake::Task['bonnie:patients:move_patients_csv'].execute }

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = Record.where(user_id:@source_user.id)

    assert_equal(0, source_patients.count)
    assert_equal(4, dest_patients.count)
    assert_equal(4, user_patients.count)

  end

  test "successful export of patients" do
    load_measure_fixtures_from_folder(File.join("measures", "CMS158v6"), @source_user)
    hqmf_set_id =  '3BBFC929-50C8-44B8-8D34-82BE75C08A70'
    associate_measures_with_patients(CQM::Measure.where(hqmf_set_id: hqmf_set_id), Record.all)

    ENV['EMAIL'] = @source_user.email
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
    dump_database
    users_set = File.join("users", "base_set")
    collection_fixtures(users_set)

    hqmf_set_id =  '848D09DE-7E6B-43C4-BEDD-5A2957CCFFE3'
    load_measure_fixtures_from_folder(File.join("measures", "CMS177v6"), @source_user)


    ENV['EMAIL'] = @source_user.email
    ENV['HQMF_SET_ID'] = hqmf_set_id
    ENV['FILENAME'] = File.join('test','fixtures','patient_export','cms104v2_export_patients_test.json')
    Rake::Task['bonnie:patients:import_patients'].execute
    # Confirm that there are 7 patients now associated with this measure.
    assert_equal 7, Record.where(measure_ids: hqmf_set_id, user_id: @source_user._id).count
  end

  test "importing patient updates facility and diagnosis"  do
    dump_database
    users_set = File.join("users", "base_set")
    collection_fixtures(users_set)

    hqmf_set_id =  '3FD13096-2C8F-40B5-9297-B714E8DE9133'
    load_measure_fixtures_from_folder(File.join("measures", "CMS32v7"), @source_user)
    assert_equal 0, Record.where(measure_ids: hqmf_set_id, user_id: @source_user._id).count

    ENV['EMAIL'] = @source_user.email
    ENV['HQMF_SET_ID'] = hqmf_set_id
    ENV['FILENAME'] = File.join('test','fixtures','patient_export','Diagnosis_Facility_Patients.json')
    Rake::Task['bonnie:patients:import_patients'].execute
    # Confirm that there are 3 patients now associated with this measure.
    assert_equal 3, Record.where(measure_ids: hqmf_set_id, user_id: @source_user._id).count

    # This patient should no longer have arrival, departure, or facility in field_values
    deletion_patient = Record.find_by(first: 'EDDuringMPeriod')
    assert_equal 0, deletion_patient.source_data_criteria[0]['field_values'].length

    # This patient should have new form of diagnosis
    diagnosis_patient = Record.find_by(first: 'LivebornInHospital')
    assert_equal 'COL', diagnosis_patient.source_data_criteria[0]['field_values']['DIAGNOSIS']['type']

    # This patient should have new form of facility
    facility_patient = Record.find_by(first: '3Encs<=30AftADHDMeds')
    assert_equal 'COL', facility_patient.source_data_criteria[4]['field_values']['FACILITY_LOCATION']['type']

  end

  test "materialize all of patients" do
    ENV['EMAIL'] = @source_user.email
    assert_output(/Materialized 4 of 4/) { Rake::Task['bonnie:patients:materialize_all'].execute }
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
