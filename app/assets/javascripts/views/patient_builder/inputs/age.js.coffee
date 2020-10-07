# Input view for Age type.
class Thorax.Views.InputAgeView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/age']

  initialize: ->
    if @initialValue?
      @value = @initialValue.clone()
    else
      @value = null

  events:
    'change input': 'handleInputChange'
    'keyup input': 'handleInputChange'

  context: ->
    _(super).extend
      value_value: @value?.value?.value if @value?
      value_unit: @value?.unit?.value if @value?

  # checks if both age value & unit is entered and age value > 0.
  hasValidValue: ->
    if (@value?.value?.value && @value?.unit?.value)
      return parseFloat(@value?.value?.value) > 0
    else
      return false

  disableFields: ->
    @$('input').prop('disabled', true)

  enableFields: ->
    @$('input').prop('disabled', false)

  handleInputChange: (e) ->
    inputData = @serialize()
    try
      # Validate with CQL.Quantity
      new cqm.models.CQL.Quantity(parseFloat(inputData.value_value), inputData.value_unit)
      @value = new cqm.models.Age()
      @value.unit = cqm.models.PrimitiveString.parsePrimitive(inputData.value_unit)
      @value.value = cqm.models.PrimitiveDecimal.parsePrimitive(parseFloat(inputData.value_value))
      @$('.quantity-control-unit').removeClass('has-error')
    catch error
      @value = null
      @$('.quantity-control-unit').addClass('has-error')
    @trigger 'valueChanged', @
