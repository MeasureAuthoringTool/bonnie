class Thorax.Views.TestCaseHistoryTimelineView extends Thorax.Views.BonnieView
  template: JST['test_case_history_timeline']
  
  initialize: ->
    @populationIndex = @model.get('displayedPopulation').index()
    
  events:
    'population:change': @updatePopulation
    
  loadHistory: ->
    #TODO: Load update history
    
  updatePopulation: (population) ->
    console.log ("")
    @populationIndex = population.index()
    @render()
