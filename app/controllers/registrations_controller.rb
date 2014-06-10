class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  # updated from original to look for changes to user crosswalk setting
  def update_resource(resource, params)
    original_crosswalk_setting = resource.crosswalk_enabled
    saved = super(resource, params)
    if saved && resource.is_portfolio? && (resource.crosswalk_enabled != original_crosswalk_setting)
      Measure.by_user(current_user).each { |m| m.clear_cached_js }
    end
    return saved
  end

  def after_inactive_sign_up_path_for(resource)
    set_flash_message :notice, :signed_up_but_inactive
    "#{(respond_to?(:root_path) ? root_path : "/")}users/sign_in"
  end

  # Store the original destroy so we can use it later
  alias :destroy_user_account :destroy

  def destroy
    # Override the superclass destroy method to prevent the user from instantly
    # deleting their account just by visiting this page.
    # TODO (maybe): Require the user to enter their password to delete their
    # account?
    if params[:reset_token] == 'true' or (session.has_key?(:account_delete_token_expires) and session[:account_delete_token_expires] < Time.now)
      # Reset or expire the token
      session.delete(:account_delete_token)
      session.delete(:account_delete_token_expires)
    end
    if session.has_key?(:account_delete_token)
      if params[:delete_token] == session[:account_delete_token]
        # Invoke the parent method
        destroy_user_account
      else
        @delete_denied = true
      end
    else
      # If we have no token, add it to the session
      session[:account_delete_token] = SecureRandom.urlsafe_base64(nil, false)
      # And add a max time
      session[:account_delete_token_expires] = Time.now + (60 * 60)
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << :crosswalk_enabled
  end

end
