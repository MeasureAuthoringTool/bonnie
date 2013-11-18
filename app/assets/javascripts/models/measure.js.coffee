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
    populations = new Thorax.Collections.Population
    for population, index in attrs.populations
      population.index = index
      populations.add new Thorax.Models.Population(population)
    attrs.populations = populations
    attrs.value_sets = new Thorax.Collection(attrs.value_sets, comparator: (vs) -> vs.get('display_name').toLowerCase())
    attrs.source_data_criteria = new Thorax.Collections.MeasureDataCriteria _(attrs.source_data_criteria).values()
    attrs
  expectedPercentage: (population) ->
    sum = @get('patients').length
    # set the percentage sum to 1 if there are no patients to return 0%
    if sum is 0 then sum = 1
    matches = 0
    pops = population
    popCriteria = Object.keys(@get('population_criteria'))
    validPops = (c for c in popCriteria when pops?.get(c)?)
    @get('patients').each (patient) ->
      correct = 0
      incorrect = 0
      result = population?.calculate(patient)
      for ind, c of popCriteria
        if c in validPops and patient.has('expected_values')
          found = result[c] ?= result.get(c)
          if patient.get('expected_values')[pops.get('sub_id')][c] is found
            correct++
          else 
            incorrect++
      # only count it as a match if all the expectations are met
      if correct is validPops.length then matches++
    return ((matches / sum) * 100).toFixed(2)