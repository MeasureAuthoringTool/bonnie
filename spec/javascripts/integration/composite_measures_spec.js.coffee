describe 'Composite Measures', ->
  beforeAll ->
    jasmine.getJSONFixtures().clearCache()
    @valueSetsPath = 'cqm_measure_data/CMS890v0/value_sets.json'
    @components = getJSONFixture('cqm_measure_data/CMS890v0/components.json')
    patientTest1 = getJSONFixture('patients/CMS890v0/Patient_Test 1.json')
    @patients = new Thorax.Collections.Patients [patientTest1], parse: true
    @pt1 = @patients.models[0] # Patient Test 1

  it 'calculate correctly for the composite measure', ->
    measure = loadMeasureWithValueSets 'cqm_measure_data/CMS890v0/CMS890v0.json', @valueSetsPath
    population = measure.get('populations').at(0)

    result = population.calculate(@pt1)
    expect(result.get('IPP')).toEqual 1
    expect(result.get('MSRPOPL')).toEqual 1
    expect(result.get('MSRPOPLEX')).toEqual 0
    expect(result.get('observation_values')[0].toFixed(2)).toEqual '0.25'
    expect(result.get('observation_values').length).toEqual 1

  it 'calculate correctly for a component measure 2', ->
    measure = new Thorax.Models.Measure @components[6], parse: true
    measure.set('cqmValueSets', getJSONFixture(@valueSetsPath)[measure.get('cqmMeasure').hqmf_set_id]);
    population = measure.get('populations').at(0)

    result = population.calculate(@pt1)
    expect(result.get('IPP')).toEqual 1
    expect(result.get('DENOM')).toEqual 1
    expect(result.get('DENEX')).toEqual 0
    expect(result.get('NUMER')).toEqual 0
    expect(result.get('DENEXCEP')).toEqual 0
    expect(result.get('observation_values').length).toEqual 0

  it 'uses correct cached calculation for a component measure after composite has been calculated', ->
    measure = loadMeasureWithValueSets 'cqm_measure_data/CMS890v0/CMS890v0.json', @valueSetsPath
    population = measure.get('populations').at(0)
    population.calculate(@pt1)

    measure = new Thorax.Models.Measure @components[6], parse: true
    measure.set('cqmValueSets', getJSONFixture(@valueSetsPath)[measure.get('cqmMeasure').hqmf_set_id]);
    population = measure.get('populations').at(0)

    result = population.calculate(@pt1)
    expect(result.get('IPP')).toEqual 1
    expect(result.get('DENOM')).toEqual 1
    expect(result.get('DENEX')).toEqual 0
    expect(result.get('NUMER')).toEqual 0
    expect(result.get('DENEXCEP')).toEqual 0
    expect(result.get('observation_values').length).toEqual 0
