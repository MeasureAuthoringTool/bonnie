ENV['RAILS_ENV'] = 'test'
require_relative './simplecov_init'
require_relative '../lib/tasks/fixture_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require './lib/ext/record'
require 'rake'
WebMock.enable!

# load_tasks needs to be called exactly one time, so it's in the header area
# of this file. Additionally, because tests get run twice for some reason, we
# need to put an extra check around it to ensure the tasks aren't already loaded.
if Rake::Task.tasks.count == 0
  Bonnie::Application.load_tasks
end

class ActiveSupport::TestCase
  
  def dump_database
    Mongoid.default_client.collections.each do |c|
      c.drop()
    end
  end

end
