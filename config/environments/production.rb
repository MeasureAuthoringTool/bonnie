Bonnie::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true
  config.eager_load = true
  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Compress JavaScripts and CSS
  require 'ext/selective_assets_compressor'
  config.assets.js_compressor = SelectiveAssetsCompressor.new(harmony: true, mangle: { keep_fnames: true }, compress: { unused: false })

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Load npm modules into the asset path
  config.assets.paths << Rails.root.join('node_modules')

  Rails.application.routes.default_url_options[:host] = APP_CONFIG['hostname']

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Set log level to info
  config.log_level = :info

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w(font-awesome/fonts/fontawesome-webfont.*)

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

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
