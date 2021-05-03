require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    dump_database
    assert_equal 0, User.count
    @user = User.new(email: "test@test.com", first: "first" , last: 'last',password: 'Test1234!')
    @user.save!
  end

  test "grant and revoke admin" do
    assert_equal false, @user.is_admin?
    assert_equal false, @user.is_approved?
    @user.grant_admin
    @user.reload
    assert_equal true, @user.is_admin?
    assert_equal true, @user.is_approved?
    @user.revoke_admin
    @user.reload
    assert_equal false, @user.is_admin?
    assert_equal true, @user.is_approved?
  end

  test "grant and revoke portfolio" do
    assert_equal false, @user.is_portfolio?
    assert_equal false, @user.is_approved?
    @user.grant_portfolio
    @user.reload
    assert_equal true, @user.is_portfolio?
    assert_equal true, @user.is_approved?
    @user.revoke_portfolio
    @user.reload
    assert_equal false, @user.is_portfolio?
    assert_equal true, @user.is_approved?
  end

  test "grant and revoke dashboard" do
    assert_equal false, @user.is_dashboard?
    assert_equal false, @user.is_approved?
    @user.grant_dashboard
    @user.reload
    assert_equal true, @user.is_dashboard?
    assert_equal true, @user.is_approved?
    @user.revoke_dashboard
    @user.reload
    assert_equal false, @user.is_dashboard?
    assert_equal true, @user.is_approved?
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
    assert_equal true, @user.is_approved?
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

  test "create user with harp_id" do
    @jane = User.new(email: 'jane@harp.com', first: 'Jane', last: 'doe', password: 'Test1234!', harp_id: 'jane.doe')
    @jane.save!
    assert_equal @jane.harp_id, 'jane.doe'

    # create user with duplicate harp_id
    dup_harp_id_error = assert_raises(Mongoid::Errors::Validations) do
      @john = User.new(email: 'john@harp.com', first: 'John', last: 'Doe', password: 'Test1234!', harp_id: 'jane.doe')
      @john.save!
    end
    assert_equal true, (dup_harp_id_error.message.match /Harp id is already taken/).nil?
  end

end
