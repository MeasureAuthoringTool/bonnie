# This rakefile is for tasks that are designed to be run once to address a specific problem; we're keeping
# them as a history and as a reference for solving related problems

namespace :bonnie do
  namespace :patients do

    # HQMF OIDs were not being stored on patient record entries for data types that only appear in the HQMF R2
    # support; git commit c988d25be480171a8dac5bef02386e5f49f57acb addressed this issue for new entries; this
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

    # Medication orders previously contained fulfillment histories. This actually
    # doesn't make sense as an order is a future concept and a fulfillment history
    # is what happened. This also does not align with the QDM specification.
    # This became an issue when trying to do QRDA exports because the 
    # medication order QDM model did not support fulfillment history information.
    # The UI for medication orders was changed to align with QDM, but previously
    # entered medication orders still have fulfillment history which is no longer
    # editable in the UI and affects calculations.
    #
    # The script below removes the fulfillment history information. This will likely
    # make patients fail. We will need to send out an email when we make this change.
    desc 'Converts Medication Order fulfillment histories to allowed administrations'
    task :convert_fulfillment_history => :environment do
      Record.where({"medications.description" => /^Medication, Order/, "medications.fulfillmentHistory" => {'$ne' => []}}).each do |r|
        puts "\nRECORD " + r._id
        
        user = User.find(r.user_id)
        measure = Measure.where(:hqmf_set_id => r.measure_ids[0], :user_id => r.user_id).first
        puts user.email
        puts measure[:cms_id]
        puts r.first + ' ' + r.last
        
        # remove information from the medication list directly on the patient
        for medication in r.medications
          if medication[:description].match(/^Medication, Order/) && medication[:fulfillmentHistory].count > 0
            puts "\tResetting medication " + medication.description
            medication.fulfillmentHistory = []
            medication.dose = nil
            medication.administrationTiming = nil
          end
        end
        
        # remove information from the source data criteria patient history
        for sdc in r.source_data_criteria
          if sdc[:description] && sdc[:description].match(/^Medication, Order/) && sdc[:fulfillments] && sdc[:fulfillments].count > 0
            puts "\tResetting source data criteria " + sdc[:description]
            sdc[:fulfillments] = []
            sdc[:dose_value] = ""
            sdc[:dose_unit] = ""
            sdc[:frequency_value] = ""
            sdc[:frequency_unit] = ""
          end
        end
        
        # get rid of the cached calc results
        r.calc_results = []
        
        r.save
        
      end

    end

  end
end
