# Small view to detect and display codes that are selected in the patient elements that are not present in any
# value sets for this measure; the view is passed a patient and a measure, which are available in the @patient
# and @measure instance variables, which we just use to set up the appropriate context
class Thorax.Views.ValueSetCodeChecker extends Thorax.Views.BonnieView

  template: JST['patient_builder/value_set_code_checker']

  initialize: ->
    # If patient has changed, the problem might be fixed, so re-render
    @patient.on 'materialize', => @render()

  context: ->
    # Go through each source data criteria on the patient and examine the codes, looking for those not in any
    # measure value set; at the moment, we just note the data criteria don't have ANY codes in a value set
    missingCodes = []
    @patient.get('source_data_criteria').each (dc) =>
      if (dc.get('codes').all (code) => !@measure.hasCode(code.get('code'), code.get('codeset')))
        missingCodes.push dc.get('description')

    hasElementsWithMissingCodes: missingCodes.length > 0
    elementsWithMissingCodes: missingCodes
