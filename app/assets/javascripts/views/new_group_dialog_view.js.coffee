class Thorax.Views.NewGroupDialog extends Thorax.Views.BonnieView
  template: JST['users/new_group_dialog']

  events:
    'click button#save_new_group': 'submit_new_group',
    'ready': 'setup'

  setup: ->
    @newGroupDialog = @$("#new_group_dialog")

  display: ->
    @newGroupDialog.modal(
      "backdrop": "static",
      "keyboard": false,
      "show": true)

  submit_new_group: ->
    view = this
    group_name = view.$('#name').val()
    if @validateGroupName()
      $.ajax
        url: "admin/groups/create_group"
        type: 'POST'
        data: {
          group_name: group_name
        }
        success: (response) ->
          console.log(JSON.stringify(response))
          view.newGroupDialog.modal('hide')

          bonnie.showMsg(
            title: 'Success',
            body: "#{group_name} has been successfully created. Reresh page to see results"
          )

          #window.location.reload()

        error: (response) ->
          error_message = "";
          if(response.status == 400)
            error_message = "Error: Group name #{group_name} is already used."
          else
            error_message = 'Errors: ' + response.statusText

          bonnie.showError(
            title: 'Error',
            body: error_message)

  validateGroupName: ->
    isValid = false
    name = @$('#name').val()
    if name
      @.$('#name').parent().removeClass('has-error')
      isValid = true
    else
      @.$('#name').parent().addClass('has-error')
    isValid



