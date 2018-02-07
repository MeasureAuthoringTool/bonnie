describe 'Result', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @measure = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS160/CMS160v6.json'), parse: true
    collection = new Thorax.Collections.Patients getJSONFixture('records/CQL/CMS160/patients.json'), parse: true
    @patient = collection.findWhere(first: 'Pass', last: 'NUM2')
    @oldBonnieValueSetsByOid = bonnie.valueSetsByOid
    bonnie.valueSetsByOid = getJSONFixture('/measure_data/CQL/CMS160/value_sets.json')

  afterEach ->
    bonnie.valueSetsByOid = @oldBonnieValueSetsByOid

  it 'allows for deferring use of results until populated', ->
    result1 = new Thorax.Models.Result({}, population: @measure.get('populations').first(), patient: @patient)
    expect(result1.calculation.state()).toEqual 'pending'
    result1.set(rationale: 'RATIONALE')
    expect(result1.calculation.state()).toEqual 'resolved'
    result2 = new Thorax.Models.Result({ rationale: 'RATIONALE' }, population: @measure.get('populations').first(), patient: @patient)
    expect(result2.calculation.state()).toEqual 'resolved'

  it 'NUMER population not modified by inclusion in NUMEX', ->
    initial_results = {IPP: 1, DENOM: 1, DENEX: 0, NUMER: 1, NUMEX: 1}
    processed_results = bonnie.cql_calculator.handlePopulationValues(initial_results)
    expect(processed_results).toEqual initial_results
    
  it 'NUMEX membership removed when not a member of NUMER', ->
    initial_results = {IPP: 1, DENOM: 1, DENEX: 0, NUMER: 0, NUMEX: 1}
    expected_results = {IPP: 1, DENOM: 1, DENEX: 0, NUMER: 0, NUMEX: 0}
    processed_results = bonnie.cql_calculator.handlePopulationValues(initial_results)
    expect(processed_results).toEqual expected_results

  it 'NUMEX membership removed when not a member of DENOM', ->
    initial_results = {IPP: 1, DENOM: 0, DENEX: 0, NUMER: 0, NUMEX: 1}
    expected_results = {IPP: 1, DENOM: 0, DENEX: 0, NUMER: 0, NUMEX: 0}
    processed_results = bonnie.cql_calculator.handlePopulationValues(initial_results)
    expect(processed_results).toEqual expected_results

  it 'DENOM population not modified by inclusion in DENEX', ->
    initial_results = {IPP: 1, DENOM: 1, DENEX: 1, NUMER: 0, NUMEX: 0}
    processed_results = bonnie.cql_calculator.handlePopulationValues(initial_results)
    expect(processed_results).toEqual initial_results
    
  it 'DENEX membership removed when not a member of DENOM', ->
    initial_results = {IPP: 1, DENOM: 0, DENEX: 1, NUMER: 0, NUMEX: 0}
    expected_results = {IPP: 1, DENOM: 0, DENEX: 0, NUMER: 0, NUMEX: 0}
    processed_results = bonnie.cql_calculator.handlePopulationValues(initial_results)
    expect(processed_results).toEqual expected_results

  it 'NUMER and NUMEX membership removed there are same counts in DENEX as DENOM', ->
    initial_results = {IPP: 2, DENOM: 2, DENEX: 2, NUMER: 2, NUMEX: 1}
    expected_results = {IPP: 2, DENOM: 2, DENEX: 2, NUMER: 0, NUMEX: 0}
    processed_results = bonnie.cql_calculator.handlePopulationValues(initial_results)
    expect(processed_results).toEqual expected_results

  it 'NUMER and NUMEX membership removed there are more counts in DENEX than DENOM', ->
    initial_results = {IPP: 3, DENOM: 2, DENEX: 3, NUMER: 2, NUMEX: 1}
    expected_results = {IPP: 3, DENOM: 2, DENEX: 3, NUMER: 0, NUMEX: 0}
    processed_results = bonnie.cql_calculator.handlePopulationValues(initial_results)
    expect(processed_results).toEqual expected_results

  it 'NUMER and NUMEX membership kept if there are less counts in DENEX as DENOM', ->
    initial_results = {IPP: 2, DENOM: 2, DENEX: 1, NUMER: 1, NUMEX: 0}
    expected_results = {IPP: 2, DENOM: 2, DENEX: 1, NUMER: 1, NUMEX: 0}
    processed_results = bonnie.cql_calculator.handlePopulationValues(initial_results)
    expect(processed_results).toEqual expected_results

describe 'Continuous Variable Calculations', ->

  beforeEach ->
    @universalValueSetsByOid = bonnie.valueSetsByOid
    jasmine.getJSONFixtures().clearCache()

    bonnie.valueSetsByOid = getJSONFixture('measure_data/CQL/CMS32/value_sets.json')
    @cql_calculator = new CQLCalculator()

    @measure = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS32/CMS32v7.json'), parse: true
    @population = @measure.get('populations').at(0)
    @patients = new Thorax.Collections.Patients getJSONFixture('records/CQL/CMS32/patients.json'), parse: true

  afterEach ->
    bonnie.valueSetsByOid = @universalValueSetsByOid
    bonnie.valueSetsByOidCached = undefined

  it 'can handle single episodes observed', ->
    patient = @patients.findWhere(last: '1 ED', first: 'Visit')
    result = @population.calculate(patient)
    expect(result.get('values')).toEqual([15])
    expect(result.get('population_relevance')['values']).toBe(true)
    expect(result.get('population_relevance')['MSRPOPL']).toBe(true)
    expect(result.get('population_relevance')['MSRPOPLEX']).toBe(true)

    # check the results for the episode
    expectedEpisodeResults = { IPP: 1, MSRPOPL: 1, MSRPOPLEX: 0, values: [15] }
    expect(result.get('episode_results')['5a593cbd942c6d0773593d50']).toEqual(expectedEpisodeResults)

  it 'can handle multiple episodes observed', ->
    patient = @patients.findWhere(last: '2 ED', first: 'Visits')
    result = @population.calculate(patient)
    expect(result.get('values')).toEqual([25, 15])
    expect(result.get('population_relevance')['values']).toBe(true)
    expect(result.get('population_relevance')['MSRPOPL']).toBe(true)
    expect(result.get('population_relevance')['MSRPOPLEX']).toBe(true)

    # check the results for the episode
    expectedEpisodeResults = { IPP: 1, MSRPOPL: 1, MSRPOPLEX: 0, values: [25] }
    expect(result.get('episode_results')['5a593ef8942c6d0773593de1']).toEqual(expectedEpisodeResults)
    # check the results for the second episode
    expectedEpisodeResults = { IPP: 1, MSRPOPL: 1, MSRPOPLEX: 0, values: [15] }
    expect(result.get('episode_results')['5a593ef8942c6d0773593de3']).toEqual(expectedEpisodeResults)

  # TODO: These tests can be added back in when the MSRPOPLEX removal of OBSERVs is added back to cql_calculator in 2.1 release
  # note: the fixture file was generated with the cql_calculator code commented out, so need to change expectations
  #       to match and re-export fixture for 2.1 release
  # it 'can handle multiple episodes observed with one excluded', ->
  #   patient = @patients.findWhere(last: '2 ED', first: 'Visits 1 Excl')
  #   result = @population.calculate(patient)
  #   expect(result.get('values')).toEqual([25])
  #   expect(result.get('population_relevance')['values']).toBe(true)
  #   expect(result.get('population_relevance')['MSRPOPL']).toBe(true)
  #   expect(result.get('population_relevance')['MSRPOPLEX']).toBe(true)
  # 
  #   # check the results for the episode
  #   expectedEpisodeResults = { IPP: 1, MSRPOPL: 1, MSRPOPLEX: 0, values: [25] }
  #   expect(result.get('episode_results')['5a59405f942c6d0773593e15']).toEqual(expectedEpisodeResults)
  #   # check the results for the second episode
  #   expectedEpisodeResults = { IPP: 1, MSRPOPL: 1, MSRPOPLEX: 1, values: [] }
  #   expect(result.get('episode_results')['5a59405f942c6d0773593e17']).toEqual(expectedEpisodeResults)
  # 
  # it 'can handle multiple episodes observed with both excluded', ->
  #   patient = @patients.findWhere(last: '2 ED', first: 'Visits 2 Excl')
  #   result = @population.calculate(patient)
  #   expect(result.get('values')).toEqual([])
  #   expect(result.get('population_relevance')['values']).toBe(false)
  #   expect(result.get('population_relevance')['MSRPOPL']).toBe(true)
  #   expect(result.get('population_relevance')['MSRPOPLEX']).toBe(true)
  # 
  #   # check the results for the episode
  #   expectedEpisodeResults = { IPP: 1, MSRPOPL: 1, MSRPOPLEX: 1, values: [] }
  #   expect(result.get('episode_results')['5a5940d8942c6d0c717eeed6']).toEqual(expectedEpisodeResults)
  #   # check the results for the second episode
  #   expectedEpisodeResults = { IPP: 1, MSRPOPL: 1, MSRPOPLEX: 1, values: [] }
  #   expect(result.get('episode_results')['5a5940d8942c6d0c717eeed8']).toEqual(expectedEpisodeResults)
