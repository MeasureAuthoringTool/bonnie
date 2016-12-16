describe 'PopulationCalculationView', ->
  beforeEach ->
    loadState("base_set")
    # Clear the fixtures cache so that getJSONFixture does not return stale/modified fixtures
    jasmine.getJSONFixtures().clearCache()
    @measure = bonnie.measures.findWhere(cms_id: 'CMS156v2')
    @patients = new Thorax.Collections.Patients getJSONFixture('records/base_set/patients.json'), parse: true
    @measure.set('patients', @patients)
    @population = @measure.get('populations').first()
    @populationCalculationView = new Thorax.Views.PopulationCalculation(model: @population)
    @populationCalculationView.render()

  afterEach ->
    # clean up all changes to the measure, as this is in a global store (not a copy)
    @measure.get('patients').reset()

  it 'renders correctly', ->
    expect(@populationCalculationView.$el).toContainText @patients.first().get('last')
