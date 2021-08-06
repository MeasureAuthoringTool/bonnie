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
      name = fieldInfo.fieldName
      if name is 'id' || fieldInfo.isArray
        # Don't support nested arrays at the moment
        view = null
      else
        view = @_createInputViewForType(fieldInfo)

      if view?
        @listenTo(view, 'valueChanged', @handleComponentUpdate)
        @componentViews.push {
          title: name
          name: name
          view: view
          showPlaceholder: !view?
        }

    @showLabels = true
    if !@hasOwnProperty('allowNull')
      @allowNull = false

  events:
    rendered: ->
      @handleComponentUpdate()

  _createInputViewForType: (fieldInfo) ->
    name = fieldInfo.fieldName
    types = fieldInfo.fieldTypeNames.map((type) -> type.replace('Primitive', ''))
    isChoice = types.length > 1
    type = if isChoice then 'Any' else types[0]

    return switch type
      when 'Boolean' then new Thorax.Views.InputBooleanView()
      # TODO: pass code sybtype
#      when 'Code' then new Thorax.Views.InputCodeView({ name: name, cqmValueSets: @cqmValueSets, codeSystemMap: @codeSystemMap })
      when 'Coding' then new Thorax.Views.InputCodingView({ name: name, cqmValueSets: @cqmValueSets, codeSystemMap: @codeSystemMap  })
      when 'CodeableConcept' then new Thorax.Views.InputCodeableConceptView({ name: name, cqmValueSets: @cqmValueSets, codeSystemMap: @codeSystemMap  })
      when 'Date' then new Thorax.Views.InputDateView({ name: name, allowNull: false, defaultYear: @defaultYear })
      when 'DateTime' then new Thorax.Views.InputDateTimeView({ name: name, allowNull: false, defaultYear: @defaultYear })
      when 'Instant' then new Thorax.Views.InputInstantView({ name: name, allowNull: false, defaultYear: @defaultYear })
      when 'Decimal' then new Thorax.Views.InputDecimalView({ placeholder: attributeName, name: name, allowNull: false, placeholder: placeholderText })
      when 'Integer', 'Number' then new Thorax.Views.InputIntegerView({ placeholder: attributeName, name: name, allowNull: false, placeholder: placeholderText })
      when 'Quantity', 'SimpleQuantity' then new Thorax.Views.InputQuantityView({ name: name })
      when 'Duration' then new Thorax.Views.InputDurationView({ name: name })
      when 'Range' then new Thorax.Views.InputRangeView({ name: name })
      when 'Period' then new Thorax.Views.InputPeriodView({ name: name, defaultYear: @defaultYear })
      when 'Ratio' then new Thorax.Views.InputRatioView({ name: name })
      when 'Time' then new Thorax.Views.InputTimeView({ name: name, allowNull: false })
      when 'String' then new Thorax.Views.InputStringView({ placeholder: attributeName, name: name, allowNull: false })
      when 'Any' then new Thorax.Views.InputAnyView({
        attributeName: name,
        name: name,
        defaultYear: @defaultYear,
        types: types
        cqmValueSets: @cqmValueSets,
        codeSystemMap: @codeSystemMap
      })
      else null

  handleComponentUpdate: ->
    componentsValues = @_getAllComponentValuesIfValid()
    if componentsValues?
    # if everything is valid then make the type
      if cqm.models[@typeName]
        @value = DataTypeHelpers.createType(@typeName, componentsValues)
      else
        console.error("Could not find constructor cqm.models.#{@typeName}")
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
        newAttrs[componentView.name] = componentView.view.value
    return newAttrs

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    return @componentViews.map(
      (view) -> view.view?.value?
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

