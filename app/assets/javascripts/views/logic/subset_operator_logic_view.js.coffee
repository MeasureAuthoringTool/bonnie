class Thorax.Views.SubsetOperatorLogic extends Thorax.View
  
  template: JST['logic/subset_operator']
  subset_map:
    'COUNT':'COUNT'
    'FIRST':'FIRST'
    'SECOND':'SECOND'
    'THIRD':'THIRD'
    'FOURTH':'FOURTH',
    'FIFTH':'FIFTH'
    'RECENT':'MOST RECENT'
    'LAST':'LAST'
    'MIN':'MIN'
    'MAX':'MAX',
    'MEAN':'MEAN'
    'MEDIAN':'MEDIAN'
    'TIMEDIFF':'Difference between times'
    'DATEDIFF':'Difference between dates'

  initialize: ->
    ""

  translate_subset: (subset) ->
    @subset_map[subset]