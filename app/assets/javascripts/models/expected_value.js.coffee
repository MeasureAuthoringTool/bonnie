class Thorax.Models.ExpectedValue extends Thorax.Model

  initialize: ->
    # make 'OBSERV' be an empty list if CV measure and 'OBSERV' not set
    if @has('MSRPOPL') && !@has('OBSERV')
      @set 'OBSERV', []
    # sort OBSERV when it is set to make comparison w actuals easier
    if @has 'OBSERV' and Array.isArray(@get('OBSERV'))
      @set 'OBSERV', @get('OBSERV').sort()

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
      if result.get('values')?.length
        @set 'OBSERV', (undefined for val in result.get('values'))
    else
      if result.get('values')?.length
        if @get('OBSERV').length - result.get('values').length < 0
          @get('OBSERV').push(undefined) for n in [(@get('OBSERV').length + 1)..result.get('values').length]

    for popCrit in @populationCriteria()
      if popCrit.indexOf('OBSERV') != -1 then return false unless @compareObservs(@get('OBSERV')?[@observIndex(popCrit)], result.get('values')?[@observIndex(popCrit)])
      else return false unless @get(popCrit) == result.get(popCrit)
    return true

  comparison: (result) ->

    for popCrit in @populationCriteria()
      if popCrit.indexOf('OBSERV') != -1
        expected = @prepareObserv(if popCrit == 'OBSERV' then @get('OBSERV')?[0] else @get('OBSERV')?[@observIndex(popCrit)])
        actual = @prepareObserv(if popCrit == 'OBSERV' then result.get('values')?[0] else result.get('values')?[@observIndex(popCrit)])
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
    return @prepareObserv(val1) == @prepareObserv(val2)

  prepareObserv: (observ) ->
    if typeof observ == 'number'
      return @roundToCQLPrecision(observ)
    return observ
  
  roundToCQLPrecision: (num) ->
    Number(Math.round(num + 'e' + 8) + 'e-' + 8);

class Thorax.Collections.ExpectedValues extends Thorax.Collection
  model: Thorax.Models.ExpectedValue
