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

  def create
    build_resource(sign_up_params)
    if resource.harp_id.nil? || resource.harp_id.blank?
      resource.errors.add :base, "HARP ID is required"
      respond_with resource
    else
      super
    end
  end

  def after_inactive_sign_up_path_for(resource)
    resource.deactivate
    resource.save
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
    devise_parameter_sanitizer.permit(:account_update, keys: [:crosswalk_enabled, :first_name, :last_name, :harp_id, :telephone])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :harp_id, :telephone])
  end

end
