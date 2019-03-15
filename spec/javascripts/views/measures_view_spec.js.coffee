describe 'MeasuresView', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @measures = new Thorax.Collections.Measures()
    @measure = new Thorax.Models.Measure getJSONFixture('measure_data/core_measures/CMS160/CMS160v6.json'), parse: true
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

  describe 'Composite Measures', ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      @universalValueSetsByOid = bonnie.valueSetsByOid
      bonnie.valueSetsByOid = getJSONFixture('measure_data/special_measures/CMS890/value_sets.json')
      bonnie.measures = new Thorax.Collections.Measures()
      @compositeMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/special_measures/CMS890/CMS890v0.json'), parse: true
      bonnie.measures.push(@compositeMeasure)

      @components = getJSONFixture('measure_data/special_measures/CMS890/components.json')
      @components = @components.map((component) => new Thorax.Models.Measure component, parse: true)
      @components.forEach((component) => bonnie.measures.push(component))

      @compositePatients = new Thorax.Collections.Patients getJSONFixture('cqm_patients/CMS890/patients.json'), parse: true
      @compositeMeasure.populateComponents()
      @measuresView = new Thorax.Views.Measures(collection: bonnie.measures.sort(), patients: @compositePatients)
      @measuresView.appendTo 'body'

    afterEach ->
      bonnie.valueSetsByOid = @universalValueSetsByOid
      @measuresView.remove()

    it 'Show title of composite measure', ->
      expect(@measuresView.$el).toContainText @compositeMeasure.get('title')

    it 'Show titles of component measures', ->
      expect(@measuresView.$el.html()).toContainText 'Annual Wellness Assessment: Preventive Care (Screening for Breast Cancer)'
      expect(@measuresView.$el.html()).toContainText 'Annual Wellness Assessment: Preventive Care (Screening for Falls Risk)'
