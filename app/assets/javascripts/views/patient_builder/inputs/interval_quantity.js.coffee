# Input view for Interval<Quantity> types.
class Thorax.Views.InputIntervalQuantityView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/interval_quantity']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - Interval<Quantity> - Optional. Initial value of ratio.
  initialize: ->
    if @initialValue?
      @value = @initialValue
      @lowView = new Thorax.Views.InputQuantityView(initialValue: @value.low)
      @highView = new Thorax.Views.InputQuantityView(initialValue: @value.high)
      @lowIsDefined = @value.low?
      @highIsDefined = @value.high?
    else
      @value = null
      @lowView = new Thorax.Views.InputQuantityView()
      @highView = new Thorax.Views.InputQuantityView()
      @lowIsDefined = true
      @highIsDefined = true
    @listenTo(@lowView, 'valueChanged', @updateValueFromSubviews)
    @listenTo(@highView, 'valueChanged', @updateValueFromSubviews)

  events:
    'change input[type=checkbox]': 'handleCheckboxChange'
    rendered: ->
      @lowView.disableFields() unless @lowIsDefined
      @highView.disableFields() unless @lowIsDefined

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    @value?

  handleCheckboxChange: (e) ->
    e.preventDefault()
    # check the status of the low checkbox and disable/enable fields
    if @$("input[name='low_quantity_is_defined']").prop("checked")
      @lowView.enableFields()
      @lowIsDefined = true
    else
      @lowView.disableFields()
      @lowIsDefined = false

    # check the status of the high checkbox and disable/enable fields
    if @$("input[name='high_quantity_is_defined']").prop("checked")
      @highView.enableFields()
      @highIsDefined = true
    else
      @highView.disableFields()
      @highIsDefined = false

    @updateValueFromSubviews()

  updateValueFromSubviews: ->
    if (@lowView.hasValidValue() || !@lowIsDefined) && (@highView.hasValidValue() || !@highIsDefined)
      low = if @lowIsDefined then @lowView.value else null
      high = if @highIsDefined then @highView.value else null
      @value = new cqm.models.CQL.Interval(low, high)
    else
      @value = null
    @trigger 'valueChanged', @