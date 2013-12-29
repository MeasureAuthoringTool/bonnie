class Thorax.Model.Coverage extends Thorax.Model
  initialize: (attrs, options) ->
    @results = options.results
    @measure = options.measure
    @listenTo @results, 'change add reset destroy remove', @update
    @update()
  update: ->
    completedResults = @results.select (d) -> d.isPopulated()
    dataCriteria = @measure.get 'data_criteria'
    rationaleCoverage = {}
    for result in completedResults
      rationale = result.get 'rationale'
      for key, value of dataCriteria
        criteriaId = value['key']
        if !!rationale[criteriaId]
          rationaleCoverage[criteriaId] = true
        else
          unless !!rationaleCoverage[criteriaId]
            rationaleCoverage[criteriaId] = false

    matches = 0
    mismatches = 0
    for criteriaId, match of rationaleCoverage
      if match then matches++ else mismatches++
    unless matches == mismatches == 0
      @set coverage: ( matches * 100 / ( matches + mismatches )).toFixed()
    else
      @set coverage: 0