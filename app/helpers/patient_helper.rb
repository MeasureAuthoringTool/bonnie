module PatientHelper
  # HDS Patient to CQM Patient model translation
  def self.convert_patient_models(hds_records)
    cqm_records = []
    failed_records = []

    # Convert all of the HDS Records into CQM Records
    hds_records.each do |hds_record|
      begin
        cqm_record = CQMConverter.to_cqm(hds_record)
        cqm_record.qdmPatient._id = hds_record._id if hds_record._id? # keep ids consistent
        cqm_records << cqm_record
      rescue ExecJS::ProgramError => e
        # if there was a conversion failure we should record the resulting failure message with the hds model in a
        # separate collection to return
        failed_records << { hds_record: hds_record, error_message: e.message }
      end
    end

    # Return both successful and failed records
    [cqm_records, failed_records]
  end
end
