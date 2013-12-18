class Thorax.Models.Population extends Thorax.Model

  index: -> @collection.indexOf(this)

  url: -> "#{@collection.parent.url()}/populations/#{@get('index')}"

  measure: -> @collection.parent

  # FIXME: Good idea but only if needed...
  populationCriteria: -> (criteria for criteria in Thorax.Models.Measure.allPopulationCodes when @has(criteria))

  calculate: (patient) -> bonnie.calculator.calculate(this, patient)

  differenceFromExpected: (patient) ->
    result = @calculate(patient)
    expected = patient.getExpectedValue(this)
    new Thorax.Models.Difference({}, result: result, expected: expected)

  differencesFromExpected: ->
    # We want to explicitly call reset to fire an event (it doesn't happen if we just initialize)
    differences = new Thorax.Collections.Differences()
    differences.reset @measure().get('patients').map (patient) => @differenceFromExpected(patient)
    differences

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
        if criteria is 'OBSERV' and patient.has('expected_values') and result.has('values')
          if patient.getExpectedValue(population).get(criteria) is result.get('values')?[0]
            correct++
        else 
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
      if criteria is 'OBSERV' and patient.has('expected_values') and result.has('values')
        if patient.getExpectedValue(population).get(criteria) is result.get('values')?[0]
          correct++
      else 
        if patient.has('expected_values') and result.has criteria
        # FIXME: The ? below is a temporary work around; we want to refactor the models for results and expectations
          if patient.getExpectedValue(population).get(criteria) is result.get(criteria)
            correct++
    # only count it as a match if all the expectations are met
    return correct is validPopulations.length

class Thorax.Collections.Population extends Thorax.Collection
  model: Thorax.Models.Population
  initialize: (models, options) -> @parent = options?.parent
