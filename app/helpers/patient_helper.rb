module PatientHelper
  
  # HDS Patient to QDM Patient model translation
  def self.convert_patient_models(hds_records)
    qdm_records = []
    hds_records.each do |hds_record|
      # Convert the HDS Record into a QDM Patient.
      qdm_record = CQMConverter.to_qdm(hds_record)
      qdm_records << qdm_record
    end
    qdm_records
  end
end
