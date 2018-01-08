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
              potential_matches = 0
              if !measure.nil?
                patient_criteria_updated = false
                can_use_definition = false
                measure.source_data_criteria.each do |id, measure_criteria|
                  if id == patient_data_criteria['id']
                    patient_data_criteria['code_list_id'] = measure_criteria['code_list_id']
                    has_changed = true
                    p_code_list_ids_updated += 1
                    patient_criteria_updated = true
                  elsif measure_criteria['title'] == patient_data_criteria['title']
                    patient_data_criteria['code_list_id'] = measure_criteria['code_list_id']
                    print_warning("#{first} #{last} #{email} Using title to match code_list_id for #{patient_data_criteria['title']}")
                    warnings += 1
                    has_changed = true
                    p_code_list_ids_updated += 1
                    patient_criteria_updated = true
                  elsif measure_criteria['definition'] == patient_data_criteria['definition']
                    # Only use this if it is the only measure_criteria with this definition.
                    # TODO: Only implement if we have to; currently no patients are hitting this case.
                    can_use_definition = true
                  end
                end

                if !patient_criteria_updated
                  if can_use_definition
                    print_warning("#{first} #{last} #{email} Able to use DEFINITION to match code_list_id for #{patient_data_criteria['title']}")
                  else
                    # print an error if we have looked at all measure_criteria but still haven't found a match.
                    print_error("#{first} #{last} #{email} Unable to find code list id for #{patient_data_criteria['title']}")
                    errors += 1
                  end
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
  end
end
