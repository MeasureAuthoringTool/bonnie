describe 'Measure', ->

  beforeEach ->
    @measure = bonnie.measures.get('40280381-3D61-56A7-013E-5D1EF9B76A48')

  it 'has basic attributes available', ->
    expect(@measure.id).toEqual '40280381-3D61-56A7-013E-5D1EF9B76A48'
    expect(@measure.get('title')).toEqual 'Appropriate Testing for Children with Pharyngitis'

  it 'has the expected number of populations', ->
    expect(@measure.get('populations').length).toEqual 1

  it 'can calulate results for a patient', ->
    collection = new Thorax.Collections.Patients getJSONFixture('patients.json')
    patient = collection.findWhere(first: 'GP_Peds', last: 'A')
    results = @measure.get('populations').at(0).calculate(patient)
    waitsFor -> results.isPopulated()
    runs ->
      expect(results.get('DENEX')).toEqual 0
      expect(results.get('DENEXCEP')).toEqual 0
      expect(results.get('DENOM')).toEqual 1
      expect(results.get('IPP')).toEqual 1
      expect(results.get('NUMER')).toEqual 0
