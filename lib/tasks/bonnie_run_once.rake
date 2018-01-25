# This rakefile is for tasks that are designed to be run once to address a specific problem; we're keeping
# them as a history and as a reference for solving related problems

namespace :bonnie do
  namespace :patients do

    desc %{Update source_data_criteria to match fields from measure

    $ rake bonnie:patients:update_source_data_criteria}
    task :update_source_data_criteria=> :environment do
      puts "Updating patient source_data_criteria to match measure"
      p_hqmf_set_ids_updated, hqmf_set_ids_updated = 0, 0
      p_code_list_ids_updated, code_list_ids_updated = 0, 0
      successes = 0
      warnings = 0
      errors = 0

      Record.all.each do |patient|
        p_hqmf_set_ids_updated = 0

        first = patient.first
        last = patient.last

        begin
          email = User.find_by(_id: patient[:user_id]).email
        rescue Mongoid::Errors::DocumentNotFound => e
          print_error("#{first} #{last} #{patient[:user_id]} Unable to find user")
          p_errors += 1
        end

        has_changed = false
        hqmf_set_id = patient.measure_ids[0]

        begin
          measure = CqlMeasure.find_by(hqmf_set_id: patient.measure_ids[0], user_id: patient[:user_id])
        rescue Mongoid::Errors::DocumentNotFound => e
          print_warning("#{first} #{last} #{email} Unable to find measure")
          warnings += 1
        end

        patient.source_data_criteria.each do |patient_data_criteria|
          if patient_data_criteria['hqmf_set_id'] && patient_data_criteria['hqmf_set_id'] != hqmf_set_id
            patient_data_criteria['hqmf_set_id'] = hqmf_set_id
            p_hqmf_set_ids_updated += 1
            has_changed = true
          end

          if patient_data_criteria['code_list_id']
            if patient_data_criteria['code_list_id'].include?('-')
              # Extract the correct guid from the measure
              if !measure.nil?
                patient_criteria_updated = false
                patient_criteria_matches = false
                can_use_definition = false
                measure.source_data_criteria.each do |id, measure_criteria|
                  if id == patient_data_criteria['id']
                    if patient_data_criteria['code_list_id'] != measure_criteria['code_list_id']
                      patient_data_criteria['code_list_id'] = measure_criteria['code_list_id']
                      has_changed = true
                      p_code_list_ids_updated += 1
                      patient_criteria_updated = true
                    else
                      patient_criteria_matches = true
                    end
                  else
                      # some ids have inconsistent guids for some reason, but the prefix part still
                      # allows for a mapping.
                      get_id_head = -> (id) {
                          # handle special case with one weird measure
                          if id == 'HBsAg_LaboratoryTestPerformed_40280381_3d61_56a7_013e_7f3878ec7630_source' ||
                             id == 'prefix_5195_3_LaboratoryTestPerformed_2162F856_8C15_499E_AC82_E58B05D4B568_source'
                            id = 'prefix_5195_3_LaboratoryTestPerformed'
                          else
                            # remove the guid and _source from the id
                            id = id[0..id.index(/(_[a-zA-Z0-9]*){5}_source/)]
                          end
                      }
                    patient_id_head = get_id_head.call(patient_data_criteria['id'])
                    measure_id_head = get_id_head.call(id)
                    if patient_id_head == measure_id_head
                      if patient_data_criteria['code_list_id'] != measure_criteria['code_list_id']
                        patient_data_criteria['code_list_id'] = measure_criteria['code_list_id']
                        has_changed = true
                        p_code_list_ids_updated += 1
                        patient_criteria_updated = true
                      else
                        patient_criteria_matches = true
                      end
                    end
                  end
                end

                if !patient_criteria_updated && !patient_criteria_matches
                  # print an error if we have looked at all measure_criteria but still haven't found a match.
                  print_error("#{first} #{last} #{email} Unable to find code list id for #{patient_data_criteria['title']}")
                  errors += 1
                end
              end
            end
          end
        end

        begin
          patient.save!
          if has_changed
            hqmf_set_ids_updated += p_hqmf_set_ids_updated
            code_list_ids_updated += p_code_list_ids_updated
            successes += 1
            print_success("Fixing mismatch on User: #{email}, first: #{first}, last: #{last}")
          end
        rescue Mongo::Error::OperationFailure => e
          errors += 1
          print_error("#{e}: #{email}, first: #{first}, last: #{last}")
        end
      end
      puts "Results".center(80, '-')
      puts "Patients successfully updated: #{successes}"
      puts "Errors: #{errors}"
      puts "Warnings: #{warnings}"
      puts "Hqmf_set_ids Updated: #{hqmf_set_ids_updated}"
      puts "Code_list_ids Updated: #{code_list_ids_updated}"
    end

    # HQMF OIDs were not being stored on patient record entries for data types that only appear in the HQMF R2
    # support; git commit c988d25be480171a8dac5bef02386e5f49f57acb addressed thsi issue for new entries; this
    # rake task goes back and fixes up existing entries; it was run on May 24, 2016

    desc "Update missing HQMF OIDS in patient record entries"
    task :update_missing_hqmf_oids => :environment do
      Record.each do |r|
        conditions_without_oids = r.conditions.select { |cc| cc.oid.nil? }
        if conditions_without_oids.size > 0
          puts "Trying to update OIDs for #{r.first} #{r.last} (#{r.user.try(:email)})"
          conditions_without_oids.each do |cc|
            puts "  Trying to update OID for #{cc.description}"
            # We don't have sufficient data in the entry to re-create the OID (we don't have the definition);
            # we could try to find the matching source data criteria by type and date, but there isn't always
            # a 1-to-1 mapping; because there's limited cases where this happened, we can use a shortcut of
            # looking at the description
            case cc.description
            when /^Diagnosis: /
              cc.oid = HQMF::DataCriteria.template_id_for_definition('diagnosis', nil, false)
              cc.oid ||= HQMF::DataCriteria.template_id_for_definition('diagnosis', nil, false, 'r2')
            when /^Symptom: /
              cc.oid = HQMF::DataCriteria.template_id_for_definition('symptom', nil, false)
              cc.oid ||= HQMF::DataCriteria.template_id_for_definition('symptom', nil, false, 'r2')
            when /^Patient Characteristic Clinical Trial Participant: /
              cc.oid = HQMF::DataCriteria.template_id_for_definition('patient_characteristic', 'clinical_trial_participant', false)
              cc.oid ||= HQMF::DataCriteria.template_id_for_definition('patient_characteristic', 'clinical_trial_participant', false, 'r2')
            else
              puts "DID NOT FIND OID FOR #{cc.description}"
            end
            puts "    Updating OID to #{cc.oid}"
            r.save
          end
        end
      end
    end

    desc "Garbage collect/fix expected_values structures"
    task :expected_values_garbage_collect => :environment do
      # build structures for holding counts of changes
      patient_values_changed_count = 0
      total_patients_count = 0
      user_counts = []
      puts "Garbage collecting/fixing expected_values structures"
      puts ""

      # loop through users
      User.asc(:email).all.each do |user|
        user_count = {email: user.email, total_patients_count: 0, patient_values_changed_count: 0, measure_counts: []}

        # loop through measures
        CqlMeasure.by_user(user).each do |measure|
          measure_count = {cms_id: measure.cms_id, title: measure.title, total_patients_count: 0, patient_values_changed_count: 0}

          # loop through each patient in the measure
          Record.by_user_and_hqmf_set_id(user, measure.hqmf_set_id).each do |patient|
            user_count[:total_patients_count] += 1
            measure_count[:total_patients_count] += 1
            total_patients_count += 1

            # do the updating of the structure
            items_changed = false
            patient.update_expected_value_structure!(measure) do |change_type, change_reason, expected_value_set|
              puts "#{user.email} - #{measure.cms_id} - #{measure.title} - #{patient.first} #{patient.last} - #{change_type} because #{change_reason}"
              pp(expected_value_set)
              items_changed = true
            end

            # if anything was removed print the final structure 
            if items_changed
              measure_count[:patient_values_changed_count] += 1
              user_count[:patient_values_changed_count] += 1
              patient_values_changed_count += 1
              puts "#{user.email} - #{measure.cms_id} - #{measure.title} - #{patient.first} #{patient.last} - FINAL STRUCTURE:"
              pp(patient.expected_values)
              puts ""
            end
          end

          user_count[:measure_counts] << measure_count

        end
        user_counts << user_count
      end

      puts "--- Complete! ---"
      puts ""

      if patient_values_changed_count > 0
        puts "\e[31mexpected_values changed on #{patient_values_changed_count} of #{total_patients_count} patients\e[0m"
        user_counts.each do |user_count|
          if user_count[:patient_values_changed_count] > 0
            puts "#{user_count[:email]} - #{user_count[:patient_values_changed_count]}/#{user_count[:total_patients_count]}"
            user_count[:measure_counts].each do |measure_count|
              print "\e[31m" if measure_count[:patient_values_changed_count] > 0
              puts "  #{measure_count[:patient_values_changed_count]}/#{measure_count[:total_patients_count]} on #{measure_count[:cms_id]} - #{measure_count[:title]}\e[0m"
            end
          end
        end
      else
        puts "\e[32mNo expected_values changed\e[0m"
      end
    end
    
    desc %{Recreates the JSON elm stored on CQL measures using an instance of
      a locally running CQLTranslationService JAR and updates the code_list_id field on
      data_criteria and source_data_criteria for direct reference codes. This is in run_once
      because once all of the code_list_ids have been updated to use a hash of the parameters
      in direct reference codes, all code_list_ids for direct reference codes measures uploaded 
      subsequently will be correct

    $ rake bonnie:patients:rebuild_elm_update_drc_code_list_ids}
    task :rebuild_elm_update_drc_code_list_ids => :environment do
      update_passes = 0
      update_fails = 0
      orphans = 0
      fields_diffs = Hash.new(0)
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

          # Grab a copy of all attributes that we will update the measure with.
          before_state = {}
          before_state[:measure_data_criteria] = measure[:data_criteria].deep_dup
          before_state[:measure_source_data_criteria] = measure[:source_data_criteria].deep_dup
          before_state[:measure_cql] = measure[:cql].deep_dup
          before_state[:measure_elm] = measure[:elm].deep_dup
          before_state[:measure_elm_annotations] = measure[:elm_annotations].deep_dup
          before_state[:measure_cql_statement_dependencies] = measure[:cql_statement_dependencies].deep_dup
          before_state[:measure_main_cql_library] = measure[:main_cql_library].deep_dup
          before_state[:measure_value_set_oids] = measure[:value_set_oids].deep_dup
          before_state[:measure_value_set_oid_version_objects] = measure[:value_set_oid_version_objects].deep_dup

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
                cql_artifacts = Measures::CqlLoader.process_cql(files, main_cql_library, user, nil, nil, nil, nil, nil, nil, measure.hqmf_set_id)
                data_criteria_object['source_data_criteria'], data_criteria_object['data_criteria'] = set_data_criteria_code_list_ids(data_criteria_object, cql_artifacts)
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
            cql_artifacts = Measures::CqlLoader.process_cql(elms, main_cql_library, user, nil, nil, nil, nil, nil, nil, measure.hqmf_set_id)
            data_criteria_object['source_data_criteria'], data_criteria_object['data_criteria'] = set_data_criteria_code_list_ids(data_criteria_object, cql_artifacts)
          end

          # Get a hash of differences from the original measure and the updated data
          differences = measure_update_diff(before_state, data_criteria_object, cql, cql_artifacts, main_cql_library)
          unless differences.empty?
            # Update the measure
            measure.update(data_criteria: data_criteria_object['data_criteria'], source_data_criteria: data_criteria_object['source_data_criteria'], cql: cql, elm: cql_artifacts[:elms], elm_annotations: cql_artifacts[:elm_annotations], cql_statement_dependencies: cql_artifacts[:cql_definition_dependency_structure],
                            main_cql_library: main_cql_library, value_set_oids: cql_artifacts[:all_value_set_oids], value_set_oid_version_objects: cql_artifacts[:value_set_oid_version_objects])
            measure.save!
            update_passes += 1
            print "\e[#{32}m#{"[Success]"}\e[0m"
            puts ' Measure ' + "\e[1m#{measure[:cms_id]}\e[22m" + ': "' + measure[:title] + '" with id ' + "\e[1m#{measure[:id]}\e[22m" + ' in account ' + "\e[1m#{user[:email]}\e[22m" + ' successfully updated ELM!'
            differences.each do |key, value|
              fields_diffs[key] += 1
              puts "--- #{key} --- Has bee modified"
            end
          end
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
      puts "Overall number of fields changed."
      fields_diffs.each do |key, value|
        puts "-- #{key}: #{value} --"
      end
    end
    
    def self.set_data_criteria_code_list_ids(json, cql_artifacts)
      # Loop over data criteria to search for data criteria that is using a single reference code.
      # Once found set the Data Criteria's 'code_list_id' to our fake oid. Do the same for source data criteria.
      json['data_criteria'].each do |data_criteria_name, data_criteria|
        # We do not want to replace an existing code_list_id. Skip it, unless it is a GUID.
        if !data_criteria.key?('code_list_id') || (data_criteria['code_list_id'] && data_criteria['code_list_id'].include?('-'))
          if data_criteria['inline_code_list']
            # Check to see if inline_code_list contains the correct code_system and code for a direct reference code.
            data_criteria['inline_code_list'].each do |code_system, code_list|
              # Loop over all single code reference objects.
              cql_artifacts[:single_code_references].each do |single_code_object|
                # If Data Criteria contains a matching code system, check if the correct code exists in the data critera values.
                # If both values match, set the Data Criteria's 'code_list_id' to the single_code_object_guid.
                if code_system == single_code_object[:code_system_name] && code_list.include?(single_code_object[:code])
                  data_criteria['code_list_id'] = single_code_object[:guid]
                  # Modify the matching source data criteria
                  json['source_data_criteria'][data_criteria_name + "_source"]['code_list_id'] = single_code_object[:guid]
                end
              end
            end
          end
        end
      end
      return json['source_data_criteria'], json['data_criteria']
    end
    
    # Builds a hash of differences between the existing measure data and the new data
    def self.measure_update_diff(before_state, data_criteria_object, cql, cql_artifacts, main_cql_library)
      differences = {}
      if Digest::MD5.hexdigest(before_state[:measure_data_criteria].to_json) != Digest::MD5.hexdigest(data_criteria_object['data_criteria'].to_json)
        differences['Data Criteria'] = data_criteria_object['data_criteria']
      end
      if Digest::MD5.hexdigest(before_state[:measure_source_data_criteria].to_json) != Digest::MD5.hexdigest(data_criteria_object['source_data_criteria'].to_json)
        differences['Source Data Criteria'] = data_criteria_object['source_data_criteria']
      end
      if Digest::MD5.hexdigest(before_state[:measure_cql].to_json) != Digest::MD5.hexdigest(cql.to_json)
        differences['CQL'] = cql
      end
      if Digest::MD5.hexdigest(before_state[:measure_elm].to_json) != Digest::MD5.hexdigest(cql_artifacts[:elms].to_json)
        differences['ELM'] = cql_artifacts[:elms]
      end
      if Digest::MD5.hexdigest(before_state[:measure_elm_annotations].to_json) != Digest::MD5.hexdigest(cql_artifacts[:elm_annotations].to_json)
        differences['ELM Annotations'] = cql_artifacts[:elm_annotations]
      end
      if Digest::MD5.hexdigest(before_state[:measure_cql_statement_dependencies].to_json) != Digest::MD5.hexdigest(cql_artifacts[:cql_definition_dependency_structure].to_json)
        differences['CQL Definition Statement Dependencies'] = cql_artifacts[:cql_definition_dependency_structure]
      end
      if Digest::MD5.hexdigest(before_state[:measure_main_cql_library].to_json) != Digest::MD5.hexdigest(main_cql_library.to_json)
        differences['Main CQL Library'] = main_cql_library
      end
      if Digest::MD5.hexdigest(before_state[:measure_value_set_oids].to_json) != Digest::MD5.hexdigest(cql_artifacts[:all_value_set_oids].to_json)
        differences['All Value Set Oids'] = cql_artifacts[:all_value_set_oids]
      end
      if Digest::MD5.hexdigest(before_state[:measure_value_set_oid_version_objects].to_json) != Digest::MD5.hexdigest(cql_artifacts[:value_set_oid_version_objects].to_json)
        differences['Value Set Oid Version Objects'] = cql_artifacts[:value_set_oid_version_objects]
      end
      differences
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
end
