module PatientHelper

  def html_for_patient(patient)
    patient_exporter = HealthDataStandards::Export::HTML.new
    patient_exporter.export(patient)
  end

end