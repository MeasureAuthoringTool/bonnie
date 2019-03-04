require 'test_helper'

class BonnieUsersTest < ActiveSupport::TestCase
  setup do
    dump_database
    @user = User.new(email: 'test@test.com', first: 'first', last: 'last', password: 'Test1234!')
    @user.save!

  end

  test "grant admin rake task" do
    assert_equal 1, User.count

    ENV['EMAIL'] = @user.email
    Rake::Task['bonnie:users:grant_admin'].execute
    assert User.find_by(email: @user.email).is_admin?
  end

  test "revoke admin rake task" do
    assert_equal 1, User.count

    ENV['EMAIL'] = @user.email
    Rake::Task['bonnie:users:grant_admin'].execute
    assert User.find_by(email: @user.email).is_admin?

    Rake::Task['bonnie:users:revoke_admin'].execute
    assert_equal false, User.find_by(email: @user.email).is_admin?
  end

  test "grant portfolio rake task" do
    assert_equal 1, User.count

    ENV['EMAIL'] = @user.email
    Rake::Task['bonnie:users:grant_portfolio'].execute
    assert User.find_by(email: @user.email).is_portfolio?
  end

  test "revoke portfolio rake task" do
    assert_equal 1, User.count

    ENV['EMAIL'] = @user.email
    Rake::Task['bonnie:users:grant_portfolio'].execute
    assert User.find_by(email: @user.email).is_portfolio?

    Rake::Task['bonnie:users:revoke_portfolio'].execute
    assert_equal false, User.find_by(email: @user.email).is_portfolio?
  end

  test "grant dashboard rake task" do
    assert_equal 1, User.count

    ENV['EMAIL'] = @user.email
    Rake::Task['bonnie:users:grant_dashboard'].execute
    assert User.find_by(email: @user.email).is_dashboard?
  end

  test "revoke dashboard rake task" do
    assert_equal 1, User.count

    ENV['EMAIL'] = @user.email
    Rake::Task['bonnie:users:grant_dashboard'].execute
    assert User.find_by(email: @user.email).is_dashboard?

    Rake::Task['bonnie:users:revoke_dashboard'].execute
    assert_equal false, User.find_by(email: @user.email).is_dashboard?
  end

  test "grant dashboard set rake task" do
    assert_equal 1, User.count

    ENV['EMAIL'] = @user.email
    Rake::Task['bonnie:users:grant_dashboard_set'].execute
    assert User.find_by(email: @user.email).is_dashboard_set?
  end

  test "revoke dashboard set rake task" do
    assert_equal 1, User.count

    ENV['EMAIL'] = @user.email
    Rake::Task['bonnie:users:grant_dashboard_set'].execute
    assert User.find_by(email: @user.email).is_dashboard_set?

    Rake::Task['bonnie:users:revoke_dashboard_set'].execute
    assert_equal false, User.find_by(email: @user.email).is_dashboard_set?
  end

  test "move measure" do
    source_email = 'bonnie@example.com'
    dest_email = 'user_admin@example.com'
    source_hqmf_set_id = '3FD13096-2C8F-40B5-9297-B714E8DE9133'

    records_set = File.join("records", "core_measures", "CMS32v7")
    users_set = File.join("users", "base_set")
    collection_fixtures(users_set, records_set)
    source_user = User.by_email('bonnie@example.com').first
    dest_user = User.by_email('user_admin@example.com').first
    load_measure_fixtures_from_folder(File.join("measures", "CMS32v7"), source_user)
    # these patients are already associated with the source measure in the json file
    associate_user_with_patients(source_user, Record.all)

    measure = CQM::Measure.where(hqmf_set_id: source_hqmf_set_id).first

    # confirm base state

    source_measures = CQM::Measure.where(user_id:source_user.id)
    dest_measures = CQM::Measure.where(user_id:dest_user.id)
    source_patients = Record.where(user_id:source_user.id)
    dest_patients = Record.where(user_id:dest_user.id)

    assert_equal(1, source_measures.count)
    assert_equal(measure._id, source_measures.first._id)
    assert_equal(0, dest_measures.count)

    assert_equal(4, source_patients.count)
    assert_equal(0, dest_patients.count)

    # confirm bad source email

    ENV['SOURCE_EMAIL'] = "asdf@gmail.com"
    ENV['DEST_EMAIL'] = dest_email
    ENV['CMS_ID'] = "CMS32v7"

    err = assert_raises RuntimeError do
      Rake::Task['bonnie:users:move_measure'].execute
    end
    assert_match("asdf@gmail.com not found", err.message)

    # confirm bad dest email

    ENV['SOURCE_EMAIL'] = source_email
    ENV['DEST_EMAIL'] = "fdsa@gmail.com"
    ENV['CMS_ID'] = "CMS32v7"

    err = assert_raises RuntimeError do
      Rake::Task['bonnie:users:move_measure'].execute
    end
    assert_match("fdsa@gmail.com not found", err.message)

    # confirm bad cms id

    ENV['SOURCE_EMAIL'] = source_email
    ENV['DEST_EMAIL'] = dest_email
    ENV['CMS_ID'] = "asdf"

    err = assert_raises RuntimeError do
      Rake::Task['bonnie:users:move_measure'].execute
    end
    assert_match("asdf not found", err.message)

    # confirm behaves as expected

    ENV['SOURCE_EMAIL'] = source_email
    ENV['DEST_EMAIL'] = dest_email
    ENV['CMS_ID'] = "CMS32v7"

    vs_count_measure = measure.value_sets.count
    vs_count_user = CQM::ValueSet.where(user_id: source_user).count
    refute_equal(0, vs_count_measure)
    refute_equal(0, vs_count_user)

    Rake::Task['bonnie:users:move_measure'].execute

    source_measures = CQM::Measure.where(user_id:source_user.id)
    dest_measures = CQM::Measure.where(user_id:dest_user.id)
    source_patients = Record.where(user_id:source_user.id)
    dest_patients = Record.where(user_id:dest_user.id)

    assert_equal(0, source_measures.count)
    assert_equal(1, dest_measures.count)
    assert_equal(measure._id, dest_measures.first._id)

    assert_equal(0, source_patients.count)
    assert_equal(4, dest_patients.count)

    assert_equal(vs_count_measure, dest_measures.first.value_sets.count)
    assert_equal(vs_count_user, CQM::ValueSet.where(user_id: dest_user).count)
    assert_equal(0, CQM::ValueSet.where(user_id: source_user).count)
  end

end
