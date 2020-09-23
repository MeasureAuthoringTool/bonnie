# Small view to detect and display codes that are selected in the patient elements that are not present in any
# value sets for this measure; the view is passed a patient and a measure, which are available in the @patient
# and @measure instance variables, which we just use to set up the appropriate context
class Thorax.Views.ValueSetCodeChecker extends Thorax.Views.BonnieView

  template: JST['patient_builder/value_set_code_checker']

  initialize: ->
    # If patient has changed, the problem might be fixed, so re-render
    @patient.on 'materialize', => @render()

  context: ->
    # Go through each data element on the patient and examine the codes, looking for those not in any
    # measure value set; at the moment, we just note the data criteria don't have ANY codes in a value set
    dataElementWithMissingCodes = []
    for dataElement in @patient.get('cqmPatient').data_elements || []
      appliedCodes = []
      for attr, value of dataElement.fhir_resource
        @getCodes(value, appliedCodes)

      for coding in appliedCodes
        dataElementWithMissingCodes.push "#{dataElement.description} - #{coding.system}:#{coding.code}" unless @measure.hasCode(coding.code, coding.system) && dataElement.description

    console.log("data elements with unsupported codes:" + dataElementWithMissingCodes.length > 0)
    hasElementsWithMissingCodes: dataElementWithMissingCodes.length > 0
    elementsWithMissingCodes: dataElementWithMissingCodes

  ###
  Recursively walks the object tree to locate all instances of type Coding, and
  extract the Code's system and code value, since there is no consistent depth
  or naming scheme to readily isolate applied Codes across FHIR Resources.
  ###
  getCodes: (attr, codes) ->
    if cqm.models.Coding.isCoding(attr)
      codes.push({system:attr.system?.value, code:attr.code?.value})
    else if Array.isArray(attr)
      for a in attr
        @getCodes(a, codes)
    else if typeof(attr) == "object"
      for k,v of attr
        @getCodes(v, codes)
    return codes
