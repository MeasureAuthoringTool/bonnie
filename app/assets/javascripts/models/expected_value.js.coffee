class Thorax.Models.ExpectedValue extends Thorax.Model

  populationCriteria: ->
    defaults = _(@pick(Thorax.Models.Measure.allPopulationCodes)).keys()
    if @has('OBSERV') and @get('OBSERV')?.length > 1
      defaults = _(defaults).without('OBSERV')
      for val, index in @get('OBSERV')
        defaults.push "OBSERV_#{index}"
    defaults

  isMatch: (result) ->
    # account for OBSERV if an actual value exists
    unless @has 'OBSERV' then if result.get('values')?[0]? then @set 'OBSERV', undefined

    for popCrit in @populationCriteria()
      if popCrit.indexOf('OBSERV') != -1 then return false unless @get('OBSERV')[popCrit.split('_')[1]] == result.get('values')?[popCrit.split('_')[1]]
      else return false unless @get(popCrit) == result.get(popCrit)
    return true

  comparison: (result) ->
    for popCrit in @populationCriteria()
      key = popCrit
      if popCrit.indexOf('OBSERV') != -1
        expected = if popCrit == 'OBSERV' then @get('OBSERV') else @get('OBSERV')?[popCrit.split('_')[1]]
        actual = if popCrit == 'OBSERV' then result.get('values')?[0] else result.get('values')?[popCrit.split('_')[1]]
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

class Thorax.Collections.ExpectedValues extends Thorax.Collection
  model: Thorax.Models.ExpectedValue
