# Some tests to ensure that shared patients, the frontend views, and cql execution are all working
# correctly for composite measures

describe 'Composite Measure Calculations', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @valueSetsPath = 'cqm_measure_data/special_measures/CMS890/value_sets.json'
    @components = getJSONFixture('cqm_measure_data/special_measures/CMS890/components.json')
    @cqm_calculator = new CQMCalculator()
    @patients = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMS890/patients.json'), parse: true
    @pt1 = @patients.findWhere(last: 'doe', first: 'jon')
    @pt2 = @patients.findWhere(last: 'smith', first: 'jane')

  it 'calculates correctly for the composite measure', ->
    loadMeasureWithValueSets('cqm_measure_data/special_measures/CMS890/CMS890v0.json', @valueSetsPath)
    population = measure.get('populations').at(0)

    result = population.calculate(@pt1)
    expect(result.get('IPP')).toEqual 1
    expect(result.get('MSRPOPL')).toEqual 1
    expect(result.get('MSRPOPLEX')).toEqual 0
    expect(result.get('values')[0].toFixed(8)).toEqual "0.33333333"
    expect(result.get('values').length).toEqual 1

    result = population.calculate(@pt2)
    expect(result.get('IPP')).toEqual 1
    expect(result.get('MSRPOPL')).toEqual 1
    expect(result.get('MSRPOPLEX')).toEqual 1
    expect(result.get('values').length).toEqual 0

  it 'calculates correctly for a component measure', ->
    #hqmf set id BA108B7B-90B4-4692-B1D0-5DB554D2A1A2
    measure = new Thorax.Models.Measure @components[6], parse: true
    measure.set('cqmValueSets', getJSONFixture(@valueSetsPath))
    population = measure.get('populations').at(0)

    result = population.calculate(@pt1)
    expect(result.get('IPP')).toEqual 1
    expect(result.get('DENOM')).toEqual 1
    expect(result.get('DENEX')).toEqual 0
    expect(result.get('NUMER')).toEqual 0
    expect(result.get('DENEXCEP')).toEqual 0

    result = population.calculate(@pt2)
    expect(result.get('IPP')).toEqual 1
    expect(result.get('DENOM')).toEqual 1
    expect(result.get('DENEX')).toEqual 0
    expect(result.get('NUMER')).toEqual 1
    expect(result.get('DENEXCEP')).toEqual 0
