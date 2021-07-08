class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, except: [:page_not_found, :server_error]
  before_action :log_additional_data
  layout :layout_by_resource

  after_action :allow_no_iframe

  def allow_no_iframe
    response.headers['X-Frame-Options'] = 'DENY'
  end

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  # hook to make sure user logins to private group always
  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      resource.current_group = resource.find_personal_group
      resource.save
      # preserve flash messages on redirection
      # used for harp account linking
      flash.keep
    end
    super
  end

  def after_sign_out_path_for(resource)
    "#{(respond_to?(:root_path) ? root_path : "/")}users/saml/sign_in"
  end

  def page_not_found
    respond_to do |format|
      format.html { render template: 'errors/404', layout: 'layouts/errors', status: 404 }
      format.all  { render text: '404 Not Found', status: 404 }
    end
  end

  def server_error
    respond_to do |format|
      format.html { render template: 'errors/500', layout: 'layouts/errors', status: 500 }
      format.all  { render text: '500 Server Error', status: 500 }
    end
  end

  def client_error
    # Grab better description of the given message and return as json
    error_message = ErrorHelper.describe_error(params.permit!.to_h, Exception.new(params), request)
    respond_to do |format|
      format.json { render json: error_message }
    end
  end

  protected

  def log_additional_data
    request.env["exception_notifier.exception_data"] = {
      #:current_user => current_user
    }
  end

  def get_count_by_id(group_objects, id)
    count_obj = group_objects.detect { |group_object| group_object['_id'] == id.to_s }
    count_obj ? count_obj['count'] : 0
  end
end
