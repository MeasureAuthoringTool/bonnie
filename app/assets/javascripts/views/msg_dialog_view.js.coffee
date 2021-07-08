class Thorax.Views.MsgDialog extends Thorax.Views.BonnieView
  template: JST['msg_dialog']

  display: ->
    @$('#msgDialog').modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true)
  events:
    rendered: -> 
      @$el.on 'hidden.bs.modal', -> @remove()
