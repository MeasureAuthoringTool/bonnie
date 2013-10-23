class Thorax.Views.PatientHtmlHeader extends Thorax.View
  
  template: JST['patients/patient_html_header']

  patientGender: -> @model.getGender()

  patientBirthdate: -> @printDate(@model.attributes.birthdate)

  patientExpirationDate: -> if @model.attributes.expired then @printDate(@model.attributes.deathdate)

  patientRace: -> @model.getRace()

  patientEthnicity: -> @model.getEthnicity()

  patientInsurance: -> @model.getInsurance()

  patientAddresses: -> @model.getAddresses()

  currentTime: -> new Date()

  printDate: (date) ->
    fullDate = new Date(date * 1000)
    (fullDate.getMonth() + 1) + '/' + fullDate.getDay() + '/' + fullDate.getYear()