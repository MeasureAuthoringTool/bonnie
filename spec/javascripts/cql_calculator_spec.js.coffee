describe 'cqlCalculator', ->
  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @cql_calculator = new CQLCalculator()
    @universalValueSetsByOid = bonnie.valueSetsByOid

  afterEach ->
    bonnie.valueSetsByOid = @universalValueSetsByOid

  it 'valueSetsForCodeService properly caches refactored bonnie.valueSetsByOid', ->
    bonnie.valueSetsByOid = getJSONFixture('/measure_data/cqltest/value_sets.json')
    expect(bonnie.valueSetsByOidCached).not.toBeDefined()
    oldRefactoredValueSets = @cql_calculator.valueSetsForCodeService()
    expect(oldRefactoredValueSets).toExist()
    expect(bonnie.valueSetsByOidCached).toExist()
    newRefactoredValueSets = @cql_calculator.valueSetsForCodeService()
    expect(newRefactoredValueSets).toExist()
    expect(oldRefactoredValueSets).toEqual(newRefactoredValueSets)
    expect(bonnie.valueSetsByOidCached).toEqual(newRefactoredValueSets)
