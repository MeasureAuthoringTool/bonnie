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
          # if the refresh token will expire, add the time until it expires
          if doorkeeper_token.refresh_token_expiration_time
            # if the original_token_created_at time exists determine expiration time from that, otherwise use created_at time.
            token_info[:refresh_expires_in_seconds] = (doorkeeper_token.refresh_token_expiration_time - Time.now.utc).to_i
            # if the refresh token has already expired, show zero for the time to expiration
            token_info[:refresh_expires_in_seconds] = 0 if (token_info[:refresh_expires_in_seconds]).negative?
          end
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
