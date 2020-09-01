describe 'CQLMeasureHelpers', ->

  beforeAll ->
    jasmine.getJSONFixtures().clearCache()

  describe 'findAllLocalIdsInStatementByName', ->
    it 'finds localIds for library FunctionRefs while finding localIds in statements', ->
      measure = new Thorax.Models.Measure getJSONFixture('fhir_measures/CMS104/CMS104.json'), parse: true
      # Find the localid for the specific statement with the global function ref.
      libraryName = 'FHIRHelpers'
      statementName = 'ToInterval'
      localIds = CQLMeasureHelpers.findAllLocalIdsInStatementByName(measure.get('cqmMeasure'), libraryName, statementName)

      # For the fixture loaded for this test it is known that the local Id reference is 53.
      expect(localIds[53]).not.toBeUndefined()

    it 'finds localIds for library ExpressionRefs while finding localIds in statements', ->
      measure = new Thorax.Models.Measure getJSONFixture('fhir_measures/CMS104/CMS104.json'), parse: true

      # Find the localid for the specific statement with the global expression ref.
      libraryName = 'DischargedonAntithromboticTherapy'
      statementName = 'Initial Population'
      localIds = CQLMeasureHelpers.findAllLocalIdsInStatementByName(measure.get('cqmMeasure'), libraryName, statementName)

      # For the fixture loaded for this test it is known that the local id reference is 49 and the ExpressionRef is 50.
      expect(localIds[49]).not.toBeUndefined()
      expect(localIds[49]).toEqual({localId: '49', sourceLocalId: '50'})


    it 'handles library ExpressionRefs with libraryRef embedded in the clause', ->
      # This measure has both the TJC_Overall and MAT global libraries
      measure = new Thorax.Models.Measure getJSONFixture('fhir_measures/CMS104/CMS104.json'), parse: true

      # Find the localid for the specific statement with the global function ref.
      libraryName = 'TJCOverall_FHIR4'
      statementName = 'Comfort Measures during Hospitalization'
      localIds = CQLMeasureHelpers.findAllLocalIdsInStatementByName(measure.get('cqmMeasure'), libraryName, statementName)

      # 138 refers to the localId for the ExpressionRef that has a libraryRef included in it
      # "name": "Ischemic Stroke Encounter",
      # "libraryName": "TJCOverall_FHIR4",
      expect(localIds[138]).not.toBeUndefined()
      expect(localIds[138]).toEqual({localId: '138'})

# TODO: Implement these tests once we have more measures available
#  describe '_findLocalIdForLibraryRef for functionRefs', ->
#    beforeAll ->
#      # use a chunk of this fixture for these tests.
#      measure = getJSONFixture('cqm_measure_data/CMS146v6/CMS146v6.json')
#      # the annotation for the 'Initial Population' will be used for these tests
#      # it is known the functionRef 'Global.CalendarAgeInYearsAt' is at '71' and the libraryRef clause is at '66'
#      @annotationSnippet = measure.cql_libraries[0].elm.library.statements.def[8].annotation
#
#    it 'returns correct localId for functionRef if when found', ->
#      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '71', 'Global')
#      expect(ret).toEqual('66')
#
#    it 'returns null if it does not find the localId for the functionRef', ->
#      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '23', 'Global')
#      expect(ret).toBeNull()
#
#    it 'returns null if it does not find the proper libraryName for the functionRef', ->
#      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '71', 'notGlobal')
#      expect(ret).toBeNull()
#
#    it 'returns null if annotation is empty', ->
#      ret = CQLMeasureHelpers._findLocalIdForLibraryRef({}, '71', 'notGlobal')
#      expect(ret).toBeNull()
#
#    it 'returns null if there is no value associated with annotation', ->
#      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '87', 'notGlobal')
#      expect(ret).toBeNull()
#
#  describe '_findLocalIdForLibraryRef for expressionRefs', ->
#    beforeAll ->
#      # use a chunk of this fixture for these tests.
#      measure = getJSONFixture('cqm_measure_data/CMS146v6/CMS146v6.json')
#      # the annotation for the 'In Hospice' will be used for these tests
#      # it is known the expressionRef 'Hospice."Has Hospice"' is '136' and the libraryRef
#      # clause is at '135'
#      @annotationSnippet = measure.cql_libraries[0].elm.library.statements.def[12].annotation
#
#    it 'returns correct localId for expressionRef when found', ->
#      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '136', 'Hospice')
#      expect(ret).toEqual('135')
#
#    it 'returns null if it does not find the localId for the expressionRef', ->
#      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '21', 'Hospice')
#      expect(ret).toBeNull()
#
#    it 'returns null if it does not find the proper libraryName for the expressionRef', ->
#      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '136', 'notHospice')
#      expect(ret).toBeNull()
#
#  describe '_findLocalIdForLibraryRef for expressionRefs with libraryRef in clause', ->
#    beforeAll ->
#      # use a chunk of this fixture for these tests.
#      measure = getJSONFixture('cqm_measure_data/deprecated_measures/CMS13/CMS13v2.json')
#      # the annotation for the 'Comfort Measures during Hospitalization' will be used for these tests
#      # it is known the expressionRef 'TJC."Encounter with Principal Diagnosis of Ischemic Stroke"' is '42' and the
#      # libraryRef is embedded in the clause without a localId of its own.
#      @annotationSnippet = measure.cql_libraries[0].elm.library.statements.def[8].annotation
#
#    it 'returns null for expressionRef when found yet it is embedded', ->
#      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '42', 'TJC')
#      expect(ret).toBeNull()
#
#    it 'returns null if it does not find the proper libraryName for the expressionRef', ->
#      ret = CQLMeasureHelpers._findLocalIdForLibraryRef(@annotationSnippet, '42', 'notTJC')
#      expect(ret).toBeNull()
