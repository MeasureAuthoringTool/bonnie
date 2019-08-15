class UsersController < ApplicationController

  protect_from_forgery
  before_action :authenticate_user!

  respond_to :json

end
