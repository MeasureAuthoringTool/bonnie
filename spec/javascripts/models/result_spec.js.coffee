describe 'Result', ->

  beforeAll ->
    jasmine.getJSONFixtures().clearCache()
    @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS160v6/CMS160v6.json', 'cqm_measure_data/CMS160v6/value_sets.json'
    expiredDenex = getJSONFixture('patients/CMS160v6/Expired_DENEX.json')
    passNum2 = getJSONFixture('patients/CMS160v6/Pass_NUM2.json')
    patients = new Thorax.Collections.Patients [expiredDenex, passNum2], parse: true
    @patient = patients.at(0) # Expired DENEX

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

    @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS903v0/CMS903v0.json', 'cqm_measure_data/CMS903v0/value_sets.json'
    @population = @measure.get('populations').at(0)
    visit1ED = getJSONFixture('patients/CMS903v0/Visit_1 ED.json')
    visit1Excl2ED = getJSONFixture('patients/CMS903v0/Visits 1 Excl_2 ED.json')
    visits2Excl2ED = getJSONFixture('patients/CMS903v0/Visits 2 Excl_2 ED.json')
    visits2ED = getJSONFixture('patients/CMS903v0/Visits_2 ED.json')

    @patients = new Thorax.Collections.Patients [visit1ED, visit1Excl2ED, visits2Excl2ED, visits2ED], parse: true

  it 'can handle single episodes observed', ->
    patient = @patients.at(0) # 1 ED Visit
    result = @population.calculate(patient)
    expect(result.get('observation_values')).toEqual([15])
    expect(result.get('population_relevance')['observation_values']).toBe(true)
    expect(result.get('population_relevance')['MSRPOPL']).toBe(true)
    expect(result.get('population_relevance')['MSRPOPLEX']).toBe(true)

    # check the results for the episode
    expectedEpisodeResults = { IPP: 1, MSRPOPL: 1, MSRPOPLEX: 0, observation_values: [15] }
    expect(result.get('episode_results')['5d5af7364987880000ce1889']).toEqual(expectedEpisodeResults)

  it 'can handle multiple episodes observed', ->
    patient = @patients.at(3) # 2 ED Visits
    result = @population.calculate(patient)
    # values are ordered when created by the calculator
    expect(result.get('observation_values')).toEqual([25, 15])
    expect(result.get('population_relevance')['observation_values']).toBe(true)
    expect(result.get('population_relevance')['MSRPOPL']).toBe(true)
    expect(result.get('population_relevance')['MSRPOPLEX']).toBe(true)

    episode_ids = patient.get('source_data_criteria').map((sdc) -> sdc.get('id'))
    # check the results for the episode
    expectedEpisodeResults = { IPP: 1, MSRPOPL: 1, MSRPOPLEX: 0, observation_values: [15] }
    expect(result.get('episode_results')[episode_ids[2]]).toEqual(expectedEpisodeResults)
    # check the results for the second episode
    expectedEpisodeResults = { IPP: 1, MSRPOPL: 1, MSRPOPLEX: 0, observation_values: [25] }
    expect(result.get('episode_results')[episode_ids[1]]).toEqual(expectedEpisodeResults)

  it 'can handle multiple episodes observed with one excluded', ->
    patient = @patients.at (1) # 2 ED Visits 1 Excl
    result = @population.calculate(patient)
    expect(result.get('observation_values')).toEqual([15])
    expect(result.get('population_relevance')['observation_values']).toBe(true)
    expect(result.get('population_relevance')['MSRPOPL']).toBe(true)
    expect(result.get('population_relevance')['MSRPOPLEX']).toBe(true)

    episode_ids = patient.get('source_data_criteria').map((sdc) -> sdc.get('id'))

    # check the results for the episode
    expectedEpisodeResults = { IPP: 1, MSRPOPL: 1, MSRPOPLEX: 0, observation_values: [15] }
    expect(result.get('episode_results')[episode_ids[2]]).toEqual(expectedEpisodeResults)
    # check the results for the second episode
    expectedEpisodeResults = { IPP: 1, MSRPOPL: 1, MSRPOPLEX: 1, observation_values: [] }
    expect(result.get('episode_results')[episode_ids[1]]).toEqual(expectedEpisodeResults)

  it 'can handle multiple episodes observed with both excluded', ->
    patient = @patients.at(2) # 2 ED Visits 2 Excl
    result = @population.calculate(patient)
    expect(result.get('observation_values')).toEqual([])
    expect(result.get('population_relevance')['observation_values']).toBe(false)
    expect(result.get('population_relevance')['MSRPOPL']).toBe(true)
    expect(result.get('population_relevance')['MSRPOPLEX']).toBe(true)

    episode_ids = patient.get('source_data_criteria').map((sdc) -> sdc.get('id'))
    # check the results for the episode
    expectedEpisodeResults = { IPP: 1, MSRPOPL: 1, MSRPOPLEX: 1, observation_values: [] }
    expect(result.get('episode_results')[episode_ids[2]]).toEqual(expectedEpisodeResults)
    # check the results for the second episode
    expectedEpisodeResults = { IPP: 1, MSRPOPL: 1, MSRPOPLEX: 1, observation_values: [] }
    expect(result.get('episode_results')[episode_ids[1]]).toEqual(expectedEpisodeResults)
