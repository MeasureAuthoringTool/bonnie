describe 'UserEditDialog', ->
  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    users_index = getJSONFixture('ajax/users.json')
    users = new Thorax.Collections.Users(users_index)
    @model = users.models[0]

  afterEach ->
    @userEditDialog?.remove()

  it 'check cancel', ->
    spyOn(Thorax.Views.UserEditDialog.prototype, 'cancel').and.callThrough()
    @userEditDialog = new Thorax.Views.UserEditDialog(
      model: @model,
      cancelCallback: () -> {},
      submitCallback: () -> {}
    )
    @userEditDialog.appendTo($(document.body))
    @userEditDialog.display()
    expect($('#user-edit-dialog')).toBeVisible()
    @userEditDialog.$('#email').val('newemail@gmail.com');
    @userEditDialog.$('#harp_id').val('newharp');
    @userEditDialog.$('#approved').prop('checked', true);
    @userEditDialog.$('#admin').prop('checked', true);
    @userEditDialog.$('#portfolio').prop('checked', true);
    @userEditDialog.$('#saveUserDialogCancel').click()
    expect(@userEditDialog.cancel).toHaveBeenCalled()
    expect(@model.attributes.email).toBe("bonnie_2@example.com")
    expect(@model.attributes.approved).toBe(false)
    expect(@model.attributes.admin).toBe(false)
    expect(@model.attributes.portfolio).toBe(false)
    expect(@model.attributes.harp_id).toBeUndefined()

  it 'check submit', ->
    spyOn(Thorax.Views.UserEditDialog.prototype, 'submit').and.callThrough()
    @userEditDialog = new Thorax.Views.UserEditDialog(
      model: @model,
      cancelCallback: () -> {},
      submitCallback: () -> {}
    )
    @userEditDialog.appendTo($(document.body))
    @userEditDialog.display()
    expect($('#user-edit-dialog')).toBeVisible()
    @userEditDialog.$('#email').val('newemail@gmail.com');
    @userEditDialog.$('#harp_id').val('newharp');
    @userEditDialog.$('#approved').prop('checked', true);
    @userEditDialog.$('#admin').prop('checked', true);
    @userEditDialog.$('#portfolio').prop('checked', true);
    @userEditDialog.$('#saveUserDialogOK').click()
    expect(@userEditDialog.submit).toHaveBeenCalled()
    expect(@model.attributes.email).toBe('newemail@gmail.com')
    expect(@model.attributes.harp_id).toBe('newharp')
    expect(@model.attributes.approved).toBe(true)
    expect(@model.attributes.admin).toBe(true)
    expect(@model.attributes.portfolio).toBe(true)

  it 'isValidEmail', ->
    expect(UserGroupHelpers.isValidEmail('someone@google.com')).toBe(true)
    expect(UserGroupHelpers.isValidEmail('wrong email@google.com')).toBe(false)
    expect(UserGroupHelpers.isValidEmail('')).toBe(false)
    expect(UserGroupHelpers.isValidEmail(' ')).toBe(false)
    expect(UserGroupHelpers.isValidEmail('a@google')).toBe(false)

  it 'isValidHarp', ->
    @userEditDialog = new Thorax.Views.UserEditDialog(
      model: @model,
      cancelCallback: () -> {},
      submitCallback: () -> {}
    )
    expect(@userEditDialog.isValidHarp('someone@google.com')).toBe(true)
    expect(@userEditDialog.isValidHarp('wrong email@google.com')).toBe(false)
    expect(@userEditDialog.isValidHarp(' spaces around ')).toBe(false)
    expect(@userEditDialog.isValidHarp(' ')).toBe(false)
    expect(@userEditDialog.isValidHarp('someone.here')).toBe(true)

  it 'validates email', ->
    @userEditDialog = new Thorax.Views.UserEditDialog(
      model: @model,
      cancelCallback: () -> {},
      submitCallback: () -> {}
    )
    @userEditDialog.appendTo($(document.body))
    @userEditDialog.display()

    expect(@userEditDialog.$('#email').val()).toBe('bonnie_2@example.com')

    expect(@userEditDialog.$('#saveUserDialogOK').is(':disabled')).toBe(false)
    expect(@userEditDialog.$('#email').parent().hasClass('has-error')).toBe(false)

    # Enter invalid email
    @userEditDialog.$('#email').val('').change()
    expect(@userEditDialog.$('#email').val()).toBe('')

    expect(@userEditDialog.$('#saveUserDialogOK').is(':disabled')).toBe(true)
    expect(@userEditDialog.$('#email').parent().hasClass('has-error')).toBe(true)

    # Enter valid email
    @userEditDialog.$('#email').val('bonnie_2@example.com').change()
    expect(@userEditDialog.$('#email').val()).toBe('bonnie_2@example.com')

    expect(@userEditDialog.$('#saveUserDialogOK').is(':disabled')).toBe(false)
    expect(@userEditDialog.$('#email').parent().hasClass('has-error')).toBe(false)

  it 'validates harpid', ->
    @userEditDialog = new Thorax.Views.UserEditDialog(
      model: @model,
      cancelCallback: () -> {},
      submitCallback: () -> {}
    )
    @userEditDialog.appendTo($(document.body))
    @userEditDialog.display()

    # default empty harp id is valid
    expect(@userEditDialog.$('#harp_id').val()).toBe('')
    expect(@userEditDialog.$('#saveUserDialogOK').is(':disabled')).toBe(false)
    expect(@userEditDialog.$('#harp_id').parent().hasClass('has-error')).toBe(false)

    # Enter invalid harp
    @userEditDialog.$('#harp_id').val(' invalid harp ').change()
    expect(@userEditDialog.$('#harp_id').val()).toBe(' invalid harp ')
    expect(@userEditDialog.$('#saveUserDialogOK').is(':disabled')).toBe(true)
    expect(@userEditDialog.$('#harp_id').parent().hasClass('has-error')).toBe(true)

    # Enter valid harp
    @userEditDialog.$('#harp_id').val('newharp').change()
    expect(@userEditDialog.$('#harp_id').val()).toBe('newharp')
    expect(@userEditDialog.$('#saveUserDialogOK').is(':disabled')).toBe(false)
    expect(@userEditDialog.$('#harp_id').parent().hasClass('has-error')).toBe(false)


  describe 'addGroup', ->
    beforeEach ->
      @userWithGroup = new Thorax.Model({
        "_id": "5f402443c6a2dbf8d74bcd29",
        "admin": true,
        "approved": true,
        "crosswalk_enabled": false,
        "dashboard": false,
        "dashboard_set": false,
        "email": "bonnie@example.com",
        "first_name": 'firstName',
        "last_name": 'lastName',
        "portfolio": false,
        "telephone": null,
        "measure_count": 2,
        "patient_count": 0,
        "last_sign_in_at": "2020-08-21T19:45:20.673Z",
        groups: [
          {_id: 0, name: 'Group1', is_personal: false},
          {_id: 1, name: 'Group2', is_personal: true},
        ],
        group_ids: [new Object('1')]
      })

    it 'should require a group name', ->
      @userEditDialog = new Thorax.Views.UserEditDialog(
        model: @userWithGroup,
        cancelCallback: () -> {},
        submitCallback: () -> {}
      )
      @userEditDialog.appendTo($(document.body))
      @userEditDialog.display()

      @userEditDialog.$('button#addGroup').click()
      expect(@userEditDialog.$('#error-message').html()).toBe("Group name is required")
      @userEditDialog?.remove()

    it 'should not add an existing group', ->
      @userEditDialog = new Thorax.Views.UserEditDialog(
        model: @userWithGroup,
        cancelCallback: () -> {},
        submitCallback: () -> {}
      )
      @userEditDialog.appendTo($(document.body))
      @userEditDialog.display()

      @userEditDialog.$('input#groupName').val('Group1').keyup()
      @userEditDialog.$('button#addGroup').click()
      expect(@userEditDialog.$('#error-message').html()).toBe("Group name already exists")

    it 'should add public group to the list', ->
      group_to_add = {_id: 2, name: 'Group4', is_personal: false}
      ajax_spy = spyOn($, "ajax").and.callFake (e) ->
        e.success(group_to_add);
      @userEditDialog = new Thorax.Views.UserEditDialog(
        model: @userWithGroup,
        cancelCallback: () -> {},
        submitCallback: () -> {}
      )
      @userEditDialog.appendTo($(document.body))
      @userEditDialog.display()

      @userEditDialog.$('input#groupName').val('Group3').keyup()
      @userEditDialog.$('button#addGroup').click()
      expect(ajax_spy).toHaveBeenCalled()

      expect(@userEditDialog.displayUserGroupsView.model.get('groups').length).toEqual(3)

    it 'should not add private group to the list', ->
      group_to_add = {_id: 2, name: 'Group3', is_personal: true}
      ajax_spy = spyOn($, "ajax").and.callFake (e) ->
        e.success(group_to_add);

      @userEditDialog = new Thorax.Views.UserEditDialog(
        model: @userWithGroup,
        cancelCallback: () -> {},
        submitCallback: () -> {}
      )
      @userEditDialog.appendTo($(document.body))
      @userEditDialog.display()

      @userEditDialog.$('input#groupName').val('Group3').keyup()
      @userEditDialog.$('button#addGroup').click()

      expect(ajax_spy).toHaveBeenCalled()

      expect(@userEditDialog.$('#error-message').html()).toBe("This is a private group")
      expect(@userEditDialog.displayUserGroupsView.model.get('groups').length).toEqual(2)

    xit 'should remove group for the user', ->
      @userEditDialog = new Thorax.Views.UserEditDialog(
        model: @userWithGroup,
        cancelCallback: () -> {},
        submitCallback: () -> {}
      )
      @userEditDialog.appendTo($(document.body))
      @userEditDialog.display()

      expect(@userEditDialog.displayUserGroupsView.model.get('groups').length).toEqual(2)
      @userEditDialog.$('button[data-call-method="confirmRemoveGroup"]').first().click()
      expect(@userEditDialog.displayUserGroupsView
        .confirmationDialog.$('div#confirmation_dialog p')
        .text())
        .toContain('Are you sure you want to remove user firstName lastName from Group1 ?')
      @userEditDialog.displayUserGroupsView.confirmationDialog.$('button#continue_action').click()
      expect(@userEditDialog.displayUserGroupsView.model.get('groups').length).toEqual(1)

    xit 'should abort group removal action', ->
      @userEditDialog = new Thorax.Views.UserEditDialog(
        model: @userWithGroup,
        cancelCallback: () -> {},
        submitCallback: () -> {}
      )
      @userEditDialog.appendTo($(document.body))
      @userEditDialog.display()

      expect(@userEditDialog.displayUserGroupsView.model.get('groups').length).toEqual(2)
      @userEditDialog.$('button[data-call-method="confirmRemoveGroup"]').first().click()
      expect(@userEditDialog.displayUserGroupsView
        .confirmationDialog.$('div#confirmation_dialog p')
        .text())
        .toContain('Are you sure you want to remove user firstName lastName from Group1 ?')
      @userEditDialog.displayUserGroupsView.confirmationDialog.$('button#cancel_action').click()
      expect(@userEditDialog.displayUserGroupsView.model.get('groups').length).toEqual(2)
