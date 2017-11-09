class UsersController < ApplicationController

  protect_from_forgery
  before_filter :authenticate_user!

  respond_to :json

end
