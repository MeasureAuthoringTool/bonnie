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

      newAttr = { name: path, title: @model.getAttributeTitle(path) }
      # if is array type we need to find out what type it should be
      if info.instance == 'Array'
        newAttr.types = ['Array']
      else if info.instance == 'Any'
        # TODO: Filter these more if possible
        newAttr.types = ['Code', 'Quantity', 'DateTime', 'Ratio', 'Integer', 'Decimal', 'Time']
      else if info.instance == 'Interval'
        newAttr.types = ['Interval<DateTime>', 'Interval<Quantity>']
      else
        newAttr.types = [info.instance]

      @attributeList.push(newAttr)

  events:
    'change select[name="attribute_name"]': 'attributeNameChange'
    rendered: ->
      # make sure the correct type attribute is selected
      if @currentAttribute
        @$("select[name=\"attribute_type\"] > option[value=\"#{@currentAttributeType}\"]").prop('selected', true)

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
