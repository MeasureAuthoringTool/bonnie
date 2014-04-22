class Thorax.Models.ExpectedValue extends Thorax.Model

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
    unless @has 'OBSERV' then if result.get('values')?.length then @set 'OBSERV', (undefined for val in result.get('values'))

    for popCrit in @populationCriteria()
      if popCrit.indexOf('OBSERV') != -1 then return false unless @get('OBSERV')[@observIndex(popCrit)] == result.get('values')?[@observIndex(popCrit)]
      else return false unless @get(popCrit) == result.get(popCrit)
    return true

  comparison: (result) ->
    # sort OBSERV and results before comparing
    if @has('OBSERV') and @get('OBSERV').length
      @set 'OBSERV', _(@get('OBSERV')).sortBy( (v) -> v)
    if result.get('values')?
      result.set 'values', _(result.get('values')).sortBy( (v) -> v)

    for popCrit in @populationCriteria()
      key = popCrit
      if popCrit.indexOf('OBSERV') != -1
        expected = if popCrit == 'OBSERV' then @get('OBSERV')?[0] else @get('OBSERV')?[@observIndex(popCrit)]
        actual = if popCrit == 'OBSERV' then result.get('values')?[0] else result.get('values')?[@observIndex(popCrit)]
        unit = @get('OBSERV_UNIT')
        key = 'OBSERV'
        # console.log "#{popCrit} exp: #{expected} act: #{actual}"
      else
        expected = @get(popCrit)
        actual = result.get(popCrit)
      # Here's the hash we return:
      name: popCrit
      key: key
      expected: expected
      actual: actual
      match: expected == actual
      unit: unit

  observIndex: (observKey) ->
    observKey.split('_')[1] - 1

class Thorax.Collections.ExpectedValues extends Thorax.Collection
  model: Thorax.Models.ExpectedValue
