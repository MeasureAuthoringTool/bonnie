class Thorax.Views.DataCriteriaLogic extends Thorax.View
  
  template: JST['logic/data_criteria']

  initialize: ->
  	@dataCriteria = @dataCriteriaMap[@reference]
