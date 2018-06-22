describe 'cqlCalculator', ->
  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @cql_calculator = new CQLCalculator()
    @universalValueSetsByOid = bonnie.valueSetsByOid

  afterEach ->
    bonnie.valueSetsByOid = @universalValueSetsByOid

  describe 'valueSetsForCodeService', ->
    it 'returns bonnie.valueSetsByOidCached if it exists', ->
      bonnie.valueSetsByOidCached = {'foo': []}
      expect(@cql_calculator.valueSetsForCodeService(bonnie.valueSetsByOid, 'foo')).toEqual([])
      bonnie.valueSetsByOidCached = undefined

    it 'returns an empty hash if given empty hash', ->
      expect(bonnie.valueSetsByOidCached).not.toBeDefined()
      bonnie.valueSetsByOid = {}
      emptyRefactoredValueSets = @cql_calculator.valueSetsForCodeService(bonnie.valueSetsByOid, '')
      expect(Object.keys(emptyRefactoredValueSets).length).toEqual(0)
      expect(bonnie.valueSetsByOidCached).toEqual({'':{}})
      bonnie.valueSetsByOidCached = undefined

    it 'properly caches refactored bonnie.valueSetsByOid', ->
      bonnie.valueSetsByOid = getJSONFixture('/measure_data/cqltest/value_sets.json')
      measure = getJSONFixture('/measure_data/cqltest/CMS720v0.json')
      expect(bonnie.valueSetsByOidCached).not.toBeDefined()
      oldRefactoredValueSets = @cql_calculator.valueSetsForCodeService(measure.value_set_oid_version_objects, measure.hqmf_set_id)
      expect(oldRefactoredValueSets).toExist()
      expect(bonnie.valueSetsByOidCached).toExist()
      bonnie.valueSetsByOid = {} # If cache isn't used, next line will be {} as shown in previous test
      newRefactoredValueSets = @cql_calculator.valueSetsForCodeService(measure.value_set_oid_version_objects, measure.hqmf_set_id)
      expect(newRefactoredValueSets).toExist()
      expect(newRefactoredValueSets).not.toEqual({})
      expect(oldRefactoredValueSets).toEqual(bonnie.valueSetsByOidCached[measure.hqmf_set_id])
      expect(oldRefactoredValueSets).toEqual(newRefactoredValueSets)
      expect(bonnie.valueSetsByOidCached[measure.hqmf_set_id]['2.16.840.1.113762.1.4.1']['N/A'].length).toEqual(2)
      bonnie.valueSetsByOidCached = undefined

  describe 'setValueSetVersionsToUndefined', ->
    it 'returns valueSets with versions set to undefined', ->
      measure = getJSONFixture('/measure_data/cqltest/CMS720v0.json')
      expect(measure['elm'][0]['library']['valueSets']).toExist()
      # Add a version to a valueSet
      measure['elm'][0]['library']['valueSets']['def'][0]['version'] = '1.2.3'
      expect(measure['elm'][0]['library']['valueSets']['def'][0]['version']).toEqual('1.2.3')
      elm = @cql_calculator.setValueSetVersionsToUndefined(measure['elm'])
      expect(elm[0]['library']['valueSets']['def'][0]['version']).not.toBeDefined()

    it 'returns the elm without error if there are no valueSets', ->
      measure = getJSONFixture('/measure_data/cqltest/CMS720v0.json')
      expect(measure['elm'][0]['library']['valueSets']).toExist()
      # Remove valueSets
      measure['elm'][0]['library']['valueSets'] = undefined
      elm = @cql_calculator.setValueSetVersionsToUndefined(measure['elm'])
      expect(elm).toExist()

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

  describe '_populationRelevanceForAllEpisodes', ->
    it 'correctly builds population_relevance for multiple episodes in all populations', ->
      episode_results = {
        episode1: {IPP: 1, DENOM: 1, DENEX: 0, DENEXCEP: 1, NUMER: 0, NUMEX: 0},
        episode2: {IPP: 1, DENOM: 1, DENEX: 0, DENEXCEP: 0, NUMER: 1, NUMEX: 1},
        episode3: {IPP: 1, DENOM: 1, DENEX: 1, DENEXCEP: 0, NUMER: 0, NUMEX: 0}
      }
      expected_relevance_map = { IPP: true, DENOM: true, DENEX: true, DENEXCEP: true, NUMER: true, NUMEX: true }
      relevance_map = @cql_calculator._populationRelevanceForAllEpisodes(episode_results)
      expect(relevance_map).toEqual expected_relevance_map

    it 'correctly builds population_relevance for multiple episodes in no populations', ->
      episode_results = {
        episode1: {IPP: 0, DENOM: 0, DENEX: 0, DENEXCEP: 0, NUMER: 0, NUMEX: 0},
        episode2: {IPP: 0, DENOM: 0, DENEX: 0, DENEXCEP: 0, NUMER: 0, NUMEX: 0},
        episode3: {IPP: 0, DENOM: 0, DENEX: 0, DENEXCEP: 0, NUMER: 0, NUMEX: 0}
      }
      # IPP will be relevant because nothing has rendered it irrelevant
      expected_relevance_map = { IPP: true, DENOM: false, DENEX: false, DENEXCEP: false, NUMER: false, NUMEX: false }
      relevance_map = @cql_calculator._populationRelevanceForAllEpisodes(episode_results)
      expect(relevance_map).toEqual expected_relevance_map

  describe 'calculate', ->

      describe 'pretty statement results when requested', ->
        it 'for CMS107 correctly', ->
          bonnie.valueSetsByOid = getJSONFixture('/measure_data/CQL/CMS107/value_sets.json')
          measure1 = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS107/CMS107v6.json'), parse: true
          patients1 = new Thorax.Collections.Patients getJSONFixture('records/CQL/CMS107/patients.json'), parse: true
          patient1 = patients1.findWhere(last: 'DENEXPass', first: 'CMOduringED')
          result1 = @cql_calculator.calculate(measure1.get('populations').first(), patient1, {doPretty: true})
          expect(result1.get('statement_results').TJC_Overall['Encounter with Principal Diagnosis and Age'].pretty).toEqual('[Encounter, Performed: Non-Elective Inpatient Encounter\nSTART: 10/10/2012 9:30 AM\nSTOP: 10/12/2012 12:15 AM\nCODE: SNOMED-CT 32485007]')
          expect(result1.get('statement_results').StrokeEducation.Numerator.pretty).toEqual('UNHIT')

        it 'for CMS760 correctly', ->
          bonnie.valueSetsByOid = getJSONFixture('/measure_data/special_measures/CMS760/value_sets.json')
          measure2 = new Thorax.Models.Measure getJSONFixture('measure_data/special_measures/CMS760/CMS760v0.json'), parse: true
          patients2 = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMS760/patients.json'), parse: true
          patient2 = patients2.models[0]
          result2 = @cql_calculator.calculate(measure2.get('populations').first(), patient2, {doPretty: true})
          expect(result2.get('statement_results').PD0329.IntervalWithTZOffsets.pretty).toEqual('Interval: 08/01/2012 12:00 AM - 12/31/2012 12:00 AM')

        it 'for CMS32 correctly', ->
          bonnie.valueSetsByOid = getJSONFixture('/measure_data/CQL/CMS32/value_sets.json')
          measure3 = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS32/CMS721v0.json'), parse: true
          patients3 = new Thorax.Collections.Patients getJSONFixture('records/CQL/CMS32/patients.json'), parse: true
          bonnie.valueSetsByOid = getJSONFixture('/measure_data/CQL/CMS32/value_sets.json')
          patient3 = patients3.models[0]
          result3 = @cql_calculator.calculate(measure3.get('populations').first(), patient3, {doPretty: true})
          expect(result3.get('statement_results').Test32['Measure Observation'].pretty).toEqual('FALSE (undefined)')
          expect(result3.get('statement_results').Test32['ED Visit'].pretty).toEqual('[Encounter, Performed: Emergency department patient visit (procedure)\nSTART: 11/22/2012 8:00 AM\nSTOP: 11/22/2012 8:15 AM\nCODE: SNOMED-CT 4525004]')
          expect(result3.get('statement_results').Test32['Measure Population Exclusions'].pretty).toEqual('FALSE ([])')

        it 'for CMS347 correctly', ->
          bonnie.valueSetsByOid = getJSONFixture('/measure_data/CQL/CMS347/value_sets.json')
          measure4 = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS347/CMS735v0.json'), parse: true
          patients4 = new Thorax.Collections.Patients getJSONFixture('records/CQL/CMS347/patients.json'), parse: true
          bonnie.valueSetsByOid = getJSONFixture('/measure_data/CQL/CMS347/value_sets.json')
          patient4 = patients4.models[0]
          result4 = @cql_calculator.calculate(measure4.get('populations').first(), patient4, {doPretty: true})
          expect(result4.get('statement_results').StatinTherapy['In Demographic'].pretty).toEqual('true')

         it 'for CMS460 correctly', ->
          bonnie.valueSetsByOid = getJSONFixture('/measure_data/special_measures/CMS460/value_sets.json')
          measure5 = new Thorax.Models.Measure getJSONFixture('measure_data/special_measures/CMS460/CMS460v0.json'), parse: true
          patients5 = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMS460/patients.json'), parse: true
          bonnie.valueSetsByOid = getJSONFixture('/measure_data/special_measures/CMS460/value_sets.json')
          patient5 = patients5.models[0]
          result5 = @cql_calculator.calculate(measure5.get('populations').first(), patient5, {doPretty: true})
          expect(result5.get('statement_results').DayMonthTimings['Months Containing 29 Days'].pretty).toEqual('[1,\n2,\n3,\n4,\n5,\n6,\n7,\n8,\n9,\n10,\n11,\n12,\n13,\n14,\n15,\n16,\n17,\n18,\n19,\n20,\n21,\n22,\n23,\n24,\n25,\n26,\n27,\n28,\n29]')
          expect(result5.get('statement_results').PotentialOpioidOveruse['Prescription Days'].pretty).toContain('05/09/2012 12:00 AM')
          expect(result5.get('statement_results').PotentialOpioidOveruse['Prescription Days'].pretty).toContain('"rxNormCode": "Code: RxNorm: 1053647"')
          expect(result5.get('statement_results').PotentialOpioidOveruse['Prescriptions with MME'].pretty).toContain('"conversionFactor": "0.13"')
          expect(result5.get('statement_results').PotentialOpioidOveruse['Prescriptions with MME'].pretty).toContain('"effectivePeriod": "Interval: 05/09/2012 8:00 AM - 12/28/2012 8:15 AM"')
          expect(result5.get('statement_results').PotentialOpioidOveruse['Prescriptions with MME'].pretty).toContain('"MME": "Quantity: mg/d: 0.13"')
          expect(result5.get('statement_results').OpioidData.DrugIngredients.pretty).toContain('"drugName": "72 HR Fentanyl 0.075 MG/HR Transdermal System"')

      describe 'no pretty statement results when not requested', ->
        it 'for CMS107 correctly', ->
          bonnie.valueSetsByOid = getJSONFixture('/measure_data/CQL/CMS107/value_sets.json')
          measure1 = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS107/CMS107v6.json'), parse: true
          patients1 = new Thorax.Collections.Patients getJSONFixture('records/CQL/CMS107/patients.json'), parse: true
          patient1 = patients1.findWhere(last: 'DENEXPass', first: 'CMOduringED')
          result1 = @cql_calculator.calculate(measure1.get('populations').first(), patient1)
          expect(result1.get('statement_results').TJC_Overall['Encounter with Principal Diagnosis and Age'].pretty).toEqual(undefined)
          expect(result1.get('statement_results').StrokeEducation.Numerator.pretty).toEqual(undefined)

    describe 'episode of care based relevance map', ->
      beforeEach ->
        # TODO: Update this set of tests with new fixtures when fixture overhaul is brought in
        bonnie.valueSetsByOid = getJSONFixture('/measure_data/CQL/CMS107/value_sets.json')
        @measure = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS107/CMS107v6.json'), parse: true
        @patients = new Thorax.Collections.Patients getJSONFixture('records/CQL/CMS107/patients.json'), parse: true

      it 'is correct for patient with no episodes', ->
        # this patient has no episodes in the IPP
        patient = @patients.findWhere(last: 'IPPFail', first: 'LOS=121Days')
        result = @cql_calculator.calculate(@measure.get('populations').first(), patient)

        # no results will be in the episode_results
        expect(result.get('episode_results')).toEqual({})
        # the IPP should be the only relevant population
        expect(result.get('population_relevance')).toEqual({ IPP: true, DENOM: false, DENEX: false, NUMER: false })

      it 'is correct for patient with episodes', ->
        # this patient has an episode that is in the IPP, DENOM and DENEX
        patient = @patients.findWhere(last: 'DENEXPass', first: 'CMOduringED')
        result = @cql_calculator.calculate(@measure.get('populations').first(), patient)

        # there will be a single result in the episode_results
        expect(result.get('episode_results')).toEqual({'59cbf4f0942c6d40640067cf': { IPP: 1, DENOM: 1, DENEX: 1, NUMER: 0}})
        # NUMER should be the only not relevant population
        expect(result.get('population_relevance')).toEqual({ IPP: true, DENOM: true, DENEX: true, NUMER: false })

    describe 'patient based relevance map', ->
      beforeEach ->
        # TODO: Update this set of tests with new fixtures when fixutre overhaul is brought in
        bonnie.valueSetsByOid = getJSONFixture('/measure_data/CQL/CMS347/value_sets.json')
        @measure = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS347/CMS735v0.json'), parse: true
        @patients = new Thorax.Collections.Patients getJSONFixture('records/CQL/CMS347/patients.json'), parse: true

      it 'is correct', ->
        # this patient fails the IPP
        patient = @patients.findWhere(last: 'last', first: 'first')
        result = @cql_calculator.calculate(@measure.get('populations').first(), patient)

        # there will not be episode_results on the result object
        expect(result.has('episode_results')).toEqual(false)
        # the IPP should be the only relevant population
        expect(result.get('population_relevance')).toEqual({ IPP: true, DENOM: false, DENEX: false, NUMER: false, DENEXCEP: false})

    describe 'execution engine using passed in timezone offset', ->
      beforeEach ->
        bonnie.valueSetsByOid = getJSONFixture('/measure_data/special_measures/CMS760/value_sets.json')
        @measure = new Thorax.Models.Measure getJSONFixture('measure_data/special_measures/CMS760/CMS760v0.json'), parse: true
        @patients = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMS760/patients.json'), parse: true

      it 'is correct', ->
        # This patient fails the IPP (correctly)
        patient = @patients.findWhere(last: 'Timezone', first: 'Correct')
        result = @cql_calculator.calculate(@measure.get('populations').first(), patient)

        # The IPP should fail
        expect(result.get('IPP')).toEqual(0)