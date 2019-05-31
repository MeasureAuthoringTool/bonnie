class Thorax.Models.ExpectedValue extends Thorax.Model

  initialize: ->
    @on 'change', @changeExpectedValue, this
    # make 'OBSERV' be an empty list if CV measure and 'OBSERV' not set
    if @has('MSRPOPL') && !@has('OBSERV')
      @set 'OBSERV', []
    # sort OBSERV when it is set to make comparison w actuals easier
    if @has 'OBSERV' and Array.isArray(@get('OBSERV'))
      @set 'OBSERV', @get('OBSERV').sort()

  changeExpectedValue: (expectedValue) ->
    mongoose_expectedValue = (@collection.parent.get('cqmPatient').expectedValues.filter (val) -> val.population_index is expectedValue.get('population_index') && val.measure_id is expectedValue.get('measure_id'))[0]
    if expectedValue.has('IPP') then mongoose_expectedValue.IPP = expectedValue.get('IPP')
    if expectedValue.has('DENOM') then mongoose_expectedValue.DENOM = expectedValue.get('DENOM')
    if expectedValue.has('DENEXCEP') then mongoose_expectedValue.DENEXCEP = expectedValue.get('DENEXCEP')
    if expectedValue.has('NUMER') then mongoose_expectedValue.NUMER = expectedValue.get('NUMER')
    if expectedValue.has('MSRPOPL') then mongoose_expectedValue.MSRPOPL = expectedValue.get('MSRPOPL')
    if expectedValue.has('MSRPOPLEX') then mongoose_expectedValue.MSRPOPLEX = expectedValue.get('MSMSRPOPLEXRPOPL')
    if expectedValue.has('OBSERV') then mongoose_expectedValue.OBSERV = expectedValue.get('OBSERV')
    if expectedValue.has('OBSERV_UNIT') then mongoose_expectedValue.OBSERV_UNIT = expectedValue.get('OBSERV_UNIT')
    if expectedValue.has('STRAT') then mongoose_expectedValue.STRAT = expectedValue.get('STRAT')

  populationCriteria: ->
    defaults = _(@pick(Thorax.Models.Measure.allPopulationCodes)).keys()

    # create OBSERV_index keys for multiple OBSERV values
    if @has('OBSERV') and @get('OBSERV')?.length
      defaults = _(defaults).without('OBSERV')
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
      # Here's the hash we return:
      name: popCrit
      key: key
      expected: expected
      actual: actual
      match: @compareObservs(expected, actual)
      unit: unit

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
