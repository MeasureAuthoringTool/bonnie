describe 'EditCriteriaView', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    measureJSON = getJSONFixture('fhir_measures/CMS104/CMS104.json');
    @measure = new Thorax.Models.Measure(measureJSON, {parse: true});
    @patients = new Thorax.Collections.Patients [getJSONFixture('fhir_patients/CMS104/john_doe.json'), getJSONFixture('fhir_patients/CMS104/jane_doe.json')], parse: true
    @patient = @patients.models[0]
    bonnie.measures = new Thorax.Collections.Measures()
    bonnie.measures.add @measure
    @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure, patients: @patients)
    @patientBuilder.appendTo 'body'
    @patientBuilder.render()

    # grab the first edit criteria view which is a ServiceRequest
    @serviceRequestView = Object.values(@patientBuilder.editCriteriaCollectionView.children)[0]

    # grab the second edit criteria view which is an Encounter
    @encounterView = Object.values(@patientBuilder.editCriteriaCollectionView.children)[1]

    # grab third edit criteria view, Condition targeted by Encounter.diagnosis.condition reference
    @conditionView = Object.values(@patientBuilder.editCriteriaCollectionView.children)[2]

  afterEach ->
    @patientBuilder.remove()

  it 'displays the FHIR ID', ->
    expect(@encounterView.model.get('dataElement').fhir_resource.id).toBeDefined()
    expect(@encounterView.$el.find(".pull-left p").map(() -> $(this).text()).get())
      .toContain('FHIR ID: ' + @encounterView.model.get('dataElement').fhir_resource.id)

  it 'should update encounter.period when start date is updated', ->
    periodView = @encounterView.timingAttributeViews[0]
    # check the correct attribute is in place for primary timing attribute
    expect(periodView.attributeName).toBe 'period'
    # check start date is correct
    expect(periodView.$el.find("input[name='start_date']").val()).toBe('09/23/2020')
    # change start date
    periodView.$el.find("input[name='start_date']").val('09/24/2020').datepicker('update')
    # check that it changed on the data element
    expect(@encounterView.model.get('dataElement').fhir_resource['period'].start.value).toEqual(new cqm.models.CQL.DateTime(2020, 9, 24, 8, 0, 0, 0, 0).toString())
    # check that it was changed using route through patientBuilder.model
    expect(@patientBuilder.model.get('cqmPatient').data_elements[1].fhir_resource['period'].start.value).toEqual(new cqm.models.CQL.DateTime(2020, 9, 24, 8, 0, 0, 0, 0).toString())

  it 'should update ServiceRequest.authoredOn when date update is made', ->
    authoredOnDateTimeView = @serviceRequestView.timingAttributeViews[0]
    # check the correct attribute is in place for primary timing attribute
    expect(authoredOnDateTimeView.attributeName).toBe 'authoredOn'
    expect(authoredOnDateTimeView.attributeTitle).toBe 'authored On'
    # check date is correct
    expect(authoredOnDateTimeView.$el.find("input[name='date']").val()).toBe('09/23/2020')
    # change date
    authoredOnDateTimeView.$el.find("input[name='date']").val('09/24/2020').datepicker('update')
    # check that it changed on the data element
    expect(@serviceRequestView.model.get('dataElement').fhir_resource['authoredOn'].value).toEqual(new cqm.models.CQL.DateTime(2020, 9, 24, 8, 0, 0, 0, 0).toString())
    # check that it was changed using route through patientBuilder.model
    expect(@patientBuilder.model.get('cqmPatient').data_elements[0].fhir_resource['authoredOn'].value).toEqual(new cqm.models.CQL.DateTime(2020, 9, 24, 8, 0, 0, 0, 0).toString())

  it 'should update ServiceRequest.authoredOn when time update is made', ->
    authoredOnDateTimeView = @serviceRequestView.timingAttributeViews[0]
    # change time
    authoredOnDateTimeView.$el.find("input[name='time']").val('9:45 AM').timepicker('setTime', '9:45 AM')
    # check that it changed on the data element
    expect(@serviceRequestView.model.get('dataElement').fhir_resource['authoredOn'].value).toEqual(new cqm.models.CQL.DateTime(2020, 9, 23, 9, 45, 0, 0, 0).toString())
    # check that it was changed using route through patientBuilder.model
    expect(@patientBuilder.model.get('cqmPatient').data_elements[0].fhir_resource['authoredOn'].value).toEqual(new cqm.models.CQL.DateTime(2020, 9, 23, 9, 45, 0, 0, 0).toString())

  it 'should null out ServiceRequest.authoredOn when datetime is unchecked', ->
    authoredOnDateTimeView = @serviceRequestView.timingAttributeViews[0]
    # uncheck datetime checkbox
    authoredOnDateTimeView.$el.find("input[name='date_is_defined']").prop('checked', false).change()
    # check that it changed on the data element
    expect(@serviceRequestView.model.get('dataElement').fhir_resource['authoredOn'].value).toBe(undefined)
    # check that it was changed using route through patientBuilder.model
    expect(@patientBuilder.model.get('cqmPatient').data_elements[0].fhir_resource['authoredOn'].value).toBe(undefined)

  it 'should update Encounter.period when both start and end date is updated', ->
    periodView = @encounterView.timingAttributeViews[0]
    # check the correct attribute is in place for primary timing attribute
    expect(periodView.attributeName).toBe 'period'
    # change start date
    periodView.$el.find("input[name='start_date']").val('09/24/2020').datepicker('update')
    # change end date
    periodView.$el.find("input[name='end_date']").val('09/25/2020').datepicker('update')
    # change end time
    periodView.$el.find("input[name='end_time']").val('9:45 AM').timepicker('setTime', '9:45 AM')

    # check that it changed on the data element
    newStart = new cqm.models.CQL.DateTime(2020, 9, 24, 8, 0, 0, 0, 0)
    newEnd = new cqm.models.CQL.DateTime(2020, 9, 25, 9, 45, 0, 0, 0)
    expect(@encounterView.model.get('dataElement').fhir_resource['period'].start.value).toEqual(newStart.toString())
    expect(@encounterView.model.get('dataElement').fhir_resource['period'].end.value).toEqual(newEnd.toString())
    # check that it was changed using route through patientBuilder.model
    expect(@patientBuilder.model.get('cqmPatient').data_elements[1].fhir_resource['period'].start.value).toEqual(newStart.toString())
    expect(@patientBuilder.model.get('cqmPatient').data_elements[1].fhir_resource['period'].end.value).toEqual(newEnd.toString())

  it 'should update Encounter.period when update is made to have end of null', ->
    periodView = @encounterView.timingAttributeViews[0]

    # uncheck end date
    periodView.$el.find("input[name='end_date_is_defined']").prop('checked', false).change()

    # check that it changed on the data element
    start = new cqm.models.CQL.DateTime(2020, 9, 23, 8, 0, 0, 0, 0)
    expect(@encounterView.model.get('dataElement').fhir_resource['period'].start.value).toEqual(start.toString())
    expect(@encounterView.model.get('dataElement').fhir_resource['period'].end).toEqual(null)
    # check that it was changed using route through patientBuilder.model
    expect(@patientBuilder.model.get('cqmPatient').data_elements[1].fhir_resource['period'].start.value).toEqual(start.toString())
    expect(@patientBuilder.model.get('cqmPatient').data_elements[1].fhir_resource['period'].end).toEqual(null )

  it 'should update Encounter.period when update is made to have start of null', ->
    periodView = @encounterView.timingAttributeViews[0]
    # uncheck start date
    periodView.$el.find("input[name='start_date_is_defined']").prop('checked', false).change()

    # check that it changed on the data element
    end = new cqm.models.CQL.DateTime(2020, 9, 30, 8, 15, 0, 0, 0)
    expect(@encounterView.model.get('dataElement').fhir_resource['period'].start).toEqual(null)
    expect(@encounterView.model.get('dataElement').fhir_resource['period'].end.value).toEqual(end.toString())
    # check that it was changed using route through patientBuilder.model
    expect(@patientBuilder.model.get('cqmPatient').data_elements[1].fhir_resource['period'].start).toEqual(null)
    expect(@patientBuilder.model.get('cqmPatient').data_elements[1].fhir_resource['period'].end.value).toEqual(end.toString())

  it 'should update Encounter.period when update is made to set both the start and end to be null', ->
    periodView = @encounterView.timingAttributeViews[0]

    # set start and end to null
    periodView.$el.find("input[name='end_date_is_defined']").prop('checked', false).change()
    periodView.$el.find("input[name='start_date_is_defined']").prop('checked', false).change()

    # check that it changed on the data element
    expect(@encounterView.model.get('dataElement').fhir_resource['period'].start).toEqual(null)
    expect(@encounterView.model.get('dataElement').fhir_resource['period'].end).toEqual(null)
    # check that it was changed using route through patientBuilder.model
    expect(@patientBuilder.model.get('cqmPatient').data_elements[1].fhir_resource['period'].start).toEqual(null)
    expect(@patientBuilder.model.get('cqmPatient').data_elements[1].fhir_resource['period'].end).toEqual(null)

  it 'displays the Extensions if there are any', ->
    displayExtensionsView = @serviceRequestView.displayExtensionsView
    expect(displayExtensionsView).toBeDefined();
    expect(displayExtensionsView.context().extensions[0].url).toEqual 'testextension'
    expect(displayExtensionsView.context().extensions[0].values[0].value).toEqual "3.0 'day'"
    expect(displayExtensionsView.$el.find("a.extension-url span").text()).toEqual('testextension')
    expect(displayExtensionsView.$el.find("div.extension-value span").text()).toContain("3.0 'day")

  it 'does not display Extensions if there nno extensions', ->
    displayExtensionsView = @encounterView.displayExtensionsView
    expect(displayExtensionsView).toBeDefined();
    # No extension in view context
    expect(displayExtensionsView.context().extensions).toEqual []
    # No extension in the model
    extensions = @encounterView.model.get('dataElement').fhir_resource['extension']
    expect(extensions).toBeUndefined()

  it 'removes an Extension', (done) ->
    displayExtensionsView = @serviceRequestView.displayExtensionsView
    expect(displayExtensionsView).toBeDefined();
    expect(@serviceRequestView.model.get('dataElement').fhir_resource['extension'].length).toEqual 1
    # expand the extension
    displayExtensionsView.$el.find("a.extension-url").click()

    modelRef = @serviceRequestView.model
    setTimeout(() ->
      try
        # click delete extension button
        displayExtensionsView.$el.find("button.delete-extension-btn").click()
        expect(modelRef.get('dataElement').fhir_resource['extension'].length).toEqual 0
        done()
      catch err
        done.fail(err)
    , 1)

  it 'adds an Extensions', ->
    displayExtensionsView = @encounterView.addExtensionsView
    expect(displayExtensionsView).toBeDefined();
    # No extension in the model
    expect(displayExtensionsView.dataElement.fhir_resource['extension']).toBeUndefined()
    # enter url
    displayExtensionsView.$el.find("input[name='url']").val('testext').change()
    # select value
    displayExtensionsView.$el.find("select[name='value_type']").val('Boolean').change()
    # add extension
    displayExtensionsView.$el.find("button.add_extension_btn").click()
    extensions = displayExtensionsView.dataElement.fhir_resource['extension']
    # 1 extension added
    expect(extensions.length).toEqual 1
    expect(extensions[0].url.value).toEqual 'testext'
    expect(extensions[0].value.value).toBeTruthy()

    # add one more extension but without value
    displayExtensionsView.$el.find("input[name='url']").val('someotherextension').change()
    displayExtensionsView.$el.find("button.add_extension_btn").click()
    expect(extensions.length).toEqual 2

  it 'adds an extension and validates the extension values', ->
    displayExtensionsView = @encounterView.addExtensionsView
    expect(displayExtensionsView).toBeDefined();
    # add extension button is disabled initially
    expect(displayExtensionsView.$el.find("button.add_extension_btn").attr('disabled')).toEqual('disabled')
    # enter url
    displayExtensionsView.$el.find("input[name='url']").val('testext').change()
    # add extension button is enabled
    expect(displayExtensionsView.$el.find("button.add_extension_btn").attr('disabled')).toBeUndefined()
    # select Age value
    displayExtensionsView.$el.find("select[name='value_type']").val('Age').change()
    # add extension button disabled again because age is not valid yet(age value and ucum unit needs to be there)
    expect(displayExtensionsView.$el.find("button.add_extension_btn").attr('disabled')).toEqual('disabled')
    # enter age value
    displayExtensionsView.$el.find("input[name='value_value']").val('12').change()
    # add extension button still disabled because ucum unit needs to be there
    expect(displayExtensionsView.$el.find("button.add_extension_btn").attr('disabled')).toEqual('disabled')
    # enter invalid ucum unit
    displayExtensionsView.$el.find("input[name='value_unit']").val('testunit').change()
    # button still disabled because invalid ucum unit entered
    expect(displayExtensionsView.$el.find("button.add_extension_btn").attr('disabled')).toEqual('disabled')
    # enter valid ucum unit
    displayExtensionsView.$el.find("input[name='value_unit']").val('day').change()
    # button is not disabled because valid age value and ucum unit now
    expect(displayExtensionsView.$el.find("button.add_extension_btn").attr('disabled')).toBeUndefined()
    # add extension
    displayExtensionsView.$el.find("button.add_extension_btn").click()
    extensions = displayExtensionsView.dataElement.fhir_resource['extension']
    # extension added
    expect(extensions.length).toEqual 1
    expect(extensions[0].url.value).toEqual 'testext'
    expect(extensions[0].value.value.value).toEqual 12
    expect(extensions[0].value.unit.value).toEqual 'day'

  it "sets the saved Reference attribute with the targeted Resource's FHIR ID", ->
    attrEditorView = @encounterView.attributeEditorView
    attrDisplayView = @encounterView.attributeDisplayView
    # Check the fixture has the expected Condition Reference already applied
    expect(attrDisplayView.dataElement.fhir_resource.diagnosis[0].condition.reference.value).toBe 'Condition/hemorrhagic-stroke-6c6b'
    # Select a Procedure Reference
    attrEditorView.$el.find("select[name='attribute_name']").val('diagnosis.condition').change()
    attrEditorView.$el.find("select[name='attribute_type']").val('Reference').change()
    attrEditorView.$el.find("select[name='referenceType']").val('Procedure').change()
    attrEditorView.$el.find("select[name='valueset']").val('custom').change()
    # Check the select input
    expect(attrEditorView.currentAttribute.name).toBe 'diagnosis.condition'
    expect(attrEditorView.inputView.hasValidValue()).toBe true
    # Click the attribute add button
    @encounterView.$el.find(".input-add button[data-call-method='addValue']").click()
    # Check the Condition Reference attribute was replaced with the Procedure Reference
    expect(attrDisplayView.dataElement.fhir_resource.diagnosis[0].condition.reference.value.includes('Procedure/custom')).toBe true

  it 'removes reference attributes when the referenced resource is removed', ->
    # Encounter has a reference to the Condition resource
    conditionFhirId = @conditionView.model.get('dataElement').fhir_resource.id
    expect(@encounterView.model.get('dataElement').fhir_resource['diagnosis'][0].condition.reference.value.includes(conditionFhirId)).toBe true
    # Delete the condition resource
    @conditionView.$el.find("button.criteria-delete-check").click()
    @conditionView.$el.find("button[data-call-method='removeCriteria']").click()
    # Check that the Encounter's diagnosis.condition was set to null
    expect(@encounterView.model.get('dataElement').fhir_resource['diagnosis'][0].condition).toBe null

  it 'adds existing resource as a reference attribute', ->
    # grab the second 4th criteria view which is an Encounter
    encounterView = Object.values(@patientBuilder.editCriteriaCollectionView.children)[3]
    attrEditorView = encounterView.attributeEditorView
    attrDisplayView = encounterView.attributeDisplayView
    # Fixture does not have Condition Reference already added
    expect(attrDisplayView.dataElement.fhir_resource.diagnosis).toBeUndefined()
    # select existing Condition resource
    attrEditorView.$el.find("select[name='attribute_name']").val('diagnosis.condition').change()
    attrEditorView.$el.find("select[name='referenceType']").val('existing_resources').change()
    attrEditorView.$el.find("select[name='valueset']").val('hemorrhagic-stroke-6c6b').change()

    expect(attrEditorView.currentAttribute.name).toBe 'diagnosis.condition'
    expect(attrEditorView.inputView.value.type).toEqual 'Condition'
    expect(attrEditorView.inputView.value.vs).toEqual 'hemorrhagic-stroke-6c6b'
    # Click the attribute add button
    encounterView.$el.find(".input-add button[data-call-method='addValue']").click()

    # Check the diagnosis.condition Reference attribute set to resource with fhir id 'hemorrhagic-stroke-6c6b'
    expect(attrDisplayView.dataElement.fhir_resource.diagnosis[0].condition.reference.value.includes('Condition/hemorrhagic-stroke-6c6b')).toBe true
