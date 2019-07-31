class Thorax.Views.SharePatients extends Thorax.Views.BonnieView
  template: JST['patients/share_patients']

  initialize: ->
    # Build list of measures available to share patients to, exclude current measure
    exclude_id = @model.get('cqmMeasure').hqmf_set_id
    @hqmf_set_id = exclude_id
    @shareableMeasures = new Thorax.Collections.Measures(@model.collection.models.filter (mes) -> mes.get('cqmMeasure').hqmf_set_id != exclude_id)

  context: ->
    _(super).extend
      token: $('meta[name="csrf-token"]').attr('content')

  setup: ->
    @sharePatientsDialog = @$("#sharePatientsDialog")

  events:
    rendered: ->
        @$el.on 'hidden.bs.modal', -> @remove() unless $('#sharePatientsDialog').is(':visible')
    'click #sharePatientsCancel': 'cancel'
    'ready': 'setup'
    

  display: ->
    @sharePatientsDialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true)

  cancel: ->
    @sharePatientsDialog.modal('hide')