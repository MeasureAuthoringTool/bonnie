class Thorax.Views.SharePatients extends Thorax.Views.BonnieView
  template: JST['patients/share_patients']

  initialize: ->
    # Build list of measures available to share patients to, exclude current measure
    exclude_id = @model.get('hqmf_set_id')
    @shareableMeasures = new Thorax.Collections.Measures(@model.collection.models.filter (mes) -> mes.get('hqmf_set_id') != exclude_id)

  context: ->

  setup: ->
    @sharePatientsDialog = @$("#sharePatientsDialog")

  events:
    rendered: ->
        @$el.on 'hidden.bs.modal', -> @remove() unless $('#sharePatientsDialog').is(':visible')
    'click #sharePatientsSubmit': 'submit'
    'ready': 'setup'
    

  display: ->
    @sharePatientsDialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true)

  submit: ->
    @sharePatientsDialog.modal('hide')
    @$('form').submit()

  # FIXME: Is anything additional required for cleaning up this view on close?
  close: -> ''
