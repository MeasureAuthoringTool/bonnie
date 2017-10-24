class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :authenticate_user!, except: [:page_not_found, :server_error]
  before_filter :log_additional_data
  layout :layout_by_resource

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  def after_sign_out_path_for(resource)
    "#{(respond_to?(:root_path) ? root_path : "/")}users/sign_in"
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
    error_message = ErrorHelper.describe_error(params, Exception.new(params), request)
    respond_to do |format|
      format.json { render json: error_message }
    end
  end

  protected
    def log_additional_data
      request.env["exception_notifier.exception_data"] = {
        :current_user => current_user
      }
    end
end
