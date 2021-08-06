# View for displaying the attributes on the data element / source data criteria
class Thorax.Views.DataCriteriaAttributeEditorView extends Thorax.Views.BonnieView
  template: JST['patient_builder/data_criteria_attribute_editor']

  # Expected options to be passed in using the constructor options hash:
  #   model - Thorax.Models.SourceDataCriteria - The source data criteria we are displaying attributes for
  initialize: ->
    @dataElement = @model.get('dataElement')
    resourceType = @dataElement.fhir_resource?.resourceType

    # build a list of the possible attributes for this data element with the name and possible types for each
    @attributeList = []
    DataCriteriaHelpers.getAttributes(@dataElement).forEach (attr, index, array) =>
      @attributeList.push(
        name: attr.path
        title: attr.path
        types: attr.types?.sort()
        valueSets: attr.valueSets?()
        isArray: attr.isArray
        isComposite: attr.isComposite
        referenceTypes: attr.referenceTypes?.sort()
        resourceType: resourceType
        fieldMetadata: cqm.models[resourceType]?.fieldInfo?.find (f) -> f.fieldName is attr.path
      )
#    TODO dynamic FHIR attributes
#    @dataElement.schema.eachPath (path, info) =>
#      # go on to the next one if it is an attribute that should be skipped
#      return if Thorax.Models.SourceDataCriteria.SKIP_ATTRIBUTES.includes(path)
#
#      @attributeList.push(
#        name: path
#        title: @model.getAttributeTitle(path)
#        isArray: info.instance == 'Array'
#        isComposite: info.instance == 'Embedded' || info.$isMongooseDocumentArray || info.instance == "AnyEntity"
#        isEntity: info.instance == "AnyEntity"
#        isRelatedTo: path == 'relatedTo'
#        types: @_determineAttributeTypeList(path, info)
#      )
    @hasUserConfigurableAttributes = @attributeList.length > 0

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
      disabledStatus = !@inputView.hasValidValue?()
    @$('.input-add > button').prop('disabled', disabledStatus)

  asReferenceType: () ->
    resourceType = @inputView.value?.type
    valueSetId = @inputView.value?.vs
    newId = cqm.ObjectID().toHexString()
    newFhirId = @parent.parent.parent.addChildCriteria(resourceType, newId, valueSetId, @dataElement)
    # set reference attribute using generated fhirId from new Resource
    reference = new cqm.models.Reference()
    reference.reference = cqm.models.PrimitiveString.parsePrimitive(resourceType + '/' + newFhirId)
    reference

  # Button click handler for adding the value to the attribute
  addValue: (e) ->
    e.preventDefault()
    # double check we have a currently selected attribute and a valid value

    if @currentAttribute? && @inputView?.hasValidValue()
      attrDef = DataCriteriaHelpers.getAttribute(@dataElement, @currentAttribute.name)
      value = @inputView.value
      if @currentAttributeType is 'Reference'
        value = @asReferenceType()
      if attrDef.isArray
        # Initialize with an empty array if not defined
        array = attrDef.getValue(@dataElement.fhir_resource) || []
        array.push(value)
        attrDef.setValue(@dataElement.fhir_resource, array)
      else
        attrDef.setValue(@dataElement.fhir_resource, value)

      @trigger 'attributesModified', @

      # reset back to no selections
      @$('select[name="attribute_type"]').val('')
      @$('select[name="attribute_name"]').val('')
      @currentAttribute = null
      @currentAttributeType = null
      @_setupAttributeInputView()
      @render()

  _createInputViewForType: (type) ->
    @inputView = switch type
      when 'Code' then new Thorax.Views.InputCodeView({ cqmValueSets: @currentAttribute?.valueSets || @parent.measure.get('cqmValueSets'), codeSystemMap: @parent.measure.codeSystemMap(), codeType: @currentAttribute?.fieldMetadata?.fieldTypeNames?.map((t) -> cqm.models[t]).find((t) -> t.isPrimitiveCode != null) })
      when 'Coding' then new Thorax.Views.InputCodingView({ cqmValueSets: (@currentAttribute?.valueSets || []).concat(@parent.measure.get('cqmValueSets')), codeSystemMap: @parent.measure.codeSystemMap() })
      when 'CodeableConcept' then new Thorax.Views.InputCodeableConceptView({ cqmValueSets: (@currentAttribute?.valueSets || []).concat(@parent.measure.get('cqmValueSets')), codeSystemMap: @parent.measure.codeSystemMap() })
      when 'Date' then new Thorax.Views.InputDateView({ allowNull: false, defaultYear: @parent.measure.getMeasurePeriodYear() })
      when 'DateTime' then new Thorax.Views.InputDateTimeView({ allowNull: false, defaultYear: @parent.measure.getMeasurePeriodYear() })
      when 'Instant' then new Thorax.Views.InputInstantView({ allowNull: false, defaultYear: @parent.measure.getMeasurePeriodYear() })
      when 'Decimal' then new Thorax.Views.InputDecimalView({ allowNull: false })
      when 'Integer', 'Number' then new Thorax.Views.InputIntegerView({ allowNull: false })
      when 'Period' then new Thorax.Views.InputPeriodView({ defaultYear: @parent.measure.getMeasurePeriodYear() })
      when 'PositiveInt', 'PositiveInteger' then new Thorax.Views.InputPositiveIntegerView()
      when 'UnsignedInt', 'UnsignedInteger' then new Thorax.Views.InputUnsignedIntegerView()
      when 'Interval<DateTime>' then new Thorax.Views.InputIntervalDateTimeView({ defaultYear: @parent.measure.getMeasurePeriodYear() })
# TODO: ObservationComponent can be created with a composite view widget, autogenerated based on fields introspection.
#  In that case it will lack custom value set bindings
#  We can come up with a lookup for VS bindings
      when 'ObservationComponent' then new Thorax.Views.InputObservationComponentView({ cqmValueSets: (@currentAttribute?.valueSets || []).concat(@parent.measure.get('cqmValueSets')), codeSystemMap: @parent.measure.codeSystemMap() })
      when 'Quantity', 'SimpleQuantity' then new Thorax.Views.InputQuantityView()
      when 'Duration' then new Thorax.Views.InputDurationView()
      when 'Age' then new Thorax.Views.InputAgeView()
      when 'Range' then new Thorax.Views.InputRangeView()
      when 'Ratio' then new Thorax.Views.InputRatioView()
      when 'String' then new Thorax.Views.InputStringView({ allowNull: false })
      when 'Canonical' then new Thorax.Views.InputCanonicalView({ allowNull: false })
      when 'id' then new Thorax.Views.InputIdView()
      when 'Boolean' then new Thorax.Views.InputBooleanView()
      when 'Time' then new Thorax.Views.InputTimeView({ allowNull: false })
      when 'Reference' then new Thorax.Views.InputReferenceView({ allowNull: false, referenceTypes: @currentAttribute.referenceTypes, parentDataElement: @dataElement, cqmValueSets: @parent.measure.get('cqmValueSets') })
      when 'SampledData' then new Thorax.Views.InputSampledDataView()
      when 'Timing' then new Thorax.Views.InputTimingView({ codeSystemMap: @parent.measure.codeSystemMap(), defaultYear: @parent.measure.getMeasurePeriodYear() })
      when 'Dosage' then new Thorax.Views.InputDosageView({ cqmValueSets: @parent.measure.get('cqmValueSets'), codeSystemMap: @parent.measure.codeSystemMap() })
      when 'Identifier' then new Thorax.Views.InputIdentifierView({ cqmValueSets: @parent.measure.get('cqmValueSets'), codeSystemMap: @parent.measure.codeSystemMap(), defaultYear: @parent.measure.getMeasurePeriodYear()  })
      else null
    @showInputViewPlaceholder = !@inputView?
    @listenTo(@inputView, 'valueChanged', @updateAddButtonStatus) if @inputView?

  # sets up the view for the attribute input view.
  _setupAttributeInputView: ->
    # remove the existing view if there is one
    @inputView.remove() if @inputView?

    if @currentAttributeType
      if @currentAttribute.isComposite
        @_createCompositeInputView(@currentAttributeType)
      else
        @_createInputViewForType(@currentAttributeType)
    else
      @inputView = null
      @showInputViewPlaceholder = false

  _createCompositeInputView: (typeName) ->
    @showInputViewPlaceholder = false
    @inputView = new Thorax.Views.InputCompositeView({ typeName: typeName, cqmValueSets: @parent.measure.get('cqmValueSets'), codeSystemMap: @parent.measure.codeSystemMap(), defaultYear: @parent.measure.getMeasurePeriodYear()  })
    @listenTo(@inputView, 'valueChanged', @updateAddButtonStatus) if @inputView?

