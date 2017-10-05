describe 'PopulationCalculationView', ->

  beforeEach ->
    # Clear the fixtures cache so that getJSONFixture does not return stale/modified fixtures
    jasmine.getJSONFixtures().clearCache()
    @measure = bonnie.measures.findWhere(cms_id: 'CMS156v2')
    @patients = new Thorax.Collections.Patients getJSONFixture('patients.json'), parse: true
    @measure.set('patients', @patients)
    @population = @measure.get('populations').first()
    @populationCalculationView = new Thorax.Views.PopulationCalculation(model: @population)
    @populationCalculationView.render()

  it 'renders correctly', ->
    expect(@populationCalculationView.$el).toContainText @patients.first().get('last')

  it 'does not have a "Share" button', ->
    expect(@populationCalculationView.$('span[class=btn-label]').length).toEqual(0)
