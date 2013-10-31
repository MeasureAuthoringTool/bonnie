class Thorax.Views.MeasureLogic extends Thorax.View
  
  template: JST['logic/logic']
  
  initialize: ->
    @submeasurePopulations = []
    populationMap = @model.attributes.populations.models[@populationIndex].attributes
    population_criteria = @model.attributes.population_criteria
    for population_code in bonnie.all_population_codes
      match = population_criteria[populationMap[population_code]]
      @submeasurePopulations.push(match) if match


