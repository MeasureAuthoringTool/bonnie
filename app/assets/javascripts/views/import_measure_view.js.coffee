class Thorax.Views.ImportMeasure extends Thorax.View
  template: JST['importMeasure']
  context: ->
    titleSize: 3
    dataSize: 9
    token: $("meta[name='csrf-token']").attr('content')

  events:
    'click #importMeasureSubmit': 'submit'
    'ready': 'setup'

  setup: ->
    @importModalStep1 = $("#importMeasureModal")
    @importWait = @$("#pleaseWaitDialog")

  display: ->
    @importModalStep1.modal({
        "backdrop" : "static",
        "keyboard" : true,
        "show" : true
    }).find('.modal-dialog').css('width','650px')

  submit: ->
    @importModalStep1.modal('hide')
    @importWait.modal({
        "backdrop" : "static",
        "keyboard" : false,
        "show" : true})
    @$('form').submit()
