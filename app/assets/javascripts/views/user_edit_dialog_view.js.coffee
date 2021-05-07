class Thorax.Views.UserEditDialog extends Thorax.Views.BonnieView
  template: JST['users/user_edit_dialog']

  setup: ->
    @userEditDialog = @$("#userEditDialog")

  events:
    rendered: ->
      @$el.on 'hidden.bs.modal', -> @remove()
    'click #saveUserDialogOK': 'submit'
    'click #saveUserDialogCancel': 'cancel'
    'ready': 'setup'
    serialize: (attr) ->
      attr.admin ?= false
      attr.portfolio ?= false
      attr.approved ?= false

  display: ->
    @userEditDialog.modal(
      "backdrop" : "static",
      "keyboard" : false,
      "show" : true)

  submit: ->
    @serialize()
    @userEditDialog.modal('hide')
    @submitCallback?()

  cancel: ->
    @userEditDialog.modal('hide')
    @cancelCallback?()
