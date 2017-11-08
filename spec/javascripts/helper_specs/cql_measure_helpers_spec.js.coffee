describe 'CQLMeasureHelpers', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    #Failing to store and reset the global valueSetsByOid breaks the tests.
    #When integrated with the master branch context switching, this will need to be changed out.
    @universalValueSetsByOid = bonnie.valueSetsByOid

  afterEach ->
    bonnie.valueSetsByOid = @universalValueSetsByOid

  describe 'findAllLocalIdsInStatementByName', ->
    it 'finds localIds for libray FunctionRefs while finding localIds in statements', ->
      # Loads Anticoagulation Therapy for Atrial Fibrillation/Flutter measure.
      # This measure has the MAT global functions libray included and the measure uses the
      # "CalendarAgeInYearsAt" function.
      cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS723/CMS723v0.json'), parse: true

      # Find the localid for the specific statement with the global function ref.
      libraryName = 'AnticoagulationTherapyforAtrialFibrillationFlutter'
      statementName = 'Encounter with Principal Diagnosis and Age'
      localIds = CQLMeasureHelpers.findAllLocalIdsInStatementByName(cqlMeasure, libraryName, statementName)

      # For the fixture loaded for this test it is known that the library reference is 49 and the functionRef itself is 55.
      expect(localIds[49]).not.toBeUndefined()
      expect(localIds[49]).toEqual({localId: '49', sourceLocalId: '55'})

  describe '_findLocalIdForLibraryRef', ->
    beforeEach ->
      # use a chunk of this fixture for these tests.
      cqlMeasure = getJSONFixture('measure_data/CQL/CMS723/CMS723v0.json')
      # the annotation for the 'Encounter with Principal Diagnosis and Age' will be used for these tests
      # it is known the functionRef 'global.CalendarAgeInYearsAt' is a '55' and the libraryRef clause is at '49'
      @annotationSnippet = cqlMeasure.elm[0].library.statements.def[6].annotation

    it 'returns correct localId for functionRef if when found', ->
      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '55', 'global')
      expect(ret).toEqual('49')

    it 'returns null if it does not find the localId for the functionRef', ->
      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '23', 'global')
      expect(ret).toBeNull()

    it 'returns null if it does not find the proper libraryName for the functionRef', ->
      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '55', 'notGlobal')
      expect(ret).toBeNull()

    it 'returns null if annotation is empty', ->
      ret = CQLMeasureHelpers._findLocalIdForLibraryRef({}, '55', 'notGlobal')
      expect(ret).toBeNull()

    it 'returns null if there is no value associated with annotation', ->
      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '68', 'notGlobal')
      expect(ret).toBeNull()
