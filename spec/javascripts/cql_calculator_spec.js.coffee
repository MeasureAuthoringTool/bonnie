describe 'cqmCalculator', ->
  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @cqm_calculator = new CQMCalculator()

  describe 'setValueSetVersionsToUndefined', ->
    xit 'returns valueSets with versions set to undefined', ->
      measure = getJSONFixture('cqm_measure_data/special_measures/CMS720/CMS720v0.json')
      measure_elm = measure.cql_libraries.map((lib) -> lib.elm)
      expect(measure_elm[0]['library']['valueSets']).toExist()
      # Add a version to a valueSet
      measure_elm[0]['library']['valueSets']['def'][0]['version'] = '1.2.3'
      expect(measure_elm[0]['library']['valueSets']['def'][0]['version']).toEqual('1.2.3')
      elm = cqm.execution.CalculatorHelpers.setValueSetVersionsToUndefined(measure_elm)
      expect(elm[0]['library']['valueSets']['def'][0]['version']).not.toBeDefined()

    xit 'returns the elm without error if there are no valueSets', ->
      measure = getJSONFixture('cqm_measure_data/special_measures/CMS720/CMS720v0.json')
      measure_elm = measure.cql_libraries.map((lib) -> lib.elm)
      expect(measure_elm[0]['library']['valueSets']).toExist()
      # Remove valueSets
      measure_elm[0]['library']['valueSets'] = undefined
      elm = cqm.execution.CalculatorHelpers.setValueSetVersionsToUndefined(measure_elm)
      expect(elm).toExist()

  describe 'buildPopulationRelevanceMap', ->
    it 'marks NUMER, NUMEX, DENEXCEP not calculated if DENEX count matches DENOM', ->
      population_results = { IPP: 2, DENOM: 2, DENEX: 2, DENEXCEP: 0, NUMER: 0, NUMEX: 0 }
      expected_relevance_map = { IPP: true, DENOM: true, DENEX: true, DENEXCEP: false, NUMER: false, NUMEX: false }
      relevance_map = cqm.execution.ResultsHelpers.buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

    it 'marks NUMER, NUMEX, DENEXCEP not calculated if DENEX count exceeds DENOM', ->
      population_results = { IPP: 3, DENOM: 2, DENEX: 3, DENEXCEP: 0, NUMER: 0, NUMEX: 0 }
      expected_relevance_map = { IPP: true, DENOM: true, DENEX: true, DENEXCEP: false, NUMER: false, NUMEX: false }
      relevance_map = cqm.execution.ResultsHelpers.buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

    it 'marks NUMER, NUMEX calculated if DENEX count does not exceed DENOM', ->
      population_results = { IPP: 3, DENOM: 3, DENEX: 1, DENEXCEP: 0, NUMER: 2, NUMEX: 0 }
      expected_relevance_map = { IPP: true, DENOM: true, DENEX: true, DENEXCEP: false, NUMER: true, NUMEX: true }
      relevance_map = cqm.execution.ResultsHelpers.buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

    it 'marks OBSERV calculated if MSRPOPLEX is less than MSRPOPL', ->
      population_results = {IPP: 3, MSRPOPL: 2, MSRPOPLEX: 1, values: [12]}
      expected_relevance_map = { IPP: true, MSRPOPL: true, MSRPOPLEX: true, values: true }
      relevance_map = cqm.execution.ResultsHelpers.buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

    it 'marks OBSERV not calculated if MSRPOPLEX is same as MSRPOPL', ->
      population_results = {IPP: 3, MSRPOPL: 2, MSRPOPLEX: 2, values: [12]}
      expected_relevance_map = { IPP: true, MSRPOPL: true, MSRPOPLEX: true, values: false }
      relevance_map = cqm.execution.ResultsHelpers.buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

    it 'marks OBSERV not calculated if MSRPOPLEX is greater than MSRPOPL', ->
      population_results = {IPP: 3, MSRPOPL: 2, MSRPOPLEX: 3, values: [12]}
      expected_relevance_map = { IPP: true, MSRPOPL: true, MSRPOPLEX: true, values: false }
      relevance_map = cqm.execution.ResultsHelpers.buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

    it 'marks MSRPOPLEX not calculated if MSRPOPL is zero', ->
      population_results = {IPP: 3, MSRPOPL: 0, MSRPOPLEX: 0, values: []}
      expected_relevance_map = { IPP: true, MSRPOPL: true, MSRPOPLEX: false, values: false }
      relevance_map = cqm.execution.ResultsHelpers.buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

      initial_results = {IPP: 1, MSRPOPL: 0, MSRPOPLEX: 1}
      expected_results = {IPP: true, MSRPOPL: true, MSRPOPLEX: false}
      relevance_map = cqm.execution.ResultsHelpers.buildPopulationRelevanceMap(initial_results)
      expect(relevance_map).toEqual expected_results

    it 'marks MSRPOPLEX calculated if MSRPOPL is 1', ->
      initial_results = {IPP: 1, MSRPOPL: 1, MSRPOPLEX: 1}
      expected_results = {IPP: true, MSRPOPL: true, MSRPOPLEX: true}
      relevance_map = cqm.execution.ResultsHelpers.buildPopulationRelevanceMap(initial_results)
      expect(relevance_map).toEqual expected_results

      initial_results = {IPP: 1, MSRPOPL: 1, MSRPOPLEX: 0}
      expected_results = {IPP: true, MSRPOPL: true, MSRPOPLEX: true}
      population_relevance_map = cqm.execution.ResultsHelpers.buildPopulationRelevanceMap(initial_results)
      expect(population_relevance_map).toEqual expected_results

  describe '_populationRelevanceForAllEpisodes', ->
    it 'correctly builds population_relevance for multiple episodes in all populations', ->
      episode_results = {
        episode1: {IPP: 1, DENOM: 1, DENEX: 0, DENEXCEP: 1, NUMER: 0, NUMEX: 0},
        episode2: {IPP: 1, DENOM: 1, DENEX: 0, DENEXCEP: 0, NUMER: 1, NUMEX: 1},
        episode3: {IPP: 1, DENOM: 1, DENEX: 1, DENEXCEP: 0, NUMER: 0, NUMEX: 0}
      }
      expected_relevance_map = { IPP: true, DENOM: true, DENEX: true, DENEXCEP: true, NUMER: true, NUMEX: true }
      relevance_map = cqm.execution.ResultsHelpers.populationRelevanceForAllEpisodes(episode_results)
      expect(relevance_map).toEqual expected_relevance_map

    it 'correctly builds population_relevance for multiple episodes in no populations', ->
      episode_results = {
        episode1: {IPP: 0, DENOM: 0, DENEX: 0, DENEXCEP: 0, NUMER: 0, NUMEX: 0},
        episode2: {IPP: 0, DENOM: 0, DENEX: 0, DENEXCEP: 0, NUMER: 0, NUMEX: 0},
        episode3: {IPP: 0, DENOM: 0, DENEX: 0, DENEXCEP: 0, NUMER: 0, NUMEX: 0}
      }
      # IPP will be relevant because nothing has rendered it irrelevant
      expected_relevance_map = { IPP: true, DENOM: false, DENEX: false, DENEXCEP: false, NUMER: false, NUMEX: false }
      relevance_map = cqm.execution.ResultsHelpers.populationRelevanceForAllEpisodes(episode_results)
      expect(relevance_map).toEqual expected_relevance_map

  describe 'calculate', ->
      describe 'pretty statement results when requested', ->
        xit 'for CMS107 correctly', ->
          # TODO(cqm-measure): Need to update or replace CQL/CMS107
          measure1 = loadMeasureWithValueSets('cqm_measure_data/CQL/CMS107/CMS107v6.json', 'cqm_measure_data/CQL/CMS107/value_sets.json')
          patients1 = new Thorax.Collections.Patients getJSONFixture('records/CQL/CMS107/patients.json'), parse: true
          patient1 = patients1.findWhere(last: 'DENEXPass', first: 'CMOduringED')
          result1 = @cqm_calculator.calculate(measure1.get('populations').first(), patient1, {doPretty: true})
          expect(result1.get('statement_results').TJC_Overall['Encounter with Principal Diagnosis and Age'].pretty).toEqual('[Encounter, Performed: Non-Elective Inpatient Encounter\nSTART: 10/10/2012 9:30 AM\nSTOP: 10/12/2012 12:15 AM\nCODE: SNOMED-CT 32485007]')
          expect(result1.get('statement_results').StrokeEducation.Numerator.pretty).toEqual('UNHIT')

        it 'for CMS760 correctly', ->
          measure2 = loadMeasureWithValueSets 'cqm_measure_data/special_measures/CMS760/CMS760v0.json', 'cqm_measure_data/special_measures/CMS760/value_sets.json'
          patients2 = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMS760/patients.json'), parse: true
          patient2 = patients2.models[0]
          patient2.set('cqmPatient', new cqm.models.QDMPatient getJSONFixture('patients/CMS760v0/Correct_Timezone.json'))
          patient2.id = patient2.get('cqmPatient').id().toString()

          result2 = @cqm_calculator.calculate(measure2.get('populations').first(), patient2, {doPretty: true})
          expect(result2.get('statement_results').PD0329.IntervalWithTZOffsets.pretty).toEqual('INTERVAL: 08/01/2012 12:00 AM - 12/31/2012 12:00 AM')

        it 'for CMS32 correctly', ->
          # TODO: investigate calculation difference. could be due to measure fixture update
          measure3 = loadMeasureWithValueSets 'cqm_measure_data/core_measures/CMS32/CMS32v7.json', 'cqm_measure_data/core_measures/CMS32/value_sets.json'
          patients3 = new Thorax.Collections.Patients getJSONFixture('records/CQL/CMS32/patients.json'), parse: true
          patient3 = patients3.models[0]
          patient3.set('cqmPatient', new cqm.models.QDMPatient getJSONFixture('patients/CMS32v7/Visit_1 ED.json'))
          patient3.id = patient3.get('cqmPatient').id().toString()

          result3 = @cqm_calculator.calculate(measure3.get('populations').first(), patient3, {doPretty: true})
          expect(result3.get('statement_results').MedianTimefromEDArrivaltoEDDepartureforDischargedEDPatients['Measure Observation'].pretty).toEqual('FUNCTION')
          expect(result3.get('statement_results').MedianTimefromEDArrivaltoEDDepartureforDischargedEDPatients['ED Visit'].pretty).toEqual('[Encounter, Performed: Emergency department patient visit (procedure)\nSTART: 11/22/2012 8:00 AM\nSTOP: 11/22/2012 8:15 AM\nCODE: SNOMED-CT 4525004]')
          expect(result3.get('statement_results').MedianTimefromEDArrivaltoEDDepartureforDischargedEDPatients['Measure Population Exclusions'].pretty).toEqual('FALSE ([])')

        it 'for CMS347 correctly', ->
          # TODO(cqm-measure) Need to update or replace this fixture
          measure4 = loadMeasureWithValueSets 'cqm_measure_data/deprecated_measures/CMS347v3/CMS735v0.json', 'cqm_measure_data/deprecated_measures/CMS347/value_sets.json'
          patients4 = new Thorax.Collections.Patients getJSONFixture('records/CQL/CMS347/patients.json'), parse: true
          patient4 = patients4.models[0]
          result4 = @cqm_calculator.calculate(measure4.get('populations').first(), patient4, {doPretty: true})
          expect(result4.get('statement_results').StatinTherapy['In Demographic'].pretty).toEqual('true')

        it 'for CMS460 correctly', ->
          measure5 = loadMeasureWithValueSets 'cqm_measure_data/special_measures/CMS460/CMS460v0.json', 'cqm_measure_data/special_measures/CMS460/value_sets.json'
          patients5 = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMS460/patients.json'), parse: true
          patient5 = patients5.models[0]
          result5 = @cqm_calculator.calculate(measure5.get('populations').first(), patient5, {doPretty: true})
          expect(result5.get('statement_results').DayMonthTimings['Months Containing 29 Days'].pretty).toEqual('[1,\n2,\n3,\n4,\n5,\n6,\n7,\n8,\n9,\n10,\n11,\n12,\n13,\n14,\n15,\n16,\n17,\n18,\n19,\n20,\n21,\n22,\n23,\n24,\n25,\n26,\n27,\n28,\n29]')
          expect(result5.get('statement_results').PotentialOpioidOveruse['Prescription Days'].pretty).toContain('05/09/2012 12:00 AM')
          expect(result5.get('statement_results').PotentialOpioidOveruse['Prescription Days'].pretty).toContain('rxNormCode: CODE: RxNorm 1053647')
          expect(result5.get('statement_results').PotentialOpioidOveruse['Prescriptions with MME'].pretty).toContain('conversionFactor: 0.13')
          expect(result5.get('statement_results').PotentialOpioidOveruse['Prescriptions with MME'].pretty).toContain('effectivePeriod: INTERVAL: 05/09/2012 8:00 AM - 12/28/2012 8:15 AM')
          expect(result5.get('statement_results').PotentialOpioidOveruse['Prescriptions with MME'].pretty).toContain('MME: QUANTITY: 0.13 mg/d')
          expect(result5.get('statement_results').OpioidData.DrugIngredients.pretty).toContain('drugName: "72 HR Fentanyl 0.075 MG/HR Transdermal System"')

         it 'for CMS872 correctly', ->
          measure = loadMeasureWithValueSets 'cqm_measure_data/special_measures/CMS872v0/CMS872v0.json', 'cqm_measure_data/special_measures/CMS872v0/value_sets.json'
          patients = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMS872v0/patients.json'), parse: true
          ratioUnitConversionCorrect = patients.models[0]
          ratioCorrect = patients.models[1]
          ratioIncorrect = patients.models[2]
          ratioUnitConversionCorrectResult = @cqm_calculator.calculate(measure.get('populations').first(), ratioUnitConversionCorrect, {doPretty: true})
          ratioCorrectResult = @cqm_calculator.calculate(measure.get('populations').first(), ratioCorrect, {doPretty: true})
          ratioIncorrect = @cqm_calculator.calculate(measure.get('populations').first(), ratioIncorrect, {doPretty: true})
          expect(ratioUnitConversionCorrectResult.get('statement_results').BonnieTestRatio['Rubella Indicator 1'].final).toEqual('TRUE')
          expect(ratioCorrectResult.get('statement_results').BonnieTestRatio['Rubella Indicator 1'].final).toEqual('TRUE')
          expect(ratioIncorrect.get('statement_results').BonnieTestRatio['Rubella Indicator 1'].final).toEqual('FALSE')

      describe 'no pretty statement results when not requested', ->
        it 'for CMS107 correctly', ->
          # TODO(cqm-measure) Need to update or replace this fixture
          measure1 = loadMeasureWithValueSets 'cqm_measure_data/CQL/CMS107/CMS107v6.json', 'cqm_measure_data/CQL/CMS107/value_sets.json'
          patients1 = new Thorax.Collections.Patients getJSONFixture('records/CQL/CMS107/patients.json'), parse: true
          patient1 = patients1.findWhere(last: 'DENEXPass', first: 'CMOduringED')
          result1 = @cqm_calculator.calculate(measure1.get('populations').first(), patient1)
          expect(result1.get('statement_results').TJC_Overall['Encounter with Principal Diagnosis and Age'].pretty).toEqual(undefined)
          expect(result1.get('statement_results').StrokeEducation.Numerator.pretty).toEqual(undefined)

    describe 'episode of care based relevance map', ->
      beforeEach ->
        @measure = loadMeasureWithValueSets 'cqm_measure_data/core_measures/CMS177/CMS177v6.json', 'cqm_measure_data/core_measures/CMS177/value_sets.json'
        @patients = new Thorax.Collections.Patients getJSONFixture('records/core_measures/CMS177/patients.json'), parse: true

      it 'is correct for patient with no episodes', ->
        # this patient has no episodes in the IPP
        patient = @patients.findWhere(last: 'IPP', first: 'Fail')
        result = @cqm_calculator.calculate(@measure.get('populations').first(), patient)

        # no results will be in the episode_results
        expect(result.get('episode_results')).toEqual({})
        # the IPP should be the only relevant population
        expect(result.get('population_relevance')).toEqual({ IPP: true, DENOM: false, NUMER: false })

      it 'is correct for patient with episodes', ->
        # this patient has an episode that is in the IPP, DENOM and DENEX
        patient = @patients.findWhere(last: 'Numer', first: 'Pass')
        result = @cqm_calculator.calculate(@measure.get('populations').first(), patient)

        # there will be a single result in the episode_results
        expect(result.get('episode_results')).toEqual({'5aeb7763b848463d625b33d2': { IPP: 1, DENOM: 1, NUMER: 1}})
        # NUMER should be the only not relevant population
        expect(result.get('population_relevance')).toEqual({ IPP: true, DENOM: true, NUMER: true })

    describe 'patient based relevance map', ->
      beforeEach ->
        @measure = loadMeasureWithValueSets 'cqm_measure_data/core_measures/CMS158/CMS158v6.json', 'cqm_measure_data/core_measures/CMS158/value_sets.json'
        @patients = new Thorax.Collections.Patients getJSONFixture('records/core_measures/CMS158/patients.json'), parse: true

      it 'is correct', ->
        # this patient fails the IPP
        patient = @patients.findWhere(last: 'IPP', first: 'Fail')
        result = @cqm_calculator.calculate(@measure.get('populations').first(), patient)
        # there will not be episode_results on the result object
        expect(result.has('episode_results')).toEqual(false)
        # the IPP should be the only relevant population
        expect(result.get('population_relevance')).toEqual({ IPP: true, DENOM: false, NUMER: false, DENEXCEP: false})

    describe 'execution engine using passed in timezone offset', ->
      beforeEach ->
        @measure = loadMeasureWithValueSets 'cqm_measure_data/special_measures/CMS760/CMS760v0.json', 'cqm_measure_data/special_measures/CMS760/value_sets.json'
        @patients = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMS760/patients.json'), parse: true

      it 'is correct', ->
        # This patient fails the IPP (correctly)
        patient = @patients.findWhere(last: 'Timezone', first: 'Correct')
        result = @cqm_calculator.calculate(@measure.get('populations').first(), patient)

        # The IPP should fail
        expect(result.get('IPP')).toEqual(0)
