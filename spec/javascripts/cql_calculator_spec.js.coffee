describe 'cqlCalculator', ->
  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @cql_calculator = new CQLCalculator()
    @universalValueSetsByOid = bonnie.valueSetsByOid

  afterEach ->
    bonnie.valueSetsByOid = @universalValueSetsByOid

  describe 'valueSetsForCodeService', ->
    it 'returns bonnie.valueSetsByOidCached if it exists', ->
      bonnie.valueSetsByOidCached = 'foo'
      expect(@cql_calculator.valueSetsForCodeService()).toEqual('foo')
      bonnie.valueSetsByOidCached = undefined

    it 'returns an empty hash if given empty hash', ->
      expect(bonnie.valueSetsByOidCached).not.toBeDefined()
      bonnie.valueSetsByOid = {}
      emptyRefactoredValueSets = @cql_calculator.valueSetsForCodeService()
      expect(emptyRefactoredValueSets).toEqual({})
      expect(bonnie.valueSetsByOidCached).toEqual({})
      bonnie.valueSetsByOidCached = undefined

    it 'properly caches refactored bonnie.valueSetsByOid', ->
      bonnie.valueSetsByOid = getJSONFixture('/measure_data/cqltest/value_sets.json')
      expect(bonnie.valueSetsByOidCached).not.toBeDefined()
      oldRefactoredValueSets = @cql_calculator.valueSetsForCodeService()
      expect(oldRefactoredValueSets).toExist()
      expect(bonnie.valueSetsByOidCached).toExist()
      bonnie.valueSetsByOid = {} # If cache isn't used, next line will be {} as shown in previous test
      newRefactoredValueSets = @cql_calculator.valueSetsForCodeService()
      expect(newRefactoredValueSets).toExist()
      expect(newRefactoredValueSets).not.toEqual({})
      expect(oldRefactoredValueSets).toEqual(bonnie.valueSetsByOidCached)
      expect(oldRefactoredValueSets).toEqual(newRefactoredValueSets)
      expect(bonnie.valueSetsByOidCached['2.16.840.1.113762.1.4.1']['N/A'].length).toEqual(2)
