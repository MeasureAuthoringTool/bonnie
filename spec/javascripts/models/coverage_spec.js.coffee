describe 'Coverage', ->

  beforeAll ->
    jasmine.getJSONFixtures().clearCache()
    bonnie.measures = new Thorax.Collections.Measures()
    patientTest1 = getJSONFixture('fhir_patients/CMS124/patient-denom-EXM124.json')
    @cqlPatients = new Thorax.Collections.Patients [patientTest1], parse: true
    @measure = loadFhirMeasure 'fhir_measures/CMS124/CMS124.json'
    @measure.set('patients', @cqlPatients)
    bonnie.measures.add @measure
    @coverageModel = @measure.get('populations').at(0).coverage()

  it 'calculates coverage correctly for a measure', ->
    expect(@coverageModel.get('coverage')).toEqual 29

  it 'ignores Value Set clauses', ->
    expect(@coverageModel.ignoreClause(raw: {name: 'ValueSet'})).toBe(true)

  it 'ignores clauses with no result', ->
    expect(@coverageModel.ignoreClause(raw: {name: 'testClause'}, final:'NA')).toBe(true)
