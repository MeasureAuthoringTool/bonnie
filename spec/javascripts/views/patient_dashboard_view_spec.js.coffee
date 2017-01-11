describe 'EmptyPatientDashboardView', ->

  beforeEach ->
    window.bonnieRouterCache.load('patient_dashboard_set')
    @measure = bonnie.measures.findWhere(cms_id: 'CMS128v5')
    @measureLayout = new Thorax.Views.MeasureLayout(measure: @measure)
    # PatientDashboardView is set as view in showDashboard
    @measureLayout.showDashboard(showFixedColumns: true)

  afterEach ->
    @measureLayout.remove()

  it 'renders dashboard', ->
    expect(@measureLayout.$el).toContainText @measure.get('cms_id')
    expect(@measureLayout.$el.html()).toContain "patient-dashboard"
    
  # Technically this is checking that the table is empty on the first render
  # Patients are added on the second render, but we did not add any patients
  it 'contains empty table when no patients loaded', ->
    dataTable = @measureLayout.$('#patientDashboardTable').DataTable()
    expect(dataTable.rows().count()).toEqual 0
    
  it 'view displays the correct number of populations', ->
    num_populations = @measure.get('populations').length
    expect(@measureLayout.populations.length).toEqual num_populations

  it 'should not show patient dashboard for non existant measure', ->
    spyOn(bonnie,'showPageNotFound')
    bonnie.renderPatientDashboard('non_existant_hqmf_set_id')
    waitsForAndRuns( false, 
      expect(bonnie.showPageNotFound).toHaveBeenCalled(),
      )


###
 The following tests should be converted to use webdriver if possible 
describe 'PopulatedPatientDashboardView', ->

  beforeEach (done) ->
    jasmine.getJSONFixtures().clearCache()
    @measure = bonnie.measures.findWhere(cms_id: 'CMS185v5')
    collection = new Thorax.Collections.Patients getJSONFixture('patients.json'), parse: true
    @patients = collection.filter((patient) => 
      @measure.get('hqmf_set_id') in patient.get('measure_ids'))
    # need to add patients to the measure
    @measure.get('patients').add(@patients)
    @measureLayout = new Thorax.Views.MeasureLayout(measure: @measure, patients: @patients)
    
    # PatientDashboardView is set as view in showDashboard
    @measureLayout.showDashboard(showFixedColumns: true)
    @patientDashboardView = @measureLayout.getView() # multiple populations so have a layout view
    
    @patientDashboardView.on "all", (eventName) =>
      console.log(eventName)
      debugger
    
    @patientDashboardView.initialize()
    setTimeout( done, 0)

  afterEach ->
    @patientDashboardView.results.reset() # empties the results so that they get recalculated for each run
    @patientDashboardView.unbind()
    @patientDashboardView.remove()
    
  it 'view has correct number of patients', ->
    dataTable = @patientDashboardView.$('#patientDashboardTable').DataTable()
    expect(dataTable.rows().count()).toEqual this.patients.length

jasmine.DEFAULT_TIMEOUT_INTERVAL = 20000
describe 'AddDeleteInPatientDashboardView', ->

  beforeEach (done) ->
    jasmine.getJSONFixtures().clearCache()
    @measure = bonnie.measures.findWhere(cms_id: 'CMS185v5')
    collection = new Thorax.Collections.Patients getJSONFixture('patients.json'), parse: true
    @patients = collection.filter((patient) => 
      @measure.get('hqmf_set_id') in patient.get('measure_ids'))
    # need to add patients to the measure
    @measure.get('patients').add(@patients)
    @measureLayout = new Thorax.Views.MeasureLayout(measure: @measure, patients: @patients)
    
    # PatientDashboardView is set as view in showDashboard
    @measureLayout.showDashboard(showFixedColumns: true)
    @patientDashboardView = @measureLayout.getView() # multiple populations so have a layout view

    @patientDashboardView.on "append",=>
      @patientDashboardView.render()

    @patientDashboardView.initialize()
    setTimeout( done, 10000)

  afterEach ->
    @patientDashboardView.results.reset() # empties the results so that they get recalculated for each run
    @patientDashboardView.unbind()
    @patientDashboardView.remove()
    
  it 'deletes a patient', ->
    patientsCount = this.patients.length
    dataTable = @patientDashboardView.$('#patientDashboardTable').DataTable()

    expect(dataTable.rows().count()).toEqual patientsCount
###
