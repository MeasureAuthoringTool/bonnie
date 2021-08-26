# Input view for Timing types.
class Thorax.Views.InputCompositeView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/composite']

  # Expected options to be passed in using the constructor options hash:
  #   typeName      - required
  #   codeSystemMap - required
  #   cqmValueSets  - required
  #   defaultYear   - required
  initialize: ->
    @value = null

    @componentViews = []

    cqm.models[@typeName].fieldInfo.forEach (fieldInfo, index, array) =>
      fieldName = fieldInfo.fieldName
      additionalTypeInfo = DataCriteriaHelpers.COMPOSITE_TYPES[@typeName]
      additionalFieldInfo = additionalTypeInfo?[fieldName]
      skip = additionalFieldInfo?.skip
      if skip || fieldName is 'id' || fieldInfo.isArray
        # Don't support nested arrays, id attribute or attributes listed in the skip list
        view = null
      else
        view = @_createInputViewForType(fieldInfo, additionalFieldInfo)

      if view?
        @listenTo(view, 'valueChanged', @handleComponentUpdate)
        @componentViews.push {
          title: fieldName
          name: fieldName
          view: view
          showPlaceholder: !view?
        }

    @componentViews.sort((a, b) -> (a.name.localeCompare(b.name)))
    @showLabels = true
    if !@hasOwnProperty('allowNull')
      @allowNull = false

  events:
    rendered: ->
      @handleComponentUpdate()

  _createInputViewForType: (fieldInfo, additionalFieldInfo) ->
    fieldName = fieldInfo.fieldName
    types = fieldInfo.fieldTypeNames.map((type) -> type.replace('Primitive', '')).sort()
    isChoice = types.length > 1
    type = if isChoice then 'Any' else types[0]

    valueSets = (additionalFieldInfo?.valueSets?() || []).concat(@cqmValueSets)

    return switch type
      when 'Boolean' then new Thorax.Views.InputBooleanView()
      # TODO: pass code subtype
#      when 'Code' then new Thorax.Views.InputCodeView({ cqmValueSets: valueSets, codeSystemMap: @codeSystemMap })
      when 'Coding' then new Thorax.Views.InputCodingView({ cqmValueSets: valueSets, codeSystemMap: @codeSystemMap  })
      when 'CodeableConcept' then new Thorax.Views.InputCodeableConceptView({ cqmValueSets: valueSets, codeSystemMap: @codeSystemMap  })
      when 'Date' then new Thorax.Views.InputDateView({ allowNull: false, defaultYear: @defaultYear })
      when 'DateTime' then new Thorax.Views.InputDateTimeView({ allowNull: false, defaultYear: @defaultYear })
      when 'Instant' then new Thorax.Views.InputInstantView({ allowNull: false, defaultYear: @defaultYear })
      when 'Decimal' then new Thorax.Views.InputDecimalView({ placeholder: fieldName, allowNull: false })
      when 'Integer', 'Number' then new Thorax.Views.InputIntegerView({ placeholder: fieldName, allowNull: false })
      when 'Period' then new Thorax.Views.InputPeriodView({ defaultYear: @defaultYear })
      when 'PositiveInt', 'PositiveInteger' then new Thorax.Views.InputPositiveIntegerView()
      when 'UnsignedInt', 'UnsignedInteger' then new Thorax.Views.InputUnsignedIntegerView()
      when 'Quantity', 'SimpleQuantity' then new Thorax.Views.InputQuantityView()
      when 'Duration' then new Thorax.Views.InputDurationView()
      when 'Age' then new Thorax.Views.InputAgeView()
      when 'Range' then new Thorax.Views.InputRangeView()
      when 'Ratio' then new Thorax.Views.InputRatioView()
      when 'String' then new Thorax.Views.InputStringView({ placeholder: fieldName, allowNull: false })
      when 'Canonical' then new Thorax.Views.InputCanonicalView({ allowNull: false })
      when 'Boolean' then new Thorax.Views.InputBooleanView()
      when 'Time' then new Thorax.Views.InputTimeView({ allowNull: false })
      when 'SampledData' then new Thorax.Views.InputSampledDataView()
      when 'Reference' then new Thorax.Views.InputReferenceView({
        allowNull: false
        referenceTypes: additionalFieldInfo?.referenceTypes || []
        parentDataElement: @parentDataElement
        dataCriteria: @dataCriteria
        cqmValueSets: valueSets
        patientBuilder: @patientBuilder
        isReference: true
      })
      when 'Any' then new Thorax.Views.InputAnyView({
        attributeName: fieldName,
        name: fieldName,
        defaultYear: @defaultYear,
        types: types
        cqmValueSets: @cqmValueSets,
        codeSystemMap: @codeSystemMap
      })
      else null

  asComponentType: () ->
    componentsValues = @_getAllComponentValuesIfValid()
    component = DataTypeHelpers.createType(@typeName, componentsValues) if componentsValues?
    component

  handleComponentUpdate: ->
    if @hasValidValue() && cqm.models[@typeName]
    # if everything is valid then make the type
      # Value is not actually used, we need to create a component by explicitly invoking asComponentType()
      # This is to handle Reference type conversion and a new resource creation.
      @value = {}
      @trigger 'valueChanged', this
    else
  # if invalid values exist, null value out if needed and trigger event
      if @value != null
        @value = null
        @trigger 'valueChanged', this

  # grabs all the component values as an object or null if there is one that is invalid
  _getAllComponentValuesIfValid: ->
    newAttrs = {}
    return null if @hasInvalidInput()
    for componentView in @componentViews
      if componentView.view.hasValidValue()
        if componentView.view.isReference
          newAttrs[componentView.name] = componentView.view.asReferenceType()
        else
          newAttrs[componentView.name] = componentView.view.value
    return newAttrs

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    return @componentViews.map(
      (view) -> view.view?.hasValidValue?()
    ).reduce(
      (acc, curr) ->  acc = acc || curr
      false
    )

  hasInvalidInput: ->
    return @componentViews.map(
      (view) -> view.view?.hasInvalidInput?() || false
    ).reduce(
      (acc, curr) ->  acc = acc || curr
      false
    )

