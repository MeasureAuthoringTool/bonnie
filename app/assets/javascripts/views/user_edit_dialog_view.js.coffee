class Thorax.Views.UserEditDialog extends Thorax.Views.BonnieView
  template: JST['users/user_edit_dialog']

  initialize: ->
    @groupsModel = new Thorax.Model groups: @model.get('groups') || []
    @groupsModel.set
      groupsToAdd: []
      groupsToRemove: []
    @displayUserGroupsView = new Thorax.Views.DisplayUserGroupsView(
      model: @groupsModel
      userModel: @model
    )

  setup: ->
    @userEditDialog = @$("#user-edit-dialog")
    @validate()

  events:
    rendered: ->
      @$el.on 'hidden.bs.modal', -> @remove()
    'click #saveUserDialogOK': 'submit'
    'click #saveUserDialogCancel': 'cancel'
    'ready': 'setup'
    'click button#addGroup': 'addGroup'

    serialize: (attr) ->
      attr.admin ?= false
      attr.portfolio ?= false
      attr.approved ?= false
    'keyup input': 'validate'
    'change input': 'validate'

  display: ->
    @userEditDialog.modal(
      "backdrop": "static",
      "keyboard": false,
      "show": true)

  addGroup: ->
    view = this
    view.$('#error-message').hide()
    groupName = @$("input#groupName").val()
    unless groupName
      view.$('#error-message').html("Group name is required").show()
      return
    index = view.model.get('groups').findIndex((group) -> group.name == groupName)
    if index != -1
      view.$('#error-message').html("Group name already exists").show()
      return
    $.ajax
      url: "admin/groups/find_group_by_name"
      type: 'GET'
      data: {
        group_name: groupName
      }
      success: (data) ->
        if(data)
          if(!data.is_personal)
            view.groupsModel.get('groups').push(data)
            view.groupsModel.get('groupsToAdd').push(data._id)
            view.displayUserGroupsView.render()
            view.$('#groupName').val("")
          else
            view.$('#error-message').html("This is a private group").show()
        else
          view.$('#error-message').html("Not a valid group").show()

  submit: ->
    view = this
    $.ajax
      url: "admin/users/update_groups_to_a_user"
      type: 'POST'
      data: {
        user_id: view.model.get('_id'),
        groups_to_add: view.groupsModel.get('groupsToAdd'),
        groups_to_remove: view.groupsModel.get('groupsToRemove')
      }
      success: (response) ->
        view.model.set group_ids: response.group_ids
        view.userEditDialog.modal('hide')
        bonnie.showMsg(
          title: 'Success',
          body: "#{view.model.get('first_name')} #{view.model.get('last_name')} has been successfully updated."
        )
      error: (response) ->
        bonnie.showError(
          title: 'Error',
          body: 'Errors: ' + response.statusText)
      @serialize()
      @userEditDialog.modal('hide')
      @submitCallback?()

  cancel: ->
    @userEditDialog.modal('hide')
    @cancelCallback?()

  isValidHarp: (harpId) ->
    re = /\s/
    !re.test(harpId)

  validate: ->
    emailInput = @$('input[name="email"]')
    email = emailInput.val()

    harpInput = @$('input[name="harp_id"]')
    haprId = harpInput.val()

    valid = true
    if UserGroupHelpers.isValidEmail(email)
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


class Thorax.Views.DisplayUserGroupsView extends Thorax.Views.BonnieView
  template: JST['users/display_user_groups']
  tagName: 'div'

  confirmRemoveGroup: (e) ->
    view = this
    groupId = $(e.target).data('group-id')
    groupName = $(e.target).data('group-name')
    confirmationMessage = "Are you sure you want to remove user #{@userModel.get('first_name')} #{@userModel.get('last_name')} from #{groupName} ?"
    @confirmationDialog = new Thorax.Views.ConfirmationDialog(
      message: confirmationMessage
      continueCallback: () -> view.removeGroupForUser(groupId)
    )
    @confirmationDialog.appendTo($(document.body))
    @confirmationDialog.display()

  removeGroupForUser: (groupId) ->
    @model.get('groupsToRemove').push(groupId)
    index = @model.get('groups').findIndex((group) -> group._id == groupId)
    @model.get('groups').splice(index, 1)
    @render()
