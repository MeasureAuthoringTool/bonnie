class Thorax.Views.MeasurementPeriod extends Thorax.Views.BonnieView
  template: JST['measure/measurement_period']

  events:
    'ready': 'setup'
    'change input[name="year"]': 'validate'
    'keyup input[name="year"]': 'validate'

  initialize: ->

  context: ->

    _(super).extend
      measurePeriodYear: @model.getMeasurePeriodYear()
      redirectRoute: Backbone.history.fragment
      token: $("meta[name='csrf-token']").attr('content')

  setup: ->
    @dialog = @$("#measurementPeriodDialog")

  changePeriod: ->
    @$('form').submit()

  display: ->
    @dialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true)

  validate: (e) ->
    year = @$('input[name="year"]').val()
    isValidYear = parseFloat(year) == parseInt(year) && year.length == 4 && year >= 1 && year <= 9999
    @$('#changePeriod').prop 'disabled', !isValidYear

  close: ->
    @dialog.modal('hide')
