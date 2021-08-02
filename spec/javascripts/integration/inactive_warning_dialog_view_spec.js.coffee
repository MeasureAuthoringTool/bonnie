describe 'InactiveWarningDialog', ->
  beforeAll ->
    jasmine.getJSONFixtures().clearCache()
    @wrn = new Thorax.Views.InactiveWarningDialog()

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
    expect($('#inactiveWarningDialog')).toContainText '00:00'
    @wrn.updateCountDown(63000)
    expect($('#inactiveWarningDialog')).toContainText '01:03'

  it 'formats seconds', ->
    expect(@wrn.toSeconds(1)).toBe '01'
    expect(@wrn.toSeconds(59)).toBe '59'
    expect(@wrn.toSeconds(60)).toBe '00'
    expect(@wrn.toSeconds(61)).toBe '01'

  it 'formats minutes', ->
    expect(@wrn.toMinutes(1)).toBe '00'
    expect(@wrn.toMinutes(59)).toBe '00'
    expect(@wrn.toMinutes(60)).toBe '01'
    expect(@wrn.toMinutes(61)).toBe '01'

  it 'formats time', ->
    expect(@wrn.formatTime(1)).toBe '00:01'
    expect(@wrn.formatTime(59)).toBe '00:59'
    expect(@wrn.formatTime(60)).toBe '01:00'
    expect(@wrn.formatTime(61)).toBe '01:01'
