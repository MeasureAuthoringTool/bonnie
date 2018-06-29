module Doorkeeper
  class AccessToken
    include Mongoid::Document

    # add original token creation time so we can determine if a refresh_token use should be allowed
    field :original_token_created_at, type: Time

    before_save :add_original_token_created_at_if_nil

    # sets the original_token_created_at to same as created_at if it isnt define. This gets us the time
    # of the original authorization to know how long we will allow refresh_token usage.
    def add_original_token_created_at_if_nil
      self.original_token_created_at = created_at if original_token_created_at.nil?
    end

    ###
    # Returns the time the refresh token should expire. This is based on the original_token_created_at time and the
    # injected configuration refresh_token_expires_in. If refresh token expiration is disabled this will return nil.
    ###
    def refresh_token_expiration_time
      return unless Doorkeeper.configuration.refresh_token_expires_in
      # if the original_token_created_at time exists determine expiration time from that, otherwise use created_at time.
      if original_token_created_at
        original_token_created_at + Doorkeeper.configuration.refresh_token_expires_in
      else
        created_at + Doorkeeper.configuration.refresh_token_expires_in
      end
    end
  end
end
