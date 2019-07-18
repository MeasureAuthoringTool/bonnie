# View for displaying the attributes on the data element / source data criteria
class Thorax.Views.DataCriteriaAttributeDisplayView extends Thorax.Views.BonnieView
  template: JST['patient_builder/data_criteria_attribute_display']

  # Expected options to be passed in using the constructor options hash:
  #   model - Thorax.Models.SourceDataCriteria - The source data criteria we are displaying attributes for
  initialize: ->
    @dataElement = @model.get('qdmDataElement')
    @hasUserConfigurableAttributes = false
    @dataElement.schema.eachPath (path, info) =>
      # go on to the next one if it is an attribute that should be skipped
      return if Thorax.Models.SourceDataCriteria.SKIP_ATTRIBUTES.includes(path)
      @hasUserConfigurableAttributes = true

  context: ->
    # build list of non-null attributes and their string representation
    displayAttributes = []
    @dataElement.schema.eachPath (path, info) =>
      # go on to the next one if it is an attribute that should be skipped or is null
      return if Thorax.Models.SourceDataCriteria.SKIP_ATTRIBUTES.includes(path) || !@dataElement[path]?

      # if is array type we need to list each element
      if info.instance == 'Array'
        @dataElement[path].forEach (elem, index) =>
          displayAttributes.push({ name: path, title: @model.getAttributeTitle(path), value: @_stringifyValue(elem, true), isArrayValue: true, index: index })
      else
        displayAttributes.push({ name: path, title: @model.getAttributeTitle(path), value: @_stringifyValue(@dataElement[path], true) })

    _(super).extend
      displayAttributes: displayAttributes

  _stringifyValue: (value, topLevel=false) ->
    if value instanceof cqm.models.CQL.Code
      codeSystemName = @parent.measure.codeSystemMap()[value.system] || value.system
      return "#{codeSystemName}: #{value.code}"

    # Date, DateTime or Time
    else if value.isDateTime
      if value.isTime() # if it is a "Time"
        # The year, month, day get discarded so don't matter
        return moment(new Date(2012, 1, 1, value.hour, value.minute, value.second)).format('LT')
      else
        return moment.utc(value.toJSDate()).format('L LT')
    else if value.isDate
      return moment.utc(value.toJSDate()).format('L')

    # if this appears to be a mongoose complex type
    else if value.schema?
      attrStrings = []
      value.schema.eachPath (path, info) =>
        return if _.without(Thorax.Models.SourceDataCriteria.SKIP_ATTRIBUTES, 'id').includes(path) || !value[path]?
        attrStrings.push @model.getAttributeTitle(path) + ": " + @_stringifyValue(value[path])
      attrString = attrStrings.join(', ')
      if value._type?
        attrString = "[#{value._type.replace('QDM::','')}] #{attrString}"
      if !topLevel
        attrString = "{ #{attrString} }"
      return attrString

    # if this is an interval
    else if value.isInterval
      lowString = if value.low? then @_stringifyValue(value.low) else "null"
      highString = if value.high? then @_stringifyValue(value.high) else "null"
      return "#{lowString} - #{highString}"

    else
      return value.toString()

  # button click handler for removing an attribute or element in a list attribute
  removeValue: (e) ->
    attributeName = $(e.target).data('attribute-name')
    attributeIndex = $(e.target).data('attribute-index')

    # if we are removing an element in an array attribute
    if attributeIndex != undefined
      @dataElement[attributeName].splice(attributeIndex, 1);
    else # we are removing an attribute
      @dataElement[attributeName] = null

    @trigger 'attributesModified', @

