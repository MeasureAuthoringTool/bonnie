###*
# Small view to detect and display codes that are selected in the patient elements that are not present in any
# value sets for this measure; the view is passed a measure as the model. This view provides a warning box for
# warning the user, and to provide a way to fix this issue.
###
class Thorax.Views.PatientsValueSetCodeChecker extends Thorax.Views.BonnieView

  template: JST['patients_value_set_code_checker']

  initialize: ->
    # If patient has changed, the problem might be fixed, so re-render
    @patients = @model.get('patients')

  context: ->
    # Go through each source data criteria on the patient and examine the codes, looking for those not in any
    # measure value set; at the moment, we just note the data criteria don't have ANY codes in a value set
    missingCodes = []
        
    @patients.each((patient) =>
      patient.get('source_data_criteria').each (sourceDataCriteria) =>
        if (sourceDataCriteria.get('codes').all (code) => !@model.hasCode(code.get('code'), code.get('codeset')))
          missingCodes.push sourceDataCriteria.get('description') if missingCodes.indexOf(sourceDataCriteria.get('description')) < 0 )
    
    hasElementsWithMissingCodes: missingCodes.length > 0
    elementsWithMissingCodes: missingCodes
