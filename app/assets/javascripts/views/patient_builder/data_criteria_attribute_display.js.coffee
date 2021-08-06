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
    DataCriteriaHelpers.getAttributes(@dataElement).forEach (attrDef) =>
      value = attrDef.getValue(@dataElement.fhir_resource)
      return if !value?
      codeSystemMap = @parent.measure.codeSystemMap()
      if Array.isArray(value)
        value.forEach (elem, index) =>
          stringValue = "#{DataCriteriaHelpers.stringifyType(elem, codeSystemMap)}"
          displayAttributes.push({ name: attrDef.path, title: attrDef.path, value: stringValue, isArrayValue: true, index: index })
      else
        stringValue = "#{DataCriteriaHelpers.stringifyType(value, codeSystemMap)}"
        displayAttributes.push({ name: attrDef.path, title: attrDef.path, value: stringValue })

    _(super).extend
      displayAttributes: displayAttributes

  # button click handler for removing an attribute or element in a list attribute
  removeValue: (e) ->
    attributeName = $(e.target).data('attribute-name')
    attributeIndex = $(e.target).data('attribute-index')

    attrDef = DataCriteriaHelpers.getAttribute(@dataElement, attributeName)
    if attributeIndex != undefined
      attrDef.getValue(@dataElement.fhir_resource).splice(attributeIndex, 1)
    else
      attrDef.setValue(@dataElement.fhir_resource, null)

    @trigger 'attributesModified', @

