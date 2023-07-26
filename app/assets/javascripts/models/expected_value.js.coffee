class Thorax.Models.ExpectedValue extends Thorax.Model

  initialize: ->
    # make 'OBSERV' be an empty list if CV measure and 'OBSERV' not set
    if @has('MSRPOPL') && !@has('OBSERV')
      @set 'OBSERV', []
    # sort OBSERV when it is set to make comparison w actuals easier
    if @has 'OBSERV' and Array.isArray(@get('OBSERV'))
      @set 'OBSERV', @get('OBSERV').sort()
    @on 'change', @changeExpectedValue, this

  changeExpectedValue: (expectedValue) ->
    mongooseExpectedValue = (@collection.parent.get('cqmPatient').expectedValues.filter (val) -> val.population_index is expectedValue.get('population_index') && val.measure_id is expectedValue.get('measure_id'))[0]
    if !mongooseExpectedValue
      @collection.parent.get('cqmPatient').expectedValues.push({population_index: expectedValue.get('population_index'), measure_id: expectedValue.get('measure_id')})
      mongooseExpectedValue = (@collection.parent.get('cqmPatient').expectedValues.filter (val) -> val.population_index is expectedValue.get('population_index') && val.measure_id is expectedValue.get('measure_id'))[0]
    if expectedValue.has('IPP') then mongooseExpectedValue.IPP = expectedValue.get('IPP')
    if expectedValue.has('DENOM') then mongooseExpectedValue.DENOM = expectedValue.get('DENOM')
    if expectedValue.has('DENEX') then mongooseExpectedValue.DENEX = expectedValue.get('DENEX')
    if expectedValue.has('DENEXCEP') then mongooseExpectedValue.DENEXCEP = expectedValue.get('DENEXCEP')
    if expectedValue.has('NUMER') then mongooseExpectedValue.NUMER = expectedValue.get('NUMER')
    if expectedValue.has('NUMEX') then mongooseExpectedValue.NUMEX = expectedValue.get('NUMEX')
    if expectedValue.has('MSRPOPL') then mongooseExpectedValue.MSRPOPL = expectedValue.get('MSRPOPL')
    if expectedValue.has('MSRPOPLEX') then mongooseExpectedValue.MSRPOPLEX = expectedValue.get('MSRPOPLEX')
    if expectedValue.has('OBSERV') then mongooseExpectedValue.OBSERV = expectedValue.get('OBSERV')
    if expectedValue.has('OBSERV_UNIT') then mongooseExpectedValue.OBSERV_UNIT = expectedValue.get('OBSERV_UNIT')
    if expectedValue.has('STRAT') then mongooseExpectedValue.STRAT = expectedValue.get('STRAT')
    if expectedValue.has('DENOM_OBSERV') then mongooseExpectedValue.DENOM_OBSERV = expectedValue.get('DENOM_OBSERV')
    if expectedValue.has('NUMER_OBSERV') then mongooseExpectedValue.NUMER_OBSERV = expectedValue.get('NUMER_OBSERV')

  populationCriteria: ->
    defaults = _(@pick(Thorax.Models.Measure.allPopulationCodes)).keys()

    # create OBSERV_index keys for multiple OBSERV values
    if @has('OBSERV') and @get('OBSERV')?.length
      defaults = _(defaults).without('OBSERV')
      for val, index in @get('OBSERV')
        defaults.push "OBSERV_#{index+1}"
    defaults

  padObservation: (result) ->
    # account for OBSERV if an actual value exists
    unless @has 'OBSERV'
      if result.get('observation_values')?.length
        @set 'OBSERV', (undefined for val in result.get('observation_values'))
    else
      if result.get('observation_values')?.length
        if @get('OBSERV').length - result.get('observation_values').length < 0
          @get('OBSERV').push(undefined) for n in [(@get('OBSERV').length + 1)..result.get('observation_values').length]

  comparison: (result) ->
    results = []
    for popCrit in @populationCriteria()
      if popCrit.indexOf('OBSERV') != -1
        continue if @get('scoring') == 'RATIO'
        expected = ExpectedValue.prepareObserv(if popCrit == 'OBSERV' then @get('OBSERV')?[0] else @get('OBSERV')?[@observIndex(popCrit)])
        actual = ExpectedValue.prepareObserv(if popCrit == 'OBSERV' then result.get('observation_values')?[0] else result.get('observation_values')?[@observIndex(popCrit)])
        unit = @get('OBSERV_UNIT')
        key = 'OBSERV'
      else
        expected = @get(popCrit)
        actual = result.get(popCrit)
        key = popCrit
      results.push @createComparison(popCrit, key, expected, actual)
    if @get('scoring') == 'RATIO'
      comparisons = @getRatioObservationComparisons(result)
      results = results.concat(comparisons)
    results

  getRatioObservationComparisons: (result) ->
    denomObsComparisons = []
    numerObsComparisons = []
    calculatedDenomObs = []
    calculatedNumerObs = []
    expectedDenomObs = if @get('DENOM_OBSERV') then [@get('DENOM_OBSERV')...] else []
    expectedNumerObs = if @get('NUMER_OBSERV') then [@get('NUMER_OBSERV')...] else []
    if @get('isEpisodeBased')
      episodeResults = result.get('episode_results')
      # ignore observations for exlcluded episode
      for id, episode of episodeResults
        if episode.DENOM ^ episode.DENEX
          calculatedDenomObs.push(episode.observation_values[0])
        if episode.NUMER ^ episode.NUMEX
          calculatedNumerObs.push(episode.observation_values[1])
      # pad denom expected/calculated observations if there is a difference in length
      if expectedDenomObs.length == 0
        expectedDenomObs.push(undefined) for n in calculatedDenomObs
      else if expectedDenomObs.length - calculatedDenomObs.length < 0
        expectedDenomObs.push(undefined) for n in [(expectedDenomObs.length + 1)..calculatedDenomObs.length]
      else if expectedDenomObs.length - calculatedDenomObs.length > 0
        calculatedDenomObs.push(undefined) for n in [(calculatedDenomObs.length + 1)..expectedDenomObs.length]
      # pad numerator expected/calculated observations if there is a difference in length
      if expectedNumerObs.length == 0
        expectedNumerObs.push(undefined) for n in calculatedNumerObs
      else if expectedNumerObs.length - calculatedNumerObs.length < 0
        expectedNumerObs.push(undefined) for n in [(expectedNumerObs.length + 1)..calculatedNumerObs.length]
      else if expectedNumerObs.length - calculatedNumerObs.length > 0
        calculatedNumerObs.push(undefined) for n in [(calculatedNumerObs.length + 1)..expectedNumerObs.length]

      for index, expected of expectedDenomObs
        denomObsComparisons.push @createComparison("DENOM OBSERV_#{+index + 1}",
          'OBSERV', expected,  calculatedDenomObs[index])
      for index, expected of expectedNumerObs
        numerObsComparisons.push @createComparison("NUMER OBSERV_#{+index + 1}",
          'OBSERV', expected, calculatedNumerObs[index])
    else
      actaulObs = [result.get('observation_values')...]
      allObs = ArrayHelpers.chunk(actaulObs, 2)
      groupObs = if allObs.length == 0 then [undefined, undefined] else allObs[@get('population_index')]
      calculatedDenomObs =
        if result.get('DENOM') and !result.get('DENEX') then groupObs[0] else undefined
      calculatedNumerObs =
        if result.get('NUMER') and !result.get('NUMEX') then groupObs[1] else undefined
      expectedDenomObs = [undefined ] if expectedDenomObs.length == 0
      expectedNumerObs = [undefined] if expectedNumerObs.length == 0
      if (expectedDenomObs[0] >= 0 || calculatedDenomObs)
        denomObsComparisons.push @createComparison('DENOM OBSERV', 'OBSERV',
          expectedDenomObs[0], calculatedDenomObs)
      if (expectedNumerObs[0] >= 0 || calculatedNumerObs)
        numerObsComparisons.push @createComparison('NUMER OBSERV', 'OBSERV',
          expectedNumerObs[0], calculatedNumerObs)
    [denomObsComparisons..., numerObsComparisons...]

  createComparison: (name, key, expected, actual) ->
    name: name
    key: key
    expected: expected
    actual: actual
    match: @compareObservs(expected, actual)

  observIndex: (observKey) ->
    observKey.split('_')[1] - 1

  compareObservs: (val1, val2) ->
    return ExpectedValue.prepareObserv(val1) == ExpectedValue.prepareObserv(val2)

  @floorToCQLPrecision: (num) ->
    Number(Math.floor(num + 'e' + 8) + 'e-' + 8);

  @prepareObserv: (observ) ->
    if typeof observ == 'number'
      return @floorToCQLPrecision(observ)
    return observ

class Thorax.Collections.ExpectedValues extends Thorax.Collection
  model: Thorax.Models.ExpectedValue

  initialize: (models, options) ->
    @parent = options?.parent
