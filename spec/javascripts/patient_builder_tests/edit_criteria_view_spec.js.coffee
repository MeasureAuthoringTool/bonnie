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

  afterEach ->
    @patientBuilder.remove()

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
