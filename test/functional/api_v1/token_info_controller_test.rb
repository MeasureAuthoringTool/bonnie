require 'test_helper'

module DoorkeeperOverride
  class TokenInfoControllerTest < ActionController::TestCase
    include Devise::Test::ControllerHelpers

    setup do
      dump_database
      users_set = File.join("users", "base_set")
      collection_fixtures(users_set)
      @user = User.by_email('bonnie@example.com').first
      @token = Doorkeeper::AccessToken.new
      @token.resource_owner_id = @user.id
      @token.scopes = 'foo'
      @token.expires_in = 600
      @token.created_at = Time.now.utc
      @token.original_token_created_at = Time.now.utc - 20.seconds
      @controller.instance_variable_set(:@token, @token)
    end

    test "successfully shows token" do
      get :show
      assert_response :ok
      body = JSON.parse(@response.body)
      assert_equal @user.email, body['user_email']
      assert_equal "bonnie", body['user_first_name']
      assert_equal "bonnie", body['user_last_name']
      assert_equal @token.scopes, body['scopes']
      assert_equal @token.expires_in, body['expires_in_seconds']
      assert_equal @token.created_at.to_i, body['created_at']
      assert_equal Doorkeeper.configuration.refresh_token_expires_in.to_i - 21, body['refresh_expires_in_seconds']
    end

    test "successfully shows token with expired refresh token" do
      @token.original_token_created_at = Time.now.utc - Doorkeeper.configuration.refresh_token_expires_in - 10.seconds
      get :show
      assert_response :ok
      body = JSON.parse(@response.body)
      assert_equal @user.email, body['user_email']
      assert_equal "bonnie", body['user_first_name']
      assert_equal "bonnie", body['user_last_name']
      assert_equal @token.scopes, body['scopes']
      assert_equal @token.expires_in, body['expires_in_seconds']
      assert_equal @token.created_at.to_i, body['created_at']
      assert_equal 0, body['refresh_expires_in_seconds']
    end

    test "successfully shows token with no original_token_create_at time" do
      @token.original_token_created_at = nil
      get :show
      assert_response :ok
      body = JSON.parse(@response.body)
      assert_equal @user.email, body['user_email']
      assert_equal "bonnie", body['user_first_name']
      assert_equal "bonnie", body['user_last_name']
      assert_equal @token.scopes, body['scopes']
      assert_equal @token.expires_in, body['expires_in_seconds']
      assert_equal @token.created_at.to_i, body['created_at']
      assert_equal Doorkeeper.configuration.refresh_token_expires_in.to_i - 1, body['refresh_expires_in_seconds']
    end

    test "successfully shows token when refresh_token expiration is not enabled" do
      # stash the expiration setting and then change it to nil
      original_refresh_token_expires_in = Doorkeeper.configuration.refresh_token_expires_in
      Doorkeeper.instance_variable_get(:@config).instance_variable_set(:@refresh_token_expires_in, nil)

      get :show
      assert_response :ok
      body = JSON.parse(@response.body)
      assert_equal @user.email, body['user_email']
      assert_equal "bonnie", body['user_first_name']
      assert_equal "bonnie", body['user_last_name']
      assert_equal @token.scopes, body['scopes']
      assert_equal @token.expires_in, body['expires_in_seconds']
      assert_equal @token.created_at.to_i, body['created_at']
      assert_equal false, body.key?('refresh_expires_in_seconds')

      # reset the expiration setting back to what it was before
      Doorkeeper.instance_variable_get(:@config).instance_variable_set(:@refresh_token_expires_in, original_refresh_token_expires_in)
    end

    test "shows unauthorized when token inaccessible" do
      @token.revoked_at = Time.now.utc - 1.minutes
      get :show
      assert_response :unauthorized
    end

    test "shows unauthorized when user cannot be found" do
      # delete the user before running the request
      User.by_email('bonnie@example.com').first.delete
      get :show
      assert_response :unauthorized
    end
  end
end
