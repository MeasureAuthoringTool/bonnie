class Thorax.Collections.ValueSetsCollection extends Thorax.Collection
  comparator: (vs) -> vs.get('display_name').toLowerCase()

  whiteList: ->
    @select (vs) -> _(vs.get('concepts')).any (c) -> c.white_list

  blackList: ->
    @select (vs) -> _(vs.get('concepts')).any (c) -> c.black_list
