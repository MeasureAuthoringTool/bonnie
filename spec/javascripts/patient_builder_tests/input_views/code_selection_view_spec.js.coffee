describe 'Code Selection View', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @measure = loadMeasureWithValueSets('cqm_measure_data/CMS160v6/CMS160v6.json', 'cqm_measure_data/CMS160v6/value_sets.json')
    bonnie.measures.add(@measure, { parse: true })
    @patients = new Thorax.Collections.Patients [getJSONFixture('patients/CMS160v6/Expired_DENEX.json')], parse: true
    @patient = @patients.first()
    @patientBuilder = new Thorax.Views.PatientBuilder(model: @patients.first(), measure: @measure)
    @diagnosis_element = @patientBuilder.model.get('cqmPatient').qdmPatient.dataElements.find((element) -> element._type == "QDM::Diagnosis")
    @patientBuilder.appendTo('body')
    @addCode = (codeSet, code, submit = true) ->
      @patientBuilder.$('[name=codesystem]:first').val(codeSet).change()
      $codelist = @patientBuilder.$('.codelist-control:first')
      $codelist.val(code).change()
      $('button[data-call-method="addCode"]')[0].click()
    @addCustomCode = (codeSystem, code, submit = true) ->
      @patientBuilder.$('[name=codesystem]:first').val('custom').change()
      @patientBuilder.$('[name=custom_codesystem]:first').val(codeSystem).change()
      @patientBuilder.$('[name=custom_code]:first').val(code).change().keyup()
      $('button[data-call-method="addCode"]')[0].click()

  afterEach ->
    @patientBuilder.remove()

  it "EditCriteriaValueView displays correct systems", ->
    dataCriteria = @patient.get('source_data_criteria').first()
    editCriteriaView = new Thorax.Views.EditCriteriaView(model: dataCriteria, measure: @measure)
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

  it "EditCriteriaValueView displays correct text for a code on the UI", ->
    expect($('.existing-values:first').text().includes('SNOMED-CT')).toBe true
    expect($('.existing-values:first').text().includes('19694002')).toBe true
    expect($('.existing-values:first').text().includes('(Late onset dysthymia (disorder))')).toBe false
    expect($('.existing-values:first').text().includes('ICD-10-CM')).toBe true
    expect($('.existing-values:first').text().includes('F34.1')).toBe true
    @addCode('SNOMED-CT', '3109008') 
    expect($('.existing-values:first').text().includes('SNOMED-CT')).toBe true
    expect($('.existing-values:first').text().includes('3109008')).toBe true
    expect($('.existing-values:first').text().includes('(Secondary dysthymia early onset (disorder))')).toBe false

  it "EditCriteriaValueView duplicate codes not added to the patient", ->
    expect($('.existing-values:first')[0].childElementCount).toEqual(2)
    @addCode('SNOMED-CT', '3109008')
    @addCode('SNOMED-CT', '19694002') # Code that already exists on the patient
    @addCode('ICD-10-CM', 'F34.1') # Code that already exists on the patient
    expect($('.existing-values:first')[0].childElementCount).toEqual(3)
    expect(@diagnosis_element.dataElementCodes.length).toEqual(3)

  it "EditCriteriaValueView can add and remove custom codes properly", ->
    @addCustomCode('SPAM', 'EGGS')
    @addCustomCode('BOSTON', 'POPS')
    @addCustomCode('FOO', 'BAR')
    expect($('.existing-values:first')[0].childElementCount).toEqual(5)
    $('button[data-call-method="removeCode"]')[2].click()
    $('button[data-call-method="removeCode"]')[3].click()
    expect($('.existing-values:first')[0].childElementCount).toEqual(3)

  it "EditCriteriaValueView adds default code back after removing original default codes and custom code", ->
    @addCustomCode('SPAM', 'EGGS')
    expect($('.existing-values:first')[0].childElementCount).toEqual(3)
    $('button[data-call-method="removeCode"]')[0].click()
    $('button[data-call-method="removeCode"]')[0].click()
    expect($('.existing-values:first')[0].childElementCount).toEqual(1)
    expect($('.existing-values:first').text().includes('SNOMED-CT')).toBe false
    expect($('.existing-values:first').text().includes('F34.1')).toBe false
    expect($('.existing-values:first').text().includes('SPAM')).toBe true

    # After removing ths custom code that still exists, the default code should be added back
    $('button[data-call-method="removeCode"]')[0].click()
    expect($('.existing-values:first')[0].childElementCount).toEqual(1)
    expect($('.existing-values:first').text().includes('SNOMED-CT')).toBe true

  it "EditCriteriaValueView adds codes and can remove them properly left to right", ->
    @addCode('SNOMED-CT', '3109008')
    @addCustomCode('SPAM', 'EGGS')
    @addCustomCode('BOSTON', 'POPS')
    @addCustomCode('FOO', 'BAR')
    expect($('.existing-values:first')[0].childElementCount).toEqual(6)
    expect(@diagnosis_element.dataElementCodes.length).toEqual(6)
    $('button[data-call-method="removeCode"]')[0].click()
    $('button[data-call-method="removeCode"]')[0].click()
    $('button[data-call-method="removeCode"]')[0].click()
    $('button[data-call-method="removeCode"]')[0].click()
    $('button[data-call-method="removeCode"]')[0].click()
    $('button[data-call-method="removeCode"]')[0].click()
    expect($('.existing-values:first')[0].childElementCount).toEqual(1)
    expect(@diagnosis_element.dataElementCodes.length).toEqual(1)

  it "EditCriteriaValueView adds codes and can remove them properly right to left", ->
    @addCode('SNOMED-CT', '3109008')
    @addCustomCode('SPAM', 'EGGS')
    @addCustomCode('BOSTON', 'POPS')
    @addCustomCode('FOO', 'BAR')
    expect($('.existing-values:first')[0].childElementCount).toEqual(6)
    $('button[data-call-method="removeCode"]')[5].click()
    $('button[data-call-method="removeCode"]')[4].click()
    $('button[data-call-method="removeCode"]')[3].click()
    $('button[data-call-method="removeCode"]')[2].click()
    $('button[data-call-method="removeCode"]')[1].click()
    $('button[data-call-method="removeCode"]')[0].click()
    expect($('.existing-values:first')[0].childElementCount).toEqual(1)
