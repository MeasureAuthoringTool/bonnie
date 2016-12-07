describe 'MeasureHistoryView', ->
  
  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @mainView = new Thorax.LayoutView(el: '#bonnie')
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