class Thorax.Views.CopyPatientView extends Thorax.Views.BonnieView
  template: JST['patients/copy_patient']

  initialize: ->
    @modelDialogHeaderText = 'Copy Patient Across Measures'
    @modelDialogInfoText = 'Please select which measures you would like to copy your patient to'
    @copyAction = 'copy_patient'
    # Prepare list of target measures to be selected, exclude current measure
    @measure_id = @model.get('cqmMeasure').id
    exclude_id = @model.get('cqmMeasure').set_id
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

class Thorax.Views.CopyPatientsView extends Thorax.Views.CopyPatientView
  initialize: ->
    super
    @copyAction = 'copy_all_patients'
    @modelDialogHeaderText = 'Clone Patients Across Measures'
    @modelDialogInfoText = 'Please select which measures you would like to clone all patients to'
