class Thorax.Models.Measure extends Thorax.Model
  idAttribute: '_id'
  initialize: ->
    @set 'patients', new Thorax.Collections.Patients
  parse: (attrs) ->
    alphabet = 'abcdefghijklmnopqrstuvwxyz' # for population sub-ids
    populations = new Thorax.Collections.Population [], parent: this
    for population, index in attrs.populations
      population.sub_id = alphabet[index]
      # copy population criteria data to population
      for code in @constructor.allPopulationCodes
        if populationCriteriaKey = population[code]
          population[code] = attrs.population_criteria[populationCriteriaKey]
      populations.add new Thorax.Models.Population(population)
    attrs.populations = populations

    attrs.value_sets = new Thorax.Collection(attrs.value_sets, comparator: (vs) -> vs.get('display_name').toLowerCase())
    attrs.source_data_criteria = new Thorax.Collections.MeasureDataCriteria _(attrs.source_data_criteria).values()
    attrs

class Thorax.Collections.Measures extends Thorax.Collection
  url: '/measures'
  model: Thorax.Models.Measure
  comparator: (m1, m2) ->
    if m1.get('patients').isEmpty() then -1
    else if m2.get('patients').isEmpty() then 1
    else
      comparison = m1.get('title') < m2.get('title')
      if comparison is true then -1
      else if comparison is false then 1
      else 0
  populations: ->
    populations = new Thorax.Collections.Population
    @each (m) -> m.get('populations').each (p) -> populations.add(p)
    populations

