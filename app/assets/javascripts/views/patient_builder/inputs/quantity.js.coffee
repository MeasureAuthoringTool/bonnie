# Input view for DateTime types.
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
      value_value: @value.value if @value?
      value_unit: @value.unit if @value?

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    @value?

  handleInputChange: (e) ->
    inputData = @serialize()
    try
      @value = new cqm.models.CQL.Quantity(value: inputData.value_value, unit: inputData.value_unit)
      @$('.quantity-control-unit').removeClass('has-error')
    catch error
      @value = null
      @$('.quantity-control-unit').addClass('has-error')
    @trigger 'valueChanged', @