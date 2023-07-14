class Thorax.Models.ExpectedValue extends Thorax.Model

  initialize: ->
    # make 'OBSERV' be an empty list if CV measure and 'OBSERV' not set
    if @has('MSRPOPL') && !@has('OBSERV')
      @set 'OBSERV', []
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

  populationCriteria: ->
    defaults = _(@pick(Thorax.Models.Measure.allPopulationCodes)).keys()
    defaults = _(defaults).without('OBSERV')
    # create OBSERV_index keys for multiple OBSERV values
    if @has('OBSERV') and @get('OBSERV')?.length
      for val, index in @get('OBSERV')
        defaults.push "OBSERV_#{index+1}"
    defaults

  isMatch: (result) ->
    # account for OBSERV if an actual value exists
    unless @has 'OBSERV'
      if result.get('observation_values')?.length
        @set 'OBSERV', (undefined for val in result.get('observation_values'))
    else
      if result.get('observation_values')?.length
        if @get('OBSERV').length - result.get('observation_values').length < 0
          @get('OBSERV').push(undefined) for n in [(@get('OBSERV').length + 1)..result.get('observation_values').length]

    for popCrit in @populationCriteria()
      if popCrit.indexOf('OBSERV') != -1 then return false unless @compareObservs(@get('OBSERV')?[@observIndex(popCrit)], result.get('observation_values')?[@observIndex(popCrit)])
      else return false unless @get(popCrit) == result.get(popCrit)
    return true

  comparison: (result) ->
    results = []
    for popCrit in @populationCriteria()
      if popCrit.indexOf('OBSERV') != -1
        expected = ExpectedValue.prepareObserv(if popCrit == 'OBSERV' then @get('OBSERV')?[0] else @get('OBSERV')?[@observIndex(popCrit)])
        actual = ExpectedValue.prepareObserv(if popCrit == 'OBSERV' then result.get('observation_values')?[0] else result.get('observation_values')?[@observIndex(popCrit)])
        unit = @get('OBSERV_UNIT')
        key = 'OBSERV'
      else
        expected = @get(popCrit)
        actual = result.get(popCrit)
        key = popCrit
      results.push
        name: popCrit
        key: key
        expected: expected
        actual: actual
        match: @compareObservs(expected, actual)
        unit: unit
    @updateObservationNames(results) if result.measure.get('cqmMeasure').measure_scoring == 'RATIO'
    results

  observIndex: (observKey) ->
    observKey.split('_')[1] - 1

  compareObservs: (val1, val2) ->
    return ExpectedValue.prepareObserv(val1) == ExpectedValue.prepareObserv(val2)

  # for ratio measures, cqm-execution is updated to have observations for all episodes even if it is excluded.
  # not the best way but observation array maintains the order- Denom observation first and then numer observations
  # e.g. for 2 episodes, and OBSERV = [1, 2, 0, 5]
  # then groupping produced by this method will be [{denomObs: 1, numerObs: 2}, {denomObs: 0, numerObs: 5}]
  groupObsByEpisodes: (observations) ->
    i = 0
    episodes = []
    while i < observations?.length
      episode = observations.slice(i, i + 2)
      episodes.push({
        denomObs: episode[0],
        numerObs: episode[1]
      })
      i += 2
    episodes

  updateObservationNames: (results) ->
    observations = results.filter((r) -> r.key == "OBSERV")
    byEpisodes = @groupObsByEpisodes(observations)
    for observation, index in byEpisodes
      observation.denomObs.name = "EPISODE #{index + 1}- DENOM OBSERV" if observation.denomObs
      observation.numerObs.name = "EPISODE #{index + 1}- NUMER OBSERV" if observation.numerObs

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
