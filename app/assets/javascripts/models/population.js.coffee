class Thorax.Models.Population extends Thorax.Model

  index: -> @collection.indexOf(this)

  url: -> "#{@collection.parent.url()}/populations/#{@get('index')}"

  measure: -> @collection.parent

  populationCriteria: -> (criteria for criteria in Thorax.Models.Measure.allPopulationCodes when @has(criteria))

  calculate: (patient) -> bonnie.calculator.calculate(this, patient)

  calculationResults: -> new Thorax.Collections.Results @measure().get('patients').map (p) => @calculate(p)

  differenceFromExpected: (patient) ->
    result = @calculate(patient)
    expected = patient.getExpectedValue(this)
    new Thorax.Models.Difference({}, result: result, expected: expected)

  differencesFromExpected: ->
    differences = new Thorax.Collections.Differences()
    # We want to explicitly call reset to fire an event (it doesn't happen if we just initialize)
    differences.reset @measure().get('patients').map (patient) => @differenceFromExpected(patient)
    differences

  coverage: ->
    new Thorax.Model.Coverage({}, results: @calculationResults(), measure: @measure())

class Thorax.Collections.Population extends Thorax.Collection
  model: Thorax.Models.Population
  initialize: (models, options) -> @parent = options?.parent
