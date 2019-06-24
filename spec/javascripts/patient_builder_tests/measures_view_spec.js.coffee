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

  it 'renders dashboard', ->
    expect(@measuresView.$('.measure').length).toBe @measures.length
    expect(@measuresView.$el).toContainText @measure.get('cqmMeasure').cms_id
    expect(@measuresView.$el).toContainText @measure.get('cqmMeasure').title
    expect(@measuresView.$('.patient-listing-col > a').length).toBe @measures.length

  it 'renders measures with populations on dashboard', ->
    expect(@measuresView.$el).toContainText @measure.get('populations').first().get('title')
    expect(@measuresView.$el).toContainText @measure.get('populations').last().get('title')

  it 'does not show a download bundle button', ->
    expect(@measuresView.$el).not.toContainText 'bundle export'

  it 'does not have a ExportBundleView instance', ->
    expect(@measuresView.exportBundleView).toBeUndefined()

  describe 'Composite Measures', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      bonnie.measures = new Thorax.Collections.Measures()
      @compositeMeasure = loadMeasureWithValueSets 'cqm_measure_data/CMS890v0/CMS890v0.json', 'cqm_measure_data/CMS890v0/value_sets.json'
      bonnie.measures.push(@compositeMeasure)

      @components = getJSONFixture('cqm_measure_data/CMS890v0/components.json')
      @components = @components.map((component) => new Thorax.Models.Measure component, parse: true)
      valueSets = getJSONFixture 'cqm_measure_data/CMS890v0/value_sets.json'
      @components.forEach((component) => component.set('cqmValueSets', valueSets))
      @components.forEach((component) => bonnie.measures.push(component))

      patientTest1 = getJSONFixture('patients/CMS890v0/Patient_Test 1.json')
      patientTest2 = getJSONFixture('patients/CMS890v0/Patient_Test 2.json')
      @compositePatients = new Thorax.Collections.Patients [patientTest1, patientTest2], parse: true
      @compositeMeasure.populateComponents()
      @measuresView = new Thorax.Views.Measures(collection: bonnie.measures.sort(), patients: @compositePatients)
      @measuresView.appendTo 'body'

    afterAll ->
      @measuresView.remove()

    it 'Show title of composite measure', ->
      expect(@measuresView.$el).toContainText @compositeMeasure.get('cqmMeasure').title

    it 'Show titles of component measures', ->
      expect(@measuresView.$el.html()).toContainText 'Annual Wellness Assessment: Preventive Care (Screening for Breast Cancer)'
      expect(@measuresView.$el.html()).toContainText 'Annual Wellness Assessment: Preventive Care (Screening for Falls Risk)'
