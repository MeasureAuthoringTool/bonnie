describe 'UserEditDialog', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    users_index = getJSONFixture("ajax/users.json")
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
    @userEditDialog.$('#approved').prop('checked', true);
    @userEditDialog.$('#admin').prop('checked', true);
    @userEditDialog.$('#portfolio').prop('checked', true);
    @userEditDialog.$('#saveUserDialogCancel').click()
    expect(@userEditDialog.cancel).toHaveBeenCalled()
    expect(@model.attributes.email).toBe("bonnie_2@example.com")
    expect(@model.attributes.approved).toBe(false)
    expect(@model.attributes.admin).toBe(false)
    expect(@model.attributes.portfolio).toBe(false)

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
    @userEditDialog.$('#approved').prop('checked', true);
    @userEditDialog.$('#admin').prop('checked', true);
    @userEditDialog.$('#portfolio').prop('checked', true);
    @userEditDialog.$('#saveUserDialogOK').click()
    expect(@userEditDialog.submit).toHaveBeenCalled()
    expect(@model.attributes.email).toBe("newemail@gmail.com")
    expect(@model.attributes.approved).toBe(true)
    expect(@model.attributes.admin).toBe(true)
    expect(@model.attributes.portfolio).toBe(true)

  it 'isValidEmail', ->
    @userEditDialog = new Thorax.Views.UserEditDialog(
      model: @model,
      cancelCallback: () -> {},
      submitCallback: () -> {}
    )
    expect(@userEditDialog.isValidEmail('someone@google.com')).toBe(true)
    expect(@userEditDialog.isValidEmail('wrong email@google.com')).toBe(false)
    expect(@userEditDialog.isValidEmail('')).toBe(false)
    expect(@userEditDialog.isValidEmail(' ')).toBe(false)
    expect(@userEditDialog.isValidEmail('a@google')).toBe(false)

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
    expect(@userEditDialog.$('#email').parent.hasClass('has-error')).toBe(false)

    # Enter invalid email
    @userEditDialog.$('#email').val('').change()
    expect(@userEditDialog.$('#email').val()).toBe('')

    expect(@userEditDialog.$('#saveUserDialogOK').is(':disabled')).toBe(true)
    expect(@userEditDialog.$('#email').parent.hasClass("has-error")).toBe(true)

    # Enter valid email
    @userEditDialog.$('#email').val('bonnie_2@example.com').change()
    expect(@userEditDialog.$('#email').val()).toBe('bonnie_2@example.com')

    expect(@userEditDialog.$('#saveUserDialogOK').is(':disabled')).toBe(false)
    expect(@userEditDialog.$('#email').parent.hasClass("has-error")).toBe(false)

