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
    if (!!@value?.low?.value?.value ^ !!@value?.high?.value?.value ^ @value?.low?.value?.value <= @value?.high?.value?.value)
      return true
    else
      return false

  handleInputChange: ->
    inputData = @serialize()
    if inputData?.low_value || inputData?.high_value
      @value = new cqm.models.Range()
      @value.low = new cqm.models.SimpleQuantity()
      @value.low.unit = cqm.models.PrimitiveString.parsePrimitive(inputData.unit)
      @value.low.value = cqm.models.PrimitiveDecimal.parsePrimitive(parseFloat(inputData.low_value))
      @value.high = new cqm.models.SimpleQuantity()
      @value.high.unit = cqm.models.PrimitiveString.parsePrimitive(inputData.unit)
      @value.high.value = cqm.models.PrimitiveDecimal.parsePrimitive(parseFloat(inputData.high_value))
    else
      @value = null
    @trigger 'valueChanged', @
