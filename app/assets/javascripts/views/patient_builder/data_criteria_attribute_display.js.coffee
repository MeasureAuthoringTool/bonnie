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
    # FIXME: value: attr.getValue(@dataElement.fhir_resource)
    # or value: attr.getValue(@dataElement.dataElement.fhir_resource)
    DataCriteriaHelpers.getAttributes(@dataElement).forEach (attr, index, array) =>
      value = attr.getValue(@dataElement.fhir_resource)
      if !!value?
        stringValue = "#{@_stringifyValue(value, true)}"
        displayAttributes.push({ name: attr.path, title: attr.title, value: stringValue })
    # TODO: revisit for FHIR attributes
#    @dataElement.schema.eachPath (path, info) =>
#      # go on to the next one if it is an attribute that should be skipped or is null
#      return if Thorax.Models.SourceDataCriteria.SKIP_ATTRIBUTES.includes(path) || !@dataElement[path]?
#
#      # if is array type we need to list each element
#      if info.instance == 'Array'
#        @dataElement[path].forEach (elem, index) =>
#          if path == 'relatedTo'
#            id = elem
#            display = Thorax.Views.InputRelatedToView.getDisplayFromId(@parent.model.collection.parent.get('source_data_criteria'), id)
#            value = "#{@_stringifyValue(display.description, true)} #{@_stringifyValue(display.timing, true)}"
#            displayAttributes.push({ name: path, title: @model.getAttributeTitle(path), value: value, isArrayValue: true, index: index })
#          else
#            displayAttributes.push({ name: path, title: @model.getAttributeTitle(path), value: @_stringifyValue(elem, true), isArrayValue: true, index: index })
#      else
#        if path == 'relatedTo'
#          id = @dataElement[path]
#          display = Thorax.Views.InputRelatedToView.getDisplayFromId(@parent.model.collection.parent.get('source_data_criteria'), id)
#          value = "#{@_stringifyValue(display.description, true)} #{@_stringifyValue(display.timing, true)}"
#          timing = displayAttributes.push({ name: path, title: @model.getAttributeTitle(path), value: value })
#        else
#          displayAttributes.push({ name: path, title: @model.getAttributeTitle(path), value: @_stringifyValue(@dataElement[path], true) })

    _(super).extend
      displayAttributes: displayAttributes

  # string representation of an attribute value
  _stringifyValue: (value, topLevel=false) ->
    if !value?
      return 'null'

    if value instanceof cqm.models.Coding
      codeSystemName = @parent.measure.codeSystemMap()[value?.system?.value] || value?.system?.value
      return "#{codeSystemName}: #{value?.code?.value}"

    if value instanceof cqm.models.Duration
      return "#{value?.value?.value} '#{value?.unit?.value}'"

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
    attributeIndex = $(e.target).data('attribute-index')
    DataCriteriaHelpers.getAttribute(@dataElement, attributeName)?.setValue(@dataElement.fhir_resource, null)
    # if we are removing an element in an array attribute
#    if attributeIndex != undefined
#      @dataElement[attributeName].splice(attributeIndex, 1);
#    else # we are removing an attribute
#      @dataElement[attributeName] = null
    # TODO arrays are not supported

    @trigger 'attributesModified', @

