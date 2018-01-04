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
          # Grab the existing data_criteria and source_data_criteria hashes. Must be a deep copy, due to how Mongo copies Hash and Array field types.
          data_criteria_object = {}
          data_criteria_object['data_criteria'] = measure[:data_criteria].deep_dup
          data_criteria_object['source_data_criteria'] = measure[:source_data_criteria].deep_dup

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
                data_criteria_object['source_data_criteria'], data_criteria_object['data_criteria'] = Measures::CqlLoader.set_data_criteria_code_list_ids(data_criteria_object, cql_artifacts)
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
            data_criteria_object['source_data_criteria'], data_criteria_object['data_criteria'] = Measures::CqlLoader.set_data_criteria_code_list_ids(data_criteria_object, cql_artifacts)
          end
          # Update the measure
          measure.update(data_criteria: data_criteria_object['data_criteria'], source_data_criteria: data_criteria_object['source_data_criteria'], cql: cql, elm: cql_artifacts[:elms], elm_annotations: cql_artifacts[:elm_annotations], cql_statement_dependencies: cql_artifacts[:cql_definition_dependency_structure],
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
    
    task :update_value_set_versions => :environment do
      User.all.each do |user|
        puts "Updating value sets for user " + user.email
        begin
          measures = CqlMeasure.where(user_id: user.id)

          measures.each do |measure|
            elms = measure.elm

            Measures::CqlLoader.modify_value_set_versions(elms)

            elms.each do |elm|

              if elm['library'] && elm['library']['valueSets'] && elm['library']['valueSets']['def']
                elm['library']['valueSets']['def'].each do |value_set|
                  db_value_sets = HealthDataStandards::SVS::ValueSet.where(user_id: user.id, oid: value_set['id'])

                  db_value_sets.each do |db_value_set|
                    if value_set['version'] && db_value_set.version == "N/A"
                      puts "Setting " + db_value_set.version.to_s + " to " + value_set['version'].to_s
                      db_value_set.version = value_set['version']
                      db_value_set.save()
                    end
                  end
                end
              end
            end
          end
        rescue Mongoid::Errors::DocumentNotFound => e
          puts "\nNo CQL measures found for the user below"
          puts user.email
          puts user.id
        end
      end
    end

    def print_helper(title, patient)
      if title == '-Facility' || title == '-Arrival' || title == '-Departure'
        printf "%-22s", "\e[#{31}m#{"[#{title}] "}\e[0m"
      else
        printf "%-22s", "\e[#{32}m#{"[#{title}] "}\e[0m"
      end
      printf "%-80s", "\e[#{36}m#{"#{patient.first} #{patient.last}"}\e[0m"
      begin
        account = User.find(patient.user_id).email
        printf "%-35s %s", "#{account}", " #{patient.measure_ids[0]}\n"
      rescue Exception => ex
        puts "ORPHANED"
      end

    end

    def update_facility(patient, datatype)
      if datatype.facility && !datatype.facility['type']
        # Need to build new facility and assign it in order to actually save it in DB
        new_datatype_facility = {}

        # Assign type to be 'COL' for collection
        new_datatype_facility['type'] = 'COL'
        new_datatype_facility['values'] = [{}]

        # Convert single facility into collection containing 1 facility
        start_time = datatype.facility['start_time']
        end_time = datatype.facility['end_time']

        # Convert times from 1505203200 format to  09/12/2017 8:00 AM format
        if start_time
          converted_start_time = Time.at(start_time).getutc().strftime("%m/%d/%Y %l:%M %p")
        else
          converted_start_time = nil
        end

        if end_time
          converted_end_time = Time.at(end_time).getutc().strftime("%m/%d/%Y %l:%M %p")
        else
          converted_end_time = nil
        end

        # start/end time -> locationPeriodLow/High
        new_datatype_facility['values'][0]['locationPeriodLow'] = converted_start_time
        new_datatype_facility['values'][0]['locationPeriodHigh'] = converted_end_time

        # name -> display
        new_datatype_facility['values'][0]['display'] = datatype.facility['name']

        # code
        if datatype.facility['code']
          code_system = datatype.facility['code']['code_system']
          code = datatype.facility['code']['code']
          new_datatype_facility['values'][0]['code'] = {'code_system'=>code_system, 'code'=>code}
          print_helper("Facility", patient)
          datatype.facility = new_datatype_facility
        else
          print_helper("-Facility", patient)
          datatype.remove_attribute(:facility)
        end
      end
    end



    task :update_facilities_and_diagnoses => :environment do
      printf "%-22s", "\e[#{32}m#{"[TITLE] "}\e[0m"
      printf "| %-80s", "\e[#{36}m#{"FIRST LAST"}\e[0m"
      printf"| %-35s", "ACCOUNT"
      puts "| MEASURE ID"
      puts "-"*157
      # For any relevant datatypes, update old facilities and diagnoses to be collections with single elements
      Record.all.each do |patient|
        if patient.source_data_criteria
          patient.source_data_criteria.each do |source_data_criterium|
            new_source_data_criterium_field_values = {}
            if source_data_criterium['field_values']
              source_data_criterium['field_values'].each do |field_value_key, field_value_value|
                # update any 'DIAGNOSIS' field values that aren't collections
                if field_value_key == 'DIAGNOSIS' && !(source_data_criterium['field_values']['DIAGNOSIS']['type'] == 'COL')
                  new_diagnosis = {}
                  new_diagnosis['type'] = 'COL'
                  if source_data_criterium['field_values']['DIAGNOSIS']['field_title']
                    new_diagnosis['field_title'] = source_data_criterium['field_values']['DIAGNOSIS']['field_title']
                  end
                  new_diagnosis['values'] = [{}]
                  new_diagnosis['values'][0]['type'] = 'CD'
                  new_diagnosis['values'][0]['key'] = 'DIAGNOSIS'
                  if source_data_criterium['field_values']['DIAGNOSIS']['field_title']
                    new_diagnosis['values'][0]['field_title'] = source_data_criterium['field_values']['DIAGNOSIS']['field_title']
                  end
                  new_diagnosis['values'][0]['code_list_id'] = source_data_criterium['field_values']['DIAGNOSIS']['code_list_id']
                  new_diagnosis['values'][0]['field_title'] = source_data_criterium['field_values']['DIAGNOSIS']['field_title']
                  new_diagnosis['values'][0]['title'] = source_data_criterium['field_values']['DIAGNOSIS']['title']
                  new_source_data_criterium_field_values['DIAGNOSIS'] = new_diagnosis 

                # update any 'FACILITY_LOCATION' field values that aren't collections
                elsif field_value_key == 'FACILITY_LOCATION' && !(source_data_criterium['field_values']['FACILITY_LOCATION']['type'] == 'COL')
                  new_facility_location = {}
                  new_facility_location['type'] = 'COL'
                  new_facility_location['values'] = [{}]
                  new_facility_location['values'][0]['type'] = 'FAC'
                  new_facility_location['values'][0]['key'] = 'FACILITY_LOCATION'
                  new_facility_location['values'][0]['code_list_id'] = source_data_criterium['field_values']['FACILITY_LOCATION']['code_list_id']
                  new_facility_location['values'][0]['field_title'] = source_data_criterium['field_values']['FACILITY_LOCATION']['field_title']
                  new_facility_location['values'][0]['title'] = source_data_criterium['field_values']['FACILITY_LOCATION']['title']

                  # Convert times
                  converted_start_date = nil
                  converted_start_time = nil
                  if source_data_criterium['field_values']['FACILITY_LOCATION_ARRIVAL_DATETIME'] 
                    old_start_time = source_data_criterium['field_values']['FACILITY_LOCATION_ARRIVAL_DATETIME']['value']
                    converted_start_date = Time.at(old_start_time / 1000).getutc().strftime('%m/%d/%Y')
                    converted_start_time = Time.at(old_start_time / 1000).getutc().strftime('%l:%M %p')
                    if source_data_criterium['field_values']['FACILITY_LOCATION_ARRIVAL_DATETIME']['value']
                      new_facility_location['values'][0]['value'] = source_data_criterium['field_values']['FACILITY_LOCATION_ARRIVAL_DATETIME']['value']
                    end
                  end
                  new_facility_location['values'][0]['start_date'] = converted_start_date
                  new_facility_location['values'][0]['start_time'] = converted_start_time

                  converted_end_date = nil
                  converted_end_time = nil
                  if source_data_criterium['field_values']['FACILITY_LOCATION_DEPARTURE_DATETIME'] 
                    old_end_time = source_data_criterium['field_values']['FACILITY_LOCATION_DEPARTURE_DATETIME']['value']
                    converted_end_date = Time.at(old_end_time / 1000).getutc().strftime('%m/%d/%Y')
                    converted_end_time = Time.at(old_end_time / 1000).getutc().strftime('%l:%M %p')
                    if source_data_criterium['field_values']['FACILITY_LOCATION_DEPARTURE_DATETIME']['value']
                      new_facility_location['values'][0]['end_value'] = source_data_criterium['field_values']['FACILITY_LOCATION_DEPARTURE_DATETIME']['value']
                    end
                  end
                  new_facility_location['values'][0]['end_date'] = converted_end_date
                  new_facility_location['values'][0]['end_time'] = converted_end_time

                  new_locationPeriodLow = nil
                  new_locationPeriodHigh = nil
                  if converted_start_date
                    new_locationPeriodLow = converted_start_date.to_s
                    new_locationPeriodLow += " #{converted_start_time.to_s}" if converted_start_time
                  end
                  if converted_end_date
                    new_locationPeriodHigh = converted_end_date.to_s
                    new_locationPeriodHigh += " #{converted_end_time.to_s}" if converted_end_time
                  end
                  new_facility_location['values'][0]['locationPeriodLow'] = new_locationPeriodLow if new_locationPeriodLow 
                  new_facility_location['values'][0]['locationPeriodHigh'] = new_locationPeriodHigh if new_locationPeriodHigh 

                  # Reassign
                  new_source_data_criterium_field_values['FACILITY_LOCATION'] = new_facility_location 
                elsif !(field_value_key == 'FACILITY_LOCATION_ARRIVAL_DATETIME' || field_value_key == 'FACILITY_LOCATION_DEPARTURE_DATETIME')
                  # add unaltered field value to new structure, unless it's a time we already used above
                  new_source_data_criterium_field_values[field_value_key] = field_value_value
                else
                  # There was an arrival/depature time without a code, remove them
                  if field_value_key == 'FACILITY_LOCATION_ARRIVAL_DATETIME' && !source_data_criterium['field_values']['FACILITY_LOCATION']
                    print_helper("-Arrival", patient)
                    new_source_data_criterium_field_values.delete(field_value_key)
                  elsif field_value_key == 'FACILITY_LOCATION_DEPARTURE_DATETIME' && !source_data_criterium['field_values']['FACILITY_LOCATION']
                    print_helper("-Departure", patient)
                    new_source_data_criterium_field_values.delete(field_value_key)
                  end
                end
              end
              source_data_criterium['field_values'] = new_source_data_criterium_field_values
            end
          end
        end

        if patient.encounters
          patient.encounters.each do |encounter|
            if encounter.facility && !encounter.facility['type']
              update_facility(patient, encounter)
            end

            # Diagnosis is only for encounter
            if encounter.diagnosis && !encounter.diagnosis['type']
              print_helper("Diagnosis", patient)
              new_encounter_diagnosis = {}
              new_encounter_diagnosis['type'] = 'COL'
              new_encounter_diagnosis['values'] = [{}]
              new_encounter_diagnosis['values'][0]['title'] = encounter.diagnosis['title']
              new_encounter_diagnosis['values'][0]['code'] = encounter.diagnosis['code']
              new_encounter_diagnosis['values'][0]['code_system'] = encounter.diagnosis['code_system']
              encounter.diagnosis = new_encounter_diagnosis
            end
          end
        end

        if patient.adverse_events
          patient.adverse_events.each do |adverse_event|
            if adverse_event.facility && !adverse_event.facility['type']
              update_facility(patient, adverse_event)
            end
          end
        end

        if patient.procedures
          patient.procedures.each do |procedure|
            if procedure.facility && !procedure.facility['type']
              update_facility(patient, procedure)
            end
          end
        end
        patient.save!
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
