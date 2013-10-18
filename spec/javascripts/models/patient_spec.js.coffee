describe 'Patient', ->

  it 'has basic attributes available', ->
    collection = new Thorax.Collections.Patients getJSONFixture('patients.json')
    patient = collection.findWhere(first: 'GP_Peds', last: 'A')
    expect(patient.get('gender')).toEqual 'F'
