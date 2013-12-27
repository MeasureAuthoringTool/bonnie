class Thorax.Models.ExpectedValue extends Thorax.Model

  populationCriteria: ->
    _(@pick(Thorax.Models.Measure.allPopulationCodes)).keys()

  isMatch: (result) ->
    for popCrit in @populationCriteria()
      return false unless @get(popCrit) == result.get(popCrit)
    return true

  comparison: (result) ->
    for popCrit in @populationCriteria()
      expected = @get(popCrit)
      actual = if popCrit == 'OBSERV' then result.get('values')?[0] else result.get(popCrit)
      # Here's the hash we return:
      name: popCrit
      expected: expected
      actual: actual
      match: expected == actual


class Thorax.Collections.ExpectedValues extends Thorax.Collection
  model: Thorax.Models.ExpectedValue
