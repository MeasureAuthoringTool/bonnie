describe 'Measure', ->

  beforeEach ->
    @measure = Fixtures.Measures.get('0002')

  it 'has basic attributes available', ->
    expect(@measure.id).toEqual '0002'
    expect(@measure.get('title')).toEqual 'Appropriate Testing for Children with Pharyngitis'

  it 'can calulate results for a patient', ->
    patient = Fixtures.Patients.findWhere(first: 'GP_Peds', last: 'A')
    results = @measure.calculate(patient)
    expect(results.DENEX).toEqual 0
    expect(results.DENEXCEP).toEqual 0
    expect(results.DENOM).toEqual 1
    expect(results.IPP).toEqual 1
    expect(results.NUMER).toEqual 0
