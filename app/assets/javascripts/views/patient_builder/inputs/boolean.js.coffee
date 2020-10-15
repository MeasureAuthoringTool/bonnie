
# Input view for Booleфт types.
class Thorax.Views.InputBooleanView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/boolean']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - PrimitiveBoolean - Optional. Initial value of string.
  initialize: ->
    if @initialValue?
      @value = @initialValue
    else
      @value = cqm.models.PrimitiveBoolean.parsePrimitive(true)

  events:
    'change select[name="boolean_select"]': 'handleSelectChange'

# checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
# if the add button should be active or not
  hasValidValue: -> true

  handleSelectChange: (e) ->
    inputValue = @$(e.target).val()
    if inputValue != ''
      @value = cqm.models.PrimitiveBoolean.parsePrimitive(inputValue == 'true')
    else
      @value = null
    @trigger 'valueChanged', @
