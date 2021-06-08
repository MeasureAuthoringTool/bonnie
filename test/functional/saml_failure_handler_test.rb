require 'test_helper'

class SamlFailureHandlerTest < ActionController::TestCase

  include Devise::Test::ControllerHelpers
  include Devise::Test::IntegrationHelpers
  include Warden::Test::Helpers

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

  test "link user approved" do
    @user.deactivate
    @user.approved = true
    @user.save
    flash = Hash.new
    handler = SamlFailureHandler.new
    redirected = handler.link_user('bonnie@example.com', 'bonnie_harp_id', flash)
    @user = User.by_email('bonnie@example.com').first
    assert_match('/users/saml/sign_in', redirected)
    assert_equal('HARP Account Linked', flash[:msg][:title])
    assert_equal('HARP Account Linked', flash[:msg][:summary])
    expected_msg = 'Your HARP Account with bonnie_harp_id and Bonnie account with bonnie@example.com have been automatically linked. '\
    'If you need further assistance please reach out to the Bonnie Help Desk.'
    assert_equal(expected_msg, flash[:msg][:body])
    assert_equal(true, @user.approved)
    assert_equal('bonnie_harp_id', @user.harp_id)
  end

  test "link user not approved" do
    @user.deactivate
    @user.approved = false
    @user.save
    flash = Hash.new
    handler = SamlFailureHandler.new
    redirected = handler.link_user('bonnie@example.com', 'bonnie_harp_id', flash)
    @user = User.by_email('bonnie@example.com').first
    assert_match('/user/registered_not_active', redirected)
    assert_empty(flash)
    assert_equal(false, @user.approved)
    assert_nil(@user.harp_id)
  end

  test "link user not found" do
    flash = Hash.new
    handler = SamlFailureHandler.new
    redirected = handler.link_user('unknonwn_user@example.com', 'unknonwn_user', flash)
    @user = User.by_email('bonnie@example.com').first
    assert_match('/saml_error', redirected)
    assert_empty(flash)
  end
end
