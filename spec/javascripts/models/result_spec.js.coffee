describe 'Result', ->

  beforeEach ->
    window.bonnieRouterCache.load('base_set')
    @measure = bonnie.measures.get('40280381-3D61-56A7-013E-5D1EF9B76A48')
    collection = new Thorax.Collections.Patients getJSONFixture('records/QDM/base_set/patients.json'), parse: true
    @patient = collection.findWhere(first: 'GP_Peds', last: 'A')

  it 'correctly handles fixing specific occurrence results', ->
    result = this.measure.get('populations').at(0).calculate(@patient)
    waitsForAndRuns( -> result.isPopulated()
      ,
      ->
        specificsRationale = result.specificsRationale()
        expect(specificsRationale.DENEX.OccurrenceAAcutePharyngitis1_precondition_4).toEqual false
        expect(specificsRationale.DENEX.GROUP_SBS_CHILDREN_47).toEqual false
        expect(specificsRationale.NUMER.OccurrenceAAmbulatoryEdVisit3).toEqual false
        )

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

  it 'MSRPOPLEX should be 0 if MSRPOPL not satisfied', ->
    initial_results = {IPP: 1, MSRPOPL: 0, MSRPOPLEX: 1}
    expected_results = {IPP: 1, MSRPOPL: 0, MSRPOPLEX: 0}
    processed_results = bonnie.cql_calculator.handlePopulationValues(initial_results)
    expect(processed_results).toEqual expected_results

    initial_results = {IPP: 1, MSRPOPL: 0, MSRPOPLEX: 0}
    expected_results = {IPP: 1, MSRPOPL: 0, MSRPOPLEX: 0}
    processed_results = bonnie.cql_calculator.handlePopulationValues(initial_results)
    expect(processed_results).toEqual expected_results

  it 'MSRPOPLEX should be unchanged if MSRPOPL satisfied', ->
    initial_results = {IPP: 1, MSRPOPL: 1, MSRPOPLEX: 1}
    expected_results = {IPP: 1, MSRPOPL: 1, MSRPOPLEX: 1}
    processed_results = bonnie.cql_calculator.handlePopulationValues(initial_results)
    expect(processed_results).toEqual expected_results

    initial_results = {IPP: 1, MSRPOPL: 1, MSRPOPLEX: 1, DENOM: 0}
    expected_results = {IPP: 1, MSRPOPL: 1, MSRPOPLEX: 1, DENOM: 0}
    processed_results = bonnie.cql_calculator.handlePopulationValues(initial_results)
    expect(processed_results).toEqual expected_results

    initial_results = {IPP: 1, MSRPOPL: 1, MSRPOPLEX: 0}
    expected_results = {IPP: 1, MSRPOPL: 1, MSRPOPLEX: 0}
    processed_results = bonnie.cql_calculator.handlePopulationValues(initial_results)
    expect(processed_results).toEqual expected_results

    initial_results = {IPP: 1, MSRPOPL: 1, MSRPOPLEX: 0, DENOM: 0}
    expected_results = {IPP: 1, MSRPOPL: 1, MSRPOPLEX: 0, DENOM: 0}
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

    @measure = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS32/CMS721v0.json'), parse: true
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

  it 'can handle multiple episodes observed', ->
    patient = @patients.findWhere(last: '2 ED ', first: 'Visits')
    result = @population.calculate(patient)
    expect(result.get('values')).toEqual([25, 15])
    expect(result.get('population_relevance')['values']).toBe(true)
    expect(result.get('population_relevance')['MSRPOPL']).toBe(true)
    expect(result.get('population_relevance')['MSRPOPLEX']).toBe(true)

  it 'can handle multiple episodes observed with one excluded', ->
    patient = @patients.findWhere(last: '2 ED ', first: 'Visits 1 Excl')
    result = @population.calculate(patient)
    # TODO: after confusion with how exclusions are to be handled, update this. for now exclusions will still be observed
    expect(result.get('values')).toEqual([25, 15])
    expect(result.get('population_relevance')['values']).toBe(true)
    expect(result.get('population_relevance')['MSRPOPL']).toBe(true)
    expect(result.get('population_relevance')['MSRPOPLEX']).toBe(true)

  it 'can handle multiple episodes observed with both excluded', ->
    patient = @patients.findWhere(last: '2 ED ', first: 'Visits 2 Excl')
    result = @population.calculate(patient)
    # TODO: after confusion with how exclusions are to be handled, update this. for now exclusions will still be observed
    expect(result.get('values')).toEqual([25, 15])
    expect(result.get('population_relevance')['values']).toBe(false)
    expect(result.get('population_relevance')['MSRPOPL']).toBe(true)
    expect(result.get('population_relevance')['MSRPOPLEX']).toBe(true)
