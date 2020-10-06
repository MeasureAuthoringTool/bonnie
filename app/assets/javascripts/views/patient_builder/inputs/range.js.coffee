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
    console.log(@value)
    if (@value?.low?.value && @value?.high?.value)
      return @value.low.value <= @value.high.value
    else
      return false

  handleInputChange: ->
    inputData = @serialize()
    if inputData?.low_value && inputData?.high_value
      @value = new cqm.models.Range()
      @value.low = new cqm.models.SimpleQuantity()
      @value.low.unit = inputData.low_unit
      @value.low.value = parseFloat(inputData.low_value)
      @value.high = new cqm.models.SimpleQuantity()
      @value.high.unit = inputData.high_unit
      @value.high.value = parseFloat(inputData.high_value)
    else
      @value = null
    @trigger 'valueChanged', @
