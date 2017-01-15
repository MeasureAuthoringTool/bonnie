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

  end
end
