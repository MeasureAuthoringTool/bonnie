class Thorax.Models.ExpectedValue extends Thorax.Model

  populationCriteria: ->
    _(@pick(Thorax.Models.Measure.allPopulationCodes)).keys()

class Thorax.Collections.ExpectedValues extends Thorax.Collection
  model: Thorax.Models.ExpectedValue