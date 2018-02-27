describe "MeasureDataCriteria", ->
  beforeEach ->
    # Clear the fixtures cache so that getJSONFixture does not return stale/modified fixtures
    jasmine.getJSONFixtures().clearCache()

  # changed from Authored to Relevant Period for QDM 5.3
  it "specifies 'Medication, Dispensed' to have a relevant period", ->
    patients = new Thorax.Collections.Patients getJSONFixture('records/special_records/CMS136/patients.json'), parse: true
    patient = patients.findWhere(first: 'BehaviorHealth<=30DaysAftrADHDMed', last: 'NUMERPop2Pass')
    dataCriteria = patient.get('source_data_criteria').at(1)
    expect(dataCriteria.getCriteriaType()).toBe 'medication_dispensed'
    expect(dataCriteria.isPeriodType()).toBe true

  # changed from Authored to Relevant Period for QDM 5.3
  it "specifies 'Medication, Order' to have a relevant period", ->
    patients = new Thorax.Collections.Patients getJSONFixture('records/special_records/CMS146/patients.json'), parse: true
    patient = patients.findWhere(first: 'PharynStrepATest<=3dB4Enc', last: 'NUMERPass')
    dataCriteria = patient.get('source_data_criteria').at(3)
    expect(dataCriteria.getCriteriaType()).toBe 'medication_ordered'
    expect(dataCriteria.isPeriodType()).toBe true
