describe 'Patient', ->

  it 'has basic attributes available', ->
    patient = Fixtures.Patients.findWhere(first: 'GP_Peds', last: 'A')
    expect(patient.get('gender')).toEqual 'F'
