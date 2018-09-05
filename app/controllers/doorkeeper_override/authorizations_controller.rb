module DoorkeeperOverride
  class AuthorizationsController < Doorkeeper::AuthorizationsController

    # Overriding default functionality to always require the user to be asked if they approve
    # of the application.
    def new
      if pre_auth.authorizable?
        render :new
      else
        render :error
      end
    end

    # Additional functional to support change user button. This logs the user out, stores the page the url
    # for authorization for later return, and sends the user to the sign in page.
    def change_user
      sign_out
      flash[:notice] = "Signed out. Login to continue authorization."
      store_location_for(:user, request.referrer)
      redirect_to(new_user_session_path)
    end
  end
end