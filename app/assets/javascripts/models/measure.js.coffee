class Thorax.Collections.Measures extends Thorax.Collection
  model: Thorax.Models.Measure

  collapsed: ->
    # FIXME: We could cache this; if we do, we need to pay attention to if measures are removed
    new Thorax.Collections.Measures(_(@toArray()).uniq (m) -> m.get('hqmf_id'))

class Thorax.Models.Measure extends Thorax.Model
  parse: (attrs) ->
    sourceDataCriteria = new Thorax.Collections.DataCriteria
    populations = new Thorax.Collections.Population
    for key, criteria of attrs.source_data_criteria
      sourceDataCriteria.add criteria
    for population, index in attrs.populations
      population['index'] = index
      populations.add new Thorax.Models.Population(population)

    attrs.source_data_criteria = sourceDataCriteria
    attrs.populations = populations
    attrs