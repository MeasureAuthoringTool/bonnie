class Thorax.Views.PreconditionLogic extends Thorax.View
  
  template: JST['logic/precondition']
  conjunction_map: 
  	'allTrue':'AND'
  	'atLeastOneTrue':'OR'

  initialize: ->
  	""

  translate_conjunction: (conjunction) ->
  	@conjunction_map[conjunction]
