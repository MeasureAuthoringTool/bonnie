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
    @isRange = @value.type == 'IVL_PQ'
    @isEquivalent = @isRange && @value.high?.value == @value.low?.value && @value.high['inclusive?'] && @value.low['inclusive?']
    @isValue = @value.type == 'PQ'
    @isAnyNonNull = @value.type == 'ANYNonNull'

  translate_unit: (unit, value) ->
    if (@unit_map[unit])
      @unit_map[unit] + (if value > 1 then 's' else '')
    else
      unit

  translate_oid: (oid) =>
    @measure.valueSets().findWhere({oid: oid})?.get('display_name')
