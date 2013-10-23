class Thorax.Views.ImportMeasure extends Thorax.View
  template: JST['import/import_measure']
  context: ->
    titleSize: 3
    dataSize: 9
    token: $("meta[name='csrf-token']").attr('content')

  events:
    'click #importMeasureSubmit': 'submit'
    'ready': 'setup'

  setup: ->
    @importDialog = @$("#importMeasureDialog")
    @importWait = @$("#pleaseWaitDialog")
    @finalizeDialog = @$("#finalizeMeasureDialog")

  display: ->
    @importDialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true).find('.modal-dialog').css('width','650px')

  submit: ->
    @importDialog.modal('hide')
    @importWait.modal(
      "backdrop" : "static",
      "keyboard" : false,
      "show" : true)
    @$('form').submit()
