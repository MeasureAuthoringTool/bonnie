describe 'MeasuresView', ->

  beforeEach ->
    @measures = Fixtures.Measures
    @measuresView = new Thorax.Views.Measures(measures: @measures)
    @measuresView.render()

  it 'renders correctly', ->
    expect(@measuresView.$el).toContainText "Total measures: #{@measures.collapsed().length}"
    @measures.each (m) =>
      expect(@measuresView.$el).toContainText m.get('hqmf_id')
      expect(@measuresView.$el).toContainText m.get('title')
