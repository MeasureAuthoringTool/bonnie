class Thorax.Collections.Measures extends Thorax.Collection
  url: '/measures'
  model: Thorax.Models.Measure
  populations: ->
    populations = new Thorax.Collections.Population
    @each (m) -> m.get('populations').each (p) -> populations.add(p)
    populations

class Thorax.Models.Measure extends Thorax.Model
  idAttribute: '_id'
  initialize: ->
    @set 'patients', new Thorax.Collections.Patients
  parse: (attrs) ->
    populations = new Thorax.Collections.Population [], parent: this
    for population, index in attrs.populations
      population.index = index
      populations.add new Thorax.Models.Population(population)
    attrs.populations = populations
    attrs.value_sets = new Thorax.Collection(attrs.value_sets, comparator: (vs) -> vs.get('display_name').toLowerCase())
    attrs.source_data_criteria = new Thorax.Collections.MeasureDataCriteria _(attrs.source_data_criteria).values()
    attrs