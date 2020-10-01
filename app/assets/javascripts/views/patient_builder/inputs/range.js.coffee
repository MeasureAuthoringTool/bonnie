# Input view for Range types.
class Thorax.Views.InputRangeView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/range']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - range - Optional. Initial value of range.
  initialize: ->
    if @initialValue?
      @value = @initialValue
      @lowView = new Thorax.Views.InputQuantityView(initialValue: @value.low)
      @highView = new Thorax.Views.InputQuantityView(initialValue: @value.high)
    else
      @value = null
      @lowView = new Thorax.Views.InputQuantityView()
      @highView = new Thorax.Views.InputQuantityView()
    @listenTo(@lowView, 'valueChanged', @updateValueFromSubviews)
    @listenTo(@highView, 'valueChanged', @updateValueFromSubviews)

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    @value?

  updateValueFromSubviews: ->
    if @lowView.hasValidValue() && @highView.hasValidValue()
      @value = new cqm.models.CQL.Range(@lowView.value, @highView.value)
    else
      @value = null
    @trigger 'valueChanged', @