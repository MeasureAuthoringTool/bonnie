Bonnie::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  config.eager_load = false
  

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  Rails.application.routes.default_url_options[:host] = 'localhost:3000'

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin


  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # Add spec/javascripts to asset paths so that jasmine tests work
  config.assets.paths << Rails.root.join('spec/javascripts')

  # Load npm modules into the asset path
  config.assets.paths << Rails.root.join('node_modules')

  # Configure to send email
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.smtp_settings = {
    address:              APP_CONFIG['smtp_hostname'],
    port:                 APP_CONFIG['smtp_port'],
    user_name:            APP_CONFIG['smtp_username'],
    password:             APP_CONFIG['smtp_password'],
    authentication:       'plain',
    enable_starttls_auto: APP_CONFIG['smtp_tls'],
    tls:                  APP_CONFIG['smtp_tls']
  }

  # Send notification when application exceptions happen
  config.middleware.use ExceptionNotification::Rack, email: {
    email_prefix: "[Bonnie] ",
    sender_address: %{"Bonnie (#{APP_CONFIG['hostname']})" <bonnie@#{APP_CONFIG['hostname']}>},
    exception_recipients: APP_CONFIG['bonnie_error_email'],
    sections: %w{request session user_info environment backtrace}
  }, error_grouping: true

end
