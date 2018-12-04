require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    dump_database
    users_set = File.join("users", "base_set")
    collection_fixtures(users_set)
    @user = User.by_email('bonnie@example.com').first
    @user_unapproved = User.by_email('user_unapproved@example.com').first
  end

  test "index" do
    sign_in @user
    get :index
    assert_response :success
  end

  test "index fails unapproved" do
    sign_in @user_unapproved
    get :index
    assert_response :redirect
    assert_equal "Your account is not activated yet.  You will receive an email when your account has been activated.", flash[:alert]
  end

  test "show" do
    sign_in @user
    get :show
    assert_response :success
  end

  test "show fails unapproved" do
    sign_in @user_unapproved
    get :index
    assert_response :redirect
    assert_equal "Your account is not activated yet.  You will receive an email when your account has been activated.", flash[:alert]
  end

end
