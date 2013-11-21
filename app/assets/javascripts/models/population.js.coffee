class Thorax.Models.Population extends Thorax.Model
  calculateExpected: ->
    measure = @collection.parent
    sum = measure.get('patients').length
    # set the percentage sum to 1 if there are no patients to return 0%
    if sum is 0 then sum = 1
    matches = 0
    populationCriteria = Thorax.Models.Measure.allPopulationCodes
    validPopulations = (criteria for criteria in populationCriteria when @get(criteria)?)
    population = @
    measure.get('patients').each (patient) ->
      correct = 0
      incorrect = 0
      result = population.calculate(patient)
      for criteria in validPopulations
        if patient.has('expected_values') and result.has criteria
          if patient.get('expected_values')[measure.get('id')][population.get('sub_id')][criteria] is result.get(criteria)
            correct++
          else 
            incorrect++
      # only count it as a match if all the expectations are met
      if correct is validPopulations.length then matches++
    return ((matches / sum) * 100).toFixed(0)

class Thorax.Collections.Population extends Thorax.Collection
  model: Thorax.Models.Population
  initialize: (models, options) -> @parent = options?.parent