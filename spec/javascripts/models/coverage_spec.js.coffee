describe 'Coverage', ->

  beforeAll ->
    jasmine.getJSONFixtures().clearCache()
    bonnie.measures = new Thorax.Collections.Measures()
    patientTest1 = getJSONFixture('fhir_patients/CMS124/patient-denom-EXM124.json')
    @cqlPatients = new Thorax.Collections.Patients [patientTest1], parse: true

  it 'calculates coverage correctly for a measure', ->
    measure = loadFhirMeasure 'fhir_measures/CMS124/CMS124.json'
    measure.set('patients', @cqlPatients)
    bonnie.measures.add measure

    expect(measure.get('populations').at(0).coverage().get('coverage')).toEqual 29
