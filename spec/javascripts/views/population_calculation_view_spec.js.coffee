describe 'PopulationCalculationView', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @measure = loadMeasureWithValueSets 'cqm_measure_data/core_measures/CMS160/CMS160v6.json', 'cqm_measure_data/core_measures/CMS160/value_sets.json'
    @patients = new Thorax.Collections.Patients getJSONFixture('patients/core_measures/CMS160/patients.json'), parse: true
    @measure.set('patients', @patients)
    @population = @measure.get('populations').first()
    @populationCalculationView = new Thorax.Views.PopulationCalculation(model: @population)
    @populationCalculationView.render()

  it 'renders correctly', ->
    expect(@populationCalculationView.$el).toContainText @patients.first().getLastName()

  it 'does not have a "Share" button', ->
    expect(@populationCalculationView.$('span[class=btn-label]').length).toEqual(0)
