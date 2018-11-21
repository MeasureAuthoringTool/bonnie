describe 'Measure', ->

  beforeEach ->
    window.bonnieRouterCache.load('base_set')
    @measure = bonnie.measures.get('40280381-3D61-56A7-013E-5D1EF9B76A48')

  it 'has basic attributes available', ->
    expect(@measure.id).toEqual '40280381-3D61-56A7-013E-5D1EF9B76A48'
    expect(@measure.get('title')).toEqual 'Appropriate Testing for Children with Pharyngitis'

  it 'has the expected number of populations', ->
    expect(@measure.get('populations').length).toEqual 1

  it 'has set itself as parent on measure_data_criteria', ->
    expect(@measure.get("source_data_criteria").get('parent') == @measure)

  it 'can calulate results for a patient', ->
    collection = new Thorax.Collections.Patients getJSONFixture('records/QDM/base_set/patients.json')
    patient = collection.findWhere(first: 'GP_Peds', last: 'A')
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
        