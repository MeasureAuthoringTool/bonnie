describe 'EditCriteriaView', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @measure = loadMeasureWithValueSets 'cqm_measure_data/core_measures/CMS134/CMS134v6.json', 'cqm_measure_data/core_measures/CMS134/value_sets.json'
    @patients = new Thorax.Collections.Patients [getJSONFixture('patients/CMS134v6/Elements_Test.json'), getJSONFixture('patients/CMS134v6/Fail_Hospice_Not_Performed_Denex.json')], parse: true
    @patient = @patients.models[1]
    @bonnie_measures_old = bonnie.measures
    bonnie.measures = new Thorax.Collections.Measures()
    bonnie.measures.add @measure
    @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure, patients: @patients)
    @patientBuilder.render()

    # grab the first edit criteria view which is a diagnosis
    @diagnosisView = Object.values(@patientBuilder.editCriteriaCollectionView.children)[0]

    # grab the sencond edit criteria view which is an encounter
    @encounterView = Object.values(@patientBuilder.editCriteriaCollectionView.children)[1]

  it 'should update prevalentPeriod interval when start_date update is made', ->
    prevalenceView = @diagnosisView.timingAttributeViews[0]
    # check the correct attribute is in place for primary timing attribute
    expect(prevalenceView.attributeName).toBe 'prevalencePeriod'
    # check start date is correct
    expect(prevalenceView.$el.find("input[name='start_date']").val()).toBe('02/17/1949')
    # change start date
    prevalenceView.$el.find("input[name='start_date']").val('02/15/2012').datepicker('update')
    # check that it changed on the data element
    expect(@diagnosisView.model.get('qdmDataElement').prevalencePeriod.low).toEqual(new cqm.models.CQL.DateTime(2012, 2, 15, 9, 0, 0, 0, 0))

  it 'should update authorDatetime when date update is made', ->
    authorDatetimeView = @diagnosisView.timingAttributeViews[1]
    # check the correct attribute is in place for primary timing attribute
    expect(authorDatetimeView.attributeName).toBe 'authorDatetime'
    # check date is correct
    expect(authorDatetimeView.$el.find("input[name='date']").val()).toBe('02/17/1949')
    # change date
    authorDatetimeView.$el.find("input[name='date']").val('02/15/2012').datepicker('update')
    # check that it changed on the data element
    expect(@diagnosisView.model.get('qdmDataElement').authorDatetime).toEqual(new cqm.models.CQL.DateTime(2012, 2, 15, 9, 0, 0, 0, 0))

  it 'should update authorDatetime when time update is made', ->
    authorDatetimeView = @diagnosisView.timingAttributeViews[1]
    # change time
    authorDatetimeView.$el.find("input[name='time']").val('9:45 AM').timepicker('setTime', '9:45 AM')
    # check that it changed on the data element
    expect(@diagnosisView.model.get('qdmDataElement').authorDatetime).toEqual(new cqm.models.CQL.DateTime(1949, 2, 17, 9, 45, 0, 0, 0))

  it 'should null out authorDatetime when datetime is unchecked', ->
    authorDatetimeView = @diagnosisView.timingAttributeViews[1]
    # uncheck
    authorDatetimeView.$el.find("input[name='date_is_defined']").prop('checked', false).change()
    # check that it changed on the data element
    expect(@diagnosisView.model.get('qdmDataElement').authorDatetime).toBe(null)

  it 'should update relevantPeriod interval when update is made', ->
    relevantView = @encounterView.timingAttributeViews[0]
    # check the correct attribute is in place for primary timing attribute
    expect(relevantView.attributeName).toBe 'relevantPeriod'
    # check end date is correct
    expect(relevantView.$el.find("input[name='start_date']").val()).toBe('02/02/2012')
    # change end date
    relevantView.$el.find("input[name='end_date']").val('02/03/2012').datepicker('update')
    relevantView.$el.find("input[name='end_time']").val('9:45 AM').timepicker('setTime', '9:45 AM')

    # check that it changed on the data element
    newStart = new cqm.models.CQL.DateTime(2012, 2, 2, 8, 45, 0, 0, 0)
    newEnd = new cqm.models.CQL.DateTime(2012, 2, 3, 9, 45, 0, 0, 0)
    newInterval = new cqm.models.CQL.Interval(newStart, newEnd)
    expect(@encounterView.model.get('qdmDataElement').relevantPeriod).toEqual(newInterval)

  it 'should update relevantPeriod interval when update is made to have end of null', ->
    relevantView = @encounterView.timingAttributeViews[0]

    # uncheck end
    relevantView.$el.find("input[name='end_date_is_defined']").prop('checked', false).change()

    # check that it changed on the data element
    start = new cqm.models.CQL.DateTime(2012, 2, 2, 8, 45, 0, 0, 0)
    expect(@encounterView.model.get('qdmDataElement').relevantPeriod).toEqual(new cqm.models.CQL.Interval(start, null))

  it 'should update relevantPeriod interval when update is made to have start of null', ->
    relevantView = @encounterView.timingAttributeViews[0]

    # uncheck start
    relevantView.$el.find("input[name='start_date_is_defined']").prop('checked', false).change()

    # check that it changed on the data element
    end = new cqm.models.CQL.DateTime(2012, 2, 2, 8, 45, 0, 0, 0)
    expect(@encounterView.model.get('qdmDataElement').relevantPeriod).toEqual(new cqm.models.CQL.Interval(null, end))

  it 'should update relevantPeriod interval when update is made to Interval[null,null]', ->
    relevantView = @encounterView.timingAttributeViews[0]

    # set start and end to null
    relevantView.$el.find("input[name='end_date_is_defined']").prop('checked', false).change()
    relevantView.$el.find("input[name='start_date_is_defined']").prop('checked', false).change()

    # check that it changed on the data element
    expect(@encounterView.model.get('qdmDataElement').relevantPeriod).toEqual(new cqm.models.CQL.Interval(null, null))
