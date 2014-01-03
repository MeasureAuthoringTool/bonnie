class Thorax.Models.ExpectedValue extends Thorax.Model

  populationCriteria: ->
    _(@pick(Thorax.Models.Measure.allPopulationCodes)).keys()

  isMatch: (result) ->
    for popCrit in @populationCriteria()
      if popCrit is 'OBSERV' then return false unless @get(popCrit) == result.get('values')?[0]
      else return false unless @get(popCrit) == result.get(popCrit)
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
      unit: if popCrit == 'OBSERV' then @get('OBSERV_UNIT')


class Thorax.Collections.ExpectedValues extends Thorax.Collection
  model: Thorax.Models.ExpectedValue
