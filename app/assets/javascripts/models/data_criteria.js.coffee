class Thorax.Collections.DataCriteria extends Thorax.Collection
  initialize: ->
    @categories = {}
    @on 'add', (model) ->
      @categories[model.get('type')] ||= new Thorax.Collection
      @categories[model.get('type')].add model unless @categories[model.get('type')].any (m) -> m.get('title') == model.get('title')
    # TODO consider adding @on 'remove'


# Used for patient encounters. idAttribute is null, as the model itself
# isn't responsible for persisting itself, and the collection must support
# multiple criteria with the same ID.
class Thorax.Models.SourceDataCriteria extends Thorax.Model
  idAttribute: null
