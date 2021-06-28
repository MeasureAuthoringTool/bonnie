class Thorax.Views.SwitchRoleConfirmationDialog extends Thorax.Views.BonnieView
  template: JST['switch_role_confirmation_dialog']

  setup: ->
    @switchRoleDialog = @$("#switchRoleConfirmationDialog")

  events:
    rendered: ->
      @$el.on 'hidden.bs.modal', -> @remove()
    'click #switchRoleConfirm': 'submit'
    'click #switchRoleCancel': 'cancel'
    'ready': 'setup'
    
  display: (confirmCallback) ->
    @confirmCallback = confirmCallback
    @switchRoleDialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true)

  submit: ->
    @switchRoleDialog.modal('hide')
    window.location = @href

  cancel: ->
    @switchRoleDialog.modal('hide')
