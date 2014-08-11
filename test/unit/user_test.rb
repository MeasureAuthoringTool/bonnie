require 'test_helper'

class UserTest < ActionController::TestCase

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
    @user.is_admin?.must_equal false
    @user.grant_admin
    @user.reload
    @user.is_admin?.must_equal true
    @user.revoke_admin
    @user.reload
    @user.is_admin?.must_equal false
  end

  test "grant and revoke portfolio" do
    @user.is_portfolio?.must_equal false
    @user.grant_portfolio
    @user.reload
    @user.is_portfolio?.must_equal true
    @user.revoke_portfolio
    @user.reload
    @user.is_portfolio?.must_equal false
  end

  test "test bad password fails" do

    bad_user = assert_raises(Mongoid::Errors::Validations) do
      u = User.new(email: "test@test.com", first: "first" , last: 'last',password: 'Test1234!')
      u.save!
    end
    (bad_user.message.match /Email is already taken/).nil?.must_equal false

    bad_user = assert_raises(Mongoid::Errors::Validations) do
      u = User.new(email: "test2@test.com", first: "first" , last: 'last',password: 'test')
      u.save!
    end
    (bad_user.message.match /Password is too short/).nil?.must_equal false
    (bad_user.message.match /assword must include characters from at least two groups/).nil?.must_equal false

  end


end
