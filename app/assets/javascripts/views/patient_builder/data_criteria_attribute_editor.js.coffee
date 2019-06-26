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
      # go on to the next one if it is an attribute that should be skipped
      return if Thorax.Models.SourceDataCriteria.SKIP_ATTRIBUTES.includes(path)

      @attributeList.push(
        name: path
        title: @model.getAttributeTitle(path)
        isArray: info.instance == 'Array'
        isComposite: info.instance == 'Embedded' || info.$isMongooseDocumentArray
        types: @_determineAttributeTypeList(path, info)
      )

  events:
    'change select[name="attribute_name"]': 'attributeNameChange'
    'change select[name="attribute_type"]': 'attributeTypeChange'
    rendered: ->
      # make sure the correct type attribute is selected
      if @currentAttribute
        @$("select[name=\"attribute_type\"] > option[value=\"#{@currentAttributeType}\"]").prop('selected', true)
        @updateAddButtonStatus()
      else
        @$("select[name=\"attribute_type\"] > option:first").prop('selected', true)

  attributeNameChange: (e) ->
    newAttributeName = $(e.target).val()

    if newAttributeName != ""
      @currentAttribute = @attributeList.find((attr) -> attr.name == newAttributeName)
      if @currentAttribute?
        @currentAttributeType = @currentAttribute.types[0]
        @_setupAttributeInputView()
        @render()
    else
      @currentAttribute = null
      @currentAttributeType = null
      @_setupAttributeInputView()
      @render()

  attributeTypeChange: (e) ->
    newAttributeType = $(e.target).val()

    if newAttributeType != ""
      @currentAttributeType = newAttributeType
    else
      @currentAttributeType = null
    @_setupAttributeInputView()
    @render()

  # update the add (+) button's disabled state based on if the input view says the input is valid or not
  updateAddButtonStatus: ->
    disabledStatus = true
    if @inputView?
      disabledStatus = !@inputView.hasValidValue()
    @$('.input-add > button').prop('disabled', disabledStatus)

  # Button click handler for adding the value to the attribute
  addValue: (e) ->
    e.preventDefault()
    # double check we have a currently selected attribute and a valid value
    if @currentAttribute? && @inputView?.hasValidValue()
      if @currentAttribute.isArray
        @dataElement[@currentAttribute.name].push(@inputView.value)
      else
        @dataElement[@currentAttribute.name] = @inputView.value
      @trigger 'attributesModified', @

  _createInputViewForType: (type) ->
    @inputView = switch type
      when 'Interval<DateTime>' then new Thorax.Views.InputIntervalDateTimeView()
      when 'DateTime' then new Thorax.Views.InputDateTimeView({ allowNull: false })
      when 'Time' then new Thorax.Views.InputTimeView({ allowNull: false })
      when 'Quantity' then new Thorax.Views.InputQuantityView()
      when 'Code' then new Thorax.Views.InputCodeView({ cqmValueSets: @parent.measure.get('cqmValueSets'), codeSystemMap: @parent.measure.codeSystemMap()})
      when 'String' then new Thorax.Views.InputStringView({ allowNull: false })
      when 'Integer', 'Number' then new Thorax.Views.InputIntegerView({ allowNull: false })
      when 'Decimal' then new Thorax.Views.InputDecimalView({ allowNull: false })
      when 'Ratio' then new Thorax.Views.InputRatioView()
      else null
    @showInputViewPlaceholder = !@inputView?
    @listenTo(@inputView, 'valueChanged', @updateAddButtonStatus) if @inputView?

  _createCompositeInputViewForSchema: (schema, typeName) ->
    @showInputViewPlaceholder = false
    @inputView = new Thorax.Views.InputCompositeView(schema: schema, typeName: typeName, cqmValueSets: @parent.measure.get('cqmValueSets'), codeSystemMap: @parent.measure.codeSystemMap())
    @listenTo(@inputView, 'valueChanged', @updateAddButtonStatus) if @inputView?

  # sets up the view for the attribute input view.
  _setupAttributeInputView: ->
    # remove the existing view if there is one
    @inputView.remove() if @inputView?

    if @currentAttributeType
      if @currentAttribute.isComposite
        @_createCompositeInputViewForSchema(@dataElement.schema.paths[@currentAttribute.name].schema, @currentAttributeType)
      else
        @_createInputViewForType(@currentAttributeType)
    else
      @inputView = null
      @showInputViewPlaceholder = false

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
      if path == 'referenceRange'
        return ['Interval<Quantity>']
      else
        return ['Interval<DateTime>']

    # If it is an embedded type, we have to make guesses about the type
    else if info.instance == 'Embedded'
      if info.schema.paths.namingSystem? # if this has namingSystem assume it is QDM::Id
        return ['ID']
      else
        return ['???'] # TODO: Handle situation of unknown type better.
    else
      return [info.instance]