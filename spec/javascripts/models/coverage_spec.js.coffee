describe 'Coverage', ->

  beforeAll ->
    jasmine.getJSONFixtures().clearCache()
    bonnie.measures = new Thorax.Collections.Measures()
    @valueSetsPath = 'cqm_measure_data/CMS890v0/value_sets.json'
    patientTest1 = getJSONFixture('patients/CMS890v0/Patient_Test 1.json')
    patientTest2 = getJSONFixture('patients/CMS890v0/Patient_Test 2.json')
    @cqlPatients = new Thorax.Collections.Patients [patientTest1, patientTest2], parse: true
    @components = getJSONFixture('cqm_measure_data/CMS890v0/components.json')

  xit 'calculates coverage correctly for composite measures', ->
    measure = loadMeasureWithValueSets 'cqm_measure_data/CMS890v0/CMS890v0.json', @valueSetsPath
    measure.set('patients',@cqlPatients)
    bonnie.measures.add measure

    expect(measure.get('populations').at(0).coverage().get('coverage')).toEqual 72

  xit 'calculates coverage correctly for a component measure', ->
    measure = new Thorax.Models.Measure @components[0], parse: true
    measure.set('cqmValueSets', getJSONFixture(@valueSetsPath))
    measure.set('patients', @cqlPatients)
    bonnie.measures.add measure

    expect(measure.get('populations').at(0).coverage().get('coverage')).toEqual 22

