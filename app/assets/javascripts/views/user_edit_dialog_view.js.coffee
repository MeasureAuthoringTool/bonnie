class Thorax.Views.UserEditDialog extends Thorax.Views.BonnieView
  template: JST['users/user_edit_dialog']

  setup: ->
    @userEditDialog = @$("#userEditDialog")
    @validate()

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
    'keyup input': 'validate'
    'change input': 'validate'

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

  isValidEmail: (email) ->
    re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    re.test(email)

  isValidHarp: (harpId) ->
    re = /\s/
    !re.test(harpId)

  validate: ->
    emailInput = @$('input[name="email"]')
    email = emailInput.val()

    harpInput = @$('input[name="harp_id"]')
    haprId = harpInput.val()

    valid = true
    if @isValidEmail(email)
      emailInput.parent().removeClass('has-error')
    else
      emailInput.parent().addClass('has-error')
      valid = false

    if haprId == "" || @isValidHarp(haprId)
      harpInput.parent().removeClass('has-error')
    else
      harpInput.parent().addClass('has-error')
      valid = false

    if valid
      @$('#saveUserDialogOK').removeAttr('disabled')
    else
      @$('#saveUserDialogOK').attr('disabled', 'disabled')

