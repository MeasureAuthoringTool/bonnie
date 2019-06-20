describe 'cqmCalculator', ->
  beforeAll ->
    jasmine.getJSONFixtures().clearCache()
    @cqm_calculator = new CQMCalculator()

  describe 'setValueSetVersionsToUndefined', ->
    it 'returns valueSets with versions set to undefined', ->
      measure = getJSONFixture('cqm_measure_data/CMS720v0/CMS720v0.json')
      measure_elm = measure.cql_libraries.map((lib) -> lib.elm)
      expect(measure_elm[0]['library']['valueSets']).toExist()
      # Add a version to a valueSet
      measure_elm[0]['library']['valueSets']['def'][0]['version'] = '1.2.3'
      expect(measure_elm[0]['library']['valueSets']['def'][0]['version']).toEqual('1.2.3')
      elm = cqm.execution.CalculatorHelpers.setValueSetVersionsToUndefined(measure_elm)
      expect(elm[0]['library']['valueSets']['def'][0]['version']).not.toBeDefined()

    it 'returns the elm without error if there are no valueSets', ->
      measure = getJSONFixture('cqm_measure_data/CMS720v0/CMS720v0.json')
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
      population_results = {IPP: 3, MSRPOPL: 2, MSRPOPLEX: 1, observation_values: [12]}
      expected_relevance_map = { IPP: true, MSRPOPL: true, MSRPOPLEX: true, observation_values: true }
      relevance_map = cqm.execution.ResultsHelpers.buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

    it 'marks OBSERV not calculated if MSRPOPLEX is same as MSRPOPL', ->
      population_results = {IPP: 3, MSRPOPL: 2, MSRPOPLEX: 2, observation_values: [12]}
      expected_relevance_map = { IPP: true, MSRPOPL: true, MSRPOPLEX: true, observation_values: false }
      relevance_map = cqm.execution.ResultsHelpers.buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

    it 'marks OBSERV not calculated if MSRPOPLEX is greater than MSRPOPL', ->
      population_results = {IPP: 3, MSRPOPL: 2, MSRPOPLEX: 3, observation_values: [12]}
      expected_relevance_map = { IPP: true, MSRPOPL: true, MSRPOPLEX: true, observation_values: false }
      relevance_map = cqm.execution.ResultsHelpers.buildPopulationRelevanceMap(population_results)
      expect(relevance_map).toEqual expected_relevance_map

    it 'marks MSRPOPLEX not calculated if MSRPOPL is zero', ->
      population_results = {IPP: 3, MSRPOPL: 0, MSRPOPLEX: 0, observation_values: []}
      expected_relevance_map = { IPP: true, MSRPOPL: true, MSRPOPLEX: false, observation_values: false }
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

    describe 'pretty statement results', ->
      # NOTE: the pretty generation test is now covered within the cqm-execution repository itself
      beforeAll ->
        measure = loadMeasureWithValueSets('cqm_measure_data/CMS160v6/CMS160v6.json', 'cqm_measure_data/CMS160v6/value_sets.json')
        patients = new Thorax.Collections.Patients [getJSONFixture('patients/CMS160v6/Expired_DENEX.json')], parse: true
        patient = patients.at(0)
        @prettyResult = @cqm_calculator.calculate(measure.get('populations').first(), patient, {doPretty: true})
        @unprettyResult = @cqm_calculator.calculate(measure.get('populations').first(), patient, {doPretty: false})

      it 'are generated for Encounter Performed correctly when requested', ->
        expect(@prettyResult.get('statement_results').DepressionUtilizationofthePHQ9Tool['Depression Office Visit Encounter 1'].pretty).toEqual('[Encounter, Performed: Office Visit\nSTART: 11/04/2012 8:00 AM\nSTOP: 11/04/2012 8:15 AM\nCODE: CPT 99201]')
        expect(@prettyResult.get('statement_results').DepressionUtilizationofthePHQ9Tool['Numerator 1'].pretty).toEqual('UNHIT')

      it 'are not generated for Encounter Perforemd correctly when not requested', ->
        expect(@unprettyResult.get('statement_results').DepressionUtilizationofthePHQ9Tool['Depression Office Visit Encounter 1'].pretty).toEqual(undefined)
        expect(@unprettyResult.get('statement_results').DepressionUtilizationofthePHQ9Tool['Numerator 1'].pretty).toEqual(undefined)

    describe 'episode of care based relevance map', ->
      beforeAll ->
        @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS177v6/CMS177v6.json', 'cqm_measure_data/CMS177v6/value_sets.json'
        failIpp = getJSONFixture 'patients/CMS177v6/Fail_IPP.json'
        passNumer = getJSONFixture 'patients/CMS177v6/Pass_Numer.json'
        @patients = new Thorax.Collections.Patients [failIpp, passNumer], parse: true

      it 'is correct for patient with no episodes', ->
        patient = @patients.at(0) # Fail IPP
        result = @cqm_calculator.calculate(@measure.get('populations').first(), patient)

        # no results will be in the episode_results
        expect(result.get('episode_results')).toEqual(undefined)
        # the IPP should be the only relevant population
        expect(result.get('extendedData').population_relevance).toEqual({ IPP: true, DENOM: false, NUMER: false })

      it 'is correct for patient with episodes', ->
        # this patient has an episode that is in the IPP, DENOM and DENEX
        patient = @patients.at(1) # Pass Numer
        result = @cqm_calculator.calculate(@measure.get('populations').first(), patient)

        # there will be a single result in the episode_results
        expect(result.get('episode_results')).toEqual({'5aeb7763b848463d625b33d2': { IPP: 1, DENOM: 1, NUMER: 1}})
        # NUMER should be the only not relevant population
        expect(result.get('extendedData').population_relevance).toEqual({ IPP: true, DENOM: true, NUMER: true })

    describe 'patient based relevance map', ->
      beforeAll ->
        @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS158v6/CMS158v6.json', 'cqm_measure_data/CMS158v6/value_sets.json'
        failIpp = getJSONFixture 'patients/CMS158v6/Fail_IPP.json'
        passNumer = getJSONFixture 'patients/CMS158v6/Pass_Numer.json'
        @patients = new Thorax.Collections.Patients [failIpp, passNumer], parse: true

      it 'is correct', ->
        patient = @patients.at(0) # Fail IPP
        result = @cqm_calculator.calculate(@measure.get('populations').first(), patient)
        # there will not be episode_results on the result object
        expect(result.has('episode_results')).toEqual(false)
        # the IPP should be the only relevant population
        expect(result.get('extendedData').population_relevance).toEqual({ IPP: true, DENOM: false, NUMER: false, DENEXCEP: false})

    describe 'execution engine using passed in timezone offset', ->
      beforeAll ->
        @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS760v0/CMS760v0.json', 'cqm_measure_data/CMS760v0/value_sets.json'
        correctTimezone = getJSONFixture 'patients/CMS760v0/Correct_Timezone.json'
        @patients = new Thorax.Collections.Patients [correctTimezone], parse: true

      it 'is correct', ->
        # This patient fails the IPP (correctly)
        patient = @patients.at(0) # Correct Timezone
        result = @cqm_calculator.calculate(@measure.get('populations').first(), patient)

        # The IPP should fail
        expect(result.get('IPP')).toEqual(0)
