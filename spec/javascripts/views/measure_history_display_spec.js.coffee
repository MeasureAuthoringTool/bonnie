describe 'MeasureHistoryView', ->
  initializeSuite = (suite) ->
    jasmine.getJSONFixtures().clearCache()
    window.measureHistorySpecLoader.loadWithHistory('single_population_set', 'CMS68v6', suite)
    suite.mainView = new Thorax.LayoutView(el: '#bonnie')

  renderView = (suite, done) ->
    suite.measure_history_view = new Thorax.Views.MeasureHistoryView
      model: suite.measure, patients: suite.patients, upload_summaries: suite.uploadSummaries
    suite.measure_history_view.on "rendered", ->
      done()
    suite.measure_history_view.render()


  describe 'without summaries', ->
    beforeEach (done) ->
      initializeSuite(@)
      @uploadSummaries = new Thorax.Collections.UploadSummaries([], {measure_id: @measure.id, _fetched: true})
      # upload_summaries is empty, this measure history view will not have any history
      renderView(@, done)

    it 'has length zero', ->
      expect(@uploadSummaries.length).toEqual 0

    it 'to indicate lack of history', ->
      expect(@measure_history_view.$el.html()).toContain 'No history found.'


  describe 'with summaries', ->
    beforeEach (done) ->
      initializeSuite(@)
      # upload_summaries non-empty, this measure history view will have history
      renderView(@, done)

    it 'has length two', ->
      expect(@uploadSummaries.length).toEqual 3

    it 'to *not* indicate lack of history', ->
      expect(@measure_history_view.$el.html()).not.toContain 'No history found.'

    it 'to have correct version strings', ->
      expect(@measure_history_view.$('tr[data-upload-id="585d7554e76e943a260004db"]')[0]).toContainText "v6.0.000"
      expect(@measure_history_view.$('tr[data-upload-id="585d7554e76e943a260004db"]')[1]).toContainText "v4"
      expect(@measure_history_view.$('tr[data-upload-id="585d739fe76e943a26000143"]')[0]).toContainText "v4"
      expect(@measure_history_view.$('tr[data-upload-id="585d739fe76e943a26000143"]')[1]).toContainText "v6.1.000"
