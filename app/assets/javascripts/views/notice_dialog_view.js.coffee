class Thorax.Views.NoticeDialog extends Thorax.Views.BonnieView
  template: JST['notice_dialog']

  display: ->
    @$('#noticeDialog').modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true)
  events:
    rendered: -> 
      @$el.on 'hidden.bs.modal', -> @remove()
