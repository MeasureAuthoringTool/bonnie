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
    $('#email').val('newemail@gmail.com');
    $('#approved').prop('checked', true);
    $('#admin').prop('checked', true);
    $('#portfolio').prop('checked', true);
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
    $('#email').val('newemail@gmail.com');
    $('#approved').prop('checked', true);
    $('#admin').prop('checked', true);
    $('#portfolio').prop('checked', true);
    @userEditDialog.$('#saveUserDialogOK').click()
    expect(@userEditDialog.submit).toHaveBeenCalled()
    expect(@model.attributes.email).toBe("newemail@gmail.com")
    expect(@model.attributes.approved).toBe(true)
    expect(@model.attributes.admin).toBe(true)
    expect(@model.attributes.portfolio).toBe(true)

