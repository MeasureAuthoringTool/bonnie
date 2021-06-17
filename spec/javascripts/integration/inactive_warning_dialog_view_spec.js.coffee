describe 'InactiveWarningDialog', ->
  beforeAll ->
    jasmine.getJSONFixtures().clearCache()
    @wrn = new Thorax.Views.InactiveWarningDialog(countdownMs: 1000)

  afterAll ->
    @wrn.remove()

  it 'draw inactive warning dialog', ->
    @wrn.appendTo(document.body)
    @wrn.display()
    expect($('#inactiveWarningDialog')).toBeVisible()
    expect($(@wrn.$el)).toBeVisible()
    expect($('#inactiveWarningDialog')).toContainText 'Do you want to continue your session?'
    expect($('#inactiveWarningDialog')).toContainText 'For security reasons, your session will time out in'
    expect($('#inactiveWarningDialog')).toContainText 'Please click on the screen or press any key to extend your session'