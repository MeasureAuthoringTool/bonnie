class Thorax.Models.ExpectedValue extends Thorax.Model

  populationCriteria: ->
    _(@pick(Thorax.Models.Measure.allPopulationCodes)).keys()

  isMatch: (result) ->
    for popCrit in @populationCriteria()
      return false unless @get(popCrit) == result.get(popCrit)
    return true


class Thorax.Collections.ExpectedValues extends Thorax.Collection
  model: Thorax.Models.ExpectedValue
