require 'test_helper'

class BonnieUsersTest < ActiveSupport::TestCase    
  setup do
  end

  test "grant admin rake task" do
    dump_database
    @user = User.new(email: 'test@test.com', first: 'first' , last: 'last', password: 'Test1234!') 
    @user.save!
    assert_equal 1, User.count

    ENV['EMAIL'] = @user.email
    Rake::Task['bonnie:users:grant_admin'].execute
    assert User.find_by(email: @user.email).is_admin?
  end

  test "revoke admin rake task" do
    dump_database
    @user = User.new(email: 'test@test.com', first: 'first', last: 'last', password: 'Test1234!')
    @user.save!
    assert_equal 1, User.count

    ENV['EMAIL'] = @user.email
    Rake::Task['bonnie:users:grant_admin'].execute
    assert User.find_by(email: @user.email).is_admin?

    Rake::Task['bonnie:users:revoke_admin'].execute
    assert_equal false, User.find_by(email: @user.email).is_admin?
  end

  test "grant portfolio rake task" do
    dump_database
    @user = User.new(email: 'test@test.com', first: 'first', last: 'last', password: 'Test1234!')
    @user.save!
    assert_equal 1, User.count

    ENV['EMAIL'] = @user.email
    Rake::Task['bonnie:users:grant_portfolio'].execute
    assert User.find_by(email: @user.email).is_portfolio?
  end

  test "revoke portfolio rake task" do
    dump_database
    @user = User.new(email: 'test@test.com', first: 'first', last: 'last', password: 'Test1234!')
    @user.save!
    assert_equal 1, User.count

    ENV['EMAIL'] = @user.email
    Rake::Task['bonnie:users:grant_portfolio'].execute
    assert User.find_by(email: @user.email).is_portfolio?

    Rake::Task['bonnie:users:revoke_portfolio'].execute
    assert_equal false, User.find_by(email: @user.email).is_portfolio?
  end

  test "grant dashboard rake task" do
    dump_database
    @user = User.new(email: 'test@test.com', first: 'first', last: 'last', password: 'Test1234!')
    @user.save!
    assert_equal 1, User.count
    
    ENV['EMAIL'] = @user.email
    Rake::Task['bonnie:users:grant_dashboard'].execute
    assert User.find_by(email: @user.email).is_dashboard?
  end

  test "revoke dashboard rake task" do
    dump_database
    @user = User.new(email: 'test@test.com', first: 'first', last: 'last', password: 'Test1234!')
    @user.save!
    assert_equal 1, User.count
    
    ENV['EMAIL'] = @user.email
    Rake::Task['bonnie:users:grant_dashboard'].execute
    assert User.find_by(email: @user.email).is_dashboard?

    Rake::Task['bonnie:users:revoke_dashboard'].execute
    assert_equal false, User.find_by(email: @user.email).is_dashboard?
  end

  test "grant dashboard set rake task" do
    dump_database
    @user = User.new(email: 'test@test.com', first: 'first', last: 'last', password: 'Test1234!')
    @user.save!
    assert_equal 1, User.count
    
    ENV['EMAIL'] = @user.email
    Rake::Task['bonnie:users:grant_dashboard_set'].execute
    assert User.find_by(email: @user.email).is_dashboard_set?   
  end

  test "revoke dashboard set rake task" do
    dump_database
    @user = User.new(email: 'test@test.com', first: 'first', last: 'last', password: 'Test1234!')
    @user.save!
    assert_equal 1, User.count
    
    ENV['EMAIL'] = @user.email
    Rake::Task['bonnie:users:grant_dashboard_set'].execute
    assert User.find_by(email: @user.email).is_dashboard_set?
    
    Rake::Task['bonnie:users:revoke_dashboard_set'].execute
    assert_equal false, User.find_by(email: @user.email).is_dashboard_set?
  end

end
