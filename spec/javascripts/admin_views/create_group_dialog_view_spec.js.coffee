describe 'NewGroupDialog', ->
  beforeEach ->
    @editDialog = new Thorax.Views.NewGroupDialog()
    @editDialog.appendTo($(document.body))
    @editDialog.display()

  afterEach ->
    @editDialog?.remove()

  it 'add new group', ->
    group_name = "MyGroup"
    group_to_add = {_id: 3, name: group_name}

    spyOn($, "ajax").and.callFake (e) ->
      e.success(group_to_add);

    @editDialog.$("#name").val(group_name).keyup()
    # click add user button @editDialog.$('button[data-call-method="submit_new_group"]').click()
    @editDialog.$('button#save_new_group').click()

    expect($.ajax).toHaveBeenCalled()

  it 'add new group fails with 400', ->
    group_name = "MyGroup"
    response = {status: 400}

    spyOn($, "ajax").and.callFake (e) ->
      e.error(response);

    @editDialog.$("#name").val(group_name).keyup()
    @editDialog.$('button#save_new_group').click()

    expect($.ajax).toHaveBeenCalled()

  it 'add new group fails with 500', ->
    group_name = "MyGroup"
    response = {status: 500, statusText: "Need bigger boat"}

    spyOn($, "ajax").and.callFake (e) ->
      e.error(response);

    @editDialog.$("#name").val(group_name).keyup()
    @editDialog.$('button#save_new_group').click()

    expect($.ajax).toHaveBeenCalled()

  it 'add new group with at sign', ->
    group_name = "MyGroup@"

    spyOn($, "ajax");

    @editDialog.$("#name").val(group_name).keyup()
    @editDialog.$('button#save_new_group').click()

    expect($.ajax).not.toHaveBeenCalled();
