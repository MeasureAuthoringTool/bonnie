describe 'CQLMeasureHelpers', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    #Failing to store and reset the global valueSetsByOid breaks the tests.
    #When integrated with the master branch context switching, this will need to be changed out.
    @universalValueSetsByOid = bonnie.valueSetsByOid

  afterEach ->
    bonnie.valueSetsByOid = @universalValueSetsByOid

  describe 'findAllLocalIdsInStatementByName', ->
    it 'finds localIds for library FunctionRefs while finding localIds in statements', ->
      # Loads Anticoagulation Therapy for Atrial Fibrillation/Flutter measure.
      # This measure has the MAT global functions library included and the measure uses the
      # "CalendarAgeInYearsAt" function.
      cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS723/CMS723v0.json'), parse: true

      # Find the localid for the specific statement with the global function ref.
      libraryName = 'AnticoagulationTherapyforAtrialFibrillationFlutter'
      statementName = 'Encounter with Principal Diagnosis and Age'
      localIds = CQLMeasureHelpers.findAllLocalIdsInStatementByName(cqlMeasure, libraryName, statementName)

      # For the fixture loaded for this test it is known that the library reference is 49 and the functionRef itself is 55.
      expect(localIds[49]).not.toBeUndefined()
      expect(localIds[49]).toEqual({localId: '49', sourceLocalId: '55'})

    it 'finds localIds for library ExpressionRefs while finding localIds in statements', ->
      # Loads Test104 aka. CMS13 measure.
      # This measure has both the TJC_Overall and MAT global libraries
      cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS13/CMS13v2.json'), parse: true

      # Find the localid for the specific statement with the global function ref.
      libraryName = 'Test104'
      statementName = 'Initial Population'
      localIds = CQLMeasureHelpers.findAllLocalIdsInStatementByName(cqlMeasure, libraryName, statementName)

      # For the fixture loaded for this test it is known that the library reference is 109 and the functionRef itself is 110.
      expect(localIds[109]).not.toBeUndefined()
      expect(localIds[109]).toEqual({localId: '109', sourceLocalId: '110'})

    it 'handles library ExpressionRefs with libraryRef embedded in the clause', ->
      # Loads Test104 aka. CMS13 measure.
      # This measure has both the TJC_Overall and MAT global libraries
      cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS13/CMS13v2.json'), parse: true

      # Find the localid for the specific statement with the global function ref.
      libraryName = 'Test104'
      statementName = 'Comfort Measures during Hospitalization'
      localIds = CQLMeasureHelpers.findAllLocalIdsInStatementByName(cqlMeasure, libraryName, statementName)

      # For the fixture loaded for this test it is known that the library reference is 109 and the functionRef itself is 110.
      expect(localIds[42]).not.toBeUndefined()
      expect(localIds[42]).toEqual({localId: '42'})


  describe '_findLocalIdForLibraryRef for functionRefs', ->
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

  describe '_findLocalIdForLibraryRef for expressionRefs', ->
    beforeEach ->
      # use a chunk of this fixture for these tests.
      cqlMeasure = getJSONFixture('measure_data/CQL/CMS13/CMS13v2.json')
      # the annotation for the 'Initial Population' will be used for these tests
      # it is known the expressionRef 'TJC."Encounter with Principal Diagnosis and Age"' is '110' and the libraryRef
      # clause is at '109'
      @annotationSnippet = cqlMeasure.elm[0].library.statements.def[12].annotation

    it 'returns correct localId for expressionRef when found', ->
      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '110', 'TJC')
      expect(ret).toEqual('109')

    it 'returns null if it does not find the localId for the expressionRef', ->
      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '21', 'TJC')
      expect(ret).toBeNull()

    it 'returns null if it does not find the proper libraryName for the expressionRef', ->
      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '110', 'notTJC')
      expect(ret).toBeNull()

  describe '_findLocalIdForLibraryRef for expressionRefs with libraryRef in clause', ->
    beforeEach ->
      # use a chunk of this fixture for these tests.
      cqlMeasure = getJSONFixture('measure_data/CQL/CMS13/CMS13v2.json')
      # the annotation for the 'Comfort Measures during Hospitalization' will be used for these tests
      # it is known the expressionRef 'TJC."Encounter with Principal Diagnosis of Ischemic Stroke"' is '42' and the
      # libraryRef is embedded in the clause without a localId of its own.
      @annotationSnippet = cqlMeasure.elm[0].library.statements.def[8].annotation

    it 'returns null for expressionRef when found yet it is embedded', ->
      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '42', 'TJC')
      expect(ret).toBeNull()

    it 'returns null if it does not find the proper libraryName for the expressionRef', ->
      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '42', 'notTJC')
      expect(ret).toBeNull()
