describe 'MeasureHistoryView', ->
  
  beforeEach (done) ->
    results = window.measureHistorySpecLoader.loadWithHistory('single_population_set', 'CMS68v6')
    @measure = results.measure
    @patients = results.patients
    @uploadSummaries = results.uploadSummaries
    @mainView = new Thorax.LayoutView(el: '#bonnie')

    @measure_history_view = new Thorax.Views.MeasureHistoryView model: @measure, patients: @patients, upload_summaries: @uploadSummaries
    @measure_history_view.on "rendered", ->
      done()
    @measure_history_view.render()
    
  it 'Ensure that version is displayed properly', ->
    expect(@uploadSummaries.length).toEqual 3
    expect(@measure_history_view.$('tr[data-upload-id="585d7554e76e943a260004db"]')[0]).toContainText "v6.0.000"
    expect(@measure_history_view.$('tr[data-upload-id="585d7554e76e943a260004db"]')[1]).toContainText "v4"
