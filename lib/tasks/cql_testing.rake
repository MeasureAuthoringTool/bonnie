require_relative './fixture_helper'
# NOTE: Tasks use array arguments to execute.
# In order for z-shell to execute, noglob is required.
# e.g., noglob bundle exec rake bonnie:fixtures:load_backend_fixtures[test/fake]
namespace :bonnie do
  namespace :fixtures do
    ###
    # Generates a set of front end fixtures representing a specific database state.
    #
    # cms_hqmf: indicates if a CMS id or an HQMF id is used.
    #   values: cms, hqmf
    # path: Path to fixture files, derived from the data-type directories (EX: measure_data/${path}).
    # user_email: email of user to export.  Measure and patients exported will be taken from this user account.
    # measure_id: id of measure to export, taken from account of given user.
    # patient_first_name: if a specific patient is desired, include a first_name and last_name.  If all patients are desired, set to nil
    # patient_last_name: if a specific patient is desired, include a first_name and last_name.  If all patients are desired, set to nil
    #
    # e.g., bundle exec rake bonnie:fixtures:generate_frontend_cql_fixtures[cms,test/fake,bonnie@test.org,CMS68v5,nil,nil]
    task :generate_frontend_cql_fixtures, [:cms_hqmf, :path, :user_email, :measure_id, :patient_first_name, :patient_last_name] => [:environment] do |t, args|
      fixtures_path = File.join('spec', 'javascripts', 'fixtures', 'json')
      measure_file_path = File.join(fixtures_path, 'measure_data', args[:path])
      record_file_path = File.join(fixtures_path, 'records', args[:path])

      user = User.find_by email: args[:user_email]
      measure = get_cql_measure(user, args[:cms_hqmf], args[:measure_id])
      records = Record.by_user_and_hqmf_set_id(user, measure.hqmf_set_id)
      if (args[:patient_first_name].present? && args[:patient_last_name].present?)
        records = records.select { |r| r.first == args[:patient_first_name] && r.last == args[:patient_last_name] }
      end

      fixture_exporter = FrontendFixtureExporter.new(user, measure: measure, records: records)
      fixture_exporter.export_measure_and_any_components(measure_file_path)
      fixture_exporter.export_value_sets(measure_file_path)
      fixture_exporter.export_records(record_file_path)
    end

    ###
    # Generates a set of back end fixtures representing a specific database state.
    # Generated fixtures will be associated with
    #
    # cms_hqmf: indicates if a CMS id or an HQMF id is used.
    #   values: cms, hqmf
    # path: Path to fixture files, derived from the data-type directories (EX: measure_data/${path}).
    # user_email: email of user to export.  Measure and patients exported will be taken from this user account.
    # measure_id: id of measure to export, taken from account of given user.
    #
    # e.g., bundle exec rake bonnie:fixtures:generate_backend_cql_fixtures[cms,test/fake,bonnie@test.org,CMS68v5]
    desc "Exports a set of fixtures that can be loaded for testing purposes"
    task :generate_backend_cql_fixtures, [:cms_hqmf, :path, :user_email, :measure_id] => [:environment] do |t, args|
      fixtures_path = File.join('test', 'fixtures')
      measure_file_path = File.join(fixtures_path, 'cql_measures', args[:path])
      record_file_path = File.join(fixtures_path, 'records', args[:path])
      measure_package_path = File.join(fixtures_path, 'cql_measure_packages', args[:path])
      value_sets_path = File.join(fixtures_path, 'health_data_standards_svs_value_sets', args[:path])

      user = User.find_by email: args[:user_email]
      measure = get_cql_measure(user, args[:cms_hqmf], args[:measure_id])
      records = Record.by_user_and_hqmf_set_id(user, measure.hqmf_set_id)

      fixture_exporter = BackendFixtureExporter.new(user, measure: measure, records: records)
      fixture_exporter.export_measure_and_any_components(measure_file_path)
      fixture_exporter.try_export_measure_package(measure_package_path)
      fixture_exporter.export_value_sets(value_sets_path)
      fixture_exporter.export_records(record_file_path)
    end

    ###
    # Takes a set of valueset json files, creates a dictionary of oid to valueset
    #
    # fileset_dir: directory containing input filesd.
    # output_dir: directory where output will be stored.
    desc "Generates oid to valueset dictonary from directory"
    task :generate_oid_to_valuesets => [:environment] do 
      fileset_dir = File.join("test", "fixtures", "health_data_standards_svs_value_sets", ENV['fileset_dir'])
      output_dir = File.join("spec", "javascripts", "fixtures", "json", "measure_data", ENV['output_dir'])
      dict = {}
      Dir.glob(File.join(fileset_dir, "*.json")).each do |file|
        vs = JSON.parse(File.read(file))
        dict[vs['oid']] = vs
      end
      output = File.join(output_dir, "value_sets.json")
      File.new(output, "w+")
      File.write(output, JSON.pretty_generate(dict))
    end
    
    ###
    # Loads a set of back end fixtures into the active database.
    # NOTE: This task will fail if documents in the database with the same ids already exist.
    # It is strongly recomended that you alter the config/mongoid.yml file so that the development:sessions:default:database points
    # to a new database (running bonnie will create a new database if the database config is pointed at one that does not exist)
    # path: the path to the files that comes after the fixture type directory
    #
    # e.g., bundle exec rake bonnie:fixtures:load_backend_fixtures[test/fake]
    desc "Loads set of fixtures into a running instance of BONNIE"
    task :load_backend_fixtures, [:path] => [:environment] do |t, args|
      measure_collection = File.join 'draft_measures', args[:path]
      cql_measure_collection = File.join 'cql_measures', args[:path]
      value_sets_collection = File.join 'health_data_standards_svs_value_sets', args[:path]
      records_collection = File.join 'records', args[:path]
      users_collection = File.join 'users', 'export_user'
      collection_fixtures(measure_collection, cql_measure_collection, value_sets_collection, records_collection, users_collection)
    end

    desc %{Export fixtures based from package files. Uses vsac credentials from environmental vars.
    Must set up folder in test/fixtures/measures/MEASURE_NAME containing MEASURE_NAME.zip and loading_params.json.
    example: bundle exec rake bonnie:fixtures:export_fixtures_from_packages[CMS890_v5_6]}
    task :export_fixtures_from_packages, [:name] => [:environment] do |t, args|
      name = args[:name]
      fixture_path = File.join('test', 'fixtures', 'measures', name)
      loading_params = HashWithIndifferentAccess.new(JSON.parse(File.read(File.join(fixture_path, "loading_params.json"))))
      loading_params[:vsac_username] = ENV['VSAC_USERNAME']
      loading_params[:vsac_password] =  ENV['VSAC_PASSWORD']
      measure_file = File.new File.join(fixture_path, name + '.zip')

      # We use the MeasuresController persist method with a dummy user to make use of the existing measure loading code
      user = User.new
      def user.save!
        nil
      end
      measures, main_hqmf_set_id = MeasuresController.new.send :persist_measure, measure_file, loading_params, user

      fixture_exporter = BackendFixtureExporter.new(nil, measure: measures.reject(&:component)[0], component_measures: measures.select(&:component))
      fixture_exporter.export_measure_and_any_components(File.join(fixture_path,'cqm_measures'))
      fixture_exporter.export_value_sets(File.join(fixture_path,'cqm_value_sets'))
      fixture_exporter.try_export_measure_package(File.join(fixture_path,'cqm_measure_packages'))
    end

    def get_cql_measure(user, cms_hqmf, measure_id)
      if (cms_hqmf.downcase  != 'cms' && cms_hqmf.downcase != 'hqmf')
        throw('Argument: "' + cms_hqmf + '" does not match expected: cms or hqmf')
      end
      CQM::Measure.by_user(user).each do |measure|
        if (cms_hqmf.downcase  == 'cms' && measure.cms_id.downcase == measure_id.downcase)
          return measure
        elsif (cms_hqmf.downcase == 'hqmf' && measure.hqmf_set_id.downcase == measure_id.downcase)
          return measure
        end
      end
      throw('Argument: "' + cms_hqmf + ': ' + measure_id +'" does not match any measure id associated with user: "'+user.email+'"')
    end

    def convert_times(json)
      if json.kind_of?(Hash)
        json.each_pair do |k,v|
          if k.ends_with?("_at")
            json[k] = Time.parse(v)
          end
        end
      end
    end

    ###
    # Creates and writes a fixture file.
    #
    # file_path: path of file to be written
    # fixture_json: json to be written
    def create_fixture_file(file_path, fixture_json)
      FileUtils.mkdir_p(File.dirname(file_path)) unless Dir.exists? File.dirname(file_path)
      File.new(file_path, "w+")
      File.write(file_path, fixture_json)
    end
    
  end
end
