
# Input view for Decimal types.
class Thorax.Views.InputDecimalView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/decimal']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - string - Optional. Initial value of decimal.
  #   allowNull - boolean - Optional. If a null or empty decimal is allowed. Defaults to true.
  initialize: ->
    if @initialValue?
      @value = @initialValue
    else
      @value = null

    if !@hasOwnProperty('allowNull')
      @allowNull = true

  events:
    'change input': 'handleInputChange'
    'keyup input': 'handleInputChange'

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    @allowNull || @value?

  handleInputChange: (e) ->
    inputValue = @$(e.target).val()
    if inputValue != ''
      @value = parseFloat(inputValue)
      if @value == NaN
        @value = null
    else
      @value = null
    @trigger 'valueChanged', @