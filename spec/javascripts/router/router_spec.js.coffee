# naming convention of this spec file matches that of the BonnieRouter (i.e. router.js instead of bonnie_router.js)
describe 'BonnieRouter', ->
  it 'no measures in router by default', ->
    window.bonnieRouterCache.load('empty_set');
    expect(window.bonnie.measures.length).toEqual 0