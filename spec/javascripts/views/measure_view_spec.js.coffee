describe 'MeasureView', ->

  beforeEach ->
    @measure = bonnie.measures.first()
    @measureView = new Thorax.Views.Measure(model: @measure, patients: @measure.get('patients'))
    @measureView.render()

  it 'renders correctly', ->
    expect(@measureView.$el).toContainText @measure.get('description')
