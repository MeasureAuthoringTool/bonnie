class Thorax.Models.Population extends Thorax.Model

  index: -> @collection.indexOf(this)

  exactMatches: ->
    measure = @collection.parent
    population = @
    matches = 0
    populationCriteria = Thorax.Models.Measure.allPopulationCodes
    validPopulations = (criteria for criteria in populationCriteria when population.has(criteria))
    measure.get('patients').each (patient) ->
      correct = 0
      result = population.calculate(patient)
      for criteria in validPopulations
        if patient.has('expected_values') and result.has criteria
          # FIXME: The ? below is a temporary work around; we want to refactor the models for results and expectations
          if patient.getExpectedValue(population).get(criteria) is result.get(criteria)
            correct++
      # only count it as a match if all the expectations are met
      if correct is validPopulations.length then matches++
    return matches

  # FIXME Re-write to return false on the first mismatch, otherwise return true
  isExactlyMatching: (patient) ->
    measure = @collection.parent
    population = @
    populationCriteria = Thorax.Models.Measure.allPopulationCodes
    validPopulations = (criteria for criteria in populationCriteria when population.has(criteria))
    correct = 0
    result = population.calculate(patient)
    for criteria in validPopulations
      if patient.has('expected_values') and result.has criteria
        # FIXME: The ? below is a temporary work around; we want to refactor the models for results and expectations
        if patient.getExpectedValue(population).get(criteria) is result.get(criteria)
          correct++
    # only count it as a match if all the expectations are met
    return correct is validPopulations.length

class Thorax.Collections.Population extends Thorax.Collection
  model: Thorax.Models.Population
  initialize: (models, options) -> @parent = options?.parent
