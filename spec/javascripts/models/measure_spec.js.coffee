describe 'Measure', ->

  beforeAll ->
    jasmine.getJSONFixtures().clearCache()
    @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS160v6/CMS160v6.json', 'cqm_measure_data/CMS160v6/value_sets.json'

  it 'has basic attributes available', ->
    expect(@measure.get('cqmMeasure').hqmf_set_id).toEqual 'A4B9763C-847E-4E02-BB7E-ACC596E90E2C'
    expect(@measure.get('cqmMeasure').get('title')).toEqual 'Depression Utilization of the PHQ-9 Tool'

  it 'has the expected number of populations', ->
    expect(@measure.get('populations').length).toEqual 3

  it 'has set itself as parent on source_data_criteria', ->
    expect(@measure.get('cqmMeasure').get('parent') == @measure)

  it 'can calulate results for a patient using second population', ->
    expiredDenex = getJSONFixture 'patients/CMS160v6/Expired_DENEX.json'
    passNum2 = getJSONFixture 'patients/CMS160v6/Pass_NUM2.json'
    collection = new Thorax.Collections.Patients [expiredDenex, passNum2], parse: true
    patient = collection.at(1) # Pass NUM2
    results = @measure.get('populations').at(1).calculate(patient)
    expect(results.get('DENEX')).toEqual 0
    expect(results.get('DENOM')).toEqual 1
    expect(results.get('IPP')).toEqual 1
    expect(results.get('NUMER')).toEqual 1
