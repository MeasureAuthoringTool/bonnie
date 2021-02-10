describe 'EditCodeDisplayView/EditCodeSelectionView', ->
  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @measure = loadFhirMeasure 'fhir_measures/CMS108/CMS108.json'
    bonnie.measures.add(@measure, { parse: true })
    @patients = new Thorax.Collections.Patients [ getJSONFixture('fhir_patients/CMS108/john_smith.json') ], parse: true
    @patient = @patients.first()
    @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure)
    @encounter_element = @patientBuilder.model.get('cqmPatient').data_elements.find((element) -> element?.fhir_resource?.resourceType == "Encounter")
    @patientBuilder.appendTo('body')
    @addCode = (codeSystem, code) ->
      @patientBuilder.$('[name=codesystem]:first').val(codeSystem).change()
      $codelist = @patientBuilder.$('.codelist-control:first')
      $codelist.val(code).change()
      $('button[data-call-method="addCode"]')[0].click()
    @addCustomCode = (codeSystem, code) ->
      @patientBuilder.$('[name=codesystem]:first').val('custom').change()
      @patientBuilder.$('[name=custom_codesystem]:first').val(codeSystem).change()
      @patientBuilder.$('[name=custom_code]:first').val(code).change().keyup()
      $('button[data-call-method="addCode"]')[0].click()

  afterEach ->
    @patientBuilder.remove()

  it "displays correct systems", ->
    dataCriteria = @patient.get('source_data_criteria').last()
    editCriteriaView = new Thorax.Views.EditCriteriaView(model: dataCriteria, measure: @measure)
    editCodeSelectionView = editCriteriaView.editCodeSelectionView

    # A total of codes
    expect(editCodeSelectionView.codes.length).toEqual(2)
    # Coding
    expect(editCodeSelectionView.codes[0].code.value).toEqual('183452005')
    expect(editCodeSelectionView.codes[0].system.value).toEqual('http://snomed.info/sct')
    # Systems
    expect(editCodeSelectionView.codeSystems.includes("SNOMEDCT")).toBe true

  it "selects default code after deletion", ->
    expect($('button[data-call-method="removeCode"]').length).toEqual(2)

    # delete the code
    $('button[data-call-method="removeCode"]')[0].click()

    # the default code should still exist, along with 1 code for the other sdc
    expect($('button[data-call-method="removeCode"]').length).toEqual(1)

  it "displays correct text for a code on the UI", ->
    expect($('.existing-values:first').text().includes('SNOMEDCT')).toBe true
    # First code
    expect($('.existing-values:first').text().includes('183452005')).toBe true
    # Second code
    expect($('.existing-values:first').text().includes('32485007')).toBe true

    @addCode('SNOMEDCT', '8715000')
    expect($('.existing-values:first').text().includes('SNOMEDCT')).toBe true
    expect($('.existing-values:first').text().includes('8715000')).toBe true

  it "duplicate codes not added to the patient", ->
    expect($('.existing-values:first')[0].childElementCount).toEqual(2)
    @addCode('SNOMEDCT', '32485007') # Code that already exists on the patient
    @addCode('SNOMEDCT', '183452005') # Code that already exists on the patient
    @addCode('SNOMEDCT', '8715000')
    expect($('.existing-values:first')[0].childElementCount).toEqual(3)
    expect(@encounter_element.fhir_resource?.type[0]?.coding.length).toEqual(3)

  it "can add and remove custom codes properly", ->
    @addCustomCode('SPAM', 'EGGS')
    @addCustomCode('BOSTON', 'POPS')
    @addCustomCode('FOO', 'BAR')
    expect($('.existing-values:first')[0].childElementCount).toEqual(5)
    $('button[data-call-method="removeCode"]')[2].click()
    $('button[data-call-method="removeCode"]')[3].click()
    expect($('.existing-values:first')[0].childElementCount).toEqual(3)

  it "adds default code back after removing original default codes and custom code", ->
    @addCustomCode('SPAM', 'EGGS')
    expect($('.existing-values:first')[0].childElementCount).toEqual(3)
    $('button[data-call-method="removeCode"]')[0].click()
    $('button[data-call-method="removeCode"]')[0].click()
    expect($('.existing-values:first')[0].childElementCount).toEqual(1)
    expect($('.existing-values:first').text().includes('SNOMEDCT')).toBe false
    expect($('.existing-values:first').text().includes('183452005')).toBe false
    expect($('.existing-values:first').text().includes('32485007')).toBe false
    expect($('.existing-values:first').text().includes('SPAM')).toBe true

    # After removing ths custom code that still exists, the default code should be added back
    $('button[data-call-method="removeCode"]')[0].click()
    expect($('.existing-values:first')[0].childElementCount).toEqual(1)
    expect($('.existing-values:first').text().includes('SNOMEDCT')).toBe true

  it "adds codes and can remove them properly left to right", ->
    @addCode('SNOMEDCT', '8715000')
    @addCustomCode('SPAM', 'EGGS')
    @addCustomCode('BOSTON', 'POPS')
    @addCustomCode('FOO', 'BAR')
    expect($('.existing-values:first')[0].childElementCount).toEqual(6)
    expect(@encounter_element.fhir_resource?.type[0]?.coding.length).toEqual(6)
    $('button[data-call-method="removeCode"]')[0].click()
    $('button[data-call-method="removeCode"]')[0].click()
    $('button[data-call-method="removeCode"]')[0].click()
    $('button[data-call-method="removeCode"]')[0].click()
    $('button[data-call-method="removeCode"]')[0].click()
    $('button[data-call-method="removeCode"]')[0].click()
    # When the last one is deleted, a default one is added back
    expect($('.existing-values:first')[0].childElementCount).toEqual(1)
    expect(@encounter_element.fhir_resource?.type[0]?.coding.length).toEqual(1)

  it "adds codes and can remove them properly right to left", ->
    @addCode('SNOMEDCT', '8715000')
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
    # When the last one is deleted, a default one is added back
    expect($('.existing-values:first')[0].childElementCount).toEqual(1)
