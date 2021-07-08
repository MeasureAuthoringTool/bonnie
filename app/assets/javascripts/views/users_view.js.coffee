class Thorax.Views.Users extends Thorax.Views.BonnieView
  className: 'user-management'
  template: JST['users/users']

  events:
    'change .users-sort-list': 'sortUsers'

  initialize: ->
    @userSummaryView = new Thorax.View model: @collection.summary, template: JST['users/user_summary'], toggleStats: ->
      @$('.stats-panel').toggleClass('hidden')
      @$('.btn-toggle-stats').toggleClass('btn-default btn-primary')
    @tableHeaderView = new Thorax.View model: @collection.summary, template: JST['users/user_table_header'], tagName: 'thead'
    @userGroupTabs = new Thorax.Views.UserGroupTabs({activeTab: 'users'})

  sortUsers: (e) ->
    attr = $(e.target).val()
    @collection.setComparator(attr).sort()

  emailAllUsers: ->
    if !@emailAllUsersView
      @emailAllUsersView = new Thorax.Views.EmailAllUsers()
      @emailAllUsersView.appendTo($(document.body))
    @emailAllUsersView.display()

  emailActiveUsers: ->
    if !@emailActiveUsersView
      @emailActiveUsersView = new Thorax.Views.EmailActiveUsers()
      @emailActiveUsersView.appendTo($(document.body))
    @emailActiveUsersView.display()

class Thorax.Views.User extends Thorax.Views.BonnieView
  template: JST['users/user']
  tagName: 'tr'

  context: ->
    _(super).extend
      isCurrentUser: bonnie.currentUserId == @model.get('_id')
      csrfToken: $("meta[name='csrf-token']").attr('content')

  events:
    'click .email-user': 'emailUser'

  approve: -> @model.approve()

  disable: -> @model.disable()

  edit: ->
    view = this
    $.ajax
      url: "admin/groups/get_groups_by_group_ids"
      type: 'POST'
      data: {
        group_ids: @model.get('group_ids')
      }
      success: (data) ->
        view.model.set groups: data
        userEditDialog = new Thorax.Views.UserEditDialog(
          model: view.model,
          cancelCallback: () -> view.cancel(),
          submitCallback: () -> view.save()
        )
        userEditDialog.appendTo($(document.body))
        userEditDialog.display()

  save: ->
    view = this
    changed = @model.changedAttributes()
    prevAttributes = _.pick(@model.previousAttributes(), _.keys(changed))
    approveChanged = @model.hasChanged('harp_id') && !(prevAttributes.harp_id && @model.changed.harp_id)
    approved = changed? && @model.changed.harp_id

    # should store the model first, then approve/disable, otherwsie the model gets refreshed from the DB
    if changed
      @model.save {},
        success: =>
          @$el.html(@renderTemplate(@template))
          if approveChanged
            @updateApprove(approved)
        error: (model, response) =>
          view.model.revert(prevAttributes)
          view.showUserError(response)

  showUserError: (response) ->
    errorSummary = response?.statusText || 'Failed to save user '
    errors = response?.responseJSON?.errors
    errorsText = if errors then Object.entries(errors)?.map((a) -> a.join(' - ')).join(', ') else 'Unhandled server exception'
    bonnie.showError(
      title: 'User save error',
      summary: errorSummary
      body: 'Errors: ' + errorsText)

  updateApprove: (approved) ->
    if approved
      @approve()
    else
      @disable()

  cancel: ->
    if @model.changedAttributes()
      prevAttributes = _.pick(@model.previousAttributes(), _.keys(changed))
      view.model.revert(prevAttributes)
    @$el.html(@renderTemplate(@template))

  showDelete: -> @$('.delete-user').toggleClass('hide')

  delete: -> @model.destroy()

  emailUser: ->
    if !@emailUserView
      @emailUserView = new Thorax.Views.EmailUser({email: @model.attributes.email})
      @emailUserView.appendTo($(document.body))
    @emailUserView.display()

class Thorax.Views.EmailUsers extends Thorax.Views.BonnieView
  template: JST['users/email_users']

  events:
    'ready': 'setup'
    'keydown input:text': 'enableSend'
    'change textarea': 'enableSend'

  context: ->
    @bodyAreaId = 'emailBody' + Date.now()
    _(super).extend
      body_area_id: @bodyAreaId

  setup: ->
    @emailUsersDialog = @$("#emailUsersDialog")
    @subjectField = @$("#emailSubject")
    @bodyAreaSelector = '#' + @bodyAreaId
    @bodyArea = @$(@bodyAreaSelector)
    @sendButton = @$("#sendButton")
    @enableSend()

  display: ->
    me = this
    @emailUsersDialog.modal(
      backdrop: 'static',
      keyboard: true,
      show: true).find('.modal-dialog').css('width','650px')
    tinymce.init({
      selector: @bodyAreaSelector
      height: 400
      plugins: 'link lists'
      toolbar: 'undo redo | formatselect | bold italic backcolor | ' +
        'link unlink | numlist bullist outdent indent | ' +
        'alignleft aligncenter alignright | removeformat'
      menubar: false
      statusbar: false
      setup: (editor) ->
        editor.on('change', ->
          editor.save()
          me.bodyArea.trigger('change')
        )
    })
    # Allow tinymce dialogs to work in Bootstrap
    $(document).on('focusin', (e) ->
      if $(e.target).closest('.tox-tinymce-aux, .moxman-window, .tam-assetmanager-root').length
        e.stopImmediatePropagation()
    )

  enableSend: ->
    @sendButton.prop('disabled', @subjectField.val().length == 0 || @bodyArea.val().length == 0)

  close: -> ''
    # Should we ask the user to confirm that they want to cancel if there's content?

  submit: ->
    form = @$('form')
    me = this
    $.ajax(form.attr('action'), {
      'type': 'POST',
      'data': form.serialize(),
      'success': ->
        # Kill the subject and body areas if we've successfully sent our message
        me.subjectField.val('')
        tinymce.activeEditor.setContent('')
        me.bodyArea.val('')
      'complete': @emailUsersDialog.modal('hide')
    })

class Thorax.Views.EmailAllUsers extends Thorax.Views.EmailUsers
  context: ->
    _(super).extend
      token: $("meta[name='csrf-token']").attr('content')
      email_modal_title: "Email All Users"
      email_action: "admin/users/email_all"

class Thorax.Views.EmailActiveUsers extends Thorax.Views.EmailUsers
  context: ->
    _(super).extend
      token: $("meta[name='csrf-token']").attr('content')
      email_modal_title: "Email Active Users"
      email_action: "admin/users/email_active"

class Thorax.Views.EmailUser extends Thorax.Views.EmailUsers
  context: ->
    _(super).extend
      token: $("meta[name='csrf-token']").attr('content')
      email_modal_title: "Email Single User"
      email_action: "admin/users/email_single"
      target_email_address: @email
