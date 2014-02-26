describe 'Patient', ->

  beforeEach ->
    collection = new Thorax.Collections.Patients getJSONFixture('patients.json'), parse: true
    @patient = collection.findWhere(first: 'GP_Peds', last: 'B')

  it 'has basic attributes available', ->
    expect(@patient.get('gender')).toEqual 'F'

  it 'correctly performs deep cloning', ->
    clone = @patient.deepClone()
    expect(clone.cid).not.toEqual @patient.cid
    expect(clone.keys()).toEqual @patient.keys()
    expect(clone.get('source_data_criteria').cid).not.toEqual @patient.get('source_data_criteria').cid
    expect(clone.get('source_data_criteria').pluck('id')).toEqual @patient.get('source_data_criteria').pluck('id')
    cloneWithoutId = @patient.deepClone(omit_id: true)
    expect(cloneWithoutId.cid).not.toEqual @patient.cid
    expect(_(@patient.keys()).difference(cloneWithoutId.keys())).toEqual ['_id']

  it 'correctly deduplicates the name when deep cloning and dedupName is an option', ->
    clone = @patient.deepClone({dedupName: true})
    expect(clone.get("first")).toEqual @patient.get("first") + " (1)"

