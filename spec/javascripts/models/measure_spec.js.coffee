describe 'Measure', ->

  beforeAll ->
    jasmine.getJSONFixtures().clearCache()
    @measure = loadFhirMeasure 'fhir_measure_data/CMS1010V0.json'

  it 'has basic attributes available', ->
    expect(@measure.get('cqmMeasure').set_id).toEqual "116A8764-E871-472F-9503-CA27889114DE"
    expect(@measure.get('cqmMeasure').title).toEqual "ContinuousFhir"

  it 'has the expected number of populations', ->
    expect(@measure.get('populations').length).toEqual 4

  # it 'has set itself as parent on source_data_criteria', ->
  #   expect(@measure.get('cqmMeasure').get('parent') == @measure)

  # it 'can calulate results for a patient using second population', ->
  #   expiredDenex = getJSONFixture 'patients/CMS160v6/Expired_DENEX.json'
  #   passNum2 = getJSONFixture 'patients/CMS160v6/Pass_NUM2.json'
  #   collection = new Thorax.Collections.Patients [expiredDenex, passNum2], parse: true
  #   patient = collection.at(1) # Pass NUM2
  #   results = @measure.get('populations').at(1).calculate(patient)
  #   expect(results.get('DENEX')).toEqual 0
  #   expect(results.get('DENOM')).toEqual 1
  #   expect(results.get('IPP')).toEqual 1
  #   expect(results.get('NUMER')).toEqual 1
