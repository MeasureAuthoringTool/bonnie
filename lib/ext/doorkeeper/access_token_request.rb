module Doorkeeper
  module OAuth
    class RefreshTokenRequest
      ###
      # Replaces code in https://github.com/doorkeeper-gem/doorkeeper/blob/v4.4.0/lib/doorkeeper/oauth/refresh_token_request.rb
      # to support expiration of refresh tokens.
      ###
      def before_successful_response
        refresh_token.transaction do
          refresh_token.lock!
          raise Errors::InvalidTokenReuse if refresh_token.revoked?

          # only check for refresh token expiration if it does expire
          if refresh_token.refresh_token_expiration_time
            # don't allow use of the refresh token if it has already expired
            raise Errors::InvalidTokenReuse if refresh_token.refresh_token_expiration_time < Time.now
          end

          refresh_token.revoke unless refresh_token_revoked_on_use?

          token = create_access_token

          # copy original_token_created_at time to the new token
          token.original_token_created_at = refresh_token.original_token_created_at unless refresh_token.original_token_created_at.nil?
          token.save!

          token
        end
        super
      end
    end
  end
end
