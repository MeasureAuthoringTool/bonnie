describe 'CQLMeasureHelpers', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    #Failing to store and reset the global valueSetsByOid breaks the tests.
    #When integrated with the master branch context switching, this will need to be changed out.
    @universalValueSetsByOid = bonnie.valueSetsByOid

  afterEach ->
    bonnie.valueSetsByOid = @universalValueSetsByOid

  it 'finds localIds for libray FunctionRefs while finding localIds in statements', ->
    # Loads Anticoagulation Therapy for Atrial Fibrillation/Flutter measure.
    # This measure has the MAT global functions libray included and the measure uses the
    # "CalendarAgeInYearsAt" function.
    cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS723/CMS723v0.json'), parse: true

    # Find the localid for the specific statement with the global function ref.
    libraryName = 'AnticoagulationTherapyforAtrialFibrillationFlutter'
    statementName = 'Encounter with Principal Diagnosis and Age'
    localIds = CQLMeasureHelpers.findAllLocalIdsInStatementByName(cqlMeasure, libraryName, statementName)

    # The fixure loaded for this test it is known that the library reference is 49 and the functionRef itself is 55.
    expect(localIds[49]).not.toBeUndefined()
    expect(localIds[49]).toEqual({localId: '49', sourceLocalId: '55'})
