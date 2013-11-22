class UsersController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  def index
    @users = [current_user]
    if current_user.is_admin?
      @users = User.all.asc(:email)
    end
    respond_to do |format|
        format.json  {render :json => @users.to_json }
      end
  end

end
