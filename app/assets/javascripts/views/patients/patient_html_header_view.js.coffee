class Thorax.Views.PatientHtmlHeader extends Thorax.View  
  template: JST['patients/patient_html_header']
  patientGender: -> @model.getGender()
  patientBirthdate: -> @model.getBirthdate()
  patientExpirationDate: -> if @model.attributes.expired then @model.getExpirationDate()
  patientRace: -> @model.getRace()
  patientEthnicity: -> @model.getEthnicity()
  patientInsurance: -> @model.getInsurance()
  patientAddresses: -> @model.getAddresses()
  currentTime: -> new Date()