describe 'MeasureHistoryView', ->

  renderView = (suite, callback) ->
    suite.mainView = new Thorax.LayoutView(el: '#bonnie')
    suite.measureHistoryView = new Thorax.Views.MeasureHistoryView
      model: suite.measure, patients: suite.patients, upload_summaries: suite.uploadSummaries
    suite.measureHistoryView.on "rendered", ->
      callback()
    suite.measureHistoryView.render()

  describe 'without summaries', ->
    beforeEach (done) ->
      window.measureHistorySpecLoader.load('measure_history_set/single_population_set/CMS68', 'initialLoad', 'CMS68v4', @)
      renderView(@, done)
      
    # there is an upload summary from the initial uplaod
    it 'has length one', ->
      expect(@uploadSummaries.length).toEqual 1

    it 'to indicate lack of history', ->
      expect(@measureHistoryView.$el.html()).toContain 'No history found.'

  describe 'with summaries', ->
    beforeEach (done) ->
      window.measureHistorySpecLoader.load('measure_history_set/single_population_set/CMS68', 'update2', 'CMS68v4', @)
      # upload_summaries non-empty, this measure history view will have history
      renderView(@, done)

    it 'has length three', ->
      expect(@uploadSummaries.length).toEqual 3

    it 'to *not* indicate lack of history', ->
      expect(@measureHistoryView.$el.html()).not.toContain 'No history found.'

    it 'to have correct version strings', ->
      expect(@measureHistoryView.$('tr[data-upload-id="5865004ae76e94aee9001433"]')[0]).toContainText "v4"
      expect(@measureHistoryView.$('tr[data-upload-id="5865004ae76e94aee9001433"]')[1]).toContainText "v6.0.000"
      expect(@measureHistoryView.$('tr[data-upload-id="5864f8b6e76e94aee9000dfc"]')[0]).toContainText "v6.0.000"
      expect(@measureHistoryView.$('tr[data-upload-id="5864f8b6e76e94aee9000dfc"]')[1]).toContainText "v4"

    it 'should not find history for non existant measure', ->
      spyOn(bonnie,'showPageNotFound')
      bonnie.renderMeasureUploadHistory('non_existant_hqmf_set_id')
      expect(bonnie.showPageNotFound).toHaveBeenCalled()

    it 'does show current patients', ->
      expect(@measureHistoryView.patients.length).toEqual 2
      expect(@measureHistoryView.$('th[class="history-patient-header"]').length).toEqual 2

      @uploadSummaries.each (us) =>
        summary_id = us.get('_id')
        # Ensure that we are looking at the first population set summary
        for population_set_summary in us.get('population_set_summaries')[0]
          for patientId, summary of population_set_summary.patients
            afterString = "version-after-#{summary_id} upload-#{summary_id} patient-#{patientId}"
            beforeString = "version-before-#{summary_id} upload-#{summary_id} patient-#{patientId}"
            afterCell = @measureHistoryView.$("td[headers='#{afterString}']")
            beforeCell = @measureHistoryView.$("td[headers='#{beforeString}']")

            # Check pass/fail text
            expect(afterCell).toContainText summary.post_upload_status
            expect(beforeCell).toContainText summary.pre_upload_status

            # Check pass/fail icon
            expect($(afterCell).find("i.fa")[0].className).toMatch (if summary.post_upload_status is "pass" then "fa-check" else "fa-times")
            expect($(beforeCell).find("i.fa")[0].className).toMatch (if summary.pre_upload_status is "pass" then "fa-check" else "fa-times")

    it 'does *not* show new patients', (done) ->
      expect(@measureHistoryView.$('th[class="history-patient-header"]').length).toEqual 2

      # Confirm that there are only 2 patients in the most resent uploadSummaries (assumes that uploadSummaries are sorted in desc order based on date)
      expect(Object.keys(this.uploadSummaries.at(0).get('population_set_summaries')[0].patients).length).toEqual 2

      # Create and add new patients to this measure history view
      @newPatient = new Thorax.Models.Patient getJSONFixture('records/base_set/patients.json')[0], parse: true
      @newClone = @measureHistoryView.patients.at(0).deepClone({omit_id: true})
      
      # Make sure that the patients are associated to the current measusre
      @newPatient.set('measure_ids', [@measure.get('hqmf_set_id')])
      @newClone.set('measure_ids', [@measure.get('hqmf_set_id')])
      @patients.add [@newPatient, @newClone]
      expect(@patients.length).toEqual 4

      # Add all the patients as patients on the measure
      @measure.get('patients').add [@newPatient, @newClone]
      expect(@measure.get('patients').length).toEqual 4

      # Get the number of Upload Summaries before rendering
      @uploadSummariesBeforeRender = @uploadSummaries.length

      # create new measure history view with the measure
      renderView @, =>

        expect(@measureHistoryView.patients.length).toEqual 4
        expect(@measureHistoryView.measureTimelineView.patients.length).toEqual 4

        expect(@measureHistoryView.$('th[class="history-patient-header"]').length).toEqual 2
        expect(@measureHistoryView.measureTimelineView.patientIndex.length).toEqual 2

        # Confirm that the number of Upload Summaries has not changed
        expect(@uploadSummaries.length).toEqual @uploadSummariesBeforeRender

        # Confirm that the number of patients in the most recent uploadSummaries hasn't changed
        expect(Object.keys(@uploadSummaries.at(0).get('population_set_summaries')[0].patients).length).toEqual 2

        done()
