describe 'User', ->

  beforeAll ->
    jasmine.getJSONFixtures().clearCache()
    userJson = {
      "_id": {
        "$oid": "5c8037f5bb9215039d87329e"
      },
      "first_name": "First Name",
      "last_name": "Last Name",
      "admin": false,
      "approved": false,
      "email": "good@email.com"
    }
    @user = new Thorax.Models.User userJson, parse: true

  it 'revert', ->
    expect(@user).toBeDefined()
    expect(@user.get('email')).toBe('good@email.com')
    expect(@user.changed).toEqual({})
    @user.set('email', 'another@email.com')
    expect(@user.changed).not.toEqual({})
    expect(@user.get('email')).toBe('another@email.com')
    @user.revert({"email": "good@email.com"})
    expect(@user.get('email')).toBe('good@email.com')
    expect(@user.changed).toEqual({})
