# tests of the test helper class RouterMeasureCache
describe 'BonnieRouterCache', ->
  it 'cache exists', ->
    expect(window.bonnieRouterCache).toBeDefined()

  it 'throws error if no such state', ->
    expect( -> window.bonnieRouterCache.load('non-existant')).toThrow()

  it 'does not throw if state exists', ->
    expect( -> window.bonnieRouterCache.load('default')).not.toThrow()

  it 'load clears JSON Fixtures', ->
    myfixture = getJSONFixture('records/base_set/patients.json')
    expect($.isEmptyObject(jasmine.getJSONFixtures().fixturesCache_)).toBe(false)
    window.bonnieRouterCache.load('default')
    expect($.isEmptyObject(jasmine.getJSONFixtures().fixturesCache_)).toBe(true)
