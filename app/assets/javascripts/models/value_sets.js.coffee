class Thorax.Collections.ValueSetsCollection extends Thorax.Collection
  initialize: (models, options) -> @sorting = options?.sorting

  comparator: (vs) ->
    if @sorting is 'complex'
      [vs.get('name'), vs.get('oid'), vs.get('version')]
    else
      vs.get('display_name').toLowerCase()

  whiteList: ->
    @select (vs) -> _(vs.get('concepts')).any (c) -> c.white_list

  blackList: ->
    @select (vs) -> _(vs.get('concepts')).any (c) -> c.black_list
