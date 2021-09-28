ENV["RAILS_ENV"] = "test"
ENV['CALCULATION_SERVICE_URL'] = 'http://localhost:8081/calculate'
ENV.delete("SAML_IDP_METADATA")
require_relative "./simplecov_init"
require_relative "./vcr_setup"
require_relative '../lib/tasks/fixture_helper'
ENV["APIPIE_RECORD"] = "examples"
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'rake'
require "minitest/mock"
WebMock.enable!

# load_tasks needs to be called exactly one time, so it's in the header area
# of this file. Additionally, because tests get run twice for some reason, we
# need to put an extra check around it to ensure the tasks aren't already loaded.
if Rake::Task.tasks.count == 0
  Bonnie::Application.load_tasks
end

# StubToken simulates an OAuth2 token... we're not actually
# verifying that a token was issued. This test completely
# bypasses OAuth2 authentication and authorization provided
# by Doorkeeper.
class StubToken
  attr_accessor :resource_owner_id

  def acceptable?(_value)
    true
  end
end

class ActiveSupport::TestCase

  def dump_database
    Mongoid.default_client.collections.each do |c|
      c.drop()
    end
  end
end
