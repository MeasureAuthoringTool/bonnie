describe 'MeasuresView', ->

  beforeAll ->
    jasmine.getJSONFixtures().clearCache()
    @measures = new Thorax.Collections.Measures()
    @measure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/CMS160v6/CMS160v6.json'), parse: true
    @measures.add(@measure)
    @measuresView = new Thorax.Views.Measures(collection: @measures)
    @measuresView.render()

  afterAll ->
    @measuresView.remove()

  xit 'renders dashboard', ->
    expect(@measuresView.$('.measure').length).toBe @measures.length
    expect(@measuresView.$el).toContainText @measure.get('cqmMeasure').cms_id
    expect(@measuresView.$el).toContainText @measure.get('cqmMeasure').title
    expect(@measuresView.$('.patient-listing-col > a').length).toBe @measures.length

  xit 'renders measures with populations on dashboard', ->
    expect(@measuresView.$el).toContainText @measure.get('populations').first().get('title')
    expect(@measuresView.$el).toContainText @measure.get('populations').last().get('title')

  xit 'does not show a download bundle button', ->
    expect(@measuresView.$el).not.toContainText 'bundle export'

  xit 'does not have a ExportBundleView instance', ->
    expect(@measuresView.exportBundleView).toBeUndefined()
