describe 'MeasureHistoryView', ->

  renderView = (suite, done) ->
    suite.mainView = new Thorax.LayoutView(el: '#bonnie')
    suite.measure_history_view = new Thorax.Views.MeasureHistoryView
      model: suite.measure, patients: suite.patients, upload_summaries: suite.uploadSummaries
    suite.measure_history_view.on "rendered", ->
      done()
    suite.measure_history_view.render()

  describe 'without summaries', ->
    beforeEach (done) ->
      window.measureHistorySpecLoader.load('measure_history_set/single_population_set/CMS68', 'initialLoad', 'CMS68v4', @)
      renderView(@, done)
      
    # there is an upload summary from the initial uplaod
    it 'has length one', ->
      expect(@uploadSummaries.length).toEqual 1

    it 'to indicate lack of history', ->
      expect(@measure_history_view.$el.html()).toContain 'No history found.'

  describe 'with summaries', ->
    beforeEach (done) ->
      window.measureHistorySpecLoader.load('measure_history_set/single_population_set/CMS68', 'update2', 'CMS68v4', @)
      # upload_summaries non-empty, this measure history view will have history
      renderView(@, done)

    it 'has length three', ->
      expect(@uploadSummaries.length).toEqual 3

    it 'to *not* indicate lack of history', ->
      expect(@measure_history_view.$el.html()).not.toContain 'No history found.'

    it 'to have correct version strings', ->
      expect(@measure_history_view.$('tr[data-upload-id="5865004ae76e94aee9001433"]')[0]).toContainText "v4"
      expect(@measure_history_view.$('tr[data-upload-id="5865004ae76e94aee9001433"]')[1]).toContainText "v6.0.000"
      expect(@measure_history_view.$('tr[data-upload-id="5864f8b6e76e94aee9000dfc"]')[0]).toContainText "v6.0.000"
      expect(@measure_history_view.$('tr[data-upload-id="5864f8b6e76e94aee9000dfc"]')[1]).toContainText "v4"

    it 'should not find history for non existant measure', ->
      spyOn(bonnie,'showPageNotFound')
      bonnie.renderMeasureUploadHistory('non_existant_hqmf_set_id')
      expect(bonnie.showPageNotFound).toHaveBeenCalled()
