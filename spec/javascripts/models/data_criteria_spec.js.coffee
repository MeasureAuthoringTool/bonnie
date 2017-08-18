describe "MeasureDataCriteria", ->
  beforeEach ->
    # Clear the fixtures cache so that getJSONFixture does not return stale/modified fixtures
    jasmine.getJSONFixtures().clearCache()
    @patient = new Thorax.Models.Patient getJSONFixture('patients.json')[1], parse: true

  # changed from Authored to Relevant Period for QDM 5.3
  it "specifies 'Medication, Ordered' to have a relevant period", ->
    dataCriteria = @patient.get('source_data_criteria').at(2)
    expect(dataCriteria.getCriteriaType()).toBe 'medication_ordered'
    expect(dataCriteria.isPeriodType()).toBe true
