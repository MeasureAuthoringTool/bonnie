describe 'Patient', ->

  beforeAll ->
    jasmine.getJSONFixtures().clearCache()
    patients = []
    patients.push(getJSONFixture('patients/CMS160v6/Expired_DENEX.json'))
    patients.push(getJSONFixture('patients/CMS160v6/Pass_NUM2.json'))
    collection = new Thorax.Collections.Patients patients, parse: true
    @patient = collection.first()
    @patient1 = collection.at(1)

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
    expect(clone.getFirstName()).toEqual @patient.getFirstName() + " (1)"

  it 'correctly sorts criteria by multiple attributes', ->
    # Patient has for existing criteria; first get their current order
    startOrder = @patient1.get('source_data_criteria').map (dc) -> dc.cid
    # Set some attribute values so that they should sort 4,3,2,1 and sort
    @patient1.get('source_data_criteria').at(0).set start_date: 2, end_date: 2
    @patient1.get('source_data_criteria').at(1).set start_date: 2, end_date: 1
    @patient1.get('source_data_criteria').at(2).set start_date: 1, end_date: 3
    @patient1.get('source_data_criteria').at(3).set start_date: 1, end_date: 2
    @patient1.sortCriteriaBy 'start_date', 'end_date'
    expect(@patient1.get('source_data_criteria').at(0).cid).toEqual startOrder[3]
    expect(@patient1.get('source_data_criteria').at(1).cid).toEqual startOrder[2]
    expect(@patient1.get('source_data_criteria').at(2).cid).toEqual startOrder[1]
    expect(@patient1.get('source_data_criteria').at(3).cid).toEqual startOrder[0]

  describe 'validation', ->

    it 'passes patient with no issues', ->
      errors = @patient.validate()
      expect(errors).toBeUndefined()

    it 'fails patient missing a first name', ->
      clone = @patient.deepClone()
      clone.get('cqmPatient').givenNames[0] = ''
      errors = clone.validate()
      expect(errors.length).toEqual 1
      expect(errors[0][2]).toEqual 'Name fields cannot be blank'

    it 'fails patient missing a last name', ->
      clone = @patient.deepClone()
      clone.get('cqmPatient').familyName = ''
      errors = clone.validate()
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
