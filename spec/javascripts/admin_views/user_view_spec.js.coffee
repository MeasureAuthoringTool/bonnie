describe 'UserView', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    users_index = getJSONFixture("ajax/users.json")
    users = new Thorax.Collections.Users(users_index)
    @model = users.models[0]

  afterEach ->
    @view?.remove()
    $('#userEditDialog').remove()


  it 'user edit and save dialog', ->
    spyOn(Thorax.Views.User.prototype, 'save')#.and.callThrough()
    @view = new Thorax.Views.User(model: @model)
    @view.render()
    expect($('#userEditDialog')).not.toBeVisible()
    @view.edit()
    expect($('#userEditDialog')).toBeVisible()
    $('#saveUserDialogOK').click()
    expect(@view.save).toHaveBeenCalled()

  it 'user edit and cancel dialog', ->
    spyOn(Thorax.Views.User.prototype, 'cancel')#.and.callThrough()
    @view = new Thorax.Views.User(model: @model)
    @view.render()
    expect($('#userEditDialog')).not.toBeVisible()
    @view.edit()
    expect($('#userEditDialog')).toBeVisible()
    $('#saveUserDialogCancel').click()
    expect(@view.cancel).toHaveBeenCalled()


