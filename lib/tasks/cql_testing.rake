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
    # e.g., bundle exec rake bonnie:fixtures:generate_frontend_fixtures[cms,test/fake,bonnie@test.org,CMS68v5,nil,nil]
    task :generate_frontend_cql_fixtures, [:cms_hqmf, :path, :user_email, :measure_id, :patient_first_name, :patient_last_name] => [:environment] do |t, args|
      fixtures_path = File.join('spec', 'javascripts', 'fixtures', 'json')

      user = User.find_by email: args[:user_email]

      #Exporting the fixtures for the measure. these go in a measure_data parent directory. the measure file is called measures.json. The accompanying value sets file is called value_sets.json
      measure = get_cql_measure(user, args[:cms_hqmf], args[:measure_id])
      measure_name = measure.cms_id + ".json"
      measure_file = File.join(fixtures_path, 'measure_data', args[:path], measure_name)
      create_fixture_file(measure_file, JSON.pretty_generate(JSON.parse(measure.to_json, max_nesting: 1000)))
      puts 'exported measure to ' + measure_file

      oid_to_vs_map = {}

      # user id for bonnie-fixtures@mitre.org
      bonnie_user_id = '501fdba3044a111b98000001'

      measure.value_set_oid_version_objects.each do |vs_v|
        db_value_sets = HealthDataStandards::SVS::ValueSet.where(user_id: measure.user_id, oid: vs_v['oid'], version: vs_v['version'])
        abort("\nFAILURE!!!!!\n\nFAILED to find value set for:\n\tuser: #{user.email}\n\toid: #{vs_v['oid']}\n\tversion: #{vs_v['version']}\n\nFAILURE!!!!!") unless db_value_sets.exists?
        vs = db_value_sets.first
        vs.user_id = bonnie_user_id
        oid_to_vs_map[vs['oid']] = { vs['version'] => vs }
      end

      value_sets_file = File.join(fixtures_path, 'measure_data', args[:path], 'value_sets.json')
      create_fixture_file(value_sets_file, JSON.pretty_generate(JSON.parse(oid_to_vs_map.to_json)))
      puts 'exported value sets to ' + value_sets_file

      #Exports patient data
      records = Record.by_user_and_hqmf_set_id(user, measure.hqmf_set_id)
      if (!args[:patient_first_name].nil? && !args[:patient_last_name].nil?)
        filtered_records = []
        records.each do |record|
          if (record.first == args[:patient_first_name] && record.last == args[:patient_last_name])
            filtered_records << record
          end
        end
        records = filtered_records
      end
      record_file = File.join(fixtures_path, 'records', args[:path], "patients.json")
      create_fixture_file(record_file, JSON.pretty_generate(JSON.parse(records.to_json)))
      puts 'exported patient records to ' + record_file
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
    # e.g., bundle exec rake bonnie:fixtures:generate_backend_fixtures[cms,test/fake,bonnie@test.org,CMS68v5]
    desc "Exports a set of fixtures that can be loaded for testing purposes"
    task :generate_backend_cql_fixtures, [:cms_hqmf, :path, :user_email, :measure_id] => [:environment] do |t, args|
      fixtures_path = File.join('test', 'fixtures')
      #Exports the user
      user = User.find_by email: args[:user_email]
      #In order to avoid storing details of real users, a test-specific user fixture exists.
      #This is used to assign the measure to that user.
      bonnie_user_id = '501fdba3044a111b98000001'

      #Exports the measure
      measure = get_cql_measure(user, args[:cms_hqmf], args[:measure_id])
      orig_user_id = measure.user_id
      measure.user_id = bonnie_user_id
      measure_name = measure.cms_id + ".json"
      measure_file = File.join(fixtures_path, 'cql_measures', args[:path], measure_name)
      # fix the measure's id so it will be imported as a BSON::ObjectId.
      measure_hash = JSON.parse(measure.to_json, max_nesting: 1000)
      measure_hash['_id'] = { '$oid' => measure_hash['_id'] }
      create_fixture_file(measure_file, JSON.pretty_generate(measure_hash))
      puts 'exported measure to ' + measure_file
      
      #Exports the measure package
      if measure.package
        measure_package_file = File.join(fixtures_path, 'cql_measure_packages', args[:path], measure_name)
        # fix the measure_id and _id so they get imported as BSON::ObjectIds
        measure_package_hash = JSON.parse(measure.package.to_json)
        measure_package_hash['_id'] = { '$oid' => measure_package_hash['_id'] }
        measure_package_hash['measure_id'] = { '$oid' => measure_package_hash['measure_id'] }
        create_fixture_file(measure_package_file, measure_package_hash.to_json)
        puts 'exported measure package to ' + measure_package_file
      end

      #Exports the measure's value_sets
      value_sets_file = File.join(fixtures_path, 'health_data_standards_svs_value_sets', args[:path], 'value_sets.json')
      vs_export = []
      measure.value_set_oid_version_objects.each do |vs_v|
        db_value_sets = HealthDataStandards::SVS::ValueSet.where(user_id: orig_user_id, oid: vs_v['oid'], version: vs_v['version'])
        abort("\nFAILURE!!!!!\n\nFAILED to find value set for:\n\tuser: #{user.email}\n\toid: #{vs_v['oid']}\n\tversion: #{vs_v['version']}\n\nFAILURE!!!!!") unless db_value_sets.exists?
        vs = db_value_sets.first
        vs.user_id = bonnie_user_id
        vs_export << vs
      end
      create_fixture_file(value_sets_file, JSON.pretty_generate(JSON.parse(vs_export.to_json)))
      puts 'exported value sets to ' + value_sets_file

      #Exports the patients on the selected measure
      records = Record.by_user_and_hqmf_set_id(user, measure.hqmf_set_id).each do |rec|
        rec.user_id = bonnie_user_id
        rec_name = rec.first + "_" + rec.last + ".json"
        record_file = File.join(fixtures_path, 'records', args[:path], rec_name)
        create_fixture_file(record_file, JSON.pretty_generate(JSON.parse(rec.to_json)))
        puts 'exported patient records to ' + record_file
      end
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

    def get_cql_measure(user, cms_hqmf, measure_id)
      if (cms_hqmf.downcase  != 'cms' && cms_hqmf.downcase != 'hqmf')
        throw('Argument: "' + cms_hqmf + '" does not match expected: cms or hqmf')
      end
      CqlMeasure.by_user(user).each do |measure|
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
