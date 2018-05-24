class DoorkeeperOverride::TokenInfoController < Doorkeeper::ApplicationMetalController
  def show
    if doorkeeper_token && doorkeeper_token.accessible?
      user = User.find(doorkeeper_token.resource_owner_id)
      token_info = {
        user_email: user.email,
        user_name: "#{user.first_name} #{user.last_name}",
        scopes: doorkeeper_token.scopes,
        expires_in_seconds: doorkeeper_token.expires_in_seconds,
        created_at: doorkeeper_token.created_at.to_i
      }
      render json: token_info, status: :ok
    else
      error = OAuth::ErrorResponse.new(name: :invalid_request)
      response.headers.merge!(error.headers)
      render json: error.body, status: error.status
    end
  end
end
