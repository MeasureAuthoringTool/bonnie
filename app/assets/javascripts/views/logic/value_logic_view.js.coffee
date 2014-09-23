class Thorax.Views.ValueLogic extends Thorax.Views.BonnieView

  template: JST['logic/value']
  unit_map:
    'a':'year'
    'mo':'month'
    'wk':'week'
    'd':'day'
    'h':'hour'
    'min':'minute'
    's':'second'

  initialize: ->
    @isRange = _(['IVL_PQ', 'IVL_TS']).contains @value.type
    @isEquivalent = @isRange && @value.high?.value == @value.low?.value && @value.high?['inclusive?'] && @value.low?['inclusive?']
    @isValue = _(['PQ', 'TS']).contains @value.type
    @isAnyNonNull = @value.type == 'ANYNonNull'
    @isTS = @value.type == 'TS'

  translate_unit: (unit, value) ->
    if (@unit_map[unit])
      @unit_map[unit] + (if value > 1 then 's' else '')
    else
      unit

  translate_oid: (oid) =>
    @measure.valueSets().findWhere({oid: oid})?.get('display_name')

  translate_date: (date) ->
    moment(date,'YYYYMMDD').format('l')
