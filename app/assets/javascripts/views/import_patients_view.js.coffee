class Thorax.Views.ImportPatients extends Thorax.Views.BonnieView
  template: JST['patients/import_patients']

  initialize: ->
    @measure = @model.get('cqmMeasure');


  context: ->
    _(super).extend
      token: $('meta[name="csrf-token"]').attr('content')

  setup: ->
    @importPatientsDialog = @$("#importPatientsDialog")

  events:
    rendered: ->
      @$el.on 'hidden.bs.modal', -> @remove() unless $('#importPatientsDialog').is(':visible')
    'click #importPatientsCancel': 'cancel'
    'click #importPatientsSubmit': 'submit'
    'ready': 'setup'
    

  display: ->
    @importPatientsDialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true)

  cancel: ->
    @importPatientsDialog.modal('hide')

  submit: (e) ->
    e.preventDefault()
    $(e.target).prop('disabled', true)
    @$('form').submit()
    @importPatientsDialog.modal('hide')
