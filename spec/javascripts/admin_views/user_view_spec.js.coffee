describe 'UserView', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    users_index = getJSONFixture("ajax/users.json")
    users = new Thorax.Collections.Users(users_index)
    @model = users.models[0]

  afterEach ->
    @view?.remove()
    $('#user-edit-dialog').remove()


  it 'user edit and save dialog', ->
	  groups = [{_id: 1,  name: 'Group1', is_personal: true}, {_id: 2,  name: 'Group2', is_personal: false}]
	  spyOn($, "ajax").and.callFake (e) ->
		  e.success(groups);
    spyOn(Thorax.Views.User.prototype, 'save')#.and.callThrough()
    @view = new Thorax.Views.User(model: @model)
    @view.render()
    expect($('#user-edit-dialog')).not.toBeVisible()
    @view.edit()
		expect($('#user-edit-dialog')).toBeVisible()
		$('#saveUserDialogOK').click()
		expect(@view.save).toHaveBeenCalled()

  it 'user edit and cancel dialog', ->
	  groups = [{_id: 1,  name: 'Group1', is_personal: true}, {_id: 2,  name: 'Group2', is_personal: false}]
	  spyOn($, "ajax").and.callFake (e) ->
		  e.success(groups);
    spyOn(Thorax.Views.User.prototype, 'cancel')#.and.callThrough()
    @view = new Thorax.Views.User(model: @model)
    @view.render()
    expect($('#user-edit-dialog')).not.toBeVisible()
    @view.edit()
    expect($('#user-edit-dialog')).toBeVisible()
    $('#saveUserDialogCancel').click()
    expect(@view.cancel).toHaveBeenCalled()


