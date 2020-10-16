# Input view for id type.
class Thorax.Views.InputIdView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/id']

  # Options to be passed in using the constructor option hash:
  #   initialValue - id - Optional. Initial value of id.
  #   placeholder - id - Optional. placeholder text to show. will use 'id' if not specified
  initialize: ->
    if @initialValue?
      @value = @initialValue
    else
      @value = null

  events:
    'change input': 'handleInputChange'
    'keyup input': 'handleInputChange'

  # checks if the value in this view is valid.
  # can have lowercase, uppercase letters, numbers, periods and hyphens. Max length can be 64
  hasValidValue: ->
    @value != null && /^([A-Za-z0-9\-\.]{1,64})$/.test(@value?.value)

  handleInputChange: (e) ->
    debugger
    inputValue = @$(e.target).val()
    if inputValue != ''
      @value = cqm.models.PrimitiveId.parsePrimitive(inputValue)
    else
      @value = null
    @trigger 'valueChanged', @
