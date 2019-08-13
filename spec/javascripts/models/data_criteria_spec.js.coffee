describe "SourceDataCriteria", ->
  beforeAll ->
    jasmine.getJSONFixtures().clearCache()

  # changed from Authored to Relevant Period for QDM 5.3
  it "specifies 'Medication, Dispensed' to have a relevant period", ->
    passIPP1 = getJSONFixture 'patients/CMS136v7/Pass_IPP1.json'
    passIPP2 = getJSONFixture 'patients/CMS136v7/Pass_IPP2.json'
    patients = new Thorax.Collections.Patients [passIPP1, passIPP2], parse: true
    patient = patients.at(0) # Pass IPP1
    dataCriteria = patient.get('source_data_criteria').at(1)
    expect(dataCriteria.getCriteriaType()).toBe 'medication_dispensed'
    expect(dataCriteria.isPeriodType()).toBe true
    expect(dataCriteria.getPrimaryTimingAttribute()).toBe 'relevantPeriod'

  # changed from Authored to Relevant Period for QDM 5.3
  it "specifies 'Medication, Order' to have a relevant period", ->
    patients = new Thorax.Collections.Patients [getJSONFixture('patients/CMS146v6/Pass_IPP.json')], parse: true
    patient = patients.first()

    dataCriteria = patient.get('source_data_criteria').at(2)
    expect(dataCriteria.getCriteriaType()).toBe 'medication_order'
    expect(dataCriteria.isPeriodType()).toBe true
    expect(dataCriteria.getPrimaryTimingAttribute()).toBe 'relevantPeriod'

  it "specifies 'Diagnosis' to have a prevalence period", ->
    patients = new Thorax.Collections.Patients [getJSONFixture('patients/CMS146v6/Pass_IPP.json')], parse: true
    patient = patients.first()

    dataCriteria = patient.get('source_data_criteria').at(0)
    expect(dataCriteria.getCriteriaType()).toBe 'condition'
    expect(dataCriteria.isPeriodType()).toBe true
    expect(dataCriteria.getPrimaryTimingAttribute()).toBe 'prevalencePeriod'

  it "specifies 'Assessment, Recommended' to have an authorDatetime", ->
    dataElement = new cqm.models.AssessmentRecommended()
    dataCriteria = new Thorax.Models.SourceDataCriteria({qdmDataElement: dataElement})
    expect(dataCriteria.getCriteriaType()).toBe 'assessment_recommended'
    expect(dataCriteria.isPeriodType()).toBe false
    expect(dataCriteria.getPrimaryTimingAttribute()).toBe 'authorDatetime'

  it "copies description onto qdmDataElement when cloned", ->
    dataElement = new cqm.models.AssessmentRecommended()
    dataElement.description = 'WithoutSpaces'
    dataCriteria = new Thorax.Models.SourceDataCriteria({qdmDataElement: dataElement, description: 'With Spaces'})
    expect(dataCriteria.clone().get('qdmDataElement').description).toBe 'With Spaces'

