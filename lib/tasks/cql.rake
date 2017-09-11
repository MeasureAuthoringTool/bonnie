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
          # Grab the measure cql
          if measure[:cql].instance_of?(Array) # New type of measure
            cql = measure[:cql]
          elsif measure[:cql].instance_of?(String) # Old type of measure
            cql = [measure[:cql]]
          end
          # Grab the name of the main cql library
          if measure[:main_cql_library].present?
            # Old measure! Grab the main_cql_library name from the ELM
            main_cql_library = measure[:main_cql_library]
          else
            main_cql_library = elms.first['library']['identifier']['id']
          end

          cql_artifacts = Measures::CqlLoader.process_cql(cql, main_cql_library, user)

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
          converted_start_time = Time.at(start_time).getutc().strftime("%m/%d/%y %I:%M %p")
        else
          converted_start_time = nil
        end

        if end_time
          converted_end_time = Time.at(end_time).getutc().strftime("%m/%d/%y %I:%M %p")
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
                  new_diagnosis['field_title'] = source_data_criterium['field_values']['DIAGNOSIS']['field_title']
                  new_diagnosis['values'] = [{}]
                  new_diagnosis['values'][0]['type'] = 'CD'
                  new_diagnosis['values'][0]['key'] = 'DIAGNOSIS'
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
                    converted_start_date = Time.at(old_start_time).getutc().strftime('%m/%d/%y')
                    converted_start_time = Time.at(old_start_time).getutc().strftime('%I:%M %p')
                  end
                  new_facility_location['values'][0]['start_date'] = converted_start_date
                  new_facility_location['values'][0]['start_time'] = converted_start_time

                  converted_end_date = nil
                  converted_end_time = nil
                  if source_data_criterium['field_values']['FACILITY_LOCATION_DEPARTURE_DATETIME'] 
                    old_end_time = source_data_criterium['field_values']['FACILITY_LOCATION_DEPARTURE_DATETIME']['value']
                    converted_end_date = Time.at(old_end_time).getutc().strftime('%m/%d/%y')
                    converted_end_time = Time.at(old_end_time).getutc().strftime('%I:%M %p')
                  end
                  new_facility_location['values'][0]['end_date'] = converted_end_date
                  new_facility_location['values'][0]['end_time'] = converted_end_time

                  # Reassign
                  new_source_data_criterium_field_values['FACILITY_LOCATION'] = new_facility_location 
                elsif !(field_value_key == 'FACILITY_LOCATION_ARRIVAL_DATETIME' || field_value_key == 'FACILITY_LOCATION_DEPARTURE_DATETIME')
                  # add unaltered field value to new structure, unless it's a time we already used above
                  new_source_data_criterium_field_values[field_value_key] = field_value_value
                else
                  # There was an arrival/depature time without a code, remove them
                  if field_value_key == 'FACILITY_LOCATION_ARRIVAL_DATETIME'
                    print_helper("-Arrival", patient)
                  else
                    print_helper("-Departure", patient)
                  end
                  new_source_data_criterium_field_values.delete(field_value_key)
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
end
