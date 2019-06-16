describe 'PopulationCalculationView', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @measure = loadMeasureWithValueSets 'cqm_measure_data/core_measures/CMS160/CMS160v6.json', 'cqm_measure_data/core_measures/CMS160/value_sets.json'
    @patients = new Thorax.Collections.Patients [getJSONFixture('patients/CMS160v6/Expired_DENEX.json')], parse: true
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
