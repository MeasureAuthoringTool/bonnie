class Thorax.Views.SharePatients extends Thorax.Views.BonnieView
  template: JST['patients/share_patients']

  initialize: ->
    # Build list of measures available to share patients to, exclude current measure
    exclude_id = @model.get('cqmMeasure').hqmf_set_id
    @shareableMeasures = new Thorax.Collections.Measures(@model.collection.models.filter (mes) -> mes.get('cqmMeasure').hqmf_set_id != exclude_id)

  context: ->

  setup: ->
    @sharePatientsDialog = @$("#sharePatientsDialog")

  events:
    rendered: ->
        @$el.on 'hidden.bs.modal', -> @remove() unless $('#sharePatientsDialog').is(':visible')
    'click #sharePatientsSubmit': 'submit'
    'click #sharePatientsCancel': 'cancel'
    'ready': 'setup'
    

  display: ->
    @sharePatientsDialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true)

  submit: ->
    selected = []
    $.each($('div#measureTitles input[type=checkbox]:checked'), -> selected.push($(this).attr('value')))
    hqmf_set_id = this.model.get("cqmMeasure").hqmf_set_id
    $.ajax({
      type: "POST",
      url: '/patients/share_patients',
      dataType: 'json',
      data: {selected: selected, hqmf_set_id: hqmf_set_id}
    });
    @sharePatientsDialog.modal('hide')
    @$('form').submit()

  cancel: ->
    @sharePatientsDialog.modal('hide')