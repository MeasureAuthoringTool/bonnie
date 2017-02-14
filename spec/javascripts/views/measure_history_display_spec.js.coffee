describe 'MeasureHistoryView', ->

  renderView = (suite, callback) ->
    suite.mainView = new Thorax.LayoutView(el: '#bonnie')
    suite.measure_history_view = new Thorax.Views.MeasureHistoryView
      model: suite.measure, patients: suite.patients, upload_summaries: suite.uploadSummaries
    suite.measure_history_view.on "rendered", ->
      callback()
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

    it 'does show current patients', ->
      expect(@measure_history_view.patients.length).toEqual 2
      expect(@measure_history_view.$('th[class="history-patient-header"]').length).toEqual 2

      @uploadSummaries.each (us) =>
        summary_id = us.get('_id')
        for population_set_summary in us.get('population_set_summaries')
          for patientId, summary of population_set_summary.patients
            afterString = "version-after-#{summary_id} upload-#{summary_id} patient-#{patientId}"
            beforeString = "version-before-#{summary_id} upload-#{summary_id} patient-#{patientId}"
            afterCell = @measure_history_view.$("td[headers='#{afterString}']")
            beforeCell = @measure_history_view.$("td[headers='#{beforeString}']")

            # Check pass/fail text
            expect(afterCell).toContainText summary.post_upload_status
            expect(beforeCell).toContainText summary.pre_upload_status

            # Check pass/fail icon
            expect($(afterCell).find("i.fa")[0].className).toMatch (if summary.post_upload_status is "pass" then "fa-check" else "fa-times")
            expect($(beforeCell).find("i.fa")[0].className).toMatch (if summary.pre_upload_status is "pass" then "fa-check" else "fa-times")

    it 'does *not* show new patients', (done) ->
      expect(@measure_history_view.$('th[class="history-patient-header"]').length).toEqual 2

      # Confirm that there are only 2 patients in the most resent uploadSummaries (assumes that uploadSummaries are sorted in desc order based on date)
      expect(Object.keys(this.uploadSummaries.at(0).get('population_set_summaries')[0].patients).length).toEqual 2

      # Create and add new patients to this measure history view
      @new_patient = new Thorax.Models.Patient getJSONFixture('records/base_set/patients.json')[0], parse: true
      @new_clone = @measure_history_view.patients.at(0).deepClone({omit_id: true})
      
      # Make sure that the patients are associated to the current measusre
      @new_patient.set('measure_ids', [@measure.get('hqmf_set_id'), null])
      @new_clone.set('measure_ids', [@measure.get('hqmf_set_id'), null])
      @patients.add [@new_patient, @new_clone]
      expect(@patients.length).toEqual 4

      # Add all the patients as patients on the measure
      @measure.get('patients').add [@new_patient, @new_clone]
      expect(@measure.get('patients').length).toEqual 4

      # create new measure history view with the measure
      renderView @, =>

        expect(@measure_history_view.patients.length).toEqual 4
        expect(@measure_history_view.measureTimelineView.patients.length).toEqual 4

        expect(@measure_history_view.$('th[class="history-patient-header"]').length).toEqual 2

        # Confirm that the number of uploadSummaries hasn't changed
        expect(Object.keys(this.uploadSummaries.at(0).get('population_set_summaries')[0].patients).length).toEqual 2

        done()
