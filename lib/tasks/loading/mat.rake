require File.expand_path('../../../../config/environment',  __FILE__)
require 'pathname'
require 'fileutils'

namespace :bonnie do
  namespace :load do
  
  
    desc 'Load MAT export zip file'
    task :mat_export, [:file, :username] do |t, args|
      raise "The file to measure definition must be specified" unless args.file
      raise "The username to load the measures for must be specified" unless args.username

      user = User.by_username args.username
      raise "The user #{args.username} could not be found." unless user
      
      file = File.new args.file
      data = Measures::MATLoader.load(file, user, {})
    end

    desc 'Load a directory of MAT export zip files'
    task :mat_exports, [:dir, :username] do |t, args|
      raise "The directory to measure definitions" unless args.dir
      raise "The username to load the measures for must be specified" unless args.username

      user = User.by_username args.username
      raise "The user #{args.username} could not be found." unless user

      Dir.glob(File.join(args.dir,'*.zip')).each do |zip_path|
        begin
          file = File.new zip_path
          data = Measures::MATLoader.load(file, user, {})
        rescue Exception => e
          puts "Loading Measure #{zip_path} failed: #{e.message}] \n"
        end
      end
      
    end
  end
end