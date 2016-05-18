class Thorax.Views.TestCaseHistoryTimelineView extends Thorax.Views.BonnieView
  template: JST['test_case_history_timeline']
  
  initialize: ->
    @populationIndex = @model.get('displayedPopulation').index()
    
  loadHistory: ->
    #TODO: Load update history
    
  updatePopulation: (population) ->
    @populationIndex = population.index()
    @render()
