# Input view for Sampled Data types.
class Thorax.Views.InputSampledDataView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/sampled_data']

  events:
    # Triggered by Show/Hide Optional Elements button.
    'optionalToggled' : 'updateButton'

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - sampledData - Optional. Initial value of sampledData.
  initialize: ->
    @showElements = true
    if @initialValue?
      @value = @initialValue
      @originView = new Thorax.Views.InputQuantityView(initialValue: @value.origin, name: 'origin')
      @periodView = new Thorax.Views.InputDecimalView(initialValue: @value.period, name: 'period')
      @factorView = new Thorax.Views.InputDecimalView(initialValue: @value.factor, name: 'factor')
      @lowerLimitView = new Thorax.Views.InputDecimalView(initialValue: @value.lowerLimit, name: 'lower limit')
      @upperLimitView = new Thorax.Views.InputDecimalView(initialValue: @value.upperLimit, name: 'upper limit')
      @dimensionsView = new Thorax.Views.InputPositiveIntegerView(initialValue: @value.dimensions, name: 'dimensions')
      @dataView = new Thorax.Views.InputStringView(initialValue: @value.data, name: 'data')
    else
      @value = null
      @originView = new Thorax.Views.InputQuantityView(name: 'origin')
      @periodView = new Thorax.Views.InputDecimalView(name: 'period', allowNull: false)
      @factorView = new Thorax.Views.InputDecimalView(name: 'factor', allowNull: false)
      @lowerLimitView = new Thorax.Views.InputDecimalView(name: 'lower limit', allowNull: false)
      @upperLimitView = new Thorax.Views.InputDecimalView(name: 'upper limit', allowNull: false)
      @dimensionsView = new Thorax.Views.InputPositiveIntegerView(name: 'dimensions')
      @dataView = new Thorax.Views.InputStringView(name: 'data')

    @subviews = [@originView, @periodView, @factorView, @lowerLimitView, @upperLimitView, @dimensionsView, @dataView]

    @listenTo(@originView, 'valueChanged', @updateValueFromSubviews)
    @listenTo(@periodView, 'valueChanged', @updateValueFromSubviews)
    @listenTo(@factorView, 'valueChanged', @updateValueFromSubviews)
    @listenTo(@lowerLimitView, 'valueChanged', @updateValueFromSubviews)
    @listenTo(@upperLimitView, 'valueChanged', @updateValueFromSubviews)
    @listenTo(@dimensionsView, 'valueChanged', @updateValueFromSubviews)
    @listenTo(@dataView, 'valueChanged', @updateValueFromSubviews)

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    @originView.hasValidValue() and @periodView.hasValidValue() and @dimensionsView.hasValidValue()

  update: (view) ->
    switch view.name
      when @originView.name
        @value.origin = new cqm.models.SimpleQuantity() unless @value.origin?
        @value.origin = view.value
      when @periodView.name
        @value.period = new cqm.models.PrimitiveDecimal() unless @value.period?
        @value.period = view.value
      when @dimensionsView.name
        @value.dimensions = new cqm.models.PrimitivePositiveInt() unless @value.dimensions?
        @value.dimensions = view.value
      when @factorView.name
        @value.factor = new cqm.models.PrimitiveDecimal() unless @value.factor?
        @value.factor = view.value
      when @lowerLimitView.name
        @value.lowerLimit = new cqm.models.PrimitiveDecimal() unless @value.lowerLimit?
        @value.lowerLimit = view.value
      when @upperLimitView.name
        @value.upperLimit = new cqm.models.PrimitiveDecimal() unless @value.upperLimit?
        @value.upperLimit = view.value
      when @dataView.name
        @value.data = new cqm.models.PrimitiveString() unless @value.data?
        @value.data = view.value

  updateValueFromSubviews: ->
    @value = new cqm.models.SampledData() unless @value?
    @update view for view in @subviews when view.hasValidValue()
    @trigger 'valueChanged', @

  updateButton: ->
    if $('#toggle').text() == 'Show Optional Elements'
      $('#toggle').text('Hide Optional Elements')
    else
      $('#toggle').text('Show Optional Elements')
