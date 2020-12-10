class Thorax.Views.ImportPatients extends Thorax.Views.BonnieView
  template: JST['patients/import_patients']

  initialize: ->
    @measure = @model.get('cqmMeasure');
    debugger

  context: ->
    _(super).extend
      token: $('meta[name="csrf-token"]').attr('content')

  setup: ->
    @importPatientsDialog = @$("#importPatientsDialog")

  events:
    rendered: ->
        @$el.on 'hidden.bs.modal', -> @remove() unless $('#importPatientsDialog').is(':visible')
    'click #importPatientsCancel': 'cancel'
    'ready': 'setup'
    

  display: ->
    @importPatientsDialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true)

  cancel: ->
    @importPatientsDialog.modal('hide')
