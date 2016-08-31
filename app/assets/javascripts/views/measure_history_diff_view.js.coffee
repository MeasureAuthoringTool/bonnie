class Thorax.Views.MeasureHistoryDiffView extends Thorax.Views.BonnieView
  template: JST['measure_history_diff']
  
  initialize: ->
    @diff = undefined
    @diffView = undefined
    @populationIndex = @model.get('displayedPopulation').index()
    
  loadDiff: (oldVersion, newVersion) ->
    if !oldVersion
      @diff = undefined
      @diffView = undefined
      @render()
      return
    
    $.get('/measures/historic_diff?new_id='+newVersion+'&old_id='+oldVersion, (data) =>
      @diff = data
      @diff.left.updateTime = moment(@diff.left.updateTime).format('M/D/YYYY h:mm a')
      @diff.right.updateTime = moment(@diff.right.updateTime).format('M/D/YYYY h:mm a')
      @diffView = @diff.diff[@populationIndex]
      @render()
    )
        
    
  clearDiff: ->
    @diff = undefined
    @diffView = undefined
    @render()
    
  updatePopulation: (population) ->
    @populationIndex = population.index()
    if @diff
      @diffView = @diff.diff[@populationIndex]
    @render()
