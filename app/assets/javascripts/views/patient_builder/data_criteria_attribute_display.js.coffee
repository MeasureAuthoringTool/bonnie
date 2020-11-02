# View for displaying the attributes on the data element / source data criteria
class Thorax.Views.DataCriteriaAttributeDisplayView extends Thorax.Views.BonnieView
  template: JST['patient_builder/data_criteria_attribute_display']

  # Expected options to be passed in using the constructor options hash:
  #   model - Thorax.Models.SourceDataCriteria - The source data criteria we are displaying attributes for
  initialize: ->
    @dataElement = @model.get('dataElement')
    @hasUserConfigurableAttributes = !!DataCriteriaHelpers.getAttributes(@dataElement)

  context: ->
    # build list of non-null attributes and their string representation
    displayAttributes = []
    DataCriteriaHelpers.getAttributes(@dataElement).forEach (attr) =>
      value = attr.getValue(@dataElement.fhir_resource)
      return if !value?
      codeSystemMap = @parent.measure.codeSystemMap()
      stringValue = "#{DataCriteriaHelpers.stringifyType(value, codeSystemMap)}"
      displayAttributes.push({ name: attr.path, title: attr.title, value: stringValue })

    _(super).extend
      displayAttributes: displayAttributes

  # button click handler for removing an attribute or element in a list attribute
  removeValue: (e) ->
    attributeName = $(e.target).data('attribute-name')
#    attributeIndex = $(e.target).data('attribute-index')

    attr = DataCriteriaHelpers.getAttribute(@dataElement, attributeName)
    attr?.setValue(@dataElement.fhir_resource, null)
    #    # if we are removing an element in an array attribute
#    if attributeIndex != undefined
#      asArray = attr.getValue(@dataElement.fhir_resource)
#      asArray.splice(attributeIndex, 1)
#      asArray?.setValue(@dataElement.fhir_resource, asArray)
#    else # we are removing an attribute
#      attr?.setValue(@dataElement.fhir_resource, null)

    @trigger 'attributesModified', @

