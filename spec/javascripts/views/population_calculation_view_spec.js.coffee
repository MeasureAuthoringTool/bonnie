describe 'PopulationCalculationView', ->

  beforeEach ->
    @measure = bonnie.measures.findWhere(cms_id: 'CMS156v2')
    @patients = new Thorax.Collections.Patients getJSONFixture('patients.json'), parse: true
    @measure.set('patients', @patients)
    @population = @measure.get('populations').first()
    @populationCalculationView = new Thorax.Views.PopulationCalculation(model: @population)
    @populationCalculationView.render()

  it 'renders correctly', ->
    expect(@populationCalculationView.$el).toContainText @patients.first().get('last')
