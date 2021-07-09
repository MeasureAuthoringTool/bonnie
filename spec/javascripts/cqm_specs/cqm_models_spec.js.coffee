describe 'cqm.models', ->

  it 'is loaded into the browser', ->
    cqm.models

  it 'can be used to create a QDMPatient', ->
    qdmPatient = new cqm.models.QDMPatient()
    expect(qdmPatient.qdmVersion).toEqual '5.5'

  it 'can be used to access cql-execution', ->
    cql = cqm.models.CQL
    expect(new cql.DateTime(2012, 2, 3).year).toEqual 2012