class Thorax.Views.Users extends Thorax.Views.BonnieView
  className: 'user-management'
  template: JST['users/users']

  events:
    'change .users-sort-list': 'sortUsers'

  initialize: ->
    @userSummaryView = new Thorax.View model: @collection.summary, template: JST['users/user_summary'], toggleStats: ->
      @$('.stats-panel').toggleClass('hidden')
      @$('.btn-toggle-stats').toggleClass('btn-default btn-primary')
    @tableHeaderView = new Thorax.View model: @collection.summary, template: JST['users/table_header'], tagName: 'thead'

  sortUsers: (e) ->
    attr = $(e.target).val()
    @collection.setComparator(attr).sort()

  emailAllUsers: ->
    if !@emailAllUsersView
      @emailAllUsersView = new Thorax.Views.EmailAllUsers()
      @emailAllUsersView.appendTo(@$el)
    @emailAllUsersView.display()

  emailActiveUsers: ->
    if !@emailActiveUsersView
      @emailActiveUsersView = new Thorax.Views.EmailActiveUsers()
      @emailActiveUsersView.appendTo(@$el)
    @emailActiveUsersView.display()
    
class Thorax.Views.User extends Thorax.Views.BonnieView
  template: JST['users/user']
  editTemplate: JST['users/edit_user']
  tagName: 'tr'

  context: ->
    _(super).extend
      isCurrentUser: bonnie.currentUserId == @model.get('_id')
      csrfToken: $("meta[name='csrf-token']").attr('content')

  events:
    serialize: (attr) ->
      attr.admin ?= false
      attr.portfolio ?= false

  approve: -> @model.approve()

  disable: -> @model.disable()

  edit: ->
    @$el.html(@renderTemplate(@editTemplate))
    @populate()

  save: ->
    @serialize()
    @model.save {}, success: => @$el.html(@renderTemplate(@template))

  cancel: -> @$el.html(@renderTemplate(@template))

  showDelete: -> @$('.delete-user').toggleClass('hide')

  delete: -> @model.destroy()

class Thorax.Views.EmailUsers extends Thorax.Views.BonnieView
  template: JST['users/email_users']

  events:
    'ready': 'setup'
    'keypress input:text': 'enableSend'
    'keypress textarea': 'enableSend'

  setup: ->
    @emailUsersDialog = @$("#emailUsersDialog")
    @subjectField = @$("#emailSubject")
    @bodyArea = @$("#emailBody")
    @sendButton = @$("#sendButton")
    @enableSend();

  display: ->
    @emailUsersDialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true).find('.modal-dialog').css('width','650px')

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
        me.bodyArea.val('')
      'complete': @emailUsersDialog.modal('hide')
    })

class Thorax.Views.EmailAllUsers extends Thorax.Views.EmailUsers
  context: ->
    _(super).extend
      token: $("meta[name='csrf-token']").attr('content')
      email_type_label: "All"
      email_action: "admin/users/email_all"
      
class Thorax.Views.EmailActiveUsers extends Thorax.Views.EmailUsers
  context: ->
    _(super).extend
      token: $("meta[name='csrf-token']").attr('content')
      email_type_label: "Active"
      email_action: "admin/users/email_active"
