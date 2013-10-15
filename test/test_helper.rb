ENV["RAILS_ENV"] = "test"
require_relative "./simplecov"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require './lib/ext/record'

require 'turn'

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
end
