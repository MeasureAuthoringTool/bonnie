describe 'MeasuresView', ->

  beforeEach ->
    @measures = bonnie.measures
    @measure = @measures.first()
    @measuresView = new Thorax.Views.Measures(collection: @measures)
    @measuresView.render()

  it 'renders dashboard correctly', ->
    expect(@measuresView.$('.measure').length).toBe @measures.length
    expect(@measuresView.$el).toContainText @measure.get('cms_id')
    expect(@measuresView.$el).toContainText @measure.get('title')
    expect(@measuresView.$('[data-call-method="importMeasure"]').length).toBe 1
    expect(@measuresView.$('[data-call-method="updateMeasure"]').length).toBe @measures.length
    expect(@measuresView.$('.patient-listing-col > a').length).toBe @measures.length

  it 'renders measures with populations on dashboard correctly', ->
    expect(@measuresView.$('.population-title')).toContainText @measure.get('populations').first().get('title')
    expect(@measuresView.$('.population-title')).toContainText @measure.get('populations').last().get('title')
