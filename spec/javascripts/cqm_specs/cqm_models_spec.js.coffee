describe 'cqm.models', ->

  it 'is loaded into the browser', ->
    cqm.models

  it 'can be used to create a CqmPatient', ->
    cqmPatient = new cqm.models.CqmPatient()
    cqmPatient.fhir_patient = new cqm.models.Patient()
    expect(cqmPatient.clone()).toEqual cqmPatient

  it 'can be used to access cql-execution', ->
    cql = cqm.models.CQL
    expect(new cql.DateTime(2012, 2, 3).year).toEqual 2012