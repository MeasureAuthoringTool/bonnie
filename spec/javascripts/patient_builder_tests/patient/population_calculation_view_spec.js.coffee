describe 'PopulationCalculationView', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @measure = loadFhirMeasure 'fhir_measures/EXM130/EXM130Test.json'
    @patients = new Thorax.Collections.Patients [getJSONFixture('fhir_patients/EXM130/IPP_DENOM_Pass_Test.json')], parse: true
    @measure.set('patients', @patients)
    @population = @measure.get('populations').first()
    @populationCalculationView = new Thorax.Views.PopulationCalculation(model: @population)
    @populationCalculationView.render()

  it 'renders correctly', ->
    expect(@populationCalculationView.$el).toContainText @patients.first().getLastName()

  it 'does not have a "Share" button', ->
    expect(@populationCalculationView.$('span[class=btn-label]').length).toEqual(0)

  it 'can delete a patient', ->
    @populationCalculationView.appendTo('body')
    spyOn(@populationCalculationView, 'showDelete')
    @populationCalculationView.$("button[data-call-method=showDelete]").click()
    expect(@populationCalculationView.showDelete).toHaveBeenCalled()
    expect(@patients.length).toEqual 1
    @populationCalculationView.$("button[data-call-method=deletePatient]").click()
    expect(@patients.length).toEqual 0
    @populationCalculationView.remove()

  it 'can clone a patient', ->
    @populationCalculationView.appendTo('body')
    spyOn(@populationCalculationView, 'clonePatient')
    @populationCalculationView.$("button[data-call-method=clonePatient]").click()
    expect(@populationCalculationView.clonePatient).toHaveBeenCalled()
    @populationCalculationView.remove()
