describe 'Measure', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @measure = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS160/CMS160v6.json'), parse: true

  it 'has basic attributes available', ->
    expect(@measure.get('hqmf_set_id')).toEqual 'A4B9763C-847E-4E02-BB7E-ACC596E90E2C'
    expect(@measure.get('title')).toEqual 'Depression Utilization of the PHQ-9 Tool'

  it 'has the expected number of populations', ->
    expect(@measure.get('populations').length).toEqual 3

  it 'has set itself as parent on measure_data_criteria', ->
    expect(@measure.get("source_data_criteria").get('parent') == @measure)

  it 'can calulate results for a patient', ->
    collection = new Thorax.Collections.Patients getJSONFixture('records/CQL/CMS160/patients.json'), parse: true
    patient = collection.findWhere(first: 'Pass', last: 'NUM2')
    results = @measure.get('populations').at(0).calculate(patient)
    waitsForAndRuns( -> results.isPopulated()
      ,
      ->
        expect(results.get('DENEX')).toEqual 0
        expect(results.get('DENEXCEP')).toEqual 0
        expect(results.get('DENOM')).toEqual 1
        expect(results.get('IPP')).toEqual 1
        expect(results.get('NUMER')).toEqual 0
        )
