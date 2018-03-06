class Thorax.Models.Population extends Thorax.Model

  index: -> @collection.indexOf(this)

  url: -> "#{@collection.parent.url()}/populations/#{@get('index')}"

  measure: -> @collection.parent

  displayName: -> "#{@measure().get('cms_id')}#{if @measure().get('populations').length > 1 then @get('sub_id') else ''}"

  populationCriteria: -> (criteria for criteria in Thorax.Models.Measure.allPopulationCodes when @has(criteria))

  calculate: (patient) ->
    bonnie.calculator_selector.calculate this, patient

  # Calculates results for all measure patients
  calculationResults: -> new Thorax.Collections.Results @measure().get('patients').map (p) => @calculate(p)

  # Calculates a result for the given patient
  calculateResult: (patient) -> @calculate(patient)

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

  getPopIndexFromPopName: (popName) ->
    # If displaying a stratification, we need to set the index to the associated populationCriteria
    # that the stratification is on so that the correct (IPOP, DENOM, NUMER..) are retrieved
    if this.get('stratification')?
      # If retrieving the STRAT specifically, set the index to the correct STRAT in the cql_map
      if popName == "STRAT"
        stratCode = this.get('STRAT')['code']
        # The strat code has the index of the stratification appended to the code ie: STRAT, STRAT_1, STRAT_2...
        stratCode = stratCode.match(///STRAT_(\d*)///)
        if(stratCode?[1]?)
          stratIndex = stratCode[1]
        else
          stratIndex = 0
        return stratIndex
      else
        return this.get('population_index')
    else
      return this.get('index')

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
        # add derived to DC list if it's a satisfies all/any or a variable
        occurrences.push child.key if child.key && (child.specific_occurrence || !specificsOnly) && (child.definition in Thorax.Models.MeasureDataCriteria.satisfiesDefinitions || child.variable)
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
      if (child.references?)
        for type, reference of child.references
          dataCriteria = @measure().get('data_criteria')[reference.reference]
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
