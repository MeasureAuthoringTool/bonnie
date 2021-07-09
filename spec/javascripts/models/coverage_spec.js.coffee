describe 'Coverage', ->

  beforeAll ->
    jasmine.getJSONFixtures().clearCache()
    bonnie.measures = new Thorax.Collections.Measures()
    patientTest1 = getJSONFixture('patients/CMS890v0/Patient_Test 1.json')
    patientTest2 = getJSONFixture('patients/CMS890v0/Patient_Test 2.json')
    @cqlPatients = new Thorax.Collections.Patients [patientTest1, patientTest2], parse: true

  it 'calculates coverage correctly for composite measures', ->
    measure = loadMeasureWithValueSets 'cqm_measure_data/CMS890v0/CMS890v0.json', 'cqm_measure_data/CMS890v0/value_sets.json'
    measure.set('patients', @cqlPatients)
    bonnie.measures.add measure

    expect(measure.get('populations').at(0).coverage().get('coverage')).toEqual 59

  it 'calculates coverage correctly for a component measure', ->
    measure = loadMeasureWithValueSets 'cqm_measure_data/CMS231v0/CMS231v0.json', 'cqm_measure_data/CMS231v0/value_sets.json'
    measure.set('patients', @cqlPatients)
    bonnie.measures.add measure

    expect(measure.get('populations').at(0).coverage().get('coverage')).toEqual 49

