class Thorax.Views.MeasurementPeriod extends Thorax.Views.BonnieView
  template: JST['measure/measurement_period']

  events:
    'ready': 'setup'

  context: ->
    _(super).extend
      titleSize: 3
      dataSize: 9

  setup: ->
    @dialog = @$("#measurementPeriodDialog")
    @$('.date-picker').datepicker('orientation': 'bottom left')
  
  display: ->
    @dialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true)
  
  close: ->
    @dialog.modal('hide')