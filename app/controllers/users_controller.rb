class UsersController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  def index
    if current_user.is_admin?
      @users = User.all.asc(:email)
      respond_to do |format|
        format.json  {render :json => @users.to_json }
      end
    end
  end

end
