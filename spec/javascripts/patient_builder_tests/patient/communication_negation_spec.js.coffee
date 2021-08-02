describe 'CommunicationNegation', ->
  beforeEach (done) ->
    jasmine.DEFAULT_TIMEOUT_INTERVAL = 20000;
    jasmine.getJSONFixtures().clearCache()
    @measure = loadFhirMeasure 'fhir_measures/CommunicationTest/communication_test_measure.json'
    @patients = new Thorax.Collections.Patients [getJSONFixture('fhir_patients/CommunicationTest/communication_negation.json')], parse: true
    @patient = @patients.models[0]
    @bonnie_measures_old = bonnie.measures
    bonnie.measures = new Thorax.Collections.Measures()
    bonnie.measures.add @measure
    @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure, patients: @patients)
    @patientBuilder.appendTo 'body'
    @patientBuilder.render()
    setTimeout(() ->
      try
        done()
      catch err
        done.fail(err)
    , 1)

  afterEach ->
    @patientBuilder.remove()

  it "has a default category as primary timing attribute", ->
    communicationResource = @patientBuilder.model.get('source_data_criteria').first().get('dataElement').fhir_resource
    category = communicationResource['category']
    expect(communicationResource.resourceType).toEqual('Communication')
    expect(JSON.stringify(category[0].coding))
      .toEqual('[{"system":"http://snomed.info/sct","version":"2020-09","code":"312903003","display":"Mild nonproliferative retinopathy due to diabetes mellitus (disorder)","userSelected":true}]')

  it "displays negation if it was already set", ->
    communicationView = Object.values(@patientBuilder.editCriteriaCollectionView.children)[1]
    expect(communicationView.model.canHaveNegation()).toEqual(true)
    expect(communicationView.model.get('dataElement').fhir_resource.modifierExtension[0].value.value).toEqual(true)
    expect(communicationView.model.get('dataElement').fhir_resource.status.value).toEqual('not-done')
    expect(JSON.stringify(communicationView.model.get('dataElement').fhir_resource.statusReason.coding))
      .toEqual('[{"system":"http://snomed.info/sct","version":null,"code":"105480006","display":"Refusal of treatment by patient (situation)","userSelected":true}]')
    expect(communicationView.model.get('dataElement').fhir_resource.extension[0].url.value)
      .toEqual(NegationHelpers.QICORE_RECORDED_URL)
    expect(JSON.stringify(communicationView.model.get('dataElement').fhir_resource.reasonCode[0].coding[0].extension))
      .toEqual('[{"url":"http://hl7.org/fhir/StructureDefinition/valueset-reference","valueUri":"urn:uuid:ede31fab-babc-4769-b242-9eebd2ed7a7b"}]')

  it "sets negation with all the necessary attributes", ->
    communicationView = Object.values(@patientBuilder.editCriteriaCollectionView.children)[0]
    expect(communicationView.model.canHaveNegation()).toEqual(true)
    # before clicking on negation checkbox, no negation extension
    expect(communicationView.model.get('dataElement').fhir_resource.modifierExtension).toBeUndefined()
    # click on negation checkbox
    communicationView.$el.find('input[name="negation"]').trigger('click')
    # verify if modifierExtension for negation is set
    expect(communicationView.model.get('dataElement').fhir_resource.modifierExtension[0].url.value)
      .toEqual(NegationHelpers.QICORE_NOT_DONE_URL)
    expect(communicationView.model.get('dataElement').fhir_resource.modifierExtension[0].value.value.value).toEqual(true)
    # set not-done status
    communicationView.negationRationaleView.status.$el.find("select[name='valueset']").val('2.16.840.1.113883.4.642.3.109').change()
    communicationView.negationRationaleView.status.$el.find("select[name='vs_code']").val('not-done').change()
    expect(communicationView.model.get('dataElement').fhir_resource.status.value).toEqual('not-done')
    # set statusReason
    communicationView.negationRationaleView.statusReason.$el.find("select[name='valueset']").val('2.16.840.1.113762.1.4.1021.56').change()
    expect(JSON.stringify(communicationView.model.get('dataElement').fhir_resource.statusReason.coding))
      .toEqual('[{"system":"http://snomed.info/sct","code":"183932001","display":"Procedure contraindicated (situation)","userSelected":true}]')

    # set recorded Date Time
    communicationView.negationRationaleView.recordedDateTime.$el.find("input[name='date_is_defined']").trigger('click')
    expect(communicationView.model.get('dataElement').fhir_resource.extension[0].url.value)
      .toEqual(NegationHelpers.QICORE_RECORDED_URL)

    # set reasonCode
    communicationView.negationRationaleView.reasonCode.$el.find("select[name='valueset']").val('drc-e00384f945cf589f5153bbe56a6a0de12cdd18eaeb2889fc0d38ac4b30298698').change()
    expect(JSON.stringify(communicationView.model.get('dataElement').fhir_resource.reasonCode[0].coding[0].extension))
      .toEqual('[{"url":"http://hl7.org/fhir/StructureDefinition/valueset-reference","valueUri":"urn:uuid:ab99fafd-c95f-4616-a80b-94efa0ed0482"}]')
