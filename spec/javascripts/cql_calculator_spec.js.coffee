describe 'cqlCalculator', ->
  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @cql_calculator = new CQMCalculator()
    @universalValueSetsByMeasureId = bonnie.valueSetsByMeasureId

  afterEach ->
    bonnie.valueSetsByMeasureId = @universalValueSetsByMeasureId

  describe 'valueSetsForCodeService', ->
    xit 'returns bonnie.valueSetsByMeasureIdCached if it exists', ->
      bonnie.valueSetsByMeasureIdCached = {'foo': []}
      expect(@cql_calculator.valueSetsForCodeService(bonnie.valueSetsByMeasureId, 'foo')).toEqual([])
      bonnie.valueSetsByMeasureIdCached = undefined

    xit 'returns an empty hash if given empty hash', ->
      expect(bonnie.valueSetsByMeasureIdCached).not.toBeDefined()
      bonnie.valueSetsByMeasureId = {}
      emptyRefactoredValueSets = @cql_calculator.valueSetsForCodeService(bonnie.valueSetsByMeasureId, '')
      expect(Object.keys(emptyRefactoredValueSets).length).toEqual(0)
      expect(bonnie.valueSetsByMeasureIdCached).toEqual({'':{}})
      bonnie.valueSetsByMeasureIdCached = undefined

    xit 'properly caches refactored bonnie.valueSetsByMeasureId', ->
      bonnie.valueSetsByMeasureId = getJSONFixture('cqm_measure_data/core_measures/CMS160/value_sets.json')
      measure = getJSONFixture('cqm_measure_data/core_measures/CMS160/CMS160v6.json')
      expect(bonnie.valueSetsByMeasureIdCached).not.toBeDefined()
      oldRefactoredValueSets = @cql_calculator.valueSetsForCodeService(measure.value_set_oid_version_objects, measure.hqmf_set_id)
      expect(oldRefactoredValueSets).toExist()
      expect(bonnie.valueSetsByMeasureIdCached).toExist()
      bonnie.valueSetsByMeasureId = {} # If cache isn't used, next line will be {} as shown in previous test
      newRefactoredValueSets = @cql_calculator.valueSetsForCodeService(measure.value_set_oid_version_objects, measure.hqmf_set_id)
      expect(newRefactoredValueSets).toExist()
      expect(newRefactoredValueSets).not.toEqual({})
      expect(oldRefactoredValueSets).toEqual(bonnie.valueSetsByMeasureIdCached[measure.hqmf_set_id])
      expect(oldRefactoredValueSets).toEqual(newRefactoredValueSets)
      expect(bonnie.valueSetsByMeasureIdCached[measure.hqmf_set_id]['2.16.840.1.113883.3.67.1.101.1.246']['Draft-A4B9763C-847E-4E02-BB7E-ACC596E90E2C'].length).toEqual(64)
      bonnie.valueSetsByMeasureIdCached = undefined

  describe 'setValueSetVersionsToUndefined', ->
    xit 'returns valueSets with versions set to undefined', ->
      measure = getJSONFixture('cqm_measure_data/special_measures/CMS720/CMS720v0.json')
      expect(measure['elm'][0]['library']['valueSets']).toExist()
      # Add a version to a valueSet
      measure['elm'][0]['library']['valueSets']['def'][0]['version'] = '1.2.3'
      expect(measure['elm'][0]['library']['valueSets']['def'][0]['version']).toEqual('1.2.3')
      elm = @cql_calculator.setValueSetVersionsToUndefined(measure['elm'])
      expect(elm[0]['library']['valueSets']['def'][0]['version']).not.toBeDefined()

    xit 'returns the elm without error if there are no valueSets', ->
      measure = getJSONFixture('cqm_measure_data/special_measures/CMS720/CMS720v0.json')
      expect(measure['elm'][0]['library']['valueSets']).toExist()
      # Remove valueSets
      measure['elm'][0]['library']['valueSets'] = undefined
      elm = @cql_calculator.setValueSetVersionsToUndefined(measure['elm'])
      expect(elm).toExist()

  describe '_buildPopulationRelevanceMap', ->
    xit 'marks NUMER, NUMEX, DENEXCEP not calculated if DENEX count matches DENOM', ->
      population_results = { IPP: 2, DENOM: 2, DENEX: 2, DENEXCEP: 0, NUMER: 0, NUMEX: 0 }
      expected_relevance_map = { IPP: true, DENOM: true, DENEX: true, DENEXCEP: false, NUMER: false, NUMEX: false }
      relevance_map = @cql_calculator._buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

    xit 'marks NUMER, NUMEX, DENEXCEP not calculated if DENEX count exceeds DENOM', ->
      population_results = { IPP: 3, DENOM: 2, DENEX: 3, DENEXCEP: 0, NUMER: 0, NUMEX: 0 }
      expected_relevance_map = { IPP: true, DENOM: true, DENEX: true, DENEXCEP: false, NUMER: false, NUMEX: false }
      relevance_map = @cql_calculator._buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

    xit 'marks NUMER, NUMEX calculated if DENEX count does not exceed DENOM', ->
      population_results = { IPP: 3, DENOM: 3, DENEX: 1, DENEXCEP: 0, NUMER: 2, NUMEX: 0 }
      expected_relevance_map = { IPP: true, DENOM: true, DENEX: true, DENEXCEP: false, NUMER: true, NUMEX: true }
      relevance_map = @cql_calculator._buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

    xit 'marks OBSERV calculated if MSRPOPLEX is less than MSRPOPL', ->
      population_results = {IPP: 3, MSRPOPL: 2, MSRPOPLEX: 1, values: [12]}
      expected_relevance_map = { IPP: true, MSRPOPL: true, MSRPOPLEX: true, values: true }
      relevance_map = @cql_calculator._buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

    xit 'marks OBSERV not calculated if MSRPOPLEX is same as MSRPOPL', ->
      population_results = {IPP: 3, MSRPOPL: 2, MSRPOPLEX: 2, values: [12]}
      expected_relevance_map = { IPP: true, MSRPOPL: true, MSRPOPLEX: true, values: false }
      relevance_map = @cql_calculator._buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

    xit 'marks OBSERV not calculated if MSRPOPLEX is greater than MSRPOPL', ->
      population_results = {IPP: 3, MSRPOPL: 2, MSRPOPLEX: 3, values: [12]}
      expected_relevance_map = { IPP: true, MSRPOPL: true, MSRPOPLEX: true, values: false }
      relevance_map = @cql_calculator._buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

    xit 'marks MSRPOPLEX not calculated if MSRPOPL is zero', ->
      population_results = {IPP: 3, MSRPOPL: 0, MSRPOPLEX: 0, values: []}
      expected_relevance_map = { IPP: true, MSRPOPL: true, MSRPOPLEX: false, values: false }
      relevance_map = @cql_calculator._buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

      initial_results = {IPP: 1, MSRPOPL: 0, MSRPOPLEX: 1}
      expected_results = {IPP: true, MSRPOPL: true, MSRPOPLEX: false}
      relevance_map = bonnie.cql_calculator._buildPopulationRelevanceMap(initial_results)
      expect(relevance_map).toEqual expected_results

    xit 'marks MSRPOPLEX calculated if MSRPOPL is 1', ->
      initial_results = {IPP: 1, MSRPOPL: 1, MSRPOPLEX: 1}
      expected_results = {IPP: true, MSRPOPL: true, MSRPOPLEX: true}
      relevance_map = bonnie.cql_calculator._buildPopulationRelevanceMap(initial_results)
      expect(relevance_map).toEqual expected_results

      initial_results = {IPP: 1, MSRPOPL: 1, MSRPOPLEX: 0}
      expected_results = {IPP: true, MSRPOPL: true, MSRPOPLEX: true}
      population_relevance_map = bonnie.cql_calculator._buildPopulationRelevanceMap(initial_results)
      expect(relevance_map).toEqual expected_results

  describe '_populationRelevanceForAllEpisodes', ->
    xit 'correctly builds population_relevance for multiple episodes in all populations', ->
      episode_results = {
        episode1: {IPP: 1, DENOM: 1, DENEX: 0, DENEXCEP: 1, NUMER: 0, NUMEX: 0},
        episode2: {IPP: 1, DENOM: 1, DENEX: 0, DENEXCEP: 0, NUMER: 1, NUMEX: 1},
        episode3: {IPP: 1, DENOM: 1, DENEX: 1, DENEXCEP: 0, NUMER: 0, NUMEX: 0}
      }
      expected_relevance_map = { IPP: true, DENOM: true, DENEX: true, DENEXCEP: true, NUMER: true, NUMEX: true }
      relevance_map = @cql_calculator._populationRelevanceForAllEpisodes(episode_results)
      expect(relevance_map).toEqual expected_relevance_map

    xit 'correctly builds population_relevance for multiple episodes in no populations', ->
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
          # TODO(cqm-measure): Need to update or replace CQL/CMS107
          valueSet1= getJSONFixture('cqm_measure_data/CQL/CMS107/value_sets.json')
          measure1 = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/CQL/CMS107/CMS107v6.json'), parse: true
          measure1.set('cqmValueSets', valueSet1)
          patients1 = new Thorax.Collections.Patients getJSONFixture('records/CQL/CMS107/patients.json'), parse: true
          patient1 = patients1.findWhere(last: 'DENEXPass', first: 'CMOduringED')
          result1 = @cql_calculator.calculate(measure1.get('populations').first(), patient1, {doPretty: true})
          expect(result1.get('statement_results').TJC_Overall['Encounter with Principal Diagnosis and Age'].pretty).toEqual('[Encounter, Performed: Non-Elective Inpatient Encounter\nSTART: 10/10/2012 9:30 AM\nSTOP: 10/12/2012 12:15 AM\nCODE: SNOMED-CT 32485007]')
          expect(result1.get('statement_results').StrokeEducation.Numerator.pretty).toEqual('UNHIT')

        it 'for CMS760 correctly', ->
          valueSet3 = getJSONFixture('cqm_measure_data/special_measures/CMS760/value_sets.json')
          measure2 = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/special_measures/CMS760/CMS760v0.json'), parse: true
          measure2.set('cqmValueSets', valueSet2)
          patients2 = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMS760/patients.json'), parse: true
          patient2 = patients2.models[0]
          result2 = @cql_calculator.calculate(measure2.get('populations').first(), patient2, {doPretty: true})
          expect(result2.get('statement_results').PD0329.IntervalWithTZOffsets.pretty).toEqual('INTERVAL: 08/01/2012 12:00 AM - 12/31/2012 12:00 AM')

        it 'for CMS32 correctly', ->
          # TODO(cqm-measure) Need to update or replace this fixture
          valueSet3 = getJSONFixture('cqm_measure_data/CQL/CMS32/value_sets.json')
          measure3 = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/CQL/CMS32/CMS721v0.json'), parse: true
          measure3.set('cqmValueSets', valueSet3)
          patients3 = new Thorax.Collections.Patients getJSONFixture('records/CQL/CMS32/patients.json'), parse: true
          patient3 = patients3.models[0]
          result3 = @cql_calculator.calculate(measure3.get('populations').first(), patient3, {doPretty: true})
          expect(result3.get('statement_results').Test32['Measure Observation'].pretty).toEqual('FUNCTION')
          expect(result3.get('statement_results').Test32['ED Visit'].pretty).toEqual('[Encounter, Performed: Emergency department patient visit (procedure)\nSTART: 11/22/2012 8:00 AM\nSTOP: 11/22/2012 8:15 AM\nCODE: SNOMED-CT 4525004]')
          expect(result3.get('statement_results').Test32['Measure Population Exclusions'].pretty).toEqual('FALSE ([])')

        it 'for CMS347 correctly', ->
          # TODO(cqm-measure) Need to update or replace this fixture
          measure4 = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/CQL/CMS347/CMS735v0.json'), parse: true
          patients4 = new Thorax.Collections.Patients getJSONFixture('records/CQL/CMS347/patients.json'), parse: true
          valueSet4 = getJSONFixture('cqm_measure_data/CQL/CMS347/value_sets.json')
          measure4.set('cqmValueSets', valueSet4)
          patient4 = patients4.models[0]
          result4 = @cql_calculator.calculate(measure4.get('populations').first(), patient4, {doPretty: true})
          expect(result4.get('statement_results').StatinTherapy['In Demographic'].pretty).toEqual('true')

        it 'for CMS460 correctly', ->
          measure5 = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/special_measures/CMS460/CMS460v0.json'), parse: true
          patients5 = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMS460/patients.json'), parse: true
          valueSet5 = getJSONFixture('cqm_measure_data/special_measures/CMS460/value_sets.json')
          measure5.set('cqmValueSets', valueSet5)
          patient5 = patients5.models[0]
          result5 = @cql_calculator.calculate(measure5.get('populations').first(), patient5, {doPretty: true})
          expect(result5.get('statement_results').DayMonthTimings['Months Containing 29 Days'].pretty).toEqual('[1,\n2,\n3,\n4,\n5,\n6,\n7,\n8,\n9,\n10,\n11,\n12,\n13,\n14,\n15,\n16,\n17,\n18,\n19,\n20,\n21,\n22,\n23,\n24,\n25,\n26,\n27,\n28,\n29]')
          expect(result5.get('statement_results').PotentialOpioidOveruse['Prescription Days'].pretty).toContain('05/09/2012 12:00 AM')
          expect(result5.get('statement_results').PotentialOpioidOveruse['Prescription Days'].pretty).toContain('rxNormCode: CODE: RxNorm 1053647')
          expect(result5.get('statement_results').PotentialOpioidOveruse['Prescriptions with MME'].pretty).toContain('conversionFactor: 0.13')
          expect(result5.get('statement_results').PotentialOpioidOveruse['Prescriptions with MME'].pretty).toContain('effectivePeriod: INTERVAL: 05/09/2012 8:00 AM - 12/28/2012 8:15 AM')
          expect(result5.get('statement_results').PotentialOpioidOveruse['Prescriptions with MME'].pretty).toContain('MME: QUANTITY: 0.13 mg/d')
          expect(result5.get('statement_results').OpioidData.DrugIngredients.pretty).toContain('drugName: "72 HR Fentanyl 0.075 MG/HR Transdermal System"')

         it 'for CMS872 correctly', ->
          bonnie.valueSetsByMeasureId = getJSONFixture('cqm_measure_data/special_measures/CMS872v0/value_sets.json')
          measure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/special_measures/CMS872v0/CMS872v0.json'), parse: true
          patients = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMS872v0/patients.json'), parse: true
          ratioUnitConversionCorrect = patients.models[0]
          ratioCorrect = patients.models[1]
          ratioIncorrect = patients.models[2]
          ratioUnitConversionCorrectResult = @cql_calculator.calculate(measure.get('populations').first(), ratioUnitConversionCorrect, {doPretty: true})
          ratioCorrectResult = @cql_calculator.calculate(measure.get('populations').first(), ratioCorrect, {doPretty: true})
          ratioIncorrect = @cql_calculator.calculate(measure.get('populations').first(), ratioIncorrect, {doPretty: true})
          expect(ratioUnitConversionCorrectResult.get('statement_results').BonnieTestRatio['Rubella Indicator 1'].final).toEqual('TRUE')
          expect(ratioCorrectResult.get('statement_results').BonnieTestRatio['Rubella Indicator 1'].final).toEqual('TRUE')
          expect(ratioIncorrect.get('statement_results').BonnieTestRatio['Rubella Indicator 1'].final).toEqual('FALSE')

      describe 'no pretty statement results when not requested', ->
        it 'for CMS107 correctly', ->
          # TODO(cqm-measure) Need to update or replace this fixture
          bonnie.valueSetsByMeasureId = getJSONFixture('cqm_measure_data/CQL/CMS107/value_sets.json')
          measure1 = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/CQL/CMS107/CMS107v6.json'), parse: true
          patients1 = new Thorax.Collections.Patients getJSONFixture('records/CQL/CMS107/patients.json'), parse: true
          patient1 = patients1.findWhere(last: 'DENEXPass', first: 'CMOduringED')
          result1 = @cql_calculator.calculate(measure1.get('populations').first(), patient1)
          expect(result1.get('statement_results').TJC_Overall['Encounter with Principal Diagnosis and Age'].pretty).toEqual(undefined)
          expect(result1.get('statement_results').StrokeEducation.Numerator.pretty).toEqual(undefined)

    describe 'episode of care based relevance map', ->
      beforeEach ->
        @valueSets = getJSONFixture('cqm_measure_data/core_measures/CMS177/value_sets.json')
        @measure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/core_measures/CMS177/CMS177v6.json'), parse: true
        @measure.set('cqmValueSets', @valueSets)
        @patients = new Thorax.Collections.Patients getJSONFixture('records/core_measures/CMS177/patients.json'), parse: true

      it 'is correct for patient with no episodes', ->
        # this patient has no episodes in the IPP
        patient = @patients.findWhere(last: 'IPP', first: 'Fail')
        result = @cql_calculator.calculate(@measure.get('populations').first(), patient)

        # no results will be in the episode_results
        expect(result.get('episode_results')).toEqual({})
        # the IPP should be the only relevant population
        expect(result.get('population_relevance')).toEqual({ IPP: true, DENOM: false, NUMER: false })

      it 'is correct for patient with episodes', ->
        # this patient has an episode that is in the IPP, DENOM and DENEX
        patient = @patients.findWhere(last: 'Numer', first: 'Pass')
        result = @cql_calculator.calculate(@measure.get('populations').first(), patient)

        # there will be a single result in the episode_results
        expect(result.get('episode_results')).toEqual({'5aeb7763b848463d625b33d2': { IPP: 1, DENOM: 1, NUMER: 1}})
        # NUMER should be the only not relevant population
        expect(result.get('population_relevance')).toEqual({ IPP: true, DENOM: true, NUMER: true })

    describe 'patient based relevance map', ->
      beforeEach ->
        @valueSets = getJSONFixture('cqm_measure_data/core_measures/CMS158/value_sets.json')
        @measure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/core_measures/CMS158/CMS158v6.json'), parse: true
        @measure.set('cqmValueSets', @valueSets)
        @patients = new Thorax.Collections.Patients getJSONFixture('records/core_measures/CMS158/patients.json'), parse: true

      it 'is correct', ->
        # this patient fails the IPP
        patient = @patients.findWhere(last: 'IPP', first: 'Fail')
        result = @cql_calculator.calculate(@measure.get('populations').first(), patient)
        # there will not be episode_results on the result object
        expect(result.has('episode_results')).toEqual(false)
        # the IPP should be the only relevant population
        expect(result.get('population_relevance')).toEqual({ IPP: true, DENOM: false, NUMER: false, DENEXCEP: false})

    describe 'execution engine using passed in timezone offset', ->
      beforeEach ->
        @valueSets = getJSONFixture('cqm_measure_data/special_measures/CMS760/value_sets.json')
        @measure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/special_measures/CMS760/CMS760v0.json'), parse: true
        @measure.set('cqmValueSets', @valueSets)
        @patients = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMS760/patients.json'), parse: true

      it 'is correct', ->
        # This patient fails the IPP (correctly)
        patient = @patients.findWhere(last: 'Timezone', first: 'Correct')
        result = @cql_calculator.calculate(@measure.get('populations').first(), patient)

        # The IPP should fail
        expect(result.get('IPP')).toEqual(0)
