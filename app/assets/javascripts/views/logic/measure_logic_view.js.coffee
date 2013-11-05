class Thorax.Views.MeasureLogic extends Thorax.View
  
  template: JST['logic/logic']
  
  initialize: ->
    @submeasurePopulations = []
    populationMap = @model.get('populations').at(@populationIndex).attributes
    population_criteria = @model.get('population_criteria')
    for population_code in Thorax.Models.Measure.allPopulationCodes
      match = population_criteria[populationMap[population_code]]
      @submeasurePopulations.push(match) if match


