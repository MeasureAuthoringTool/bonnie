# View for displaying the attributes on the data element / source data criteria
class Thorax.Views.DataCriteriaAttributeDisplayView extends Thorax.Views.BonnieView
  template: JST['patient_builder/data_criteria_attribute_display']

  # Expected options to be passed in using the constructor options hash:
  #   model - Thorax.Models.SourceDataCriteria - The source data criteria we are displaying attributes for
  initialize: ->
    @dataElement = @model.get('qdmDataElement')

  context: ->
    # build list of non-null attributes and their string representation
    displayAttributes = []
    @dataElement.schema.eachPath (path, info) =>
      # go on to the next one if it is an attribute that should be skipped or is null
      return if Thorax.Models.SourceDataCriteria.SKIP_ATTRIBUTES.includes(path) || !@dataElement[path]?

      # if is array type we need to list each element
      if info.instance == 'Array'
        @dataElement[path].forEach (elem, index) =>
          displayAttributes.push({ name: path, title: @model.getAttributeTitle(path), value: elem.toString(), isArrayValue: true, index: index })
      else
        displayAttributes.push({ name: path, title: @model.getAttributeTitle(path), value: @dataElement[path].toString() })

    _(super).extend
      displayAttributes: displayAttributes

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

