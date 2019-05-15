describe 'CQLMeasureHelpers', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()

  describe 'findAllLocalIdsInStatementByName', ->
    it 'finds localIds for library FunctionRefs while finding localIds in statements', ->
      # Loads Diabetes: Medical Attention for Neuropathy.
      # This measure has the MAT global functions library included and the measure uses the
      # "CalendarAgeInYearsAt" function.
      measure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/core_measures/CMS134/CMS134v6.json'), parse: true

      # Find the localid for the specific statement with the global function ref.
      libraryName = 'DiabetesMedicalAttentionforNephropathy'
      statementName = 'Initial Population'
      localIds = CQLMeasureHelpers.findAllLocalIdsInStatementByName(measure.get('cqmMeasure'), libraryName, statementName)

      # For the fixture loaded for this test it is known that the library reference is 102 and the functionRef itself is 107.
      expect(localIds[102]).not.toBeUndefined()
      expect(localIds[102]).toEqual({localId: '102', sourceLocalId: '107'})

    it 'finds localIds for library ExpressionRefs while finding localIds in statements', ->
      # Loads Diabetes: Medical Attention for Neuropathy.
      measure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/core_measures/CMS134/CMS134v6.json'), parse: true

      # Find the localid for the specific statement with the global expression ref.
      libraryName = 'DiabetesMedicalAttentionforNephropathy'
      statementName = 'In Hospice'
      localIds = CQLMeasureHelpers.findAllLocalIdsInStatementByName(measure.get('cqmMeasure'), libraryName, statementName)

      # For the fixture loaded for this test it is known that the library reference is 159 and the ExpressionRef itself is 160.
      expect(localIds[159]).not.toBeUndefined()
      expect(localIds[159]).toEqual({localId: '159', sourceLocalId: '160'})

    xit 'handles library ExpressionRefs with libraryRef embedded in the clause', ->
      # Loads Test104 aka. CMS13 measure.
      # This measure has both the TJC_Overall and MAT global libraries
      measure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/deprecated_measures/CMS13/CMS13v2.json'), parse: true

      # Find the localid for the specific statement with the global function ref.
      libraryName = 'Test104'
      statementName = 'Comfort Measures during Hospitalization'
      localIds = CQLMeasureHelpers.findAllLocalIdsInStatementByName(measure.get('cqmMeasure'), libraryName, statementName)

      # 79 refers to the localId for the ExpressionRef that has a libraryRef included in it
      #        "name": "Encounter with Principal Diagnosis of Ischemic Stroke",
      # "libraryName": "TJC",
      expect(localIds[79]).not.toBeUndefined()
      expect(localIds[79]).toEqual({localId: '79'})


  describe '_findLocalIdForLibraryRef for functionRefs', ->
    beforeEach ->
      # use a chunk of this fixture for these tests.
      measure = getJSONFixture('cqm_measure_data/special_measures/CMS146/CMS146v6.json')
      # the annotation for the 'Initial Population' will be used for these tests
      # it is known the functionRef 'Global.CalendarAgeInYearsAt' is at '71' and the libraryRef clause is at '66'
      @annotationSnippet = measure.cql_libraries[0].elm.library.statements.def[8].annotation

    it 'returns correct localId for functionRef if when found', ->
      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '71', 'Global')
      expect(ret).toEqual('66')

    it 'returns null if it does not find the localId for the functionRef', ->
      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '23', 'Global')
      expect(ret).toBeNull()

    it 'returns null if it does not find the proper libraryName for the functionRef', ->
      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '71', 'notGlobal')
      expect(ret).toBeNull()

    it 'returns null if annotation is empty', ->
      ret = CQLMeasureHelpers._findLocalIdForLibraryRef({}, '71', 'notGlobal')
      expect(ret).toBeNull()

    it 'returns null if there is no value associated with annotation', ->
      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '87', 'notGlobal')
      expect(ret).toBeNull()

  describe '_findLocalIdForLibraryRef for expressionRefs', ->
    beforeEach ->
      # use a chunk of this fixture for these tests.
      measure = getJSONFixture('cqm_measure_data/special_measures/CMS146/CMS146v6.json')
      # the annotation for the 'In Hospice' will be used for these tests
      # it is known the expressionRef 'Hospice."Has Hospice"' is '136' and the libraryRef
      # clause is at '135'
      @annotationSnippet = measure.cql_libraries[0].elm.library.statements.def[12].annotation

    it 'returns correct localId for expressionRef when found', ->
      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '136', 'Hospice')
      expect(ret).toEqual('135')

    it 'returns null if it does not find the localId for the expressionRef', ->
      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '21', 'Hospice')
      expect(ret).toBeNull()

    it 'returns null if it does not find the proper libraryName for the expressionRef', ->
      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '136', 'notHospice')
      expect(ret).toBeNull()

  describe '_findLocalIdForLibraryRef for expressionRefs with libraryRef in clause', ->
    beforeEach ->
      # use a chunk of this fixture for these tests.
      measure = getJSONFixture('cqm_measure_data/deprecated_measures/CMS13/CMS13v2.json')
      # the annotation for the 'Comfort Measures during Hospitalization' will be used for these tests
      # it is known the expressionRef 'TJC."Encounter with Principal Diagnosis of Ischemic Stroke"' is '42' and the
      # libraryRef is embedded in the clause without a localId of its own.
      @annotationSnippet = measure.cql_libraries[0].elm.library.statements.def[8].annotation

    it 'returns null for expressionRef when found yet it is embedded', ->
      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '42', 'TJC')
      expect(ret).toBeNull()

    it 'returns null if it does not find the proper libraryName for the expressionRef', ->
      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '42', 'notTJC')
      expect(ret).toBeNull()
