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

  def destroy
    if current_user.valid_password? params[:user][:current_password]
      super
    else
      flash[:error] = "Incorrect password supplied, account not deleted"
      redirect_to edit_user_registration_url
    end
  end

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update).push(:crosswalk_enabled, :first_name, :last_name, :telephone)
    devise_parameter_sanitizer.for(:sign_up).push(:first_name, :last_name, :telephone)
  end

end
