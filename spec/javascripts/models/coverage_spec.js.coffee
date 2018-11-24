describe 'Coverage', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    bonnie.measures = new Thorax.Collections.Measures()
    @universalValueSetsByOid = bonnie.valueSetsByOid
    bonnie.valueSetsByOid = getJSONFixture('measure_data/special_measures/CMS321/value_sets.json')
    @cqlPatients = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMS321/patients.json'), parse: true
    @components = getJSONFixture('measure_data/special_measures/CMS321/components.json')

  afterEach ->
    bonnie.valueSetsByOid = @universalValueSetsByOid

  it 'calculates coverage correctly for composite measures', ->
    measure = new Thorax.Models.Measure getJSONFixture('measure_data/special_measures/CMS321/CMS321v0.json'), parse: true
    measure.set('patients',@cqlPatients)
    bonnie.measures.add measure      

    expect(measure.get('populations').at(0).coverage().get('coverage')).toEqual 61

  it 'calculates coverage correctly for a component measure', ->
    measure = new Thorax.Models.Measure @components[0], parse: true
    measure.set('patients',@cqlPatients)
    bonnie.measures.add measure      

    expect(measure.get('populations').at(0).coverage().get('coverage')).toEqual 22


