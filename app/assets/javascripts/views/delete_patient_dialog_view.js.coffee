class Thorax.Views.DeletePatientDialog extends Thorax.Views.BonnieView
  template: JST['patients/delete_patient']

  setup: ->
    @deletePatientDialog = @$("#deletePatientDialog")

  events:
    rendered: ->
        @$el.on 'hidden.bs.modal', -> @remove() unless $('#deletePatientDialog').is(':visible')
    'click #deletePatientSubmit': 'submit'
    'click #deletePatientCancel': 'cancel'
    'ready': 'setup'
    

  display: ->
    @deletePatientDialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true)

  submit: ->
    selected = []
    $.each($('div#measureTitles input[type=checkbox]:checked'), -> selected.push($(this).attr('value')))
    @submitCallback(@model, selected, @difference)
    @deletePatientDialog.modal('hide')
    @$('form').submit()

  cancel: ->
    @deletePatientDialog.modal('hide')