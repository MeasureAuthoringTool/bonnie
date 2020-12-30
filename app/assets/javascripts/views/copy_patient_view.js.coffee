class Thorax.Views.CopyPatientView extends Thorax.Views.BonnieView
  template: JST['patients/copy_patient']

  initialize: ->
    # Build list of measures available to copy this patient to, exclude current measure
    exclude_id = @model.get('cqmMeasure').set_id
    @set_id = exclude_id
    @targetMeasures = new Thorax.Collections.Measures(@model.collection.models.filter (mes) -> mes.get('cqmMeasure').set_id != exclude_id)

  context: ->
    _(super).extend
      token: $('meta[name="csrf-token"]').attr('content')

  setup: ->
    @copyPatientDialog = @$("#copyPatientDialog")

  events:
    rendered: ->
      @$el.on 'hidden.bs.modal', -> @remove() unless $('#copyPatientDialog').is(':visible')
    'click #copyPatientCancel': 'cancel'
    'ready': 'setup'


  display: ->
    @copyPatientDialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true)

  cancel: ->
    @copyPatientDialog.modal('hide')
