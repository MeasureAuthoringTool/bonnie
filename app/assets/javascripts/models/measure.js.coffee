class Thorax.Collections.Measures extends Thorax.Collection
  url: '/measures'
  model: Thorax.Models.Measure
  populations: ->
    populations = new Thorax.Collections.Population
    @each (m) -> m.get('populations').each (p) -> populations.add(p)
    populations

class Thorax.Models.Measure extends Thorax.Model
  idAttribute: '_id'
  parse: (attrs) ->
    populations = new Thorax.Collections.Population
    for population, index in attrs.populations
      population.index = index
      populations.add new Thorax.Models.Population(population)
    attrs.populations = populations
    attrs.source_data_criteria = new Thorax.Collections.MeasureDataCriteria _(attrs.source_data_criteria).values()
    attrs
