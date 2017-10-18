require File.expand_path('../../../../config/environment',  __FILE__)
require 'pathname'
require 'fileutils'

namespace :bonnie do
  namespace :load do


    desc 'Load MAT export zip file'
    task :mat_export, [:file, :email] do |t, args|
      raise "The file to measure definition must be specified" unless args.file
      raise "The user email to load the measures for must be specified" unless args.email

      user = User.by_email(args.email).first
      raise "The user #{args.email} could not be found." unless user

      file = File.new args.file
      data = Measures::CqlLoader.load(file, user, {})
    end

    desc 'Load a directory of MAT export zip files'
    task :mat_exports, [:dir, :email] do |t, args|
      raise "The directory to measure definitions" unless args.dir
      raise "The user email to load the measures for must be specified" unless args.email

      user = User.by_email(args.email).first
      raise "The user #{args.email} could not be found." unless user

      Dir.glob(File.join(args.dir,'*.zip')).each do |zip_path|
        begin
          file = File.new zip_path
          data = Measures::CqlLoader.load(file, user, {})
        rescue Exception => e
          puts "Loading Measure #{zip_path} failed: #{e.message}] \n"
        end
      end

    end
  end
end
