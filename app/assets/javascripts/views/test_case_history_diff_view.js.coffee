class Thorax.Views.TestCaseHistoryDiffView extends Thorax.Views.BonnieView
  template: JST['test_case_history_diff']
  
  initialize: ->
    @diff = undefined
    @diffView = undefined
    @populationIndex = @model.get('displayedPopulation').index()
    console.log("current pop index is: " + @populationIndex)
    
  loadDiff: (oldVersion, newVersion) ->
    if !oldVersion
      @diff = undefined
      @diffView = undefined
      @render()
      return
    
    $.get('/measures/historic_diff?new_id='+newVersion+'&old_id='+oldVersion, (data) =>
      console.log data
      # console.log 'RETRIEVED MEASURE DATA - ' + JSON.stringify(measureData)
      @diff = data
      @diffView = @diff.diff[@populationIndex]
      @render()
      return
    )
        
    
  clearDiff: ->
    @diff = undefined
    @diffView = undefined
    
  updatePopulation: (population) ->
    @populationIndex = population.index()
    if @diff
      @diffView = @diff.diff[@populationIndex]
    @render()
