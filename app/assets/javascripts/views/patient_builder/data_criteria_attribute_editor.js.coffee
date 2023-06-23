# View for displaying the attributes on the data element / source data criteria
class Thorax.Views.DataCriteriaAttributeEditorView extends Thorax.Views.BonnieView
  template: JST['patient_builder/data_criteria_attribute_editor']

  ENTITY_TYPES = ['PatientEntity', 'CarePartner', 'Practitioner', 'Organization', 'Location']

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
        isComposite: info.instance == 'Embedded' || info.$isMongooseDocumentArray || info.instance == "AnyEntity"
        isEntity: info.instance == "AnyEntity"
        isRelatedTo: path == 'relatedTo'
        types: @_determineAttributeTypeList(path, info)
      )
    @hasUserConfigurableAttributes = @attributeList.length > 0

  events:
    'change select[name="attribute_name"]': 'attributeNameChange'
    'change select[name="attribute_type"]': 'attributeTypeChange'
    rendered: ->
      # make sure the correct type attribute is selected
      if @currentAttribute
        if @currentAttribute.isRelatedTo
          @$("select[name=\"attribute_type\"] > option[value=\"Data Element\"]").prop('selected', true)
        else
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
      if @inputView.value.isRelatedTo
        value = @inputView.value.id
      else
        value = @inputView.value

      if @currentAttribute.isArray
        @dataElement[@currentAttribute.name] = [] if !@dataElement[@currentAttribute.name]?
        @dataElement[@currentAttribute.name].push(value)
      else
        @dataElement[@currentAttribute.name] = value
      @trigger 'attributesModified', @

      # reset back to no selections
      @$('select[name="attribute_type"]').val('')
      @$('select[name="attribute_name"]').val('')
      @currentAttribute = null
      @currentAttributeType = null
      @_setupAttributeInputView()
      @render()

  _createInputViewForType: (type) ->
    if ENTITY_TYPES.includes(type)
      @inputView = new Thorax.Views.InputCompositeView({
        schema: cqm.models["#{type}Schema"],
        typeName: type, allowNull: false,
        cqmValueSets: @parent.measure.get('cqmValueSets'),
        codeSystemMap: @parent.measure.codeSystemMap(),
        defaultYear: @parent.measure.getMeasurePeriodYear()
      })
    else
      @inputView = switch type
        when 'Code' then new Thorax.Views.InputCodeView({ cqmValueSets: @parent.measure.get('cqmValueSets'), codeSystemMap: @parent.measure.codeSystemMap()})
        when 'Date' then new Thorax.Views.InputDateView({ allowNull: false, defaultYear: @parent.measure.getMeasurePeriodYear() })
        when 'DateTime' then new Thorax.Views.InputDateTimeView({ allowNull: false, defaultYear: @parent.measure.getMeasurePeriodYear() })
        when 'Decimal' then new Thorax.Views.InputDecimalView({ allowNull: false })
        when 'Integer', 'Number' then new Thorax.Views.InputIntegerView({ allowNull: false })
        when 'Interval<DateTime>' then new Thorax.Views.InputIntervalDateTimeView({ defaultYear: @parent.measure.getMeasurePeriodYear()})
        when 'Interval<Quantity>' then new Thorax.Views.InputIntervalQuantityView()
        when 'Quantity' then new Thorax.Views.InputQuantityView()
        when 'Ratio' then new Thorax.Views.InputRatioView()
        when 'String' then new Thorax.Views.InputStringView({ allowNull: false })
        when 'Time' then new Thorax.Views.InputTimeView({ allowNull: false })
        when 'relatedTo' then new Thorax.Views.InputRelatedToView(sourceDataCriteria: @parent.model.collection.models, currentDataElementId: @dataElement.id)
        else null
    @showInputViewPlaceholder = !@inputView?
    @listenTo(@inputView, 'valueChanged', @updateAddButtonStatus) if @inputView?

  _createCompositeInputViewForSchema: (schema, typeName) ->
    @showInputViewPlaceholder = false
    @inputView = new Thorax.Views.InputCompositeView(schema: schema, typeName: typeName, cqmValueSets: @parent.measure.get('cqmValueSets'), codeSystemMap: @parent.measure.codeSystemMap(), defaultYear: @parent.measure.getMeasurePeriodYear())
    @listenTo(@inputView, 'valueChanged', @updateAddButtonStatus) if @inputView?

  # sets up the view for the attribute input view.
  _setupAttributeInputView: ->
    # remove the existing view if there is one
    @inputView.remove() if @inputView?

    if @currentAttributeType
      if @currentAttribute.isComposite
        schema = if @currentAttribute.isEntity # if it is entity, grab the correct schema
                   cqm.models["#{@currentAttributeType}Schema"]
                 else
                   @dataElement.schema.paths[@currentAttribute.name].schema
        @_createCompositeInputViewForSchema(schema, @currentAttributeType)
      else if @currentAttribute.isRelatedTo
        @_createInputViewForType('relatedTo') # Use custom view for relatedTo, not String
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
          return ['Id']
        else
          return ['???'] # TODO: Handle situation of unknown type better.
      else if info.caster.instance # if this is a schema array we may be able to ask for the caster's instance type
        if info.caster.instance == 'AnyEntity'
          return ENTITY_TYPES
        else
          return [info.caster.instance]
      else
        return ['???'] # TODO: Handle situation of unknown type better.

    # If this is an any type, there will be more options than one.
    else if info.instance == 'Any'
      # TODO: Filter these more if possible
      return ['Code', 'Quantity', 'Ratio', 'Integer', 'Decimal', 'Date', 'DateTime', 'Time']

    # It this is an AnyEntity type
    else if info.instance == 'AnyEntity'
      return ENTITY_TYPES

    # If it is an interval, it may be one of DateTime or one of Quantity
    else if info.instance == 'Interval'
      if path == 'referenceRange'
        return ['Interval<Quantity>']
      else
        return ['Interval<DateTime>']

    # If it is an embedded type, we have to make guesses about the type
    else if info.instance == 'Embedded'
      if info.schema.paths.namingSystem? # if this has namingSystem assume it is QDM::Identifier
        return ['Identifier']
      else if info.path == 'facilityLocation'
        return ['FacilityLocation']
      else
        return ['???'] # TODO: Handle situation of unknown type better.
    else
      return [info.instance]
