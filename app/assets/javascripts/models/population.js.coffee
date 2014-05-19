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
    new Thorax.Model.Coverage({}, population: this)

  dataCriteriaKeys: ->
    return @populationDataCriteriaKeys if @populationDataCriteriaKeys
    criteriaKeys = []
    for code in @populationCriteria()
      criteriaKeys = criteriaKeys.concat @getDataCriteriaKeys(@get(code), false)
    @populationDataCriteriaKeys = _.uniq(criteriaKeys)
    @populationDataCriteriaKeys


  getDataCriteriaKeys: (child, specificsOnly=true) ->
    occurrences = []
    return occurrences unless child
    if child.preconditions?.length > 0
      for precondition in child.preconditions
        occurrences = occurrences.concat @getDataCriteriaKeys(precondition,specificsOnly)
    else if child.reference
      occurrences = occurrences.concat @getDataCriteriaKeys(@measure().get('data_criteria')[child.reference],specificsOnly)
    else
      if child.type is 'derived' && child.children_criteria
        for dataCriteriaKey in child.children_criteria
          dataCriteria = @measure().get('data_criteria')[dataCriteriaKey]
          occurrences = occurrences.concat @getDataCriteriaKeys(dataCriteria,specificsOnly)
      else
        if child.specific_occurrence || !specificsOnly
          occurrences.push child.key if child.key
      if (child.temporal_references?.length > 0)
        for temporal_reference in child.temporal_references
          dataCriteria = @measure().get('data_criteria')[temporal_reference.reference]
          occurrences = occurrences.concat @getDataCriteriaKeys(dataCriteria,specificsOnly)
    return occurrences

class Thorax.Collections.Population extends Thorax.Collection
  model: Thorax.Models.Population
  initialize: (models, options) -> @parent = options?.parent
  whenDifferencesComputed: (callback) ->
    @each (population) => population.differencesFromExpected().once 'complete', => callback(@) if @differencesComputed()
    callback(@) if @differencesComputed()

  differencesComputed: ->
    _.isEmpty(@select (population) -> !population.differencesFromExpected().summary.get('done'))
