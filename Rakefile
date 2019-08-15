#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
require 'simplecov'

# see https://gist.github.com/afeld/5704079
namespace :assets do
  desc "Modified to make sprockets handle Bower files"
  # Add extensions to all Bower-installed files that don't have them.
  # See https://github.com/sstephenson/sprockets/issues/347
  task :precompile do
    Dir['vendor/assets/components/**/*'].each do |filename|
      if File.file?(filename) && File.extname(filename) == ''
        File.rename(filename, "#{filename}.txt")
      end
    end
  end
end

require File.expand_path('config/application', __dir__)

Bonnie::Application.load_tasks

# Rake::TestTask.new(:test_unit) do |t|
#   t.libs << "test"
#   t.test_files = FileList['test/**/*_test.rb']
#   t.verbose = true
#   t.ruby_opts = ['-W1']
# end

# Rake::Task[:test].clear # rake has a default test task, if we do not clear it the following lines will append to it and the tests get run twice
# task :test => [:test_unit] do
#   system("open coverage/index.html")
# end
