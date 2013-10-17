class Thorax.Collections.DataCriteria extends Thorax.Collection
  initialize: ->
    @categories = {}
    @on 'add', (model) ->
      @categories[model.get('type')] ||= new Thorax.Collection
      @categories[model.get('type')].add model unless @categories[model.get('type')].any (m) -> m.get('title') == model.get('title')
    # TODO consider adding @on 'remove'
