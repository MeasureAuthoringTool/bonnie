class Thorax.Views.PopulationCriteriaLogic extends Thorax.View
  
  template: JST['logic/population_criteria']

  initialize: ->
  	@rootPrecondiiton = @population.preconditions[0]
