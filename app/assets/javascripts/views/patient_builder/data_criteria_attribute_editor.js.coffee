# View for displaying the attributes on the data element / source data criteria
class Thorax.Views.DataCriteriaAttributeEditorView extends Thorax.Views.BonnieView
  template: JST['patient_builder/data_criteria_attribute_editor']

  # Expected options to be passed in using the constructor options hash:
  #   model - Thorax.Models.SourceDataCriteria - The source data criteria we are displaying attributes for
  initialize: ->
    @dataElement = @model.get('dataElement')

    # build a list of the possible attributes for this data element with the name and possible types for each
    @attributeList = []
    DataCriteriaHelpers.getAttributes(@dataElement).forEach (attr, index, array) =>
      @attributeList.push(
        name: attr.path
        title: attr.title
        types: attr.types?.sort()
        valueSets: attr.valueSets?()
        referenceTypes: attr.referenceTypes?.sort()
      )
#    TODO FHIR attributes
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
#        if @currentAttribute.isRelatedTo
#          @$("select[name=\"attribute_type\"] > option[value=\"Data Element\"]").prop('selected', true)
#        else
#          @$("select[name=\"attribute_type\"] > option[value=\"#{@currentAttributeType}\"]").prop('selected', true)
#        @updateAddButtonStatus()
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
      attrMeta = DataCriteriaHelpers.getAttribute(@dataElement, @currentAttribute.name)
      if @currentAttributeType is 'Reference'
        prevVal = attrMeta?.getValue(@dataElement.fhir_resource)
        if prevVal? && cqm.models.Reference.isReference(prevVal)
          [prevResourceType, prevResourceId] = prevVal.reference?.value?.split('/')
          if prevResourceType? && prevResourceId?
            # delete existing resource data element
            @parent.parent.parent.deleteCriteriaById(prevResourceId)
        # Create new Resource for Reference target
        resourceType = @inputView.value?.type
        valueSetId = @inputView.value?.vs
        newId = cqm.ObjectID().toHexString()
        newFhirId = @parent.parent.parent.addChildCriteria(resourceType, newId, valueSetId, @dataElement)
        # set reference attribute using generated fhirId from new Resource
        reference = new cqm.models.Reference()
        reference.reference = cqm.models.PrimitiveString.parsePrimitive(resourceType + '/' + newFhirId)
        attrMeta?.setValue(@dataElement.fhir_resource, reference)

      else
        attrMeta?.setValue(@dataElement.fhir_resource, @inputView.value)

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
      when 'Code' then new Thorax.Views.InputCodeView({ cqmValueSets: @currentAttribute?.valueSets || @parent.measure.get('cqmValueSets'), codeSystemMap: @parent.measure.codeSystemMap() })
      when 'CodeableConcept', 'Coding' then new Thorax.Views.InputCodingView({ cqmValueSets: (@currentAttribute?.valueSets || []).concat(@parent.measure.get('cqmValueSets')), codeSystemMap: @parent.measure.codeSystemMap() })
      when 'Date' then new Thorax.Views.InputDateView({ allowNull: false, defaultYear: @parent.measure.getMeasurePeriodYear() })
      when 'DateTime', 'Instant' then new Thorax.Views.InputDateTimeView({ allowNull: false, defaultYear: @parent.measure.getMeasurePeriodYear() })
      when 'Decimal' then new Thorax.Views.InputDecimalView({ allowNull: false })
      when 'Integer', 'Number' then new Thorax.Views.InputIntegerView({ allowNull: false })
      when 'Period' then new Thorax.Views.InputPeriodView({ defaultYear: @parent.measure.getMeasurePeriodYear() })
      when 'PositiveInt', 'PositiveInteger' then new Thorax.Views.InputPositiveIntegerView()
      when 'UnsignedInt', 'UnsignedInteger' then new Thorax.Views.InputUnsignedIntegerView()
      when 'Interval<DateTime>' then new Thorax.Views.InputIntervalDateTimeView({ defaultYear: @parent.measure.getMeasurePeriodYear() })
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
      else null
    @showInputViewPlaceholder = !@inputView?
    @listenTo(@inputView, 'valueChanged', @updateAddButtonStatus) if @inputView?

  # sets up the view for the attribute input view.
  _setupAttributeInputView: ->
    # remove the existing view if there is one
    @inputView.remove() if @inputView?

    if @currentAttributeType
#      if @currentAttribute.isComposite
#        schema = if @currentAttribute.isEntity # if it is entity, grab the correct schema
#                   cqm.models["#{@currentAttributeType}Schema"]
#                 else
#                   @dataElement.schema.paths[@currentAttribute.name].schema
#        @_createCompositeInputViewForSchema(schema, @currentAttributeType)
#      else if @currentAttribute.isRelatedTo
#        @_createInputViewForType('relatedTo') # Use custom view for relatedTo, not String
#      else
      @_createInputViewForType(@currentAttributeType)
    else
      @inputView = null
      @showInputViewPlaceholder = false

#  # Helper function that returns the list of acceptable types for a given attribute path and schema info.
#  _determineAttributeTypeList: (path, info) ->
#    # if is array type we need to find out what type it should be
#    if info.instance == 'Array'
#      if info.$isMongooseDocumentArray
#        if info.schema.paths._type? # Use the default _type if exists to get info
#          return [info.schema.paths._type.defaultValue.replace(/QDM::/, '')]
#        else if info.schema.paths.namingSystem? # if this has namingSystem assume it is QDM::Id
#          return ['Id']
#        else
#          return ['???'] # TODO: Handle situation of unknown type better.
#      else if info.caster.instance # if this is a schema array we may be able to ask for the caster's instance type
#        return [info.caster.instance]
#      else
#        return ['???'] # TODO: Handle situation of unknown type better.
#
#    # If this is an any type, there will be more options than one.
#    else if info.instance == 'Any'
#      # TODO: Filter these more if possible
#      return ['Code', 'Quantity', 'Ratio', 'Integer', 'Decimal', 'Date', 'DateTime', 'Time']
#
#    # It this is an AnyEntity type
#    else if info.instance == 'AnyEntity'
#      return ['PatientEntity', 'CarePartner', 'Practitioner', 'Organization']
#
#    # If it is an interval, it may be one of DateTime or one of Quantity
#    else if info.instance == 'Interval'
#      if path == 'referenceRange'
#        return ['Interval<Quantity>']
#      else
#        return ['Interval<DateTime>']
#
#    # If it is an embedded type, we have to make guesses about the type
#    else if info.instance == 'Embedded'
#      if info.schema.paths.namingSystem? # if this has namingSystem assume it is QDM::Identifier
#        return ['Identifier']
#      else
#        return ['???'] # TODO: Handle situation of unknown type better.
#    else
#      return [info.instance]
