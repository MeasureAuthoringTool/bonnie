class Thorax.Views.TestCaseHistoryDiffView extends Thorax.Views.BonnieView
  template: JST['test_case_history_diff']
  
  initialize: ->
    @diff = undefined
    
  loadDiff: (oldVersion, newVersion) ->
    $.get('/measures/historic_diff?new_id='+newVersion+'&old_id='+oldVersion, (data) =>
      console.log data
      # console.log 'RETRIEVED MEASURE DATA - ' + JSON.stringify(measureData)
      @diff = data
      @render()
      return
    )
