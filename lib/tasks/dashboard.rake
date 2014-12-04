namespace :bonnie do
  namespace :dashboard do
    desc "Load measures into a dashboard dataset account, creating the account if necessary"
    task :load_measures => :environment do

      raise "Need to specify FILE" unless ENV['FILE']
      raise "Need to specify EMAIL" unless ENV['EMAIL']
      raise "Need to specify VSAC_USERNAME" unless ENV['VSAC_USERNAME']
      raise "Need to specify VSAC_PASSWORD" unless ENV['VSAC_PASSWORD']

      # Find user account; if it doesn't exist, set it up as a dashboard set account (no login required, so throw away password)
      user = User.where(email: ENV['EMAIL']).first
      unless user
        password = SecureRandom.hex(64)
        name = File.basename(ENV['FILE'], '.zip').gsub('_', ' ')
        user = User.create!(email: ENV['EMAIL'], first_name: name, password: password, password_confirmation: password,
                            approved: true, dashboard_set: true)
      end

      # Measures can be packaged in a number of ways... this just handles the CMS zip-of-zips for now
      Zip::ZipFile.open(ENV['FILE']) do |zip_file|
        Dir.mktmpdir("measure_files", Rails.root.join('tmp')) do |tmpdir|
          zip_file.glob(File.join('**','**.zip')).each do |measure_zip_entry|
            measure_zip_filename = File.join(tmpdir, File.basename(measure_zip_entry.name))
            measure_zip_entry.extract(measure_zip_filename)
            Zip::ZipFile.open(measure_zip_filename) do |measure_zip_file|
              measure_zip_file.glob(File.join('**.xml')).each do |measure_xml_entry|
                measure_xml_filename = File.join(tmpdir, File.basename(measure_xml_entry.name))
                measure_xml_entry.extract(measure_xml_filename)
                puts "Loading #{measure_xml_entry.name}"
                begin
                  Measures::SourcesLoader.load_measure_xml(measure_xml_filename, user, ENV['VSAC_USERNAME'], ENV['VSAC_PASSWORD'], {})
                rescue Exception => e
                  puts "ERROR loading #{measure_xml_entry.name}: #{e.message}"
                end
              end
            end
          end
        end
      end
    end
  end
end
