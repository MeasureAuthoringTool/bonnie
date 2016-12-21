# duplicates the BonnieRouter for test isolation
@BonnieRouterCache = class BonnieRouterCache
  DEFAULT_STATE = 'default'
  constructor: () ->
    @state = {}
    #default state is as we find things now
    this.save(DEFAULT_STATE)

  load: (key) ->
    throw "Key '#{key}' doesn't exist!" if not (key of @state)
    # Clear the fixtures cache so that getJSONFixture does not return stale/modified fixtures
    jasmine.getJSONFixtures().clearCache()
    # deep copy
    window.bonnie = $.extend(true, {}, @state[key])
    window.bonnie.measures = @state[key].measures.deepClone()

  save: (key) ->
    @state[key] = window.bonnie