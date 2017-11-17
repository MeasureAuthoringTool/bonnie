#  -*- coding: utf-8 -*-
namespace :bonnie do
  namespace :cql do

    desc %{Recreates the JSON elm stored on CQL measures using an instance of
      a locally running CQLTranslationService JAR.

    $ rake bonnie:cql:rebuild_elm}
    task :rebuild_elm => :environment do
      update_passes = 0
      update_fails = 0
      orphans = 0
      CqlMeasure.all.each do |measure|
        begin
          # Grab the user, we need this to output the name of the user who owns
          # this measure. Also comes in handy when detecting measures uploaded
          # by accounts that have since been deleted.
          user = User.find_by(_id: measure[:user_id])
          cql = nil
          cql_artifacts = nil
          # Grab the name of the main cql library
          main_cql_library = measure[:main_cql_library]

          # If measure has been uploaded more recently (we should have a copy of the MAT Package) we will use the actual MAT artifacts
          if !measure.package.nil?
            # Create a temporary directory
            Dir.mktmpdir do |dir|
              # Write the package to a temp directory
              File.open(File.join(dir, measure.measure_id + '.zip'), 'wb') do |zip_file|
                # Write the package binary to a zip file.
                zip_file.write(measure.package.file.data)
                files = Measures::CqlLoader.get_files_from_zip(zip_file, dir)
                cql_artifacts = Measures::CqlLoader.process_cql(files, main_cql_library, user)
                cql = files[:CQL]
              end
            end
          # If the measure does not have a MAT package stored, continue as we have in the past using the cql to elm service
          else
            # Grab the measure cql
            cql = measure[:cql]
             # Use the CQL-TO-ELM Translation Service to regenerate elm for older measures.
            elm_json, elm_xml = CqlElm::CqlToElmHelper.translate_cql_to_elm(cql)
            elms = {:ELM_JSON => elm_json,
                    :ELM_XML => elm_xml}
            cql_artifacts = Measures::CqlLoader.process_cql(elms, main_cql_library, user)
          end
          # Update the measure
          measure.update(cql: cql, elm: cql_artifacts[:elms], elm_annotations: cql_artifacts[:elm_annotations], cql_statement_dependencies: cql_artifacts[:cql_definition_dependency_structure],
                         main_cql_library: main_cql_library, value_set_oids: cql_artifacts[:all_value_set_oids], value_set_oid_version_objects: cql_artifacts[:value_set_oid_version_objects])
          measure.save!
          update_passes += 1
          print "\e[#{32}m#{"[Success]"}\e[0m"
          puts ' Measure ' + "\e[1m#{measure[:cms_id]}\e[22m" + ': "' + measure[:title] + '" with id ' + "\e[1m#{measure[:id]}\e[22m" + ' in account ' + "\e[1m#{user[:email]}\e[22m" + ' successfully updated ELM!'
        rescue Mongoid::Errors::DocumentNotFound => e
          orphans += 1
          print "\e[#{31}m#{"[Error]"}\e[0m"
          puts ' Measure ' + "\e[1m#{measure[:cms_id]}\e[22m" + ': "' + measure[:title] + '" with id ' + "\e[1m#{measure[:id]}\e[22m" + ' belongs to a user that doesn\'t exist!'
        rescue Exception => e
          update_fails += 1
          print "\e[#{31}m#{"[Error]"}\e[0m"
          puts ' Measure ' + "\e[1m#{measure[:cms_id]}\e[22m" + ': "' + measure[:title] + '" with id ' + "\e[1m#{measure[:id]}\e[22m" + ' in account ' + "\e[1m#{user[:email]}\e[22m" + ' failed to update ELM!'
        end
      end
      puts "#{update_passes} measures successfully updated."
      puts "#{update_fails} measures failed to update."
      puts "#{orphans} measures are orphaned, and were not updated."
    end

    desc %{Outputs user accounts that have cql measures and which measures are cql in their accounts.
      Example test@test.com  
                CMS_ID: xxx   TITLE: Measure Title
    $ rake bonnie:cql:cql_measure_stats}
    task :cql_measure_stats => :environment do

      # Collect user info from CQL measures
      users = {}
      CqlMeasure.all.each do |m|
        users[m.user_id.to_s] = [] unless users.key? m.user_id.to_s
        users[m.user_id.to_s].push({cms_id: m.cms_id, title: m.title})
      end

      # Print info
      users.each do |u, m_array|
        user = User.find_by(id: u)
        puts 'User: ' + user.email
        m_array.each do |m|
          puts "  CMS_ID: #{m[:cms_id]}  TITLE: #{m[:title]}"
        end
      end
      
    end

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
