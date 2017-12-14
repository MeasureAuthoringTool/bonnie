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
      bonnie.valueSetsByOidCached = undefined

  describe '_buildPopulationRelevanceMap', ->
    it 'marks NUMER, NUMEX, DENEXCEP not calculated if DENEX count matches DENOM', ->
      population_results = { IPP: 2, DENOM: 2, DENEX: 2, DENEXCEP: 0, NUMER: 0, NUMEX: 0 }
      expected_relevance_map = { IPP: true, DENOM: true, DENEX: true, DENEXCEP: false, NUMER: false, NUMEX: false }
      relevance_map = @cql_calculator._buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

    it 'marks NUMER, NUMEX, DENEXCEP not calculated if DENEX count exceeds DENOM', ->
      population_results = { IPP: 3, DENOM: 2, DENEX: 3, DENEXCEP: 0, NUMER: 0, NUMEX: 0 }
      expected_relevance_map = { IPP: true, DENOM: true, DENEX: true, DENEXCEP: false, NUMER: false, NUMEX: false }
      relevance_map = @cql_calculator._buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

    it 'marks NUMER, NUMEX calculated if DENEX count does not exceed DENOM', ->
      population_results = { IPP: 3, DENOM: 3, DENEX: 1, DENEXCEP: 0, NUMER: 2, NUMEX: 0 }
      expected_relevance_map = { IPP: true, DENOM: true, DENEX: true, DENEXCEP: false, NUMER: true, NUMEX: true }
      relevance_map = @cql_calculator._buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

    it 'marks OBSERV calculated if MSRPOPLEX is less than MSRPOPL', ->
      population_results = {IPP: 3, MSRPOPL: 2, MSRPOPLEX: 1, values: [12]}
      expected_relevance_map = { IPP: true, MSRPOPL: true, MSRPOPLEX: true, values: true }
      relevance_map = @cql_calculator._buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

    it 'marks OBSERV not calculated if MSRPOPLEX is same as MSRPOPL', ->
      population_results = {IPP: 3, MSRPOPL: 2, MSRPOPLEX: 2, values: [12]}
      expected_relevance_map = { IPP: true, MSRPOPL: true, MSRPOPLEX: true, values: false }
      relevance_map = @cql_calculator._buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

    it 'marks OBSERV not calculated if MSRPOPLEX is greater than MSRPOPL', ->
      population_results = {IPP: 3, MSRPOPL: 2, MSRPOPLEX: 3, values: [12]}
      expected_relevance_map = { IPP: true, MSRPOPL: true, MSRPOPLEX: true, values: false }
      relevance_map = @cql_calculator._buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

    it 'marks MSRPOPLEX not calculated if MSRPOPL is zero', ->
      population_results = {IPP: 3, MSRPOPL: 0, MSRPOPLEX: 0, values: []}
      expected_relevance_map = { IPP: true, MSRPOPL: true, MSRPOPLEX: false, values: false }
      relevance_map = @cql_calculator._buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

      initial_results = {IPP: 1, MSRPOPL: 0, MSRPOPLEX: 1}
      expected_results = {IPP: true, MSRPOPL: true, MSRPOPLEX: false}
      relevance_map = bonnie.cql_calculator._buildPopulationRelevanceMap(initial_results)
      expect(relevance_map).toEqual expected_results

    it 'marks MSRPOPLEX calculated if MSRPOPL is 1', ->
      initial_results = {IPP: 1, MSRPOPL: 1, MSRPOPLEX: 1}
      expected_results = {IPP: true, MSRPOPL: true, MSRPOPLEX: true}
      relevance_map = bonnie.cql_calculator._buildPopulationRelevanceMap(initial_results)
      expect(relevance_map).toEqual expected_results

      initial_results = {IPP: 1, MSRPOPL: 1, MSRPOPLEX: 0}
      expected_results = {IPP: true, MSRPOPL: true, MSRPOPLEX: true}
      population_relevance_map = bonnie.cql_calculator._buildPopulationRelevanceMap(initial_results)
      expect(relevance_map).toEqual expected_results
