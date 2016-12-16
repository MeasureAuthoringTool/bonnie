# holds loaded measures to be used in tests, but not actively stored in the BonnieRouter
# these measures are cloned, which is added to the router, used in a test, and then deleted
@BonnieRouterMeasureCache = class BonnieRouterMeasureCache
  constructor: () ->
    @foo = 3
