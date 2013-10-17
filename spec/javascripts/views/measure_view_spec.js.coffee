describe 'MeasuresView', ->

  beforeEach ->
    @measure = Fixtures.Measures.first()
    @measureView = new Thorax.Views.Measure(model: @measure, patients: Fixtures.Patients)
    @measureView.render()

  it 'renders correctly', ->
    expect(@measureView.$el).toContainText @measure.get('description')
