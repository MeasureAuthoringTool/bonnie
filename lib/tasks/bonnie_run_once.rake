# This rakefile is for tasks that are designed to be run once to address a specific problem; we're keeping
# them as a history and as a reference for solving related problems

namespace :bonnie do
  namespace :patients do

    desc %{Update source_data_criteria to match fields from measure

    $ rake bonnie:patients:update_source_data_criteria}
    task :update_source_data_criteria=> :environment do
      puts "Updating patient source_data_criteria to match measure"
      p_hqmf_set_ids_updated, hqmf_set_ids_updated = 0, 0
      successes = 0
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

        patient.source_data_criteria.each do |patient_data_criteria|
          if patient_data_criteria['hqmf_set_id'] && patient_data_criteria['hqmf_set_id'] != hqmf_set_id
            patient_data_criteria['hqmf_set_id'] = hqmf_set_id
            p_hqmf_set_ids_updated += 1
            has_changed = true
          end
        end

        begin
          patient.save!
          if has_changed
            hqmf_set_ids_updated += p_hqmf_set_ids_updated
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
      puts "Hqmf_set_ids Updated: #{hqmf_set_ids_updated}"
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
