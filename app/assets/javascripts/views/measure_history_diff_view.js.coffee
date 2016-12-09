class Thorax.Views.MeasureHistoryDiffView extends Thorax.Views.BonnieView
  template: JST['measure_history_diff']

  initialize: ->
    @diff = null
    @diffView = null
    @populationIndex = @model.get('displayedPopulation').index()

  loadDiff: (oldVersion, newVersion) ->
    if !oldVersion || !newVersion
      @clearDiff()
      return

    # gets the diff from the server by using the diffy gem.
    $.get('/measures/historic_diff?new_id='+newVersion+'&old_id='+oldVersion, (data) =>
      @diff = data
      @diff.pre_upload.updateTime = moment(@diff.pre_upload.updateTime).format('M/D/YYYY h:mm a')
      @diff.post_upload.updateTime = moment(@diff.post_upload.updateTime).format('M/D/YYYY h:mm a')
      @diffView = @diff.diff[@populationIndex]
      @render()
    )


  clearDiff: ->
    @diff = null
    @diffView = null
    @render()

  # updates the displayed diff to correspond to the selected population
  updatePopulation: (population) ->
    @populationIndex = population.index()
    if @diff
      @diffView = @diff.diff[@populationIndex]
    @render()
