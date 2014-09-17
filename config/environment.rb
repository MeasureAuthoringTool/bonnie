# Load the rails application
require File.expand_path('../application', __FILE__)

# Load config here, not in bonnie initializer, so config is available during initialization
APP_CONFIG = YAML.load_file(Rails.root.join('config', 'bonnie.yml'))[Rails.env]

# Determine our hostname if not specified in config file
APP_CONFIG['hostname'] ||= `hostname`.chomp

# Initialize the rails application
Bonnie::Application.initialize!
