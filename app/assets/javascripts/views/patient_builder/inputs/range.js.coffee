# Input view for Range type
class Thorax.Views.InputRangeView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/range']

  initialize: ->
    if @initialValue?
      @value = @initialValue.clone
    else
      @value = null

  events:
    'change input': 'handleInputChange'
    'keyup input': 'handleInputChange'

  hasValidValue: ->
    if @value?.low? && @value?.high?
      return @value?.low?.value?.value <= @value?.high?.value?.value
    else if @value?.low? || @value?.high?
      return true
    else
      return false

  handleInputChange: ->
    inputData = @serialize()

    # @value should be null by default
    @value = null
    if inputData?.unit?.length && !@isValidUcum(inputData?.unit)
      @$('.range-control-unit').addClass('has-error')
    else
      @$('.range-control-unit').removeClass('has-error')
      unit = if !inputData?.unit?.length then null else cqm.models.PrimitiveString.parsePrimitive(inputData.unit)
      if inputData?.low_value?
        lowValue = parseFloat(inputData.low_value)
        if !isNaN(lowValue)
          @value = new cqm.models.Range() unless @value?
          @value.low = new cqm.models.SimpleQuantity()
          @value.low.unit = unit
          @value.low.value = cqm.models.PrimitiveDecimal.parsePrimitive(lowValue)

      if inputData?.high_value?
        highValue = parseFloat(inputData.high_value)
        if !isNaN(highValue)
          @value = new cqm.models.Range() unless @value?
          @value.high = new cqm.models.SimpleQuantity()
          @value.high.unit = unit
          @value.high.value = cqm.models.PrimitiveDecimal.parsePrimitive(highValue)
    @trigger 'valueChanged', @

  isValidUcum: (unit) ->
    try
      new cqm.models.CQL.Quantity(1, unit)
      return true
    catch error
      return false
