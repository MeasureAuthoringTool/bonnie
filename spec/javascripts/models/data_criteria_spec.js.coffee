describe "MeasureDataCriteria", ->
  beforeEach ->
    # Clear the fixtures cache so that getJSONFixture does not return stale/modified fixtures
    jasmine.getJSONFixtures().clearCache()

  # changed from Authored to Relevant Period for QDM 5.3
  it "specifies 'Medication, Dispensed' to have a relevant period", ->
    patients = new Thorax.Collections.Patients getJSONFixture('cqm_patients/CMS136/patients.json'), parse: true
    patient = patients.findWhere(first: 'Pass', last: 'IPP1')
    dataCriteria = patient.get('source_data_criteria').at(1)
    expect(dataCriteria.getCriteriaType()).toBe 'medication_dispensed'
    expect(dataCriteria.isPeriodType()).toBe true

  # changed from Authored to Relevant Period for QDM 5.3
  it "specifies 'Medication, Order' to have a relevant period", ->
    patients = new Thorax.Collections.Patients getJSONFixture('cqm_patients/CMS146/patients.json'), parse: true
    patient = patients.findWhere(first: 'Pass', last: 'IPP')
    dataCriteria = patient.get('source_data_criteria').at(2)
    expect(dataCriteria.getCriteriaType()).toBe 'medication_ordered'
    expect(dataCriteria.isPeriodType()).toBe true
