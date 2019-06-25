# Input view for Ratio types.
class Thorax.Views.InputRatioView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/ratio']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - ratio - Optional. Initial value of ratio.
  initialize: ->
    if @initialValue?
      @value = @initialValue
      @numeratorView = new Thorax.Views.InputQuantityView(initialValue: @value.numerator)
      @denominatorView = new Thorax.Views.InputQuantityView(initialValue: @value.denominator)
    else
      @value = null
      @numeratorView = new Thorax.Views.InputQuantityView()
      @denominatorView = new Thorax.Views.InputQuantityView()
    @listenTo(@numeratorView, 'valueChanged', @updateValueFromSubviews)
    @listenTo(@denominatorView, 'valueChanged', @updateValueFromSubviews)

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    @value?

  updateValueFromSubviews: ->
    if @numeratorView.hasValidValue() && @denominatorView.hasValidValue()
      @value = new cqm.models.CQL.Ratio(numerator: @numeratorView.value, denominator: @denominatorView.value)
    else
      @value = null
    @trigger 'valueChanged', @