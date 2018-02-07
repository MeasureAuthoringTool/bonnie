describe 'MeasuresView', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @measures = new Thorax.Collections.Measures()
    @measure = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS160/CMS160v6.json'), parse: true
    @measures.add(@measure)
    @measuresView = new Thorax.Views.Measures(collection: @measures)
    @measuresView.render()

  afterEach ->
    bonnie.valueSetsByOid = @oldBonnieValueSetsByOid
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
