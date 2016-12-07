describe 'MeasureHistoryView', ->
  
  beforeEach (done) ->
    jasmine.getJSONFixtures().clearCache()
    @mainView = new Thorax.LayoutView(el: '#bonnie')
<<<<<<< HEAD
    @measure = new Thorax.Models.Measure getJSONFixture('measure_data/measure_history_set/version_display/measures.json'), parse: true
    @uploadSummaries= new Thorax.Collections.UploadSummaries([], {measure_id: @measure.id, _fetched: true})
    @uploadSummaries.add(new Thorax.Models.UploadSummary uploadSummaryFixture) for uploadSummaryFixture in getJSONFixture('upload_summaries/measure_history_set/upload_summary.json')
    @patients = new Thorax.Collections.Patients()
    @patients.add(new Thorax.Models.Patient patientFixture) for patientFixture in getJSONFixture('records/measure_history_set/patients.json')
    @measure.attributes.upload_summaries = @uploadSummaries
    @measure_history_view = new Thorax.Views.MeasureHistoryView model: @measure, patients: @patients, upload_summaries: @uploadSummaries
    @measure_history_view.on "rendered", ->
      done()
    @measure_history_view.render()
    
  it 'Ensure that version is displayed properly', ->
    expect(@uploadSummaries.length).toEqual 2
    expect(@measure_history_view.$('tr[data-upload-id="584187bae76e94d175000227"]')[0]).toContainText "v5.4.000"
    expect(@measure_history_view.$('tr[data-upload-id="584187bae76e94d175000227"]')[1]).toContainText "v5.3.000"
=======
    @measure = new Thorax.Models.Measure getJSONFixture('measure_history_version_display/measure.json'), parse: true
    @uploadSummaries= new Thorax.Collections.UploadSummaries([], {measure_id: @measure.id, _fetched: true})
    @uploadSummaries.add(new Thorax.Models.UploadSummary uploadSummaryFixture) for uploadSummaryFixture in getJSONFixture('measure_history_version_display/upload_summary.json')
    @patients = new Thorax.Collections.Patients()
    @patients.add(new Thorax.Models.Patient patientFixture) for patientFixture in getJSONFixture('measure_history_version_display/patients.json')
    @measure.attributes.upload_summaries = @uploadSummaries
    
  it 'Ensure that version is displayed properly', ->
    @measure_history_view = new Thorax.Views.MeasureHistoryView model: @measure, patients: @patients, upload_summaries: @uploadSummaries
    @measure_history_view.render()
    expect(@measure_history_view.$('.measure-history-table')).toContainText "v5.4.000"
>>>>>>> BONNIE-132 Update test to use camlecase for consistancy.
