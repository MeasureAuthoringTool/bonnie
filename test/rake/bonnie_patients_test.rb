require 'test_helper'
require 'vcr_setup.rb'

class BonniePatientsTest < ActiveSupport::TestCase
  setup do
    dump_database

    patients_set = File.join('cqm_patients', 'CMS903v0')
    users_set = File.join('users', 'base_set')
    collection_fixtures(users_set, patients_set)

    @source_email = 'bonnie@example.com'
    @dest_email = 'user_admin@example.com'
    @source_hqmf_set_id = '4DC3E7AA-8777-4749-A1E4-37E942036076'
    @dest2_hqmf_set_id = 'A4B9763C-847E-4E02-BB7E-ACC596E90E2C'
    @dest_hqmf_set_id = '848D09DE-7E6B-43C4-BEDD-5A2957CCFFE3'

    @source_user = User.by_email('bonnie@example.com').first
    @dest_user = User.by_email('user_admin@example.com').first

    load_measure_fixtures_from_folder(File.join('measures', 'CMS903v0'), @source_user) # '4DC3E7AA-8777-4749-A1E4-37E942036076'
    load_measure_fixtures_from_folder(File.join('measures', 'CMS160v6'), @source_user) # 'A4B9763C-847E-4E02-BB7E-ACC596E90E2C'
    load_measure_fixtures_from_folder(File.join('measures', 'CMS177v6'), @dest_user) # '848D09DE-7E6B-43C4-BEDD-5A2957CCFFE3'

    associate_user_with_patients(@source_user, CQM::Patient.all)
    associate_measure_with_patients(CQM::Measure.find_by(hqmf_set_id: @source_hqmf_set_id), CQM::Patient.all)
  end


  test 'move_measure_patients bad environment variables' do
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

  test 'copy_measure_patients bad environment variables' do
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

  test 'move_measure_patients moves patients' do
    ENV['SOURCE_EMAIL'] = @source_email
    ENV['DEST_EMAIL'] = @dest_email
    ENV['SOURCE_HQMF_SET_ID'] = @source_hqmf_set_id
    ENV['DEST_HQMF_SET_ID'] = @dest_hqmf_set_id

    source_patients = CQM::Patient.where(measure_ids:@source_hqmf_set_id)
    dest_patients = CQM::Patient.where(measure_ids:@dest_hqmf_set_id)

    assert_equal(4, source_patients.count)
    assert_equal(0, dest_patients.count)

    source_patients = CQM::Patient.where(user_id:@source_user.id)
    dest_patients = CQM::Patient.where(user_id:@dest_user.id)

    assert_equal(4, source_patients.count)
    assert_equal(0, dest_patients.count)

    assert_output(
      "Moving patients from '#{@source_hqmf_set_id}' in '#{@source_email}' to '#{@dest_hqmf_set_id}' in '#{@dest_email}'\n" +
      "\e[#{32}m#{"[Success]"}\e[0m\tSuccessfully moved patients from '#{@source_hqmf_set_id}' in '#{@source_email}' to '#{@dest_hqmf_set_id}' in '#{@dest_email}'\n"
      ) { Rake::Task['bonnie:patients:move_measure_patients'].execute }

    source_patients = CQM::Patient.where(measure_ids:@source_hqmf_set_id)
    dest_patients = CQM::Patient.where(measure_ids:@dest_hqmf_set_id)

    assert_equal(0, source_patients.count)
    assert_equal(4, dest_patients.count)

    source_patients = CQM::Patient.where(user_id:@source_user.id)
    dest_patients = CQM::Patient.where(user_id:@dest_user.id)

    assert_equal(0, source_patients.count)
    assert_equal(4, dest_patients.count)
  end

  test 'copy_measure_patients moves patients' do
    ENV['SOURCE_EMAIL'] = @source_email
    ENV['DEST_EMAIL'] = @dest_email
    ENV['SOURCE_HQMF_SET_ID'] = @source_hqmf_set_id
    ENV['DEST_HQMF_SET_ID'] = @dest_hqmf_set_id

    source_patients = CQM::Patient.where(measure_ids:@source_hqmf_set_id)
    dest_patients = CQM::Patient.where(measure_ids:@dest_hqmf_set_id)

    assert_equal(4, source_patients.count)
    assert_equal(0, dest_patients.count)

    source_patients = CQM::Patient.where(user_id:@source_user.id)
    dest_patients = CQM::Patient.where(user_id:@dest_user.id)

    assert_equal(4, source_patients.count)
    assert_equal(0, dest_patients.count)

    assert_output(
      "Copying patients from '#{@source_hqmf_set_id}' in '#{@source_email}' to '#{@dest_hqmf_set_id}' in '#{@dest_email}'\n" +
      "\e[#{32}m#{"[Success]"}\e[0m\tSuccessfully copied patients from '#{@source_hqmf_set_id}' in '#{@source_email}' to '#{@dest_hqmf_set_id}' in '#{@dest_email}'\n"
      ) { Rake::Task['bonnie:patients:copy_measure_patients'].execute }

    source_patients = CQM::Patient.where(measure_ids:@source_hqmf_set_id)
    dest_patients = CQM::Patient.where(measure_ids:@dest_hqmf_set_id)

    assert_equal(4, source_patients.count)
    assert_equal(4, dest_patients.count)

    source_patients = CQM::Patient.where(user_id:@source_user.id)
    dest_patients = CQM::Patient.where(user_id:@dest_user.id)

    assert_equal(4, source_patients.count)
    assert_equal(4, dest_patients.count)
  end

  test 'move_patients_csv moves patients' do
    ENV['CSV_PATH'] = File.join(Rails.root, 'test', 'fixtures', 'csv', 'good_transfers.csv')

    source_patients = CQM::Patient.where(measure_ids:@source_hqmf_set_id)
    dest_patients = CQM::Patient.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = CQM::Patient.where(user_id:@source_user.id)

    assert_equal(4, source_patients.count)
    assert_equal(0, dest_patients.count)
    assert_equal(4, user_patients.count)

    assert_output(
      "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS903v0:LikeCMS32 found\n" +
      "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS160v6:Depression Utilization of the PHQ-9 Tool found\n" +
      "\e[#{32}m#{"[Success]"}\e[0m\tmoved records in bonnie@example.com from CMS903v0:LikeCMS32 to CMS160v6:Depression Utilization of the PHQ-9 Tool\n\n"
      ) { Rake::Task['bonnie:patients:move_patients_csv'].execute }

    source_patients = CQM::Patient.where(measure_ids:@source_hqmf_set_id)
    dest_patients = CQM::Patient.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = CQM::Patient.where(user_id:@source_user.id)

    assert_equal(0, source_patients.count)
    assert_equal(4, dest_patients.count)
    assert_equal(4, user_patients.count)

  end

  test 'move_patients_csv with bad information' do
    ENV['CSV_PATH'] = File.join(Rails.root, 'test', 'fixtures', 'csv', 'bad_transfers.csv')

    source_patients = CQM::Patient.where(measure_ids:@source_hqmf_set_id)
    dest_patients = CQM::Patient.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = CQM::Patient.where(user_id:@source_user.id)

    assert_equal(4, source_patients.count)
    assert_equal(0, dest_patients.count)
    assert_equal(4, user_patients.count)

    assert_output(
      # test 1 user not found failure
      "\e[#{31}m#{"[Error]"}\e[0m\t\ttest1@example.com not found\n" +
      # test 2 dest measure not found
      "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS903v0:LikeCMS32 found\n" +
      "\e[#{31}m#{"[Error]"}\e[0m\t\tbonnie@example.com: test2:Depression Utilization of the PHQ-9 Tool not found\n" +
      "\e[#{31}m#{"[Error]"}\e[0m\t\tunable to move records in bonnie@example.com from CMS903v0:LikeCMS32 to test2:Depression Utilization of the PHQ-9 Tool\n\n" +
      # test 3 source measure not found
      "\e[#{31}m#{"[Error]"}\e[0m\t\tbonnie@example.com: test3:LikeCMS32 not found\n" +
      "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS160v6:Depression Utilization of the PHQ-9 Tool found\n" +
      "\e[#{31}m#{"[Error]"}\e[0m\t\tunable to move records in bonnie@example.com from test3:LikeCMS32 to CMS160v6:Depression Utilization of the PHQ-9 Tool\n\n"
      ) { Rake::Task['bonnie:patients:move_patients_csv'].execute }

    source_patients = CQM::Patient.where(measure_ids:@source_hqmf_set_id)
    dest_patients = CQM::Patient.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = CQM::Patient.where(user_id:@source_user.id)

    assert_equal(4, source_patients.count)
    assert_equal(0, dest_patients.count)
    assert_equal(4, user_patients.count)

  end

  test 'move_patients_csv with bad duplicate information' do
    ENV['CSV_PATH'] = File.join(Rails.root, 'test', 'fixtures', 'csv', 'bad_duplicate_transfers.csv')

    # need to associate the last measure with this user account to test duplicate cms ids
    associate_user_with_measures(@source_user, CQM::Measure.where(hqmf_set_id: @dest_hqmf_set_id))
    measure = CQM::Measure.where(hqmf_set_id: @dest_hqmf_set_id).first
    measure.cms_id = "CMS903v0"
    measure.title = "LikeCMS32"
    measure.save

    source_patients = CQM::Patient.where(measure_ids:@source_hqmf_set_id)
    dest_patients = CQM::Patient.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = CQM::Patient.where(user_id:@source_user.id)

    assert_equal(4, source_patients.count)
    assert_equal(0, dest_patients.count)
    assert_equal(4, user_patients.count)

    assert_output(
      # test 1 source title incorrect for duplicate cms ids
      "\e[#{31}m#{"[Error]"}\e[0m\t\tbonnie@example.com: CMS903v0:Test 1 LikeCMS32 not found\n" +
      "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS160v6:Depression Utilization of the PHQ-9 Tool found\n" +
      "\e[#{31}m#{"[Error]"}\e[0m\t\tunable to move records in bonnie@example.com from CMS903v0:Test 1 LikeCMS32 to CMS160v6:Depression Utilization of the PHQ-9 Tool\n\n" +
      # test 2 destination title incorrect for duplicate cms ids
      "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS160v6:Depression Utilization of the PHQ-9 Tool found\n" +
      "\e[#{31}m#{"[Error]"}\e[0m\t\tbonnie@example.com: CMS903v0:Test 2 LikeCMS32 not found\n" +
      "\e[#{31}m#{"[Error]"}\e[0m\t\tunable to move records in bonnie@example.com from CMS160v6:Depression Utilization of the PHQ-9 Tool to CMS903v0:Test 2 LikeCMS32\n\n" +
      # test 3 measure title and cms id are duplicates
      "\e[#{31}m#{"[Error]"}\e[0m\t\tbonnie@example.com: CMS903v0:LikeCMS32 not unique\n" +
      "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS160v6:Depression Utilization of the PHQ-9 Tool found\n" +
      "\e[#{31}m#{"[Error]"}\e[0m\t\tunable to move records in bonnie@example.com from CMS903v0:LikeCMS32 to CMS160v6:Depression Utilization of the PHQ-9 Tool\n\n"
      ) { Rake::Task['bonnie:patients:move_patients_csv'].execute }

    source_patients = CQM::Patient.where(measure_ids:@source_hqmf_set_id)
    dest_patients = CQM::Patient.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = CQM::Patient.where(user_id:@source_user.id)

    assert_equal(4, source_patients.count)
    assert_equal(0, dest_patients.count)
    assert_equal(4, user_patients.count)

  end

  test 'move_patients_csv with duplicate information' do
    ENV['CSV_PATH'] = File.join(Rails.root, 'test', 'fixtures', 'csv', 'duplicate_transfers.csv')

    # need to associate the last measure with this user account to test duplicate cms ids
    associate_user_with_measures(@source_user, CQM::Measure.where(hqmf_set_id: @dest_hqmf_set_id))
    measure = CQM::Measure.where(hqmf_set_id: @dest_hqmf_set_id).first
    measure.cms_id = 'CMS903v0'
    measure.save

    source_patients = CQM::Patient.where(measure_ids:@source_hqmf_set_id)
    dest_patients = CQM::Patient.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = CQM::Patient.where(user_id:@source_user.id)

    assert_equal(4, source_patients.count)
    assert_equal(0, dest_patients.count)
    assert_equal(4, user_patients.count)

    assert_output(
      "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS903v0:LikeCMS32 found\n" +
      "\e[#{32}m#{"[Success]"}\e[0m\tbonnie@example.com: CMS160v6:Depression Utilization of the PHQ-9 Tool found\n" +
      "\e[#{32}m#{"[Success]"}\e[0m\tmoved records in bonnie@example.com from CMS903v0:LikeCMS32 to CMS160v6:Depression Utilization of the PHQ-9 Tool\n\n"
      ) { Rake::Task['bonnie:patients:move_patients_csv'].execute }

    source_patients = CQM::Patient.where(measure_ids:@source_hqmf_set_id)
    dest_patients = CQM::Patient.where(measure_ids:@dest2_hqmf_set_id)
    user_patients = CQM::Patient.where(user_id:@source_user.id)

    assert_equal(0, source_patients.count)
    assert_equal(4, dest_patients.count)
    assert_equal(4, user_patients.count)

  end

  test 'successful export of patients' do
    load_measure_fixtures_from_folder(File.join('measures', 'CMS158v6'), @source_user)
    hqmf_set_id =  '3BBFC929-50C8-44B8-8D34-82BE75C08A70'
    associate_measures_with_patients(CQM::Measure.where(hqmf_set_id: hqmf_set_id), CQM::Patient.all)

    ENV['EMAIL'] = @source_user.email
    ENV['HQMF_SET_ID'] = hqmf_set_id
    ENV['FILENAME'] = 'cms104v2_export_patients_test.json'
    Rake::Task['bonnie:patients:export_patients'].execute

    assert File.exist? File.expand_path'cms104v2_export_patients_test.json'

    # Open up the file and assert the file contains 4 lines, one for each patient.
    f = File.open('cms104v2_export_patients_test.json', 'r')
    assert_equal 4, f.readlines.size
    File.delete('cms104v2_export_patients_test.json') if File.exist?('cms104v2_export_patients_test.json')
  end

  test 'successful import of patients'  do
    dump_database
    users_set = File.join('users', 'base_set')
    collection_fixtures(users_set)

    hqmf_set_id =  '848D09DE-7E6B-43C4-BEDD-5A2957CCFFE3'
    load_measure_fixtures_from_folder(File.join('measures', 'CMS177v6'), @source_user)

    ENV['EMAIL'] = @source_user.email
    ENV['HQMF_SET_ID'] = hqmf_set_id
    ENV['FILENAME'] = File.join('test','fixtures','patient_export','cms104v3_export_patients_test.json')
    Rake::Task['bonnie:patients:import_patients'].execute
    # Confirm that there are 4 patients now associated with this measure.
    assert_equal 4, CQM::Patient.where(measure_ids: hqmf_set_id, user_id: @source_user._id).count
  end

end
