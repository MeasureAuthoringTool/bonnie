describe 'UsersViews', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    users_index = getJSONFixture("ajax/users.json")
    users = new Thorax.Collections.Users(users_index)
    @view = new Thorax.Views.Users(collection: users)
    @view.render()

  it 'initializes', ->
    listedEmails = @view.$('td.user-email').toArray().map (e) ->
      e.innerText
    expect(listedEmails).toEqual jasmine.objectContaining [ 'bonnie_2@example.com', 'bonnie_3@example.com', 'bonnie_4@example.com', 'bonnie@example.com' ]

  it 'opens modal on icon click', ->
    @view.$("td.user-email:contains('bonnie_2@example.com')").children("i.email-user").click()
    expect(@view.$("#emailUsersDialog").length).toBe 1
    expect(@view.$('input[name="target_email"]').val()).toBe 'bonnie_2@example.com'
