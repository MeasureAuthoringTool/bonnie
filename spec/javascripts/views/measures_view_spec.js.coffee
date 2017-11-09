describe 'MeasuresView', ->

  beforeEach ->
    @measures = bonnie.measures
    @measure = bonnie.measures.findWhere(cms_id: 'CMS156v2')
    @measuresView = new Thorax.Views.Measures(collection: @measures)
    @measuresView.render()

  afterEach ->
    @measuresView.remove()

  it 'renders dashboard', ->
    expect(@measuresView.$('.measure').length).toBe @measures.length
    expect(@measuresView.$el).toContainText @measure.get('cms_id')
    expect(@measuresView.$el).toContainText @measure.get('title')
    expect(@measuresView.$('.patient-listing-col > a').length).toBe @measures.length

  it 'renders measures with populations on dashboard', ->
    expect(@measuresView.$el).toContainText @measure.get('populations').first().get('title')
    expect(@measuresView.$el).toContainText @measure.get('populations').last().get('title')

  it 'does not show a download bundle button', ->
    expect(@measuresView.$el).not.toContainText 'bundle export'

  it 'does not have a ExportBundleView instance', ->
    expect(@measuresView.exportBundleView).toBeUndefined()
