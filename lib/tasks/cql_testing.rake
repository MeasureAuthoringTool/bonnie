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
      measure_file_path = File.join(fixtures_path, 'cqm_measure_data', args[:path])
      record_file_path = File.join(fixtures_path, 'cqm_patients', args[:path])

      user = User.find_by email: args[:user_email]
      cqm_measure = get_cqm_measure(user, args[:cms_hqmf], args[:measure_id])
      records = Record.by_user_and_hqmf_set_id(user, cqm_measure.hqmf_set_id)
      if (args[:patient_first_name].present? && args[:patient_last_name].present?)
        records = records.select { |r| r.first == args[:patient_first_name] && r.last == args[:patient_last_name] }
      end

      fixture_exporter = FrontendFixtureExporter.new(user, measure: cqm_measure, records: records)
      fixture_exporter.export_measure_and_any_components(measure_file_path)
      fixture_exporter.export_value_sets(measure_file_path)
      fixture_exporter.export_records(record_file_path)
    end

    desc %{Export backend cqm fixtures for a given user account
    example: bundle exec rake bonnie:fixtures:generate_backend_cqm_fixtures[bonnie-fixtures@mitre.org]}
    task :generate_backend_cqm_fixtures, [:user_email] => [:environment] do |t, args|
      fixtures_path = File.join('test', 'fixtures')

      user = User.find_by email: args[:user_email]
      CQM::Measure.by_user(user).each do |measure|
        patients = CQM::Patient.by_user_and_hqmf_set_id(user, measure.hqmf_set_id)

        measure_file_path = File.join(fixtures_path, 'measures', measure.cms_id, 'cqm_measures')
        patient_file_path = File.join(fixtures_path, 'cqm_patients', measure.cms_id)
        measure_package_path = File.join(fixtures_path, 'measures', measure.cms_id, 'cqm_measure_packages')
        value_sets_path = File.join(fixtures_path, 'measures', measure.cms_id, 'cqm_value_sets')

        fixture_exporter = BackendFixtureExporter.new(user, measure: measure, records: patients)
        fixture_exporter.export_measure_and_any_components(measure_file_path)
        fixture_exporter.try_export_measure_package(measure_package_path)
        fixture_exporter.export_value_sets(value_sets_path)
        fixture_exporter.export_records(patient_file_path)
      end
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
      measure = get_cqm_measure(user, args[:cms_hqmf], args[:measure_id])
      records = CQM::Patient.by_user_and_hqmf_set_id(user, measure.hqmf_set_id)

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

    desc %{Export patient fixtures for a given account. Uses vsac credentials from environmental vars.
      Exports into test/fixtures/cqm_patients/<CMS_ID> and spec/javascripts/fixtures/json/cqm_patients/<CMS_ID>
      example: bundle exec rake bonnie:fixtures:generate_cqm_patient_fixtures_from_cql_patients[bonnie-fixtures@mitre.org]}
    task :generate_cqm_patient_fixtures_from_cql_patients, [:email] => [:environment] do |task, args|
      email = args[:email]
      user = User.find_by email: args[:email]
      cms_ids = {}
      failed_exports = []
      CqlMeasure.by_user(user).each do |measure|
        Record.where(measure_ids: measure.hqmf_set_id, user_id: BSON::ObjectId.from_string(user.id)).each do |record|
          begin
            patient = CQMConverter.to_cqm(record)
            patient._id = record._id if record._id

            backend_fixture_exporter = BackendFixtureExporter.new(user, measure: measure, records: [patient])
            backend_fixture_path = File.join('test', 'fixtures', 'cqm_patients', measure.cms_id)
            backend_fixture_exporter.export_records_as_individual_files(backend_fixture_path)

            frontend_fixture_exporter = FrontendFixtureExporter.new(user, measure: measure, records: [patient])
            frontend_fixture_path = File.join('spec', 'javascripts', 'fixtures', 'json', 'patients', measure.cms_id)
            frontend_fixture_exporter.export_records_as_individual_files(frontend_fixture_path)
          rescue StandardError => e
            failed_exports << "measure.hqmf_set_id: #{measure.hqmf_set_id}\n\trecord._id: #{record._id}\n\terror: #{e}"
          end
        end
      end
      unless failed_exports.empty?
        puts "Failed to export the following patients:"
        failed_exports.each {|failed_export| puts failed_export }
      end
    end

    def get_cqm_measure(user, cms_hqmf, measure_id)
      if (!cms_hqmf.casecmp('cms').zero? && !cms_hqmf.casecmp('hqmf').zero?)
        throw('Argument: "' + cms_hqmf + '" does not match expected: cms or hqmf')
      end
      CQM::Measure.by_user(user).each do |measure|
        if (cms_hqmf.casecmp('cms').zero? && measure.cms_id.casecmp(measure_id).zero?)
          return measure
        elsif (cms_hqmf.casecmp('hqmf').zero? && measure.hqmf_set_id.casecmp(measure_id).zero?)
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

  end

  namespace :cql do
    desc %{Adds the JSON ELM to a MAT package and replaces the XML ELM. Saves as a new file with '_with_JSON' appened to
    the file name. Add 'true' as a second parameter to keep the XML ELM already in the package if possible. It will
    still be replaced if no clause level annotations are found.

    $ bundle exec rake bonnie:cql:add_json_to_package[path/to/package.zip,true]

    If you are using a zsh terminal, you need to use 'noglob':
    $ noglob bundle exec rake bonnie:cql:add_json_to_package[path/to/package.zip]}

    task :add_json_to_package, [:input_package_path, :keep_elm_xml] => [:environment] do |t, args|
      input_package_path = Pathname.new(args[:input_package_path])
      keep_elm_xml = args.fetch(:keep_elm_xml, false) == 'true'
      temp_path = Pathname.new(File.join('tmp', 'package_temp'))
      FileUtils.rm_rf(temp_path) if temp_path.exist?
      temp_path.mkdir
      puts "Adding JSON ELM to #{args[:input_package_path]}"

      base_zip_directory = nil
      # extract human_readable and determine base directory name if there is one
      Zip::ZipFile.open(input_package_path) do |zip_file|
        human_readable_path = zip_file.glob(File.join('**','**.html')).select { |x| !x.name.starts_with?('__MACOSX') }.first
        zip_file.extract(human_readable_path, File.join(temp_path, File.basename(human_readable_path.name)))

        # look at the human_readable to see if it has a directory it resides in
        if File.dirname(human_readable_path.name) != "."
          base_zip_directory = File.dirname(human_readable_path.name)
        end
      end

      # extract all other files
      files = Measures::CqlLoader.get_files_from_zip(File.new(input_package_path), temp_path)
      raise Exception.new("Package already has ELM JSON!") if files[:ELM_JSON].length > 0

      # translate_cql_to_elm
      elm_jsons, elm_xmls = CqlElm::CqlToElmHelper.translate_cql_to_elm(files[:CQL])

      # older packages don't have annotations or clause level annotations, if they dont have them wipe out the existing
      # XML ELM and use the ones from the translation server
      # start by assuming there are annotations, then set this to false
      annotations_exist = true
      # only do the check if we are attempting to keep ELM XML
      if keep_elm_xml
        files[:ELM_XML].each do |elm_xml|
          if elm_xml.index("<a:s r=") == nil
            annotations_exist = false
          end
        end
      end

      # if we found that annotations are missing then we have to use the xml from the translation service. Also do so
      # if specifically requested to.
      xml_filenames = []
      if !annotations_exist || !keep_elm_xml
        if keep_elm_xml
          puts "This appears to be an older package that needs clause annotations. Replacing XML ELM with translation service response."
        else
          puts "Replacing XML ELM with translation service response."
        end

        # remove the old xml files
        old_elm_xml_filepaths = Dir.glob(File.join(temp_path, "*.xml")).select { |x| x != files[:HQMF_XML_PATH] }
        old_elm_xml_filepaths.each do |file|
          puts "deleting #{file}"
          File.unlink(file)
        end

        # save the versions from the service
        elm_xmls.each do |elm_xml|
          elm_doc = Nokogiri::XML.parse(elm_xml)
          library_identifier = elm_doc.at_xpath("//xmlns:library/xmlns:identifier")
          library_name = library_identifier.attribute('id').value
          library_version = library_identifier.attribute('version').value
          xml_path = "#{library_name}-#{library_version}.xml"
          xml_filenames << xml_path
          puts "creating #{xml_path}"
          File.write(File.join('tmp', 'package_temp', xml_path), elm_xml)
        end
      end

      # save json files
      json_filenames = []
      elm_jsons.each do |elm_json|
        elm_json_hash = JSON.parse(elm_json, max_nesting: 1000)
        if elm_json_hash['library']['annotation']
          raise Exception.new("Translation server found error in #{elm_json_hash['library']['identifier']['id']}\n#{JSON.pretty_generate(elm_json_hash['library']['annotation'])}")
        end
        elm_library_version = "#{elm_json_hash['library']['identifier']['id']}-#{elm_json_hash['library']['identifier']['version']}"
        json_filenames << "#{elm_library_version}.json"
        json_path = File.join('tmp', 'package_temp', "#{elm_library_version}.json")
        puts "creating #{elm_library_version}.json"
        File.write(json_path, elm_json)
      end

      # edit xml
      puts "Adding JSON ELM entries to HQMF"
      doc = Nokogiri::XML.parse(File.read(files[:HQMF_XML_PATH]))
      # find cql each expressionDocument
      doc.xpath("//xmlns:relatedDocument/xmlns:expressionDocument/xmlns:text").each do |cql_node|
        # guess at the library name and attempt to find a json file we created for it
        cql_filename = cql_node.at_xpath('xmlns:reference').attribute('value').value
        cql_libname = cql_filename.split(/[-,_]/)[0]
        json_filename = json_filenames.select { |filename| filename.start_with?(cql_libname)}
        raise Exception.new("Could not find JSON ELM file for #{cql_libname}") unless json_filename.length > 0

        # update reference to ELM XML files we replaced if that was needed
        if !annotations_exist
          xml_filename = xml_filenames.select { |filename| filename.start_with?(cql_libname)}
          raise Exception.new("Could not find XML ELM file for #{cql_libname}") unless xml_filename.length > 0
          cql_node.at_xpath('xmlns:translation/xmlns:reference').attribute('value').value = xml_filename[0]
        end

        # clone the xml translation and modify it to reference the elm_json
        new_translation = cql_node.at_xpath('xmlns:translation').clone()
        new_translation.attribute('mediaType').value = "application/elm+json"
        new_translation.at_xpath('xmlns:reference').attribute('value').value = json_filename[0]
        cql_node.add_child(new_translation)
      end
      File.write(files[:HQMF_XML_PATH], doc.to_xml)

      # create new zip
      output_package_path = Pathname.new(File.join(input_package_path.dirname, input_package_path.basename('.zip').to_s + "_with_json.zip"))
      puts "Creating new zip file at #{output_package_path}"
      Zip::ZipFile.open(output_package_path, Zip::File::CREATE) do |new_package_zip|
        temp_path.children.each do |path|
          if base_zip_directory != nil
            target_path = File.join(base_zip_directory, path.basename)
          else
            target_path = path.basename
          end
          puts "  + #{target_path}"
          new_package_zip.add(target_path, path)
        end
      end
    end
  end
end
