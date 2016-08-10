require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    dump_database
    assert_equal 0, User.count
    assert_equal 0, HealthDataStandards::CQM::Bundle.count
    @user = User.new(email: "test@test.com", first: "first" , last: 'last',password: 'Test1234!') 
    @user.save!
  end


  test "Creating user creates bundle" do
    assert_equal 1, User.count
    assert_equal 1, HealthDataStandards::CQM::Bundle.count
    assert_equal User.first.bundle , HealthDataStandards::CQM::Bundle.first
  end

  test "grant and revoke admin" do
    assert_equal false, @user.is_admin?
    @user.grant_admin
    @user.reload
    assert_equal true, @user.is_admin?
    @user.revoke_admin
    @user.reload
    assert_equal false, @user.is_admin?
  end

  test "grant and revoke portfolio" do
    assert_equal false, @user.is_portfolio?
    @user.grant_portfolio
    @user.reload
    assert_equal true, @user.is_portfolio?
    @user.revoke_portfolio
    @user.reload
    assert_equal false, @user.is_portfolio?
  end

  test "grant and revoke dashboard" do
    assert_equal false, @user.is_dashboard?
    @user.grant_dashboard
    @user.reload
    assert_equal true, @user.is_dashboard?
    @user.revoke_dashboard
    @user.reload
    assert_equal false, @user.is_dashboard?
  end

  test "grant and revoke dashboard_set" do
    assert_equal false, @user.is_dashboard_set?
    assert_equal false, @user.is_approved?
    @user.grant_dashboard_set
    @user.reload
    assert_equal true, @user.is_dashboard_set?
    assert_equal true, @user.is_approved?
    @user.revoke_dashboard_set
    @user.reload
    assert_equal false, @user.is_dashboard_set?
    assert_equal true, @user.is_approved? # revoke_dashboard_set doesn't remove approved status
  end

  test "test bad password fails" do

    bad_user = assert_raises(Mongoid::Errors::Validations) do
      u = User.new(email: "test@test.com", first: "first" , last: 'last',password: 'Test1234!')
      u.save!
    end
    assert_equal false, (bad_user.message.match /Email is already taken/).nil?

    bad_user = assert_raises(Mongoid::Errors::Validations) do
      u = User.new(email: "test2@test.com", first: "first" , last: 'last',password: 'test')
      u.save!
    end
    assert_equal false, (bad_user.message.match /Password is too short/).nil?
    assert_equal false, (bad_user.message.match /assword must include characters from at least two groups/).nil?

  end


end
