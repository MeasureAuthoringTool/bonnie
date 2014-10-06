# Load the rails application
require File.expand_path('../application', __FILE__)

# Load config here, not in bonnie initializer, so config is available during initialization
APP_CONFIG = YAML.load_file(Rails.root.join('config', 'bonnie.yml'))[Rails.env]

# Also load in a server specific config file, if present, for things like mail server config
APP_CONFIG.merge! YAML.load_file(Rails.root.join('config', 'server.yml')) if File.exists? Rails.root.join('config', 'server.yml')

# Determine our hostname if not specified in config file
APP_CONFIG['hostname'] ||= `hostname`.chomp

# Initialize the rails application
Bonnie::Application.initialize!
