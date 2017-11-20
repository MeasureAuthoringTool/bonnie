require 'test_helper'
require 'vcr_setup.rb'

class RakeTest < ActiveSupport::TestCase
  setup do
    dump_database

    records_set = File.join("records", "CMS347v1")
    users_set = File.join("users", "base_set")
    cql_measures_set_1 = File.join("cql_measures", "CMS347v1")
    cql_measures_set_2 = File.join("cql_measures", "CMS160v6")
    collection_fixtures(users_set, records_set)
    add_collection(cql_measures_set_1)
    add_collection(cql_measures_set_2)

    @source_email = 'bonnie@example.com'
    @dest_email = 'user_admin@example.com'
    @source_hqmf_set_id = '5375D6A9-203B-4FFF-B851-AFA9B68D2AC2'
    @dest_hqmf_set_id = 'A4B9763C-847E-4E02-BB7E-ACC596E90E2C'

    @source_user = User.by_email('bonnie@example.com').first
    @dest_user = User.by_email('user_admin@example.com').first

    associate_user_with_measures(@source_user, CqlMeasure.where(hqmf_set_id: '5375D6A9-203B-4FFF-B851-AFA9B68D2AC2'))
    associate_user_with_measures(@dest_user, CqlMeasure.where(hqmf_set_id: 'A4B9763C-847E-4E02-BB7E-ACC596E90E2C'))
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

    Rake::Task['bonnie:patients:move_measure_patients'].execute

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

    Rake::Task['bonnie:patients:copy_measure_patients'].execute

    source_patients = Record.where(measure_ids:@source_hqmf_set_id)
    dest_patients = Record.where(measure_ids:@dest_hqmf_set_id)

    assert_equal(7, source_patients.count)
    assert_equal(7, dest_patients.count)

    source_patients = Record.where(user_id:@source_user.id)
    dest_patients = Record.where(user_id:@dest_user.id)

    assert_equal(7, source_patients.count)
    assert_equal(7, dest_patients.count)
  end

end
