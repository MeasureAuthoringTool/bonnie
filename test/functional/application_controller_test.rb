require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    dump_database
    users_set = File.join("users","base_set")
    collection_fixtures(users_set)
  end

  # after_inactive_sign_up_path_for is hit in the RegistrationsControllerTest test 'destroy with valid passoword'
  # This test asserts that a redirect occurs after the forced sign out of the user upon deletion

  test "page not found" do
    get :page_not_found
    assert_equal 404, response.status
  end

  test "server error" do
    get :server_error
    assert_equal 500, response.status
  end

end
