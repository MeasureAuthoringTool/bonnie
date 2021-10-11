class Thorax.Views.ImportJsonPatients extends Thorax.Views.BonnieView
  template: JST['measure/import_json_patients']

  initialize: ->
    @measure = @model.get('cqmMeasure');


  context: ->
    _(super).extend
      token: $('meta[name="csrf-token"]').attr('content')

  setup: ->
    @importJsonPatientsDialog = @$("#importJsonPatientsDialog")

  events:
    rendered: ->
      @$el.on 'hidden.bs.modal', -> @remove() unless $('#importJsonPatientsDialog').is(':visible')
    'click #importPatientsCancel': 'cancel'
    'click #importPatientsSubmit': 'submit'
    'change #patientFileInput': 'fileChanged'
    'ready': 'setup'
    

  display: ->
    @importJsonPatientsDialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true)

  cancel: ->
    @importJsonPatientsDialog.modal('hide')

  submit: (e) ->
    e.preventDefault()
    $(e.target).prop('disabled', true)
    @$('form').submit()
    @importJsonPatientsDialog.modal('hide')
    @$("#importJsonPatientInProgressDialog").modal backdrop: 'static'

  fileChanged: (e) ->
    @$('#importPatientsSubmit').prop('disabled', !fileName = $(e.target).val())