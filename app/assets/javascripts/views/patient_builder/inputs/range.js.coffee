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
    if (@value?.low && @value?.high)
      return @value.low < @value.high
    else
      return false

  handleInputChange: (e) ->
    inputData = @serialize()
    if inputData.low && inputData.high && inputData.low < inputData.high
      @value = new cqm.models.Range()
      @value.low = inputData.low
      @value.high = inputData.high
    else
      @value = null
    @trigger 'valueChanged', @
