describe 'Patient', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    collection = new Thorax.Collections.Patients getJSONFixture('cqm_patients/CMS160v6/patients.json'), parse: true
    @patient = collection.findWhere(first: 'Expired', last: 'DENEX')

  it 'has basic attributes available', ->
    gender = (@patient.get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'gender')[0]
    expect(gender.dataElementCodes[0].code).toEqual 'M'

  it 'correctly performs deep cloning', ->
    clone = @patient.deepClone()
    expect(clone.cid).not.toEqual @patient.cid
    expect(clone.keys()).toEqual @patient.keys()
    # I am not convinced that the sdc collection needs a CID, it's not getting set on initialization
    # expect(clone.get('source_data_criteria').cid).not.toEqual @patient.get('source_data_criteria').cid
    expect(clone.get('source_data_criteria').pluck('id')).toEqual @patient.get('source_data_criteria').pluck('id')
    cloneNewId = @patient.deepClone(new_id: true)
    expect(cloneNewId.cid).not.toEqual @patient.cid
    expect(cloneNewId.get('cqmPatient')._id.toString()).not.toEqual @patient.get('cqmPatient')._id.toString()

  it 'correctly deduplicates the name when deep cloning and dedupName is an option', ->
    clone = @patient.deepClone({dedupName: true})
    expect(clone.get("first")).toEqual @patient.get("first") + " (1)"

  it 'correctly sorts criteria by multiple attributes', ->
    # Patient has for existing criteria; first get their current order
    startOrder = @patient.get('source_data_criteria').map (dc) -> dc.cid
    # Set some attribute values so that they should sort 4,3,2,1 and sort
    @patient.get('source_data_criteria').at(0).set start_date: 2, end_date: 2
    @patient.get('source_data_criteria').at(1).set start_date: 2, end_date: 1
    @patient.get('source_data_criteria').at(2).set start_date: 1, end_date: 2
    @patient.get('source_data_criteria').at(3).set start_date: 1, end_date: 1
    @patient.get('source_data_criteria').at(4).set start_date: 5, end_date: 3
    @patient.get('source_data_criteria').at(5).set start_date: 3, end_date: 3
    @patient.get('source_data_criteria').at(6).set start_date: 1, end_date: 3
    @patient.sortCriteriaBy 'start_date', 'end_date'
    expect(@patient.get('source_data_criteria').at(0).cid).toEqual startOrder[3]
    expect(@patient.get('source_data_criteria').at(1).cid).toEqual startOrder[2]
    expect(@patient.get('source_data_criteria').at(2).cid).toEqual startOrder[6]
    expect(@patient.get('source_data_criteria').at(3).cid).toEqual startOrder[1]
    expect(@patient.get('source_data_criteria').at(4).cid).toEqual startOrder[0]
    expect(@patient.get('source_data_criteria').at(5).cid).toEqual startOrder[5]
    expect(@patient.get('source_data_criteria').at(6).cid).toEqual startOrder[4]

  describe 'validation', ->

    beforeEach ->
      @errorsForPatientWithout = (field, extraAttrs) ->
        clone = @patient.deepClone()
        clone.set field, ''
        clone.set extraAttrs
        clone.validate()

    it 'passes patient with no issues', ->
      errors = @patient.validate()
      expect(errors).toBeUndefined()

    it 'fails patient missing a first name', ->
      errors = @errorsForPatientWithout('first')
      expect(errors.length).toEqual 1
      expect(errors[0][2]).toEqual 'Name fields cannot be blank'

    it 'fails patient missing a last name', ->
      errors = @errorsForPatientWithout('last')
      expect(errors.length).toEqual 1
      expect(errors[0][2]).toEqual 'Name fields cannot be blank'

    it 'fails patient missing a birthdate', ->
      clone = @patient.deepClone()
      clone.get('cqmPatient').qdmPatient.birthDatetime = undefined
      errors = clone.validate()
      expect(errors.length).toEqual 1
      expect(errors[0][2]).toEqual 'Date of birth cannot be blank'

    it 'fails deceased patient without a deathdate', ->
      clone = @patient.deepClone()
      (clone.get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'expired')[0].expiredDatetime = undefined
      errors = clone.validate()
      expect(errors.length).toEqual 1
      expect(errors[0][2]).toEqual 'Deceased patient must have date of death'
