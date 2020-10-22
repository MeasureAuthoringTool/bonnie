
# Input view for String types.
class Thorax.Views.InputCanonicalView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/canonical']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - canonical - Optional. Initial value of canonical.
  #   allowNull - boolean - Optional. If a null or empty string is allowed. Defaults to false.
  #   placeholder - string - Optional. placeholder text to show. will use 'string' if not specified
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
    if /^\S+$/g.test(inputValue)
      @value = cqm.models.PrimitiveCanonical.parsePrimitive(inputValue)
    else
      @value = null
    @trigger 'valueChanged', @