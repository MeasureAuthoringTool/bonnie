require 'test_helper'

module DoorkeeperOverride
  class TokenInfoControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    # StubToken simulates an OAuth2 token... we're not actually
    # verifying that a token was issued. This test completely
    # bypasses OAuth2 authentication and authorization provided
    # by Doorkeeper.
    class StubToken
      attr_accessor :resource_owner_id, :scopes, :expires_in_seconds, :created_at, :is_accessible
      def accessible?
        is_accessible
      end
    end

    setup do
      dump_database
      users_set = File.join("users", "base_set")
      collection_fixtures(users_set)
      @user = User.by_email('bonnie@example.com').first
      @token = StubToken.new
      @token.resource_owner_id = @user.id
      @token.scopes = 'foo'
      @token.expires_in_seconds = 100
      @token.created_at = Time.now
      @token.is_accessible = true
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
      assert_equal @token.expires_in_seconds, body['expires_in_seconds']
      assert_equal @token.created_at.to_i, body['created_at']
    end

    test "shows unauthorized when token inaccessible" do
      @token.is_accessible = false
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
