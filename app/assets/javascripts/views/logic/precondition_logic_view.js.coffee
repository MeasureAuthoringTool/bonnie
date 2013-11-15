class Thorax.Views.PreconditionLogic extends Thorax.View
  
  template: JST['logic/precondition']
  conjunction_map: 
  	'allTrue':'AND'
  	'atLeastOneTrue':'OR'

  initialize: ->
  	@preconditionKey = "precondition_#{@precondition.id}"
  	@parentPreconditionKey = "precondition_#{@parentPrecondition.id}"

  translate_conjunction: (conjunction) ->
  	@conjunction_map[conjunction]
