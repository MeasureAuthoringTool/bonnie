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
    DataCriteriaHelpers.getAttributes(@dataElement).forEach (attr, index, array) =>
      value = attr.getValue(@dataElement.fhir_resource)
      return if !value?
      stringValue = "#{@_stringifyValue(value, true)}"
      displayAttributes.push({ name: attr.path, title: attr.title, value: stringValue })
#      if attr.isArrayValue
#        value.forEach(elem, index) =>
#          displayAttributes.push({ name: path, title: attr.title, value: @_stringifyValue(elem, true), isArrayValue: true, index: index })
#      else
#        stringValue = "#{@_stringifyValue(value, true)}"
#        displayAttributes.push({ name: attr.path, title: attr.title, value: stringValue })

    _(super).extend
      displayAttributes: displayAttributes

  # string representation of an attribute value
  _stringifyValue: (value, topLevel=false) ->
    if !value?
      return 'null'

    if value instanceof cqm.models.Coding
      codeSystemName = @parent.measure.codeSystemMap()[value?.system?.value] || value?.system?.value
      return "#{codeSystemName}: #{value?.code?.value}"

    if value instanceof cqm.models.PrimitiveCode || value instanceof cqm.models.PrimitiveString
      return "#{value?.value}"

    if value instanceof cqm.models.Duration || value instanceof cqm.models.Age
      return "#{value?.value?.value} '#{value?.unit?.value}'"

    if value instanceof cqm.models.Range
      return "#{value?.low} - #{value?.high}"

    if value instanceof cqm.models.Period
      lowString = if value.start? then @_stringifyValue(value.start) else "null"
      highString = if value.end? then @_stringifyValue(value.end) else "null"
      return "#{lowString} - #{highString}"

    if value instanceof cqm.models.PrimitiveDateTime
      cqlValue = DataCriteriaHelpers.getCQLDateTimeFromString(value?.value)
      return moment.utc(cqlValue.toJSDate()).format('L LT')

#    # Date, DateTime or Time
#    else if value.isDateTime
#      if value.isTime() # if it is a "Time"
#        # The year, month, day get discarded so don't matter
#        return moment(new Date(2020, 1, 1, value.hour, value.minute, value.second)).format('LT')
#      else
#        return moment.utc(value.toJSDate()).format('L LT')
#    else if value.isDate
#      return moment.utc(value.toJSDate()).format('L')
#
#    # if this appears to be a mongoose complex type
#    else if value.schema?
#      attrStrings = []
#      value.schema.eachPath (path, info) =>
#        return if _.without(Thorax.Models.SourceDataCriteria.SKIP_ATTRIBUTES, 'id').includes(path)
#        attrStrings.push @model.getAttributeTitle(path) + ": " + @_stringifyValue(value[path])
#      attrString = attrStrings.join(', ')
#      if value._type? && value._type != 'QDM::Identifier'
#        attrString = "[#{value._type.replace('QDM::','')}] #{attrString}"
#      if !topLevel
#        attrString = "{ #{attrString} }"
#      return attrString
#
#    # if this is an interval
#    else if value.isInterval
#      lowString = if value.low? then @_stringifyValue(value.low) else "null"
#      highString = if value.high? then @_stringifyValue(value.high) else "null"
#      return "#{lowString} - #{highString}"
#
#    else
#      return value.toString()
    return JSON.stringify(value)

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

