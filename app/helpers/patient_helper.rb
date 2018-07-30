module PatientHelper
  
  # HDS Patient to QDM Patient model translation
  def self.convert_patient_models(hds_records)
    qdm_records = []
    failed_records = []

    # Convert all of the HDS Records into QDM Records
    hds_records.each do |hds_record|
      begin
        qdm_record = CQMConverter.to_qdm(hds_record)
        qdm_record._id = hds_record._id if hds_record._id? # keep ids consistent
        qdm_records << qdm_record
      rescue ExecJS::ProgramError => e
        # if there was a conversion failure we should record the resulting failure message with the hds model in a
        # separate collection to return
        failed_records << { hds_record: hds_record, error_message: e.message }
      end
    end

    # Return both successful and failed records
    [qdm_records, failed_records]
  end
end
