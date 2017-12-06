describe 'PopulationCalculationView', ->

  beforeEach ->
    window.bonnieRouterCache.load('base_set')
    @measure = bonnie.measures.findWhere(cms_id: 'CMS156v2')
    @patients = new Thorax.Collections.Patients getJSONFixture('records/QDM/base_set/patients.json'), parse: true
    @measure.set('patients', @patients)
    @population = @measure.get('populations').first()
    @populationCalculationView = new Thorax.Views.PopulationCalculation(model: @population)
    @populationCalculationView.render()

  it 'renders correctly', ->
    expect(@populationCalculationView.$el).toContainText @patients.first().get('last')

  it 'does not have a "Share" button', ->
    expect(@populationCalculationView.$('span[class=btn-label]').length).toEqual(0)
