
# Input view for Decimal types.
class Thorax.Views.InputDecimalView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/decimal']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - number - Optional. Initial value of primitive decimal.
  #   allowNull - boolean - Optional. If a null or empty decimal is allowed. Defaults to true.
  #   placeholder - string - Optional. placeholder text to show. will use 'decimal' if not specified
  initialize: ->
    if @initialValue?
      @value = @initialValue
    else
      @value = null

    if !@hasOwnProperty('allowNull')
      @allowNull = true
    @invalidInput = false

  events:
    'change input': 'handleInputChange'
    'keyup input': 'handleInputChange'

  # checks if an invalid value is entered
  # hasInvalidInput is true when there is an entered value which is invalid or cannot be parsed
  hasInvalidInput: ->
    @invalidInput

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    @allowNull || @value?

  handleInputChange: (e) ->
    inputValue = @$(e.target).val()
    if /^[0]|[-+]?[1-9][0-9]*(\.?[0-9]+([eE][-+]?[0-9]+)?)?$/.test(inputValue)
      parsed = parseFloat(inputValue)
      if isNaN(parsed)
        @value = null
      else
        @value = cqm.models.PrimitiveDecimal.parsePrimitive(parsed)
    else
      @value = null

    if @value? || !inputValue
      @$(e.target).parent().removeClass('has-error')
      @invalidInput = false
    else
      @$(e.target).parent().addClass('has-error')
      @invalidInput = true

    @trigger 'valueChanged', @
