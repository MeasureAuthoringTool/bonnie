module PatientHelper
  
  # HDS Patient to QDM Patient model translation
  def self.convert_patient_models(hds_records)
    # Convert all of the HDS Records into QDM Records
    hds_records.map { |hds_record| CQMConverter.to_qdm(hds_record) }
  end
end
