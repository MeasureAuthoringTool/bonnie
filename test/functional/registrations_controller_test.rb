require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase

  include Devise::Test::ControllerHelpers

  setup do
    request.env["devise.mapping"] = Devise.mappings[:user]

    dump_database
    users_set = File.join("users", "base_set")
    collection_fixtures(users_set)
    @user = User.by_email('bonnie@example.com').first
    @user.init_personal_group
    @user.save
    @user.grant_portfolio
  end

  test "after_inactive_sign_up_path_for" do

    # password is not required
    post :create, params: {utf8:"✓", authenticity_token: "0n4OMnJb0zHfByZcHZdWBpQpxqW0YolmC/2Iig35tIk=",
      user: {first_name: "Foo", last_name: "Bar", email: "foobar@mitre.org", telephone: "555-555-5555",
             harp_id:'foo.bar'},
        agree_license: "1", commit: "Register"}
    assert_response :redirect

    assert_equal "You have signed up successfully. However, we could not sign "+
    "you in because your account is not yet approved.  You will receive an email"+
    " once your account has been approved.", flash[:notice]
  end

  test 'harp_id is required for registration' do
    post :create, params: {utf8:"✓", authenticity_token: "0n4OMnJb0zHfByZcHZdWBpQpxqW0YolmC/2Iig35tIk=",
       user: {first_name: "Foo", last_name: "Bar", email: "foobar@mitre.org", telephone: "555-555-5555"},
      agree_license: "1", commit: "Register"}
    assert_response :success
    assert_match "1 error prohibited this user from being saved", response.body
    assert_match "HARP ID is required", response.body
  end

  test "destroy with valid password" do
    # TODO: password is not required any more
    sign_in @user
    delete :destroy, params: { user: {current_password: 'Test1234!'}}
    assert_response :redirect
    deluser = User.by_email(@user.email).first
    assert_nil(deluser)
  end

  test "destroy with invalid password" do
    skip("Not implmented yet")
    sign_in @user
    # Supply incorrect passwordin call to delete account
    delete :destroy, params: {user:{users_email: @user.email} , current_password: "wrongpass" }
    assert_response :redirect
    deluser = User.by_email(@user.email).first
    assert_equal(@user,deluser)
    assert_equal "Incorrect password supplied, account not deleted", flash[:error]
  end

end
