class Thorax.Views.RecordHeader extends Thorax.View  
  template: JST['patients/record_header']
  patientGender: -> @model.getGender()
  patientBirthdate: -> @model.getBirthdate()
  patientExpirationDate: -> if @model.get('expired') then @model.getExpirationDate()
  patientRace: -> @model.getRace()
  patientEthnicity: -> @model.getEthnicity()
  patientInsurance: -> @model.getInsurance()
  patientAddresses: -> @model.getAddresses()
  currentTime: -> new Date()