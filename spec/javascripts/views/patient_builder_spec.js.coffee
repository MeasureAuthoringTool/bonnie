describe 'PatientBuilderView', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS134v6/CMS134v6.json', 'cqm_measure_data/CMS134v6/value_sets.json'
    @patients = new Thorax.Collections.Patients [getJSONFixture('patients/CMS134v6/Elements_Test.json'), getJSONFixture('patients/CMS134v6/Fail_Hospice_Not_Performed_Denex.json')], parse: true
    @patient = @patients.models[1]
    @bonnie_measures_old = bonnie.measures
    bonnie.measures = new Thorax.Collections.Measures()
    bonnie.measures.add @measure
    @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure, patients: @patients)
    # TODO: don't rely on first() for this. What should the criteria be?
    @firstCriteria = @patientBuilder.model.get('source_data_criteria').first()
    # Normally the first criteria can't have a value (wrong type); for testing we allow it
    @patientDataElement = @patientBuilder.patients.first().get("cqmPatient").qdmPatient.dataElements[0]
    @patientBuilder.render()
    spyOn(@patientBuilder.model, 'materialize')
    spyOn(@patientBuilder.originalModel, 'save').and.returnValue(true)
    @$el = @patientBuilder.$el

  afterEach ->
    bonnie.measures = @bonnie_measures_old

  it 'should not open patient builder for non existent measure', ->
    spyOn(bonnie,'showPageNotFound')
    bonnie.showPageNotFound.calls.reset()
    bonnie.renderPatientBuilder('non_existant_hqmf_set_id', @patient.id)
    expect(bonnie.showPageNotFound).toHaveBeenCalled()

  it 'should set the main view when calling showPageNotFound', ->
    spyOn(bonnie.mainView,'setView')
    bonnie.renderPatientBuilder('non_existant_hqmf_set_id', @patient.id)
    expect(bonnie.mainView.setView).toHaveBeenCalled()

  it 'renders the builder correctly', ->
    expect(@$el.find(":input[name='first']")).toHaveValue @patient.getFirstName()
    expect(@$el.find(":input[name='last']")).toHaveValue @patient.getLastName()
    expect(@$el.find(":input[name='birthdate']")).toHaveValue @patient.getBirthDate()
    expect(@$el.find(":input[name='birthtime']")).toHaveValue @patient.getBirthTime()
    expect(@$el.find(":input[name='notes']")).toHaveValue @patient.getNotes()


  it 'does not display compare patient results button when there is no history', ->
    expect(@patientBuilder.$('button[data-call-method=showCompare]:first')).not.toExist()

  it "toggles patient expiration correctly", ->
    @patientBuilder.appendTo 'body'
    # Press deceased check box and enter death date
    @patientBuilder.$('input[type=checkbox][name=expired]:first').click()
    @patientBuilder.$(':input[name=deathdate]').val('01/02/1994')
    @patientBuilder.$(':input[name=deathtime]').val('1:15 PM')
    @patientBuilder.$("button[data-call-method=save]").click()
    expect(@patientBuilder.model.get('expired')).toEqual true
    expect(@patientBuilder.model.get('deathdate')).toEqual '01/02/1994'
    expect(@patientBuilder.model.get('deathtime')).toEqual "1:15 PM"
    expiredElement = (@patientBuilder.model.get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'expired')[0]
    expect(expiredElement.expiredDatetime.toString()).toEqual (new cqm.models.CQL.DateTime(1994,1,2,13,15,0,0,0).toString())
    # Remove deathdate from patient
    @patientBuilder.$("button[data-call-method=removeDeathDate]").click()
    @patientBuilder.$("button[data-call-method=save]").click()
    expect(@patientBuilder.model.get('expired')).toEqual false
    expect(@patientBuilder.model.get('deathdate')).toEqual null
    expect(@patientBuilder.model.get('deathtime')).toEqual null
    expiredElement = (@patientBuilder.model.get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'expired')[0]
    expect(expiredElement).not.toExist()
    @patientBuilder.remove()

  describe "setting basic attributes and saving", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'
      @patientBuilder.$(':input[name=last]').val("LAST NAME")
      @patientBuilder.$(':input[name=first]').val("FIRST NAME")
      @patientBuilder.$('select[name=payer]').val('1')
      @patientBuilder.$('select[name=gender]').val('F')
      @patientBuilder.$(':input[name=birthdate]').val('01/02/1993')
      @patientBuilder.$(':input[name=birthtime]').val('1:15 PM')
      @patientBuilder.$('select[name=race]').val('2131-1')
      @patientBuilder.$('select[name=ethnicity]').val('2135-2')
      @patientBuilder.$(':input[name=notes]').val('EXAMPLE NOTES FOR TEST')
      @patientBuilder.$("button[data-call-method=save]").click()

    it "dynamically loads race, ethnicity, gender and payer codes from measure", ->
      expect(@patientBuilder.$('select[name=race]')[0].options.length).toEqual 6
      expect(@patientBuilder.$('select[name=ethnicity]')[0].options.length).toEqual 2
      expect(@patientBuilder.$('select[name=gender]')[0].options.length).toEqual 2
      expect(@patientBuilder.$('select[name=payer]')[0].options.length).toEqual 155

    it "serializes the attributes correctly", ->
      thoraxPatient = @patientBuilder.model
      cqmPatient = thoraxPatient.get('cqmPatient')
      expect(cqmPatient.familyName).toEqual 'LAST NAME'
      expect(cqmPatient.givenNames[0]).toEqual 'FIRST NAME'
      birthdateElement = (cqmPatient.qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'birthdate')[0]
      expect(birthdateElement.birthDatetime.toString()).toEqual (new cqm.models.CQL.DateTime(1993,1,2,13,15,0,0,0).toString())
      expect(cqmPatient.qdmPatient.birthDatetime.toString()).toEqual (new cqm.models.CQL.DateTime(1993,1,2,13,15,0,0,0).toString())
      expect(thoraxPatient.getBirthDate()).toEqual '1/2/1993'
      expect(thoraxPatient.getNotes()).toEqual 'EXAMPLE NOTES FOR TEST'
      expect(thoraxPatient.getGender()).toEqual 'Female'
      genderElement = (cqmPatient.qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'gender')[0]
      expect(genderElement.dataElementCodes[0].code).toEqual 'F'
      raceElement = (cqmPatient.qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'race')[0]
      expect(raceElement.dataElementCodes[0].code).toEqual '2131-1'
      expect(raceElement.dataElementCodes[0].display).toEqual 'Other Race'
      expect(thoraxPatient.getRace()).toEqual 'Other Race'
      ethnicityElement = (cqmPatient.qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'ethnicity')[0]
      expect(ethnicityElement.dataElementCodes[0].code).toEqual '2135-2'
      expect(ethnicityElement.dataElementCodes[0].display).toEqual 'Hispanic or Latino'
      expect(thoraxPatient.getEthnicity()).toEqual 'Hispanic or Latino'
      payerElement = (cqmPatient.qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'payer')[0]
      expect(payerElement.dataElementCodes[0].code).toEqual '1'
      expect(payerElement.dataElementCodes[0].display).toEqual 'MEDICARE'
      expect(@patientBuilder.model.get('payer')).toEqual '1'

    it "tries to save the patient correctly", ->
      expect(@patientBuilder.originalModel.save).toHaveBeenCalled()

    afterEach -> @patientBuilder.remove()

  describe "changing and blurring basic fields", ->
    beforeEach ->
      @patientBuilder.appendTo('body')
      @patientBuilder.$('select[name=gender]').val('M').change()
      @patientBuilder.$('input[name=birthdate]').blur()

    afterEach ->
      @patientBuilder.remove()

    xit "materializes the patient", ->
      # SKIP: The above change() and blur() commands do hit materialize when
      # executed in the browser console:w Not sure why the spy is not getting
      # hit here.
      expect(@patientBuilder.model.materialize).toHaveBeenCalled()
      expect(@patientBuilder.model.materialize.calls.count()).toEqual 2

  describe "adding encounters to patient", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'
      @patientBuilder.render()
      # simulate dragging an encounter onto the patient
      @addEncounter = (position, targetSelector) ->
        $('.panel-title').click() # Expand the criteria to make draggables visible
        criteria = @$el.find(".draggable:eq(#{position})").draggable()
        target = @$el.find(targetSelector)
        targetView = target.view()
        # We used to simulate a drag, but that had issues with different viewport sizes, so instead we just
        # directly call the appropriate drop event handler
        if targetView.dropCriteria
          target.view().dropCriteria({ target: target }, { draggable: criteria })
        else
          target.view().drop({ target: target }, { draggable: criteria })

    it "adds data criteria to model when dragged", ->
      initialOriginalDataElementCount = @patientBuilder.originalModel.get('cqmPatient').qdmPatient.dataElements.length
      # force materialize to get any patient characteristics that should exist added
      @patientBuilder.materialize();
      initialSourceDataCriteriaCount = @patientBuilder.model.get('source_data_criteria').length
      initialDataElementCount = @patientBuilder.model.get('cqmPatient').qdmPatient.dataElements.length
      @addEncounter 1, '.criteria-container.droppable'
      expect(@patientBuilder.model.get('source_data_criteria').length).toEqual initialSourceDataCriteriaCount + 1
      expect(@patientBuilder.model.get('cqmPatient').qdmPatient.dataElements.length).toEqual initialDataElementCount + 1
      # make sure the dataElements on the original model were not touched
      expect(@patientBuilder.originalModel.get('cqmPatient').qdmPatient.dataElements.length).toEqual initialOriginalDataElementCount

    it "can add multiples of the same criterion", ->
      initialOriginalDataElementCount = @patientBuilder.originalModel.get('cqmPatient').qdmPatient.dataElements.length
      # force materialize to get any patient characteristics that should exist added
      @patientBuilder.materialize();
      initialSourceDataCriteriaCount = @patientBuilder.model.get('source_data_criteria').length
      initialDataElementCount = @patientBuilder.model.get('cqmPatient').qdmPatient.dataElements.length
      @addEncounter 1, '.criteria-container.droppable'
      @addEncounter 1, '.criteria-container.droppable' # add the same one again
      expect(@patientBuilder.model.get('source_data_criteria').length).toEqual initialSourceDataCriteriaCount + 2
      expect(@patientBuilder.model.get('cqmPatient').qdmPatient.dataElements.length).toEqual initialDataElementCount + 2
      # make sure the dataElements on the original model were not touched
      expect(@patientBuilder.originalModel.get('cqmPatient').qdmPatient.dataElements.length).toEqual initialOriginalDataElementCount

    it "has a default start and end date for the primary timing attributes when not dropped on an existing criteria", ->
      startDate = @patientBuilder.model.get('source_data_criteria').first().get('qdmDataElement').prevalencePeriod.low
      endDate = @patientBuilder.model.get('source_data_criteria').first().get('qdmDataElement').prevalencePeriod.high
      # droppable 17 used because droppable 1 didn't have a start and end date
      @addEncounter 17, '.criteria-container.droppable'

      # get today in MP year and check the defaults are today 8:00-8:15
      today = new Date()
      newStart = new cqm.models.CQL.DateTime(2012, today.getMonth() + 1, today.getDate(), 8, 0, 0, 0, 0)
      newEnd = new cqm.models.CQL.DateTime(2012, today.getMonth() + 1, today.getDate(), 8, 15, 0, 0, 0)
      newInterval = new cqm.models.CQL.Interval(newStart, newEnd)
      expect(@patientBuilder.model.get('source_data_criteria').last().get('qdmDataElement').relevantPeriod).toEqual newInterval
      # authorDatetime should be same as the start of the relevantPeriod
      expect(@patientBuilder.model.get('source_data_criteria').last().get('qdmDataElement').authorDatetime).toEqual newStart

    it "acquires the interval of the drop target when dropping on an existing criteria", ->
      startDate = @patientBuilder.model.get('source_data_criteria').first().get('qdmDataElement').prevalencePeriod.low
      endDate = @patientBuilder.model.get('source_data_criteria').first().get('qdmDataElement').prevalencePeriod.high
      # droppable 17 used because droppable 1 didn't have a start and end date
      @addEncounter 17, '.criteria-data.droppable:first'
      expect(@patientBuilder.model.get('source_data_criteria').last().get('qdmDataElement').relevantPeriod.low).toEqual startDate
      expect(@patientBuilder.model.get('source_data_criteria').last().get('qdmDataElement').relevantPeriod.high).toEqual endDate

    it "acquires the authorDatetime of the drop target when dropping on an existing criteria", ->
      authorDatetime = @patientBuilder.model.get('source_data_criteria').first().get('qdmDataElement').authorDatetime
      # droppable 17
      @addEncounter 17, '.criteria-data.droppable:first'
      expect(@patientBuilder.model.get('source_data_criteria').last().get('qdmDataElement').authorDatetime).toEqual authorDatetime

    it "acquires the interval of the drop target when dropping on an existing criteria even when low is null", ->
      @patientBuilder.model.get('source_data_criteria').first().get('qdmDataElement').prevalencePeriod.low = null
      endDate = @patientBuilder.model.get('source_data_criteria').first().get('qdmDataElement').prevalencePeriod.high
      # droppable 17 used because droppable 1 didn't have a start and end date
      @addEncounter 17, '.criteria-data.droppable:first'
      expect(@patientBuilder.model.get('source_data_criteria').last().get('qdmDataElement').relevantPeriod.low).toBe null
      expect(@patientBuilder.model.get('source_data_criteria').last().get('qdmDataElement').relevantPeriod.high).toEqual endDate

    it "acquires the start time and makes an end time of the drop target when dropping on an existing criteria with only authorDatetime ", ->
      startDate = @patientBuilder.model.get('source_data_criteria').at(2).get('qdmDataElement').authorDatetime
      # expecting end date to be 15 minutes later
      endDate = startDate.add(15, cqm.models.CQL.DateTime.Unit.MINUTE)
      # droppable 17 used because droppable 1 didn't have a start and end date
      @addEncounter 17, '.criteria-data.droppable:last'
      expect(@patientBuilder.model.get('source_data_criteria').last().get('qdmDataElement').relevantPeriod).toEqual(new cqm.models.CQL.Interval(startDate, endDate))

    it "acquires Interval[null,null] when dropping on an existing criteria with only authorDatetime that is null", ->
      @patientBuilder.model.get('source_data_criteria').at(2).get('qdmDataElement').authorDatetime = null
      # droppable 17 used because droppable 1 didn't have a start and end date
      @addEncounter 17, '.criteria-data.droppable:last'
      # interval should be [null,null]
      expect(@patientBuilder.model.get('source_data_criteria').last().get('qdmDataElement').relevantPeriod).toEqual(new cqm.models.CQL.Interval(null, null))
      expect(@patientBuilder.model.get('source_data_criteria').last().get('qdmDataElement').authorDatetime).toBe(null)

    it "acquires the start of an interval as the authorDatetime when criteria with only authorDatetime is dropped on one with an Interval", ->
      startDate = @patientBuilder.model.get('source_data_criteria').first().get('qdmDataElement').prevalencePeriod.low
      # droppable 14 used. this is InterventionOrder that only has authorDatetime
      @addEncounter 14, '.criteria-data.droppable:first'
      expect(@patientBuilder.model.get('source_data_criteria').last().get('qdmDataElement').authorDatetime).toEqual(startDate)

    it "acquires null as the authorDatetime when criteria with only authorDatetime is dropped on one with an Interval that starts with null", ->
      # set the low of the drop target to be null
      @patientBuilder.model.get('source_data_criteria').first().get('qdmDataElement').prevalencePeriod.low = null
      # droppable 14 used. this is InterventionOrder that only has authorDatetime
      @addEncounter 14, '.criteria-data.droppable:first'
      expect(@patientBuilder.model.get('source_data_criteria').last().get('qdmDataElement').authorDatetime).toBe(null)

    it "materializes the patient", ->
      expect(@patientBuilder.model.materialize).not.toHaveBeenCalled()
      @addEncounter 1, '.criteria-container.droppable'
      expect(@patientBuilder.model.materialize).toHaveBeenCalled()

    afterEach -> @patientBuilder.remove()

  describe "editing basic attributes of a criteria", ->
    # SKIP: This should be re-enabled with patient builder timing work
    beforeEach ->
      @patientBuilder.appendTo 'body'
      # need to be specific with the query to select one of the data criteria with a period.
      # this is due to QDM 5.0 changes which make several data criteria only have an author time.
      $dataCriteria = @patientBuilder.$('div.patient-criteria:contains(Diagnosis: Diabetes):first')
      $dataCriteria.find('button[data-call-method=toggleDetails]:first').click()
      $dataCriteria.find(':input[name=start_date]:first').val('01/1/2012')
      $dataCriteria.find(':input[name=start_time]:first').val('3:33')
      # verify DOM as well
      expect($dataCriteria.find(':input[name=end_date]:first')).toBeDisabled()
      expect($dataCriteria.find(':input[name=end_time]:first')).toBeDisabled()
      @patientBuilder.$("button[data-call-method=save]").click()

    xit "serializes the attributes correctly", ->
      # SKIP: Re-endable with Patient Builder Timing Attributes
      dataCriteria = this.patient.get('cqmPatient').qdmPatient.conditions()[0]
      expect(dataCriteria.get('prevelancePeriod').low).toEqual moment.utc('01/1/2012 3:33', 'L LT').format('X') * 1000
      expect(dataCriteria.get('prevelancePeriod').high).toBeUndefined()

    afterEach -> @patientBuilder.remove()

  describe "setting and unsetting a criteria as not performed", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'

    it "does not serialize negationRationale for element that can't be negated", ->
      # 0th source_data_criteria is a diagnosis and therefore cannot have a negation and will not contain the negation
      expect(@patientBuilder.model.get('source_data_criteria').at(0).get('negationRationale')).toEqual undefined

    it "serializes negationRationale to null for element that can be negated but isnt", ->
      # 1st source_data_criteria is an encounter that is not negated
      expect(@patientBuilder.model.get('source_data_criteria').at(1).get('negationRationale')).toEqual null

    it "serializes negationRationale for element that is negated", ->
      # The 2nd source_data_criteria is an intervention with negationRationale set to 'Emergency Department Visit' code:
      expect(@patientBuilder.model.get('source_data_criteria').at(2).get('negationRationale').code).toEqual '4525004'
      expect(@patientBuilder.model.get('source_data_criteria').at(2).get('negationRationale').system).toEqual 'SNOMED-CT'

    xit "toggles negations correctly", ->
      # SKIP: should be re-enabled when negation part of patient builder is put back on
      # Find first instance of a negated source_data_criteria and un-negate it
      @patientBuilder.$('.criteria-data').children().toggleClass('hide')
      @patientBuilder.$('input[name=negation]:first').click()
      @patientBuilder.$("button[data-call-method=save]").click()
      # Assert that the negation field of the intervention source_data_criteria is set to false and the negation_code_list_id field is cleared
      expect(@patientBuilder.model.get('source_data_criteria').at(1).get('negation')).toBe false
      expect(@patientBuilder.model.get('source_data_criteria').at(1).get('negation_code_list_id')).toEqual ""

    afterEach -> @patientBuilder.remove()

  describe 'author date time', ->
    xit "removes author date time field value when not performed is checked", ->
      # SKIP: Re-enable with Patient Builder work
      authorDateTimePatient = @patients.models.filter((patient) -> patient.get('last') is 'AuthorDateTime')[0]
      patientBuilder = new Thorax.Views.PatientBuilder(model: authorDateTimePatient, measure: @measure, patients: @patients)
      patientBuilder.appendTo 'body'
      firstCriteria = patientBuilder.model.get('source_data_criteria').first()
      authorDateTime = patientBuilder.model.get('source_data_criteria').first().get('field_values').first().get('start_date')
      expect(authorDateTime).toEqual '04/24/2019'
      patientBuilder.$('input[name=negation]:first').click()
      expect(patientBuilder.model.get('source_data_criteria').first().get('field_values').length).toBe 0
      startDate = new Date(patientBuilder.model.get('source_data_criteria').first().get('start_date'))
      expect(startDate.toString().includes("Tue Apr 17 2012")).toBe true
      patientBuilder.remove()

  describe "blurring basic fields of a criteria", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'
      @patientBuilder.$(':text[name=start_date]:first').blur()

    xit "materializes the patient", ->
      # SKIP: Re-enable with Patient Builder Work
      expect(@patientBuilder.model.materialize).toHaveBeenCalled()
      expect(@patientBuilder.model.materialize.calls.count()).toEqual 1

    afterEach -> @patientBuilder.remove()

  describe "adding codes to an encounter", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'
      @addCode = (codeSet, code, submit = true) ->
        @patientBuilder.$('.codeset-control:first').val(codeSet).change()
        $codelist = @patientBuilder.$('.codelist-control:first')
        expect($codelist.children("[value=#{code}]")).toExist()
        $codelist.val(code).change()

    # FIXME Our test JSON doesn't yet support value sets very well... write these tests when we have a source of value sets independent of the measures
    it "adds a code", ->

    afterEach -> @patientBuilder.remove()

  describe "adding values to a criteria", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'
      @addScalarValue = (input, units, submit=true) ->
        @patientBuilder.$('select[name=type]:first').val('PQ').change()
        @patientBuilder.$('input[name=value]:first').val(input).keyup()
        @patientBuilder.$('input[name=unit]:first').val(units)
        @patientBuilder.$('.value-formset .btn-primary:first').click() if submit
      @addCodedValue = (codeListId, submit=true) ->
        @patientBuilder.$('select[name=type]:first').val('CD').change()
        @patientBuilder.$('select[name=code_list_id]').val(codeListId).change()
        @patientBuilder.$('.value-formset .btn-primary:first').click() if submit
      @addRatioValue= (numer, numer_units, denom, denom_units, submit=true) ->
        @patientBuilder.$('select[name=type]:first').val('RT').change()
        @patientBuilder.$('input[name=numerator_scalar]:first').val(numer).keyup()
        @patientBuilder.$('input[name=numerator_units]:first').val(numer_units)
        @patientBuilder.$('input[name=denominator_scalar]:first').val(denom).keyup()
        @patientBuilder.$('input[name=denominator_units]:first').val(denom_units)
        @patientBuilder.$('.value-formset .btn-primary:first').click() if submit

    xit "adds a scalar value", ->
      # SKIP: Re-enable with Patient Builder Attributes section
      expect(@firstCriteria.get('value').length).toEqual 0
      @addScalarValue 1, 'mg'
      expect(@firstCriteria.get('value').length).toEqual 1
      expect(@firstCriteria.get('value').first().get('type')).toEqual 'PQ'
      expect(@firstCriteria.get('value').first().get('value')).toEqual '1'
      expect(@firstCriteria.get('value').first().get('unit')).toEqual 'mg'

    xit "adds a coded value", ->
      # SKIP: Re-enable with Patient Builder Attributes section
      expect(@firstCriteria.get('value').length).toEqual 0
      @addCodedValue '2.16.840.1.113883.3.464.1003.109.12.1016'
      expect(@firstCriteria.get('value').length).toEqual 1
      expect(@firstCriteria.get('value').first().get('type')).toEqual 'CD'
      expect(@firstCriteria.get('value').first().get('code_list_id')).toEqual '2.16.840.1.113883.3.464.1003.109.12.1016'
      expect(@firstCriteria.get('value').first().get('title')).toEqual 'Dialysis Education'

    xit "adds a ratio value", ->
      # SKIP: Re-enable with Patient Builder Attributes section
      expect(@firstCriteria.get('value').length).toEqual 0
      @addRatioValue '1', 'mg', '8', 'g'
      expect(@firstCriteria.get('value').length).toEqual 1
      expect(@firstCriteria.get('value').first().get('type')).toEqual 'RT'
      expect(@firstCriteria.get('value').first().get('numerator_scalar')).toEqual '1'
      expect(@firstCriteria.get('value').first().get('numerator_units')).toEqual 'mg'
      expect(@firstCriteria.get('value').first().get('denominator_scalar')).toEqual '8'
      expect(@firstCriteria.get('value').first().get('denominator_units')).toEqual 'g'

    xit "only allows for a single result", ->
      # SKIP: Re-enable with Patient Builder Attributes section
      expect(@firstCriteria.get('value').length).toEqual 0
      # Want the option to select a Result value to be visible
      expect(@patientBuilder.$('.edit_value_view.hide')).not.toExist()
      @addScalarValue 1, 'mg'
      expect(@firstCriteria.get('value').length).toEqual 1
      # Once a Result value has been added don't want to be able to add more
      expect(@patientBuilder.$('.edit_value_view.hide')).toExist()

    xit "materializes the patient", ->
      # SKIP: Re-enable with Patient Builder Attributes section
      expect(@patientBuilder.model.materialize).not.toHaveBeenCalled()
      @addScalarValue 1, 'mg'
      expect(@patientBuilder.model.materialize).toHaveBeenCalled()
      expect(@patientBuilder.model.materialize.calls.count()).toEqual 1
      @addScalarValue 3, 'mg'
      expect(@patientBuilder.model.materialize.calls.count()).toEqual 2

    xit "disables input until form is filled out", ->
      # SKIP: Re-enable with Patient Builder Attributes section
      expect(@patientBuilder.$('.value-formset .btn-primary:first')).toBeDisabled()
      @addScalarValue 1, 'mg', false
      expect(@patientBuilder.$('.value-formset .btn-primary:first')).not.toBeDisabled()
      @addScalarValue '', '', false
      expect(@patientBuilder.$('.value-formset .btn-primary:first')).toBeDisabled()

    afterEach -> @patientBuilder.remove()

  describe "adding field values to an encounter", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'
      @addScalarFieldValue = (fieldType, input, units, submit=true) ->
        @patientBuilder.$('select[name=key]').val(fieldType)
        @patientBuilder.$('select[name=type]:eq(1)').val('PQ').change()
        @patientBuilder.$('input[name=value]').val(input).keyup()
        @patientBuilder.$('input[name=unit]').val(units)
        @patientBuilder.$('.field-value-formset .btn-primary:first').click() if submit
      @addCodedFieldValue = (fieldType, codeListId, submit=true) ->
        @patientBuilder.$('select[name=key]').val(fieldType).change()
        @patientBuilder.$('select[name=type]:eq(1)').val('CD').change()
        @patientBuilder.$('select[name=code_list_id]').val(codeListId).change()
        @patientBuilder.$('.field-value-formset .btn-primary:first').click() if submit
      @addIdFieldValue = (fieldType, id, system, submit=true) ->
        @patientBuilder.$('select[name=key]').val(fieldType).change()
        @patientBuilder.$('select[name=type]:eq(1)').val('ID').change()
        @patientBuilder.$('input[name=root]').val(id).keyup()
        @patientBuilder.$('input[name=extension]').val(system).keyup()
        @patientBuilder.$('.field-value-formset .btn-primary:first').click() if submit

    xit "adds a scalar field value", ->
      # SKIP: Re-enable with Patient Builder Attributes section
      expect(@firstCriteria.get('field_values').length).toEqual 0
      @addScalarFieldValue 'SOURCE', 1, 'unit'
      expect(@firstCriteria.get('field_values').length).toEqual 1
      expect(@firstCriteria.get('field_values').first().get('type')).toEqual 'PQ'
      expect(@firstCriteria.get('field_values').first().get('key')).toEqual 'SOURCE'
      expect(@firstCriteria.get('field_values').first().get('value')).toEqual '1'
      expect(@firstCriteria.get('field_values').first().get('unit')).toEqual 'unit'

    xit "adds a coded field value", ->
      # SKIP: Re-enable with Patient Builder Attributes section
      expect(@firstCriteria.get('field_values').length).toEqual 0
      @addCodedFieldValue 'SOURCE', '2.16.840.1.113883.3.464.1003.109.12.1016'
      expect(@firstCriteria.get('field_values').length).toEqual 1
      expect(@firstCriteria.get('field_values').first().get('type')).toEqual 'CD'
      expect(@firstCriteria.get('field_values').first().get('key')).toEqual 'SOURCE'
      expect(@firstCriteria.get('field_values').first().get('code_list_id')).toEqual '2.16.840.1.113883.3.464.1003.109.12.1016'
      expect(@firstCriteria.get('field_values').first().get('title')).toEqual 'Dialysis Education'

    xit "adds an ID type field value", ->
      # SKIP: Re-enable with Patient Builder Attributes section
      expect(@firstCriteria.get('field_values').length).toEqual 0
      @addIdFieldValue 'SOURCE', 'testId', 'testSystem'
      expect(@firstCriteria.get('field_values').length).toEqual 1
      expect(@firstCriteria.get('field_values').first().get('type')).toEqual 'ID'
      expect(@firstCriteria.get('field_values').first().get('key')).toEqual 'SOURCE'
      expect(@firstCriteria.get('field_values').first().get('root')).toEqual 'testId'
      expect(@firstCriteria.get('field_values').first().get('extension')).toEqual 'testSystem'

    xit "materializes the patient", ->
      # SKIP: Re-enable with Patient Builder Attributes section
      expect(@patientBuilder.model.materialize).not.toHaveBeenCalled()
      @addScalarFieldValue 'SOURCE', 1, 'unit'
      expect(@patientBuilder.model.materialize).toHaveBeenCalled()
      expect(@patientBuilder.model.materialize.calls.count()).toEqual 1
      @addCodedFieldValue 'SOURCE', '2.16.840.1.113883.3.464.1003.109.12.1016'
      expect(@patientBuilder.model.materialize.calls.count()).toEqual 2

    xit "disables input until form is filled out", ->
      # SKIP: Re-enable with Patient Builder Attributes section
      expect(@patientBuilder.$('.field-value-formset .btn-primary:first')).toBeDisabled()
      @addScalarFieldValue 'SOURCE', 1, 'unit', false
      expect(@patientBuilder.$('.field-value-formset .btn-primary:first')).not.toBeDisabled()
      @addScalarFieldValue '', '', '', false
      expect(@patientBuilder.$('.field-value-formset .btn-primary:first')).toBeDisabled()

    afterEach -> @patientBuilder.remove()

  describe "setting expected values", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'
      @selectPopulationEV = (population, save=true) ->
        @patientBuilder.$("input[type=checkbox][name=#{population}]:first").click()
        @patientBuilder.$("button[data-call-method=save]").click() if save

    it "auto unselects DENOM and IPP when IPP is unselected", ->
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 1
      expect(expectedValues.get('DENOM')).toEqual 1
      expect(expectedValues.get('NUMER')).toEqual 0
      @selectPopulationEV('IPP', true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 0
      expect(expectedValues.get('DENOM')).toEqual 0
      expect(expectedValues.get('NUMER')).toEqual 0

    it "auto selects DENOM and IPP when NUMER is selected", ->
      @selectPopulationEV('NUMER', true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 1
      expect(expectedValues.get('DENOM')).toEqual 1
      expect(expectedValues.get('NUMER')).toEqual 1

    it "auto unselects DENOM when IPP is unselected", ->
      @selectPopulationEV('DENOM', false)
      @selectPopulationEV('IPP', true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 0
      expect(expectedValues.get('DENOM')).toEqual 0
      expect(expectedValues.get('NUMER')).toEqual 0

    it "auto unselects DENOM and NUMER when IPP is unselected", ->
      @selectPopulationEV('NUMER', false)
      @selectPopulationEV('IPP', true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 0
      expect(expectedValues.get('DENOM')).toEqual 0
      expect(expectedValues.get('NUMER')).toEqual 0

    it "auto selects DENOM and IPP when NUMER is selected", ->
      @selectPopulationEV('NUMER', true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 1
      expect(expectedValues.get('DENOM')).toEqual 1
      expect(expectedValues.get('NUMER')).toEqual 1

    it "auto unselects DENOM when IPP is unselected", ->
      @selectPopulationEV('DENOM', false)
      @selectPopulationEV('IPP', true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 0
      expect(expectedValues.get('DENOM')).toEqual 0
      expect(expectedValues.get('NUMER')).toEqual 0

    it "auto unselects DENOM and NUMER when IPP is unselected", ->
      @selectPopulationEV('NUMER', false)
      @selectPopulationEV('IPP', true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 0
      expect(expectedValues.get('DENOM')).toEqual 0
      expect(expectedValues.get('NUMER')).toEqual 0

    it 'updates the values of the frontend mongoose model', ->
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      mongooseExpectecValue = (expectedValues.collection.parent.get('cqmPatient').expectedValues.filter (val) -> val.population_index is 0 && val.measure_id is '7B2A9277-43DA-4D99-9BEE-6AC271A07747')[0]
      expect(mongooseExpectecValue.IPP).toEqual 1
      expect(mongooseExpectecValue.DENOM).toEqual 1
      expect(mongooseExpectecValue.NUMER).toEqual 0
      @selectPopulationEV('IPP', true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(mongooseExpectecValue.IPP).toEqual 0
      expect(mongooseExpectecValue.DENOM).toEqual 0
      expect(mongooseExpectecValue.NUMER).toEqual 0
      @selectPopulationEV('NUMER', false)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(mongooseExpectecValue.IPP).toEqual 1
      expect(mongooseExpectecValue.DENOM).toEqual 1
      expect(mongooseExpectecValue.NUMER).toEqual 1

    afterEach -> @patientBuilder.remove()

  describe "setting expected values for CV measure", ->
    beforeEach ->
      cqlMeasure = loadMeasureWithValueSets 'cqm_measure_data/core_measures/CMS32/CMS32v7.json', 'cqm_measure_data/core_measures/CMS32/value_sets.json'
      patientsJSON = []
      patientsJSON.push(getJSONFixture('patients/CMS32v7/Visit_1 ED.json'))
      patientsJSON.push(getJSONFixture('patients/CMS32v7/Visits 1 Excl_2 ED.json'))
      patientsJSON.push(getJSONFixture('patients/CMS32v7/Visits 2 Excl_2 ED.json'))
      patientsJSON.push(getJSONFixture('patients/CMS32v7/Visits_2 ED.json'))
      patients = new Thorax.Collections.Patients patientsJSON, parse: true
      @patientBuilder = new Thorax.Views.PatientBuilder(model: patients.first(), measure: cqlMeasure)
      @patientBuilder.appendTo 'body'
      @setPopulationVal = (population, value=0, save=true) ->
        @patientBuilder.$("input[type=number][name=#{population}]:first").val(value).change()
        @patientBuilder.$("button[data-call-method=save]").click() if save

    it "IPP removal removes membership of all populations in CV measures", ->
      @setPopulationVal('IPP', 0, true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 0
      expect(expectedValues.get('MSRPOPL')).toEqual 0
      expect(expectedValues.get('MSRPOPLEX')).toEqual 0
      expect(expectedValues.get('OBSERV')).toEqual undefined

    it "MSRPOPLEX addition adds membership to all populations in CV measures", ->
      # First set IPP to 0 to zero out all population membership
      @setPopulationVal('IPP', 0, true)
      @setPopulationVal('MSRPOPLEX', 4, true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 4
      expect(expectedValues.get('MSRPOPL')).toEqual 4
      expect(expectedValues.get('MSRPOPLEX')).toEqual 4
      # 4 MSRPOPLEX and 4 MSRPOPL means there should be no OBSERVs
      expect(expectedValues.get('OBSERV')).toEqual undefined

    it "MSRPOPLEX addition and removal adds and removes OBSERVs in CV measures", ->
      # First set IPP to 0 to zero out all population membership
      @setPopulationVal('IPP', 0, true)
      @setPopulationVal('MSRPOPLEX', 3, true)
      @setPopulationVal('MSRPOPL', 4, true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 4
      expect(expectedValues.get('MSRPOPL')).toEqual 4
      expect(expectedValues.get('MSRPOPLEX')).toEqual 3
      # 4 MSRPOPL and 3 MSRPOPLEX means there should be 1 OBSERVs
      expect(expectedValues.get('OBSERV').length).toEqual 1
      @setPopulationVal('MSRPOPL', 6, true)
      expect(expectedValues.get('IPP')).toEqual 6
      expect(expectedValues.get('MSRPOPL')).toEqual 6
      expect(expectedValues.get('MSRPOPLEX')).toEqual 3
      # 6 MSRPOPL and 3 MSRPOPLEX means there should be 3 OBSERVs
      expect(expectedValues.get('OBSERV').length).toEqual 3
      # Should remove all observs
      @setPopulationVal('MSRPOPLEX', 6, true)
      expect(expectedValues.get('IPP')).toEqual 6
      expect(expectedValues.get('MSRPOPL')).toEqual 6
      expect(expectedValues.get('MSRPOPLEX')).toEqual 6
      # 6 MSRPOPLEX and 6 MSRPOPL means there should be no OBSERVs
      expect(expectedValues.get('OBSERV')).toEqual undefined
      # set IPP to 0, should zero out all populations
      @setPopulationVal('IPP', 0, true)
      expect(expectedValues.get('IPP')).toEqual 0
      expect(expectedValues.get('MSRPOPL')).toEqual 0
      expect(expectedValues.get('MSRPOPLEX')).toEqual 0
      expect(expectedValues.get('OBSERV')).toEqual undefined

    afterEach -> @patientBuilder.remove()

  describe 'CQL', ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      @cqlMeasure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/deprecated_measures/CMS347/CMS347v3.json'), parse: true
      # preserve atomicity
      @bonnie_measures_old = bonnie.measures
      bonnie.measures = new Thorax.Collections.Measures()
      bonnie.measures.add(@cqlMeasure, {parse: true})

    afterEach ->
      bonnie.measures = @bonnie_measures_old

    xit "laboratory test performed should have custom view for components", ->
      # SKIP: Re-enable with Patient Builder Attributes
      # NOTE: these patients aren't in the DB so fixture will need to be swapped
      patients = new Thorax.Collections.Patients getJSONFixture('patients/CMS347/patients.json'), parse: true
      patientBuilder = new Thorax.Views.PatientBuilder(model: patients.first(), measure: @cqlMeasure)
      dataCriteria = patientBuilder.model.get('source_data_criteria').models
      laboratoryTestIndex = dataCriteria.findIndex((m) ->  m.attributes.definition is 'laboratory_test')
      laboratoryTest = dataCriteria[laboratoryTestIndex]
      editCriteriaView = new Thorax.Views.EditCriteriaView(model: laboratoryTest)
      editFieldValueView = editCriteriaView.editFieldValueView
      editFieldValueView.render()
      editFieldValueView.$('select[name=key]').val('COMPONENT').change()

      expect(editFieldValueView.$('label[for=code]')).toExist()
      expect(editFieldValueView.$('label[for=code]')[0].innerHTML).toEqual('Code')
      expect(editFieldValueView.$('label[for=referenceRangeLow]')).toExist()
      expect(editFieldValueView.$('label[for=referenceRangeLow]')[0].innerHTML).toEqual('Reference Range - Low')
      expect(editFieldValueView.$('label[for=referenceRangeHigh]')).toExist()
      expect(editFieldValueView.$('label[for=referenceRangeHigh]')[0].innerHTML).toEqual('Reference Range - High')
      expect(editFieldValueView.$('select[name=code_list_id]')).toExist()

      editFieldValueView.$('select[name=key]').val('REASON').change()
      expect(editFieldValueView.$('label[for=code]').length).toEqual(0)
      expect(editFieldValueView.$('label[for=referenceRangeLow]').length).toEqual(0)
      expect(editFieldValueView.$('label[for=referenceRangeHigh]').length).toEqual(0)

    xit "EditCriteriaValueView does not have duplicated codes in dropdown", ->
      # SKIP: Re-enable with Patient Builder Code Work
      # TODO(cqm-measure/patients) Need to update or replace this fixture and the patients one below
      cqlMeasure = loadMeasureWithValueSets 'cqm_measure_data/CQL/CMS107/CMS107v6.json', 'cqm_measure_data/CQL/CMS107/value_sets.json'
      bonnie.measures.add(cqlMeasure, { parse: true })
      patients = new Thorax.Collections.Patients getJSONFixture('patients/CMS107/patients.json'), parse: true
      patientBuilder = new Thorax.Views.PatientBuilder(model: patients.first(), measure: cqlMeasure)
      dataCriteria = patientBuilder.model.get('source_data_criteria').first()
      editCriteriaView = new Thorax.Views.EditCriteriaView(model: dataCriteria, measure: cqlMeasure)
      editFieldValueView = editCriteriaView.editFieldValueView
      codesInDropdown = {}

      # Each code should appear only once
      for code in editFieldValueView.context().codes
        expect(codesInDropdown[code.display_name]).toBeUndefined()
        codesInDropdown[code.display_name] = 'exists'

      # These are from direct reference codes
      expect(codesInDropdown['Birthdate']).toBeDefined()
      expect(codesInDropdown['Dead']).toBeDefined()

    xit "EditCriteriaValueView allows for input field validation to happen on change event", ->
      # SKIP: Re-enable with Patient Builder Code Work
      cqlMeasure = loadMeasureWithValueSets 'cqm_measure_data/CMS160v6/CMS160v6.json', 'cqm_measure_data/CMS160v6/value_sets.json'
      bonnie.measures = new Thorax.Collections.Measures()
      bonnie.measures.add(cqlMeasure, { parse: true })
      patients = new Thorax.Collections.Patients getJSONFixture('patients/CMS160v6/patients.json'), parse: true
      patientBuilder = new Thorax.Views.PatientBuilder(model: patients.first(), measure: cqlMeasure)
      assessmentPerformed = patientBuilder.model.get('source_data_criteria').at(2)
      editCriteriaView = new Thorax.Views.EditCriteriaView(model: assessmentPerformed, measure: cqlMeasure)

      # getting the element result edit view
      editFieldValueView = editCriteriaView.editValueView
      editFieldValueView.render()

      # change it to scalar
      editFieldValueView.$('select[name="type"]').val('PQ').change()

      # expect add button to be disabled
      expect(editFieldValueView.$('button[data-call-method=addValue]').prop('disabled')).toEqual(true)

      # change the value
      editFieldValueView.$('input[name="value"]').val(3).change()

      # expect add button to be enabled
      expect(editFieldValueView.$('button[data-call-method=addValue]').prop('disabled')).toEqual(false)

  describe 'Composite Measure', ->

    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      # preserve atomicity
      @bonnie_measures_old = bonnie.measures

      valueSetsPath = 'cqm_measure_data/CMS890v0/value_sets.json'
      bonnie.measures = new Thorax.Collections.Measures()
      @compositeMeasure = loadMeasureWithValueSets 'cqm_measure_data/CMS890v0/CMS890v0.json', valueSetsPath
      bonnie.measures.push(@compositeMeasure)

      @components = getJSONFixture('cqm_measure_data/CMS890v0/components.json')
      @components = @components.map((component) -> new Thorax.Models.Measure component, parse: true)
      @components.forEach((component) -> bonnie.measures.push(component))

      patientTest1 = getJSONFixture('patients/CMS890v0/Patient_Test 1.json')
      patientTest2 = getJSONFixture('patients/CMS890v0/Patient_Test 2.json')
      @compositePatients = new Thorax.Collections.Patients [patientTest1, patientTest2], parse: true
      @compositeMeasure.populateComponents()

    afterEach ->
      bonnie.measures = @bonnie_measures_old

    xit "should floor the observ value to at most 8 decimals", ->
      # SKIP: Re-enable with patient saving/expected value work
      patientBuilder = new Thorax.Views.PatientBuilder(model: @compositePatients.at(1), measure: @compositeMeasure)
      patientBuilder.render()
      expected_vals = patientBuilder.model.get('expected_values').findWhere({measure_id: "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC"})

      patientBuilder.$(':input[name=OBSERV]').val(0.123456781111111)
      patientBuilder.serializeWithChildren()
      expect(expected_vals.get("OBSERV")[0]).toEqual 0.12345678

      patientBuilder.$(':input[name=OBSERV]').val(0.123456786666666)
      patientBuilder.serializeWithChildren()
      expect(expected_vals.get("OBSERV")[0]).toEqual 0.12345678

      patientBuilder.$(':input[name=OBSERV]').val(1.5)
      patientBuilder.serializeWithChildren()
      expect(expected_vals.get("OBSERV")[0]).toEqual 1.5

    it "should display a warning that the patient is shared", ->
      patientBuilder = new Thorax.Views.PatientBuilder(model: @compositePatients.first(), measure: @components[0])
      patientBuilder.render()

      expect(patientBuilder.$("div.alert-warning")[0].innerHTML.substr(0,31).trim()).toEqual "Note: This patient is shared"

    it 'should have the breadcrumbs with composite and component measure', ->
      breadcrumb = new Thorax.Views.Breadcrumb()
      breadcrumb.addPatient(@components[0], @compositePatients.first())
      breadcrumb.render()

      expect(breadcrumb.$("a")[1].childNodes[1].textContent).toEqual " CMS890v0 " # parent composite measure
      expect(breadcrumb.$("a")[2].childNodes[1].textContent).toEqual " CMS231v0 " # the component measure

describe 'Direct Reference Code Usage', ->
  # Originally BONNIE-939

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS32v7/CMS32v7.json', 'cqm_measure_data/CMS32v7/value_sets.json'
    bonnie.measures.add(@measure, { parse: true })
    @patients = new Thorax.Collections.Patients getJSONFixture('cqm_patients/CMS32v7/patients.json'), parse: true

  xit 'Field Value Dropdown should contain direct reference code element', ->
    # SKIP: Re-enable with Patient Builder Code Work
    patientBuilder = new Thorax.Views.PatientBuilder(model: @patients.first(), measure: @measure)
    dataCriteria = patientBuilder.model.get('source_data_criteria').models
    edVisitIndex = dataCriteria.findIndex((m) ->
      m.attributes.description is 'Encounter, Performed: Emergency Department Visit')
    emergencyDepartmentVisit = dataCriteria[edVisitIndex]
    editCriteriaView = new Thorax.Views.EditCriteriaView(model: emergencyDepartmentVisit, measure: @measure)
    editFieldValueView = editCriteriaView.editFieldValueView
    expect(editFieldValueView.render()).toContain('drc-')

  xit 'Adding direct reference code element should calculate correctly', ->
    # SKIP: Re-enable with Patient Builder Code Work
    @measure.set('patients', [patientThatCalculatesDrc])
    population = @measure.get('populations').first()
    patientThatCalculatesDrc = @patients.findWhere(first: "Visits 2 Excl")
    results = population.calculate(patientThatCalculatesDrc)
    library = "MedianTimefromEDArrivaltoEDDepartureforDischargedEDPatients"
    statementResults = results.get("statement_results")
    titleOfClauseThatUsesDrc = statementResults[library]['Measure Population Exclusions'].raw[0]._dischargeDisposition.title
    expect(titleOfClauseThatUsesDrc).toBe "Patient deceased during stay (discharge status = dead) (finding)"

describe 'Allergy', ->
  # Originally BONNIE-785

  beforeAll ->
    jasmine.getJSONFixtures().clearCache()
    @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS12v0/CMS12v0.json', 'cqm_measure_data/CMS12v0/value_sets.json'
    bonnie.measures.add @measure
    medAllergy = getJSONFixture("patients/CMS12v0/MedAllergyEndIP_DENEXCEPPass.json")
    @patients = new Thorax.Collections.Patients [medAllergy], parse: true
    @patient = @patients.at(0) # MedAllergyEndIP_DENEXCEPPass
    @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure, patients: @patients)
    sourceDataCriteria = @patientBuilder.model.get("source_data_criteria")
    @allergyIntolerance = sourceDataCriteria.findWhere({qdmCategory: "allergy"})
    @patientBuilder.render()
    @patientBuilder.appendTo('body')

  afterEach ->
    @patientBuilder.remove()

  it 'is displayed on Patient Builder Page in Elements section', ->
    expect(@patientBuilder.$el.find("div#criteriaElements").html()).toContainText "allergy"

  it 'highlight is triggered by relevant cql clause', ->
    cqlLogicView = @patientBuilder.populationLogicView.getView().cqlLogicView
    sourceDataCriteria = cqlLogicView.latestResult.patient.get('source_data_criteria')
    patientDataCriteria = _.find(sourceDataCriteria.models, (sdc) -> sdc.get('qdmCategory') == 'allergy')
    dataCriteriaIds = [patientDataCriteria.get('_id').toString()]
    spyOn(patientDataCriteria, 'trigger')
    cqlLogicView.highlightPatientData(dataCriteriaIds)
    expect(patientDataCriteria.trigger).toHaveBeenCalled()

