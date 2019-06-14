describe 'Result', ->

  beforeAll ->
    jasmine.getJSONFixtures().clearCache()
    @measure = loadMeasureWithValueSets 'cqm_measure_data/core_measures/CMS160/CMS160v6.json', 'cqm_measure_data/core_measures/CMS160/value_sets.json'
    collection = new Thorax.Collections.Patients getJSONFixture('patients/core_measures/CMS160/patients.json'), parse: true
    @patient = collection.findWhere(_id: '5cc9fb96d7c8ac82dc80879f')

  it 'allows for deferring use of results until populated', ->
    result1 = new Thorax.Models.Result({}, population: @measure.get('populations').first(), patient: @patient)
    expect(result1.calculation.state()).toEqual 'pending'
    result1.set(rationale: 'RATIONALE')
    expect(result1.calculation.state()).toEqual 'resolved'
    result2 = new Thorax.Models.Result({ rationale: 'RATIONALE' }, population: @measure.get('populations').first(), patient: @patient)
    expect(result2.calculation.state()).toEqual 'resolved'



describe 'Continuous Variable Calculations', ->

  beforeAll ->
    jasmine.getJSONFixtures().clearCache()

    @cqm_calculator = new CQMCalculator()

    @measure = loadMeasureWithValueSets 'cqm_measure_data/core_measures/CMS32/CMS32v7.json', 'cqm_measure_data/core_measures/CMS32/value_sets.json'
    @population = @measure.get('populations').at(0)
    @patients = new Thorax.Collections.Patients getJSONFixture('patients/core_measures/CMS32/patients.json'), parse: true

  it 'can handle single episodes observed', ->
    patient = @patients.findWhere(_id: '5cc9fbb6d7c8ac83080ceba9') # 1 ED Visit
    result = @population.calculate(patient)
    expect(result.get('observation_values')).toEqual([15])
    expect(result.get('extendedData').population_relevance['observation_values']).toBe(true)
    expect(result.get('extendedData').population_relevance['MSRPOPL']).toBe(true)
    expect(result.get('extendedData').population_relevance['MSRPOPLEX']).toBe(true)

    # check the results for the episode
    expectedEpisodeResults = { IPP: 1, MSRPOPL: 1, MSRPOPLEX: 0, observation_values: [15] }
    expect(result.get('episode_results')['5aeb7763b848463d625b33cf']).toEqual(expectedEpisodeResults)

  it 'can handle multiple episodes observed', ->
    patient = @patients.findWhere(_id: '5cc9fbb6d7c8ac83080cebb3') # 2 ED Visits
    result = @population.calculate(patient)
    # values are ordered when created by the calculator
    expect(result.get('observation_values')).toEqual([15, 25])
    expect(result.get('extendedData').population_relevance['observation_values']).toBe(true)
    expect(result.get('extendedData').population_relevance['MSRPOPL']).toBe(true)
    expect(result.get('extendedData').population_relevance['MSRPOPLEX']).toBe(true)

    # check the results for the episode
    expectedEpisodeResults = { IPP: 1, MSRPOPL: 1, MSRPOPLEX: 0, observation_values: [25] }
    expect(result.get('episode_results')['5aeb77ccb848463d625b5d48']).toEqual(expectedEpisodeResults)
    # check the results for the second episode
    expectedEpisodeResults = { IPP: 1, MSRPOPL: 1, MSRPOPLEX: 0, observation_values: [15] }
    expect(result.get('episode_results')['5aeb77ccb848463d625b5d4a']).toEqual(expectedEpisodeResults)

  it 'can handle multiple episodes observed with one excluded', ->
    patient = @patients.findWhere(_id: '5cc9fbb6d7c8ac83080cebbf') # 2 ED Visits 1 Excl
    result = @population.calculate(patient)
    expect(result.get('observation_values')).toEqual([25])
    expect(result.get('extendedData').population_relevance['observation_values']).toBe(true)
    expect(result.get('extendedData').population_relevance['MSRPOPL']).toBe(true)
    expect(result.get('extendedData').population_relevance['MSRPOPLEX']).toBe(true)

    # check the results for the episode
    expectedEpisodeResults = { IPP: 1, MSRPOPL: 1, MSRPOPLEX: 0, observation_values: [25] }
    expect(result.get('episode_results')['5aeb77ccb848463d625b5d4d']).toEqual(expectedEpisodeResults)
    # check the results for the second episode
    expectedEpisodeResults = { IPP: 1, MSRPOPL: 1, MSRPOPLEX: 1, observation_values: [] }
    expect(result.get('episode_results')['5aeb77ccb848463d625b5d4f']).toEqual(expectedEpisodeResults)

  it 'can handle multiple episodes observed with both excluded', ->
    patient = @patients.findWhere(_id: '5cc9fbb6d7c8ac83080cebcb') # 2 ED Visits 2 Excl
    result = @population.calculate(patient)
    expect(result.get('observation_values')).toEqual([])
    expect(result.get('extendedData').population_relevance['observation_values']).toBe(false)
    expect(result.get('extendedData').population_relevance['MSRPOPL']).toBe(true)
    expect(result.get('extendedData').population_relevance['MSRPOPLEX']).toBe(true)

    # check the results for the episode
    expectedEpisodeResults = { IPP: 1, MSRPOPL: 1, MSRPOPLEX: 1, observation_values: [] }
    expect(result.get('episode_results')['5aeb77cdb848463d625b5d52']).toEqual(expectedEpisodeResults)
    # check the results for the second episode
    expectedEpisodeResults = { IPP: 1, MSRPOPL: 1, MSRPOPLEX: 1, observation_values: [] }
    expect(result.get('episode_results')['5aeb77cdb848463d625b5d54']).toEqual(expectedEpisodeResults)
