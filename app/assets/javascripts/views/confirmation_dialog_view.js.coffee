class Thorax.Views.ConfirmationDialog extends Thorax.Views.BonnieView
  template: JST['confirmation_dialog']

  display: ->
    @$('#confirmation_dialog').modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true)
  events:
    rendered: ->
      @$el.on 'hidden.bs.modal', -> @remove()

  continueAction: ->
    @continueCallback()
    @hideModal()

  hideModal: ->
    @$('#confirmation_dialog').modal('hide')
