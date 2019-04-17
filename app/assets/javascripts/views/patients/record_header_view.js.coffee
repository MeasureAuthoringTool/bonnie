class Thorax.Views.RecordHeader extends Thorax.Views.BonnieView
  template: JST['patients/record_header']
  patientGender: -> @model.getGender()
  patientBirthdate: -> @model.getBirthdate()
  patientExpirationDate: -> if @model.get('expired') then @model.getExpirationDate()
  patientRace: -> @model.getRace()
  patientEthnicity: -> @model.getEthnicity()
  patientInsurance: -> @model.getInsurance()
  patientAddresses: -> @model.getAddresses()
  patientFirstName: -> @model.getFirstName()
  patientLastName: -> @model.getLastName()
  currentTime: -> new Date()
