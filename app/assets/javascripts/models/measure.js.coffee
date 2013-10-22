class Thorax.Collections.Measures extends Thorax.Collection
  model: Thorax.Models.Measure

  collapsed: ->
    # FIXME: We could cache this; if we do, we need to pay attention to if measures are removed
    new Thorax.Collections.Measures(_(@toArray()).uniq (m) -> m.get('hqmf_id'))

class Thorax.Models.Measure extends Thorax.Model
  parse: (attrs) ->
    populations = new Thorax.Collections.Population
    for population, index in attrs.populations
      population['index'] = index
      populations.add new Thorax.Models.Population(population)
    attrs.populations = populations

    attrs.source_data_criteria = new Thorax.Collections.MeasureDataCriteria _(attrs.source_data_criteria).values()

    attrs
