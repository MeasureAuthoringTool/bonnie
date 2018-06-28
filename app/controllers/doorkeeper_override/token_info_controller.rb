module DoorkeeperOverride
  class TokenInfoController < Doorkeeper::ApplicationMetalController
    def show
      if doorkeeper_token&.accessible?
        user = User.find(doorkeeper_token.resource_owner_id)
        if !user.nil?
          token_info = {
            user_email: user.email,
            user_first_name: user.first_name,
            user_last_name: user.last_name,
            scopes: doorkeeper_token.scopes,
            expires_in_seconds: doorkeeper_token.expires_in_seconds,
            created_at: doorkeeper_token.created_at.to_i
          }
          render json: token_info, status: :ok
        else # If the user does not exist, then return with unauthorized error response
          error = Doorkeeper::OAuth::ErrorResponse.new(name: :unauthorized)
          response.headers.merge!(error.headers)
          render json: error.body, status: error.status
        end
      else
        error = Doorkeeper::OAuth::ErrorResponse.new(name: :invalid_request)
        response.headers.merge!(error.headers)
        render json: error.body, status: error.status
      end
    end
  end
end
