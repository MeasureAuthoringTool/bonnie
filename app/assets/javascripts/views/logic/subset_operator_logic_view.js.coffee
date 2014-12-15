class Thorax.Views.SubsetOperatorLogic extends Thorax.Views.BonnieView

  template: JST['logic/subset_operator']
  subset_map:
    'RECENT':'MOST RECENT'
    'TIMEDIFF':'Difference between times'
    'DATEDIFF':'Difference between dates'
    'DATETIMEDIFF':'Difference between date/times'

  initialize: ->
    ""

  translate_subset: (subset) ->
    @subset_map[subset] || subset
