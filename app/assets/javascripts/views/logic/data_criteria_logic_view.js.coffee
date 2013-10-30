class Thorax.Views.DataCriteriaLogic extends Thorax.View
  
  template: JST['logic/data_criteria']
  operator_map: 
  	'XPRODUCT':'AND'
  	'UNION':'OR'

  initialize: ->
  	@dataCriteria = @dataCriteriaMap[@reference]

  translate_operator: (conjunction) =>
  	@operator_map[conjunction]
