describe 'Measure', ->

  beforeEach ->
    @measure = Fixtures.Measures.get('40280381-3D61-56A7-013E-5D1EF9B76A48')

  it 'has basic attributes available', ->
    expect(@measure.id).toEqual '40280381-3D61-56A7-013E-5D1EF9B76A48'
    expect(@measure.get('title')).toEqual 'Appropriate Testing for Children with Pharyngitis'

  it 'can calulate results for a patient', ->
    collection = new Thorax.Collections.Patients getJSONFixture('patients.json')
    patient = collection.findWhere(first: 'GP_Peds', last: 'A')
    results = @measure.calculate(patient)
    expect(results.DENEX).toEqual 0
    expect(results.DENEXCEP).toEqual 0
    expect(results.DENOM).toEqual 1
    expect(results.IPP).toEqual 1
    expect(results.NUMER).toEqual 0
