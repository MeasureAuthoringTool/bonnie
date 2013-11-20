class Thorax.Collections.Measures extends Thorax.Collection
  url: '/measures'
  model: Thorax.Models.Measure
  comparator: (m1, m2) ->
    if m1.get('patients').length is 0 then -1
    else if m2.get('patients').length is 0 then 1
    else
      # FIXME: Flip the comparison from > to < when hqmf2js has been updated
      comparison = m1.get('title') > m2.get('title')
      if comparison is true then -1
      else if comparison is false then 1
      else 0
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