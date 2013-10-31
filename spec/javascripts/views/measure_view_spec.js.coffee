describe 'MeasureView', ->

  beforeEach ->
    @measure = Fixtures.Measures.first()
    @measureView = new Thorax.Views.Measure(model: @measure, patients: Fixtures.Patients, allPopulationCodes: ['IPP', 'DENOM', 'NUMER', 'DENEXCEP', 'DENEX', 'MSRPOPL', 'OBSERV'])
    @measureView.render()

  it 'renders correctly', ->
    expect(@measureView.$el).toContainText @measure.get('description')
