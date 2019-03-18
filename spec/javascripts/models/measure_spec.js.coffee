describe 'Measure', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @measure = new Thorax.Models.Measure getJSONFixture('measure_data/core_measures/CMS160/CMS160v6.json'), parse: true
    @oldBonnieValueSetsByOid = bonnie.valueSetsByOid
    bonnie.valueSetsByOid = getJSONFixture('measure_data/core_measures/CMS160/value_sets.json')

  afterEach ->
    bonnie.valueSetsByOid = @oldBonnieValueSetsByOid

  it 'has basic attributes available', ->
    expect(@measure.get('hqmf_set_id')).toEqual 'A4B9763C-847E-4E02-BB7E-ACC596E90E2C'
    expect(@measure.get('title')).toEqual 'Depression Utilization of the PHQ-9 Tool'

  it 'has the expected number of populations', ->
    expect(@measure.get('populations').length).toEqual 3

  it 'has set itself as parent on measure_data_criteria', ->
    expect(@measure.get("source_data_criteria").get('parent') == @measure)

  it 'can calulate results for a patient', ->
    collection = new Thorax.Collections.Patients getJSONFixture('cqm_patients/CMS160/patients.json'), parse: true
    patient = collection.findWhere(givenNames: 'Pass', familyName: 'NUM2')
    results = @measure.get('populations').at(1).calculate(patient)
    expect(results.get('DENEX')).toEqual 0
    expect(results.get('DENOM')).toEqual 1
    expect(results.get('IPP')).toEqual 1
    expect(results.get('NUMER')).toEqual 1
