@NegationHelpers = class NegationHelpers

  @QICORE_RECORDED_URL = 'http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-recorded'
  @QICORE_NOT_DONE_URL = 'http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-notDone'
  @VALUESET_REFERENCE_URL = 'http://hl7.org/fhir/StructureDefinition/valueset-reference'

  # check if resource can have negation
  @canHaveNegation: (resourceType) ->
    ['Communication'].indexOf(resourceType) != -1

  @getCodeableConcept: (coding) ->
    return undefined unless coding?
    codeableConcept = new cqm.models.CodeableConcept()
    codeableConcept.coding = [coding]
    codeableConcept

  @setRecordedExtention: (value, resource) ->
    if value
      if resource.extension
        recorded = resource.extension.find((extension) -> extension.url?.value == NegationHelpers.QICORE_RECORDED_URL )
        if recorded
          recorded.value = value
        else
          resource.extension.push(@createExtension(value.value, 'DateTime', NegationHelpers.QICORE_RECORDED_URL))
      else
        resource.extension = [ @createExtension(value.value, 'DateTime', NegationHelpers.QICORE_RECORDED_URL) ]
    else
      resource.extension = resource.extension.filter(
        (extension) -> extension.url?.value != NegationHelpers.QICORE_RECORDED_URL)

  @createExtension: (value, valueType, url) ->
    cqm.models.Extension.parse({
      url: url,
      "value#{valueType}": value
    })

  @setResonCodeExtension: (reasonCodeView, resource) ->
    if reasonCodeView.value
      coding = reasonCodeView.value
      coding.extension = [ @createExtension(reasonCodeView.valueSet?.url, 'Uri', @VALUESET_REFERENCE_URL) ]
      resource.reasonCode = [@getCodeableConcept(coding)]
    else
      resource.reasonCode = undefined

  @getRecordedDate: (resource) ->
    dateRecordedExtension = resource.extension?.find(
      (extension) -> extension.url?.value == NegationHelpers.QICORE_RECORDED_URL)
    dateRecordedExtension?.value

  @isResourceNegated: (resource) ->
    if resource.resourceType == 'Communication'
      resource.modifierExtension?.some((extension) -> extension.url?.value == NegationHelpers.QICORE_NOT_DONE_URL)
