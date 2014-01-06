class Thorax.Model.Coverage extends Thorax.Model
  initialize: (attrs, options) ->
    @population = options.population
    @results = @population.calculationResults()
    @measureCriteria = @population.dataCriteriaKeys()

    @listenTo @results, 'change add reset destroy remove', @update
    @update()
  update: ->

    # Find all unique criteria that evaluated true in the rationale that are also in the measure
    @rationaleCriteria = []
    for result in (@results.select (d) -> d.isPopulated())
      rationale = result.updatedRationale()
      @rationaleCriteria.push(criteria) for criteria, result of rationale when result
    @rationaleCriteria = _(@rationaleCriteria).intersection(@measureCriteria)

    # Set coverage to the fraction of measure criteria that were true in the rationale
    @set coverage: ( @rationaleCriteria.length * 100 / @measureCriteria.length ).toFixed()