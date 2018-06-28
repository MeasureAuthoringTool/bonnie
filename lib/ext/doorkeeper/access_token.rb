module Doorkeeper
  class AccessToken
    include Mongoid::Document

    # add original token creation time so we can determine if a refresh_token use should be allowed
    field :original_token_created_at, type: Time

    before_save :add_original_token_created_at_if_nil

    # sets the original_token_created_at to same as created_at if it isnt define. This gets us the time
    # of the original authorization to know how long we will allow refresh_token usage.
    def add_original_token_created_at_if_nil
      self.original_token_created_at = self.created_at if self.original_token_created_at.nil?
    end
  end
end