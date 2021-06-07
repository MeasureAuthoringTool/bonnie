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
    expect($('#userEditDialog')).toBeVisible()
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
    expect($('#userEditDialog')).toBeVisible()
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
