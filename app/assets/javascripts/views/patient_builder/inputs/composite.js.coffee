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

    DataCriteriaHelpers.getCompositeAttributes(@typeName).forEach( (attrDef) =>
      attributeName = attrDef.path
      view = @_createInputViewForType(attrDef)
      if view?
        @listenTo(view, 'valueChanged', @handleComponentUpdate)
        @componentViews.push {
          title: attributeName
          name: attributeName
          view: view
          showPlaceholder: !view?
        }
    )

    @componentViews.sort((a, b) -> (a.name.localeCompare(b.name)))
    @showLabels = true
    if !@hasOwnProperty('allowNull')
      @allowNull = false

  events:
    rendered: ->
      @handleComponentUpdate()

  _createInputViewForType: (attrDef) ->
#    TODO: add support for arrays
    attributeName = attrDef.path
    isChoice = attrDef.types.length > 1
    types = attrDef.types
    type = if isChoice then 'Any' else types[0]
    referenceTypes = attrDef.referenceTypes || []
    valueSets = (attrDef?.valueSets?() || []).concat(@cqmValueSets)

    return switch type
      when 'Boolean' then new Thorax.Views.InputBooleanView({ typeName: @typeName, attributeName: attributeName })
      # Pass typeName and attributeName to a suview for identification purposes
      # TODO: pass code subtype
#      when 'Code' then new Thorax.Views.InputCodeView({ cqmValueSets: valueSets, codeSystemMap: @codeSystemMap, typeName: @typeName, attributeName: attributeName })
      when 'Coding' then new Thorax.Views.InputCodingView({ cqmValueSets: valueSets, codeSystemMap: @codeSystemMap, typeName: @typeName, attributeName: attributeName  })
      when 'CodeableConcept' then new Thorax.Views.InputCodeableConceptView({ cqmValueSets: valueSets, codeSystemMap: @codeSystemMap, typeName: @typeName, attributeName: attributeName  })
      when 'Date' then new Thorax.Views.InputDateView({ allowNull: false, defaultYear: @defaultYear, typeName: @typeName, attributeName: attributeName })
      when 'DateTime' then new Thorax.Views.InputDateTimeView({ allowNull: false, defaultYear: @defaultYear, typeName: @typeName, attributeName: attributeName })
      when 'Instant' then new Thorax.Views.InputInstantView({ allowNull: false, defaultYear: @defaultYear, typeName: @typeName, attributeName: attributeName })
      when 'Decimal' then new Thorax.Views.InputDecimalView({ placeholder: attributeName, allowNull: false, typeName: @typeName, attributeName: attributeName })
      when 'Integer', 'Number' then new Thorax.Views.InputIntegerView({ placeholder: attributeName, allowNull: false, typeName: @typeName, attributeName: attributeName })
      when 'Period' then new Thorax.Views.InputPeriodView({ defaultYear: @defaultYear, typeName: @typeName, attributeName: attributeName })
      when 'PositiveInt', 'PositiveInteger' then new Thorax.Views.InputPositiveIntegerView({ typeName: @typeName, attributeName: attributeName })
      when 'UnsignedInt', 'UnsignedInteger' then new Thorax.Views.InputUnsignedIntegerView({ typeName: @typeName, attributeName: attributeName })
      when 'Quantity', 'SimpleQuantity' then new Thorax.Views.InputQuantityView({ typeName: @typeName, attributeName: attributeName })
      when 'Duration' then new Thorax.Views.InputDurationView({ typeName: @typeName, attributeName: attributeName })
      when 'Age' then new Thorax.Views.InputAgeView({ typeName: @typeName, attributeName: attributeName })
      when 'Range' then new Thorax.Views.InputRangeView({ typeName: @typeName, attributeName: attributeName })
      when 'Ratio' then new Thorax.Views.InputRatioView({ typeName: @typeName, attributeName: attributeName })
      when 'String' then new Thorax.Views.InputStringView({ placeholder: attributeName, allowNull: false, typeName: @typeName, attributeName: attributeName })
      when 'Canonical' then new Thorax.Views.InputCanonicalView({ allowNull: false, typeName: @typeName, attributeName: attributeName })
      when 'Boolean' then new Thorax.Views.InputBooleanView({ typeName: @typeName, attributeName: attributeName })
      when 'Time' then new Thorax.Views.InputTimeView({ allowNull: false, typeName: @typeName, attributeName: attributeName })
      when 'SampledData' then new Thorax.Views.InputSampledDataView({ typeName: @typeName, attributeName: attributeName })
      when 'Reference' then new Thorax.Views.InputReferenceView({
        allowNull: false
        referenceTypes: referenceTypes
        parentDataElement: @parentDataElement
        dataCriteria: @dataCriteria
        cqmValueSets: valueSets
        patientBuilder: @patientBuilder
        isReference: true
        typeName: @typeName
        attributeName: attributeName
      })
      when 'Any' then new Thorax.Views.InputAnyView({
        name: attributeName
        defaultYear: @defaultYear
        types: types
        cqmValueSets: @cqmValueSets
        codeSystemMap: @codeSystemMap
        typeName: @typeName
        attributeName: attributeName
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

