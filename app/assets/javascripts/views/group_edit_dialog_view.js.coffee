class Thorax.Views.GroupEditDialog extends Thorax.Views.BonnieView
  template: JST['users/group_edit_dialog']
  initialize: ->
    @displayUsersModel = new Thorax.Model users: @model.get('users') || []
    @displayUsersModel.set
      usersToAdd: []
      usersToRemove: []
      name: @model.get('name')
    @displayGroupUsersView = new Thorax.Views.DisplayGroupUsersView(model: @displayUsersModel)

  events:
    'click button#save_group': 'submit',
    'keyup input#email': 'validateEmail',
    'keyup input#name': 'validateGroupName',
    'click button#addUser': 'addUser',
    'ready': 'setup'

  setup: ->
    @groupEditDialog = @$("#group_edit_dialog")

  display: ->
    @groupEditDialog.modal(
      "backdrop": "static",
      "keyboard": false,
      "show": true)

  addUser: ->
    view = this
    view.$('#error-message').hide()
    email = @$("input#email").val()
    return unless email
    # check if user already exists in group
    index = view.displayUsersModel.get('users').findIndex((user) -> user.email == email)
    # return if users already exists in group
    return if index != -1
    $.ajax
      url: "admin/users/user_by_email?email=#{email}"
      type: 'GET'
      success: (data) ->
        if(data)
          view.displayUsersModel.get('users').push(data)
          view.displayUsersModel.get('usersToAdd').push(data._id)
          view.displayGroupUsersView.render()
          view.$('#email').val("")
        else
          view.$('#error-message').show()

  submit: ->
    view = this
    group_name = view.$('#name').val()
    if @validateGroupName() && @validateEmail()
      $.ajax
        url: "admin/users/update_group_and_users"
        type: 'POST'
        data: {
          group_id: view.model.get('_id'),
          group_name: group_name
          users_to_add: view.displayUsersModel.get('usersToAdd')
          users_to_remove: view.displayUsersModel.get('usersToRemove')
        }
        success: (response) ->
          view.model.set(name: group_name)
          view.groupEditDialog.modal('hide')
          bonnie.showMsg(
            title: 'Success',
            body: "#{group_name} has been successfully updated."
          )
        error: (response) ->
          error_message = "";

          if(response.status == 400)
            error_message = "Error: Group name #{group_name} is already used."
          else
            error_message = 'Errors: ' + response.statusText

          bonnie.showError(
            title: 'Error',
            body: error_message)

  validateEmail: ->
    email = @$('#email').val()
    @$('#email').parent().removeClass('has-error')
    @$('#error_div').hide()
    return true unless email
    isValid = false
    if UserGroupHelpers.isValidEmail(email)
      isValid = true
    else
      @$('#email').parent().addClass('has-error')
    isValid

  validateGroupName: ->
    isValid = false
    name = @$('#name').val()
    if name && name.indexOf( "@" ) < 0
      @.$('#name').parent().removeClass('has-error')
      isValid = true
    else
      @.$('#name').parent().addClass('has-error')
    isValid

class Thorax.Views.DisplayGroupUsersView extends Thorax.Views.BonnieView
  template: JST['users/display_group_uers']
  tagName: 'div'

  confirmRemoveUser: (e) ->
    view = this
    userId = $(e.target).data('user-id')
    userName = $(e.target).data('user-name')
    # confirmtion message
    confirmationMessage = "Are you sure you want to remove #{userName} from #{@model.get('name')}?"
    # confirmtion dialog
    @confirmationDialog = new Thorax.Views.ConfirmationDialog(
      message: confirmationMessage
      continueCallback: () -> view.removeUser(userId)
    )
    @confirmationDialog.appendTo($('#bonnie'))
    @confirmationDialog.display()

  removeUser: (userId) ->
    @model.get('usersToRemove').push(userId)
    @model.get('usersToAdd').splice(userId)
    index = @model.get('users').findIndex((user) -> user._id == userId)
    @model.get('users').splice(index, 1)
    @render()
