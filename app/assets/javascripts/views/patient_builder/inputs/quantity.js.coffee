# Input view for Quantity types.
class Thorax.Views.InputQuantityView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/quantity']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - CQL Quantity - Optional. Initial value of datetime.
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

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    cqm.models.Quantity.isQuantity(@value)
  disableFields: ->
    @$('input').prop('disabled', true)

  enableFields: ->
    @$('input').prop('disabled', false)

  handleInputChange: (e) ->
    inputData = @serialize()
    try
      if inputData.value_value == '' && inputData.value_unit == ''
        @value = null
      else
        # Validate with CQL.Quantity
        new cqm.models.CQL.Quantity(parseFloat(inputData.value_value), inputData.value_unit)
        @value = new cqm.models.Quantity()
        @value.unit = cqm.models.PrimitiveString.parsePrimitive(inputData.value_unit)
        @value.value = cqm.models.PrimitiveDecimal.parsePrimitive(parseFloat(inputData.value_value))
      @$('.quantity-control-unit').removeClass('has-error')
    catch error
      @value = null
      @$('.quantity-control-unit').addClass('has-error')
    @trigger 'valueChanged', @
