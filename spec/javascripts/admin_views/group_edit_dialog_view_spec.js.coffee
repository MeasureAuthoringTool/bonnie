describe 'GroupEditDialog', ->
  beforeEach ->
    users = [
      {_id: 0,  first_name: 'A', last_name: 'B', email: 'a.b@ab.com'},
      {_id: 1,  first_name: 'C', last_name: 'D', email: 'a.b@cd.com'},
    ]
    @editDialog = new Thorax.Views.GroupEditDialog(
      model: new Thorax.Model(users: users, name: 'CMS', _id: 0)
    )
    @editDialog.appendTo($(document.body))
    @editDialog.display()

  it 'displays initial state of the Group', ->
    existing_users = @editDialog.$('td').toArray().map (e) ->
      e.innerText
    expect(existing_users).toEqual([
      'A B', 'a.b@ab.com', 'Remove',
      'C D', 'a.b@cd.com', 'Remove'
    ])

  it 'adds new user', ->
    user_to_add = {_id: 3,  first_name: 'E', last_name: 'F', email: 'e.f@ef.com'}
    spyOn($, "ajax").and.callFake (e) ->
      e.success(user_to_add);

    @editDialog.$("input#email").val('e.f@ef.com').keyup()
    # click add user button
    @editDialog.$('button#addUser').click()
    expect($.ajax).toHaveBeenCalled()
    # verify if user added to the list
    expect(@editDialog.displayUsersModel.get('usersToAdd').length).toEqual(1)
    users = @editDialog.$('td').toArray().map (e) ->
      e.innerText
    expect(users).toEqual([
      'A B', 'a.b@ab.com', 'Remove',
      'C D', 'a.b@cd.com', 'Remove',
      'E F', 'e.f@ef.com', 'Remove'
    ])

    # submit the form
    @editDialog.$("#name").val('SemanticBits').keyup()
    @editDialog.$('button#save_group').click()
    expect(@editDialog.model.get('name')).toEqual('SemanticBits')

  xit 'cancel user removal action upon canceling confirm action', ->
    # before removal
    expect(@editDialog.displayGroupUsersView.model.get('users').length).toEqual(2)
    @editDialog.$('button[data-call-method="confirmRemoveUser"]').first().click()
    expect(@editDialog.displayGroupUsersView
      .confirmationDialog.$('div#confirmation_dialog p')
      .text())
      .toContain('Are you sure you want to remove A B from CMS?')
    # confirm cancel action
    @editDialog.displayGroupUsersView.confirmationDialog.$('button#cancel_action').click()
    # user not removed
    expect(@editDialog.displayGroupUsersView.model.get('users').length).toEqual(2)
