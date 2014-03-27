# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Bonnie::Application.initialize!

# Determine our hostname; first look for it specified in a config file, else query OS
HOSTNAME = (File.read(Rails.root.join('config', 'hostname')).chomp rescue nil) || `hostname`.chomp
