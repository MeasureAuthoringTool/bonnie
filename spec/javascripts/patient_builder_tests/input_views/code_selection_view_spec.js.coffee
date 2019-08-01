describe 'Code Selection View', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @measure = loadMeasureWithValueSets('cqm_measure_data/CMS160v6/CMS160v6.json', 'cqm_measure_data/CMS160v6/value_sets.json')
    bonnie.measures.add(@measure, { parse: true })
    @patients = new Thorax.Collections.Patients [getJSONFixture('patients/CMS160v6/Expired_DENEX.json')], parse: true
    @patient = @patients.first()
    @dataCriteria = @patient.get('source_data_criteria').first()
    @patientBuilder = new Thorax.Views.PatientBuilder(model: @patients.first(), measure: @measure)
    @patientBuilder.appendTo('body')

  afterEach ->
    @patientBuilder.remove()

  it "EditCriteriaValueView displays correct systems", ->
    editCriteriaView = new Thorax.Views.EditCriteriaView(model: @dataCriteria, measure: @measure)
    editCodeSelectionView = editCriteriaView.editCodeSelectionView

    # The dateria saved to the patient with codeListId:2.16.840.1.113883.3.67.1.101.1.254 should have:
    # 2 Code Systems
    # A total of 2 codes
    expect(editCodeSelectionView.codes.length).toEqual(2)
    expect(editCodeSelectionView.codeSystems.includes("SNOMED-CT")).toBe true
    expect(editCodeSelectionView.codeSystems.includes("ICD-10-CM")).toBe true

  it "EditCriteriaValueView selects default code after deletion", ->
    # delete the 2 codes on the first sdc
    $('button[data-call-method="removeCode"]')[0].click()
    $('button[data-call-method="removeCode"]')[0].click()

    # the default code should still exist, along with 1 code for the other sdc
    expect($('button[data-call-method="removeCode"]').length).toEqual(2)

