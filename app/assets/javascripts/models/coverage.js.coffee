class Thorax.Model.Coverage extends Thorax.Model
  initialize: (attrs, options) ->
    @population = options.population
    @differences = @population.differencesFromExpected()
    @measureCriteria = @population.dataCriteriaKeys()

    @listenTo @differences, 'change add reset destroy remove', @update
    @update()

  update: ->
    if @population.measure().get('cql')
      # Count all possible data critiera minus supplemental data elements
      all_dc = []
      for data_criteria, details of @population.measure().get('data_criteria')
        if details.type != 'characteristic'
          all_dc.push(data_criteria)
      dc_count = all_dc.length

      # Count number of covered data criteria
      covered_dc = []
      for patient in @population.measure().get('patients').models
        covered_dc = covered_dc.concat(new CQL_QDM.CQLPatient(patient).getUniqueCoveredDataCriteria())
      covered_dc_count = _.uniq(covered_dc).length

      # Set coverage to the ratio of covered data criteria over total measure data criteria
      @set coverage: ( covered_dc_count * 100 / dc_count ).toFixed()
    else
      # Find all unique criteria that evaluated true in the rationale that are also in the measure
      @rationaleCriteria = []
      @differences.each (difference) => if difference.get('done')
        result = difference.result
        rationale = result.get('rationale')
        @rationaleCriteria.push(criteria) for criteria, result of rationale when result
      @rationaleCriteria = _(@rationaleCriteria).intersection(@measureCriteria)

      # Set coverage to the fraction of measure criteria that were true in the rationale
      @set coverage: ( @rationaleCriteria.length * 100 / @measureCriteria.length ).toFixed()
