require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    request.env["devise.mapping"] = Devise.mappings[:user]

    dump_database
    records_set = File.join("records", "base_set")
    users_set = File.join("users", "base_set")
    measures_set = File.join("draft_measures", "base_set")
    collection_fixtures(users_set, records_set, measures_set)
    @user = User.by_email('bonnie@example.com').first
    @user.grant_portfolio

    associate_user_with_measures(@user, Measure.all)
    associate_user_with_patients(@user, Record.all)

    @user.measures.first.value_set_oids.uniq.each do |oid|
      vs = HealthDataStandards::SVS::ValueSet.new(oid: oid)
      vs.concepts << HealthDataStandards::SVS::Concept.new(code_set: 'foo', code:'bar')
      vs.user = @user
      vs.save!
    end
  end

  test "yield resource to block on update success" do
    sign_in @user
    assert_equal false, @user.crosswalk_enabled
    Measure.by_user(@user).each do |measure|
      assert !measure.map_fns.compact.empty?
    end
    put :update, { user: { current_password: 'Test1234!', crosswalk_enabled: true } }
    @user.reload
    assert_equal true, @user.crosswalk_enabled
    Measure.by_user(@user).each do |measure|
      assert measure.map_fns.compact.empty?
    end
  end

  test "after_inactive_sign_up_path_for" do

    post :create, {utf8:"✓", authenticity_token: "0n4OMnJb0zHfByZcHZdWBpQpxqW0YolmC/2Iig35tIk=",
      user: {first_name: "Foo", last_name: "Bar", email: "foobar@mitre.org", telephone: "555-555-5555",
        password: "[FILTERED]", password_confirmation: "[FILTERED]"}, agree_license: "1", commit: "Register"}
    assert_response :redirect

    assert_equal "You have signed up successfully. However, we could not sign "+
    "you in because your account is not yet approved.  You will receive an email"+
    " once your account has been approved.", flash[:notice]
  end

  test "destroy with valid password" do
    sign_in @user
    delete :destroy, { user: {current_password: 'Test1234!'}}
    assert_response :redirect
    deluser = User.by_email(@user.email).first
    assert_nil(deluser)
  end

  test "destroy with invalid password" do
    sign_in @user
    # Supply incorrect passwordin call to delete account
    delete :destroy, {user:{users_email: @user.email} , current_password: "wrongpass" }
    assert_response :redirect
    deluser = User.by_email(@user.email).first
    assert_equal(@user,deluser)
    assert_equal "Incorrect password supplied, account not deleted", flash[:error]
  end

end
