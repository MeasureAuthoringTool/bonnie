describe 'MeasuresView', ->

  beforeAll ->
    jasmine.getJSONFixtures().clearCache()
    @measures = new Thorax.Collections.Measures()
    @measure = new Thorax.Models.Measure getJSONFixture('fhir_measures/CMS104/CMS104.json'), parse: true
    @measures.add(@measure)
    @measuresView = new Thorax.Views.Measures(collection: @measures)
    @measuresView.render()

  afterAll ->
    @measuresView.remove()

  it 'renders dashboard for a measure', ->
    expect(@measuresView.$('.measure').length).toBe @measures.length
    expect(@measuresView.$el).toContainText @measure.get('cqmMeasure').cms_id
    expect(@measuresView.$el).toContainText @measure.get('cqmMeasure').title
    expect(@measuresView.$('.expected-col canvas').length).toBe @measures.length
