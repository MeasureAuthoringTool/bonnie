# View for displaying the attributes on the data element / source data criteria
class Thorax.Views.DataCriteriaAttributeEditorView extends Thorax.Views.BonnieView
  template: JST['patient_builder/data_criteria_attribute_editor']

  # Expected options to be passed in using the constructor options hash:
  #   model - Thorax.Models.SourceDataCriteria - The source data criteria we are displaying attributes for
  initialize: ->
    @dataElement = @model.get('qdmDataElement')

    # build a list of the possible attributes for this data element with the name and possible types for each
    @attributeList = []
    @dataElement.schema.eachPath (path, info) =>
      # go on to the next one if it is an attribute that should be skipped or is null
      return if Thorax.Models.SourceDataCriteria.SKIP_ATTRIBUTES.includes(path) || !@dataElement[path]?

      @attributeList.push(
        name: path
        title: @model.getAttributeTitle(path)
        isArray: info.instance == 'Array'
        types: @_determineAttributeTypeList(path, info)
      )

  events:
    'change select[name="attribute_name"]': 'attributeNameChange'
    rendered: ->
      # make sure the correct type attribute is selected
      if @currentAttribute
        @$("select[name=\"attribute_type\"] > option[value=\"#{@currentAttributeType}\"]").prop('selected', true)
      else
        @$("select[name=\"attribute_type\"] > option:first").prop('selected', true)

  attributeNameChange: (e) ->
    newAttributeName = $(e.target).val()

    if newAttributeName != ""
      @currentAttribute = @attributeList.find((attr) -> attr.name == newAttributeName)
      if @currentAttribute?
        @currentAttributeName = @currentAttribute.name
        @currentAttributeType = @currentAttribute.types[0]
        @render()
    else
      @currentAttribute = null
      @currentAttributeName = null
      @currentAttributeType = null
      @render()

  # Helper function that returns the list of acceptable types for a given attribute path and schema info.
  _determineAttributeTypeList: (path, info) ->
    # if is array type we need to find out what type it should be
    if info.instance == 'Array'
      if info.$isMongooseDocumentArray
        if info.schema.paths._type? # Use the default _type if exists to get info
          return [info.schema.paths._type.defaultValue.replace(/QDM::/, '')]
        else if info.schema.paths.namingSystem? # if this has namingSystem assume it is QDM::Id
          return ['ID']
        else
          return ['???'] # TODO: Handle situation of unknown type better.
      else if info.caster.instance # if this is a schema array we may be able to ask for the caster's instance type
        return [info.caster.instance]
      else
        return ['???'] # TODO: Handle situation of unknown type better.

    # If this is an any type, there will be more options than one.
    else if info.instance == 'Any'
      # TODO: Filter these more if possible
      return ['Code', 'Quantity', 'DateTime', 'Ratio', 'Integer', 'Decimal', 'Time']

    # If it is an interval, it may be one of DateTime or one of Quantity
    else if info.instance == 'Interval'
      return ['Interval<DateTime>', 'Interval<Quantity>']
    else
      return [info.instance]