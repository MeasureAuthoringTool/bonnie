class Thorax.Model.Coverage extends Thorax.Model
  initialize: (attrs, options) ->
    @results = options.results
    @measure = options.measure
    @listenTo @results, 'change add reset destroy remove', @update
    @update()
  update: ->
    # Get all the criteria from the measure
    measureCriteria = _(@measure.get 'data_criteria').keys()

    # Find all unique criteria that evaluated true in the rationale that are also in the measure
    rationaleCriteria = []
    for result in (@results.select (d) -> d.isPopulated())
      rationale = result.get 'rationale'
      rationaleCriteria.push(criteria) for criteria, result of rationale when result
    rationaleCriteria = _(rationaleCriteria).intersection(measureCriteria)

    # Set coverage to the fraction of measure criteria that were true in the rationale
    @set coverage: ( rationaleCriteria.length * 100 / measureCriteria.length ).toFixed()