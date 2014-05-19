class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :log_additional_data
  layout :layout_by_resource

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  protected
    def log_additional_data
      request.env["exception_notifier.exception_data"] = {
        :current_user => current_user
      }
    end
end
