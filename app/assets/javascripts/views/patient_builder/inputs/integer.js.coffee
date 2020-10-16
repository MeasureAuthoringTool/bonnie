
# Input view for Integer types.
class Thorax.Views.InputIntegerView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/integer']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - integer - Optional. Initial value of integer.
  #   allowNull - boolean - Optional. If a null or empty integer is allowed. Defaults to false.
  #   placeholder - string - Optional. placeholder text to show. will use 'integer' if not specified
  initialize: ->
    if @initialValue?
      @value = @initialValue
    else
      @value = null

    if !@hasOwnProperty('allowNull')
      @allowNull = false

  events:
    'change input': 'handleInputChange'
    'keyup input': 'handleInputChange'

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    @allowNull || @value?

  handleInputChange: (e) ->
    inputValue = @$(e.target).val()
    if /^([0]|[-+]?[1-9][0-9]*)$/.test(inputValue)
      parsed = parseInt(inputValue)
      if isNaN(parsed)
        @value = null
      else
        @value = cqm.models.PrimitiveInteger.parsePrimitive(parsed)
    else
      @value = null
    @trigger 'valueChanged', @