require File.expand_path('../../../../config/environment',  __FILE__)

namespace :bonnie do
  namespace :load do

    desc "Load a white/black list to override default value sets"
    task :white_black_list, [:white_list_path, :black_list_path, :clear_existing] => :environment do |task, args|
      raise "You must specify a valid path to the white list file" unless args.white_list_path
      white_list_path = args.white_list_path
      black_list_path = args.black_list_path

      puts "Loading white and black lists"
      
      if (args.clear_existing != 'false')
        Measures::ValueSetLoader.clear_white_black_list
      end

      Measures::ValueSetLoader.load_white_list(white_list_path)

      if black_list_path
        Measures::ValueSetLoader.load_black_list(black_list_path)
      end
      
    end
  end
end
