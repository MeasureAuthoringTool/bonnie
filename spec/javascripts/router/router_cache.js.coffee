# duplicates the BonnieRouter for test isolation
@BonnieRouterCache = class BonnieRouterCache
  constructor: () ->
    @state = {}

  ###
  Loading a BonnieRouter that was saved via save()
  Note: deep copies the saved state so one can modify without side effects in future tests
  ###
  load: (key) ->
    throw "Key '#{key}' doesn't exist!" if not (key of @state)
    # Clear the fixtures cache so that getJSONFixture does not return stale/modified fixtures
    jasmine.getJSONFixtures().clearCache()
    # deep copy
    window.bonnie = $.extend(true, {}, @state[key])
    window.bonnie.measures = @state[key].measures.deepClone()

  ###
  Save a reference to the current BonnieRouter
  It is the responsibility of the caller to create a new instance if desired, i.e.
    window.bonnie = new BonnieRouter()
  If no new instance is created, then this cached instance will be modified
  ###
  save: (key) ->
    @state[key] = window.bonnie
