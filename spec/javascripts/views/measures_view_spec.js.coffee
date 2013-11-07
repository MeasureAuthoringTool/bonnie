describe 'MeasuresView', ->

  beforeEach ->
    @measures = Fixtures.Measures
    @measuresView = new Thorax.Views.Measures(measures: @measures)
    @measuresView.render()

  it 'renders correctly', ->
    # expect(@measuresView.$el).toContainText "Total measures: #{@measures.length}"
    expect(@measuresView.$('.measure').length).toBe @measures.length
    measure = @measures.first()
    expect(@measuresView.$el).toContainText measure.get('measure_id')
    expect(@measuresView.$el).toContainText measure.get('title')
