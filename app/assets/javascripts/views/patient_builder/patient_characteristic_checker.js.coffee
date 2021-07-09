# Small view to detect and display patient characteristics that are selected in the patient that are not contained in the
# measure; the view is passed a patient and a measure, which are available in the @patient
# and @measure instance variables, which we just use to set up the appropriate context
class Thorax.Views.PatientCharacteristicChecker extends Thorax.Views.BonnieView

  template: JST['patient_builder/patient_characteristic_checker']

  initialize: ->
    # If patient has changed, the problem might be fixed, so re-render
    @patient.on 'materialize', => @render()

  context: ->
    # Go through Birthdate and Deathdate elements on the patient and examine the patient characteristics, 
    # looking for those not in the measure; 
    birthdate = @patient.getBirthDate()
    expired = @patient.get('expired')
    expiredDataElement = (@patient.get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'expired')[0]
    birthdateDataElement = (@patient.get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'birthdate')[0]
    
    missingCharacteristics = []
    if birthdate and !birthdateDataElement
      missingCharacteristics.push "Patient Characteristic Birthdate"
    if expired and !expiredDataElement
      missingCharacteristics.push "Patient Characteristic Expired"

    hasMissingCharacteristicDataType: missingCharacteristics.length > 0
    missingCharacteristicsElements: missingCharacteristics
