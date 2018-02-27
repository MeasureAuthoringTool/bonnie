describe 'PatientBuilderView', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @measure = new Thorax.Models.Measure getJSONFixture('measure_data/core_measures/CMS134/CMS134v6.json'), parse: true
    @patients = new Thorax.Collections.Patients getJSONFixture('records/core_measures/CMS134/patients.json'), parse: true
    @patient = @patients.models[1]
    bonnie.valueSetsByOid = getJSONFixture('measure_data/core_measures/CMS134/value_sets.json')
    bonnie.measures.add @measure
    @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure, patients: @patients)
    @firstCriteria = @patientBuilder.model.get('source_data_criteria').first()
    # Normally the first criteria can't have a value (wrong type); for testing we allow it
    @firstCriteria.canHaveResult = -> true
    @patientBuilder.render()
    spyOn(@patientBuilder.model, 'materialize')
    spyOn(@patientBuilder.originalModel, 'save').and.returnValue(true)
    @$el = @patientBuilder.$el

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
    expect(@$el.find(":input[name='first']")).toHaveValue @patient.get('first')

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
    expect(@patientBuilder.model.get('deathdate')).toEqual moment.utc('01/02/1994 1:15 PM', 'L LT').format('X')
    expect(@patientBuilder.model.get('deathtime')).toEqual "1:15 PM"
    # Remove deathdate from patient
    @patientBuilder.$("button[data-call-method=removeDeathDate]").click()
    @patientBuilder.$("button[data-call-method=save]").click()
    expect(@patientBuilder.model.get('expired')).toEqual false
    expect(@patientBuilder.model.get('deathdate')).toEqual null
    expect(@patientBuilder.model.get('deathtime')).toEqual null
    @patientBuilder.remove()

  describe "setting basic attributes and saving", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'
      @patientBuilder.$(':input[name=last]').val("LAST NAME")
      @patientBuilder.$(':input[name=first]').val("FIRST NAME")
      @patientBuilder.$('select[name=payer]').val('MA')
      @patientBuilder.$('select[name=gender]').val('F')
      @patientBuilder.$(':input[name=birthdate]').val('01/02/1993')
      @patientBuilder.$(':input[name=birthtime]').val('1:15 PM')
      @patientBuilder.$('select[name=race]').val('2131-1')
      @patientBuilder.$('select[name=ethnicity]').val('2135-2')
      @patientBuilder.$("button[data-call-method=save]").click()

    it "serializes the attributes correctly", ->
      expect(@patientBuilder.model.get('last')).toEqual 'LAST NAME'
      expect(@patientBuilder.model.get('first')).toEqual 'FIRST NAME'
      expect(@patientBuilder.model.get('payer')).toEqual 'MA'
      expect(@patientBuilder.model.get('gender')).toEqual 'F'
      expect(@patientBuilder.model.get('birthdate')).toEqual moment.utc('01/02/1993 1:15 PM', 'L LT').format('X')
      expect(@patientBuilder.model.get('race')).toEqual '2131-1'
      expect(@patientBuilder.model.get('ethnicity')).toEqual '2135-2'

    it "tries to save the patient correctly", ->
      expect(@patientBuilder.originalModel.save).toHaveBeenCalled()

    afterEach -> @patientBuilder.remove()

  describe "changing and blurring basic fields", ->
    beforeEach ->
      @patientBuilder.$('select[name=gender]').val('F').change()
      @patientBuilder.$(':input[name=birthdate]').blur()

    it "materializes the patient", ->
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
      initialSourceDataCriteriaCount = @patientBuilder.model.get('source_data_criteria').length
      @addEncounter 1, '.criteria-container.droppable'
      expect(@patientBuilder.model.get('source_data_criteria').length).toEqual initialSourceDataCriteriaCount + 1

    it "can add multiples of the same criterion", ->
      initialSourceDataCriteriaCount = @patientBuilder.model.get('source_data_criteria').length
      @addEncounter 1, '.criteria-container.droppable'
      @addEncounter 1, '.criteria-container.droppable' # add the same one again
      expect(@patientBuilder.model.get('source_data_criteria').length).toEqual initialSourceDataCriteriaCount + 2

    it "acquires the dates of the drop target when dropping on an existing criteria", ->
      startDate = @patientBuilder.model.get('source_data_criteria').first().get('start_date')
      endDate = @patientBuilder.model.get('source_data_criteria').first().get('end_date')
      # droppable 5 used because droppable 1 didn't have a start and end date
      @addEncounter 5, '.criteria-data.droppable:first'
      expect(@patientBuilder.model.get('source_data_criteria').last().get('start_date')).toEqual startDate
      expect(@patientBuilder.model.get('source_data_criteria').last().get('end_date')).toEqual endDate

    it "materializes the patient", ->
      expect(@patientBuilder.model.materialize).not.toHaveBeenCalled()
      @addEncounter 1, '.criteria-container.droppable'
      expect(@patientBuilder.model.materialize).toHaveBeenCalled()

    afterEach -> @patientBuilder.remove()

  describe "editing basic attributes of a criteria", ->
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

    it "serializes the attributes correctly", ->
      dataCriteria = @patientBuilder.model.get('source_data_criteria').where({definition:'diagnosis', title:'Diabetes'})[0]
      expect(dataCriteria.get('start_date')).toEqual moment.utc('01/1/2012 3:33', 'L LT').format('X') * 1000
      expect(dataCriteria.get('end_date')).toBeUndefined()

    afterEach -> @patientBuilder.remove()

  describe "setting and unsetting a criteria as not performed", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'

    it "serializes negations of source_data_criteria correctly", ->
      # 0th source_data_criteria is a diagnosis and therefore cannot have a negation and will not contain the negation_code_list_id field
      expect(@patientBuilder.model.get('source_data_criteria').at(0).get('negation')).toBe false
      expect(@patientBuilder.model.get('source_data_criteria').at(0).get('negation_code_list_id')).toEqual undefined
      # The 1st source_data_criteria is an intervention with negation set to 'Emergency Department Visit'
      expect(@patientBuilder.model.get('source_data_criteria').at(1).get('negation')).toBe true
      expect(@patientBuilder.model.get('source_data_criteria').at(1).get('negation_code_list_id')).toEqual '2.16.840.1.113883.3.117.1.7.1.292'

    it "toggles negations correctly", ->
      # Find first instance of a negated source_data_criteria and un-negate it
      @patientBuilder.$('.criteria-data').children().toggleClass('hide')
      @patientBuilder.$('input[name=negation]:first').click()
      @patientBuilder.$("button[data-call-method=save]").click()
      # Assert that the negation field of the intervention source_data_criteria is set to false and the negation_code_list_id field is cleared
      expect(@patientBuilder.model.get('source_data_criteria').at(1).get('negation')).toBe false
      expect(@patientBuilder.model.get('source_data_criteria').at(1).get('negation_code_list_id')).toEqual ""

    afterEach -> @patientBuilder.remove()

  describe "blurring basic fields of a criteria", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'
      @patientBuilder.$(':text[name=start_date]:first').blur()

    it "materializes the patient", ->
      expect(@patientBuilder.model.materialize).toHaveBeenCalled()
      expect(@patientBuilder.model.materialize.calls.count()).toEqual 1

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

    it "adds a scalar value", ->
      expect(@firstCriteria.get('value').length).toEqual 0
      @addScalarValue 1, 'mg'
      expect(@firstCriteria.get('value').length).toEqual 1
      expect(@firstCriteria.get('value').first().get('type')).toEqual 'PQ'
      expect(@firstCriteria.get('value').first().get('value')).toEqual '1'
      expect(@firstCriteria.get('value').first().get('unit')).toEqual 'mg'

    it "adds a coded value", ->
      expect(@firstCriteria.get('value').length).toEqual 0
      @addCodedValue '2.16.840.1.113883.3.464.1003.109.12.1016'
      expect(bonnie.valueSetsByOid['2.16.840.1.113883.3.464.1003.109.12.1016']).toExist
      expect(@firstCriteria.get('value').length).toEqual 1
      expect(@firstCriteria.get('value').first().get('type')).toEqual 'CD'
      expect(@firstCriteria.get('value').first().get('code_list_id')).toEqual '2.16.840.1.113883.3.464.1003.109.12.1016'
      expect(@firstCriteria.get('value').first().get('title')).toEqual 'Dialysis Education'

    it "only allows for a single result", ->
      expect(@firstCriteria.get('value').length).toEqual 0
      # Want the option to select a Result value to be visible
      expect(@patientBuilder.$('.edit_value_view.hide')).not.toExist()
      @addScalarValue 1, 'mg'
      expect(@firstCriteria.get('value').length).toEqual 1
      # Once a Result value has been added don't want to be able to add more
      expect(@patientBuilder.$('.edit_value_view.hide')).toExist()

    it "materializes the patient", ->
      expect(@patientBuilder.model.materialize).not.toHaveBeenCalled()
      @addScalarValue 1, 'mg'
      expect(@patientBuilder.model.materialize).toHaveBeenCalled()
      expect(@patientBuilder.model.materialize.calls.count()).toEqual 1
      @addScalarValue 3, 'mg'
      expect(@patientBuilder.model.materialize.calls.count()).toEqual 2

    it "disables input until form is filled out", ->
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
      @addRatioValue= (numer, numer_units, denom, denom_units, submit=true) ->
        @patientBuilder.$('select[name=type]:first').val('RT').change()
        @patientBuilder.$('input[name=numerator_scalar]:first').val(numer).keyup()
        @patientBuilder.$('input[name=numerator_units]:first').val(numer_units)
        @patientBuilder.$('input[name=denominator_scalar]:first').val(denom).keyup()
        @patientBuilder.$('input[name=denominator_units]:first').val(denom_units)
        @patientBuilder.$('.value-formset .btn-primary:first').click() if submit

    it "adds a scalar field value", ->
      expect(@firstCriteria.get('field_values').length).toEqual 0
      @addScalarFieldValue 'SOURCE', 1, 'unit'
      expect(@firstCriteria.get('field_values').length).toEqual 1
      expect(@firstCriteria.get('field_values').first().get('type')).toEqual 'PQ'
      expect(@firstCriteria.get('field_values').first().get('key')).toEqual 'SOURCE'
      expect(@firstCriteria.get('field_values').first().get('value')).toEqual '1'
      expect(@firstCriteria.get('field_values').first().get('unit')).toEqual 'unit'

    it "adds a coded field value", ->
      expect(@firstCriteria.get('field_values').length).toEqual 0
      @addCodedFieldValue 'SOURCE', '2.16.840.1.113883.3.464.1003.109.12.1016'
      expect(@firstCriteria.get('field_values').length).toEqual 1
      expect(@firstCriteria.get('field_values').first().get('type')).toEqual 'CD'
      expect(@firstCriteria.get('field_values').first().get('key')).toEqual 'SOURCE'
      expect(@firstCriteria.get('field_values').first().get('code_list_id')).toEqual '2.16.840.1.113883.3.464.1003.109.12.1016'
      expect(@firstCriteria.get('field_values').first().get('title')).toEqual 'Dialysis Education'

    it "adds a ratio value", ->
      expect(@firstCriteria.get('value').length).toEqual 0
      @addRatioValue '1', 'mg', '8', 'g'
      expect(@firstCriteria.get('value').length).toEqual 1
      expect(@firstCriteria.get('value').first().get('type')).toEqual 'RT'
      expect(@firstCriteria.get('value').first().get('numerator_scalar')).toEqual '1'
      expect(@firstCriteria.get('value').first().get('numerator_units')).toEqual 'mg'
      expect(@firstCriteria.get('value').first().get('denominator_scalar')).toEqual '8'
      expect(@firstCriteria.get('value').first().get('denominator_units')).toEqual 'g'

    it "materializes the patient", ->
      expect(@patientBuilder.model.materialize).not.toHaveBeenCalled()
      @addScalarFieldValue 'SOURCE', 1, 'unit'
      expect(@patientBuilder.model.materialize).toHaveBeenCalled()
      expect(@patientBuilder.model.materialize.calls.count()).toEqual 1
      @addCodedFieldValue 'SOURCE', '2.16.840.1.113883.3.464.1003.109.12.1016'
      expect(@patientBuilder.model.materialize.calls.count()).toEqual 2

    it "disables input until form is filled out", ->
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

    afterEach -> @patientBuilder.remove()

  describe "setting expected values for CV measure", ->
    beforeEach ->
      cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS32/CMS32v7.json'), parse: true
      bonnie.valueSetsByOid = getJSONFixture('/measure_data/CQL/CMS32/value_sets.json')
      patients = new Thorax.Collections.Patients getJSONFixture('records/CQL/CMS32/patients.json'), parse: true
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

    describe "modifying living status", ->
      beforeEach ->
        @patientBuilder.appendTo 'body'

      it "expires patient correctly", ->
        @patientBuilder.$('input[type=checkbox][name=expired]:first').click()
        @patientBuilder.$(':input[name=deathdate]').val('01/02/1994')
        @patientBuilder.$(':input[name=deathtime]').val('1:15 PM')
        @patientBuilder.$("button[data-call-method=save]").click()
        expect(@patientBuilder.model.get('expired')).toEqual true
        expect(@patientBuilder.model.get('deathdate')).toEqual moment.utc('01/02/1994 1:15 PM', 'L LT').format('X')

      it "revives patient correctly", ->
        @patientBuilder.$("button[data-call-method=removeDeathDate]").click()
        @patientBuilder.$("button[data-call-method=save]").click()
        expect(@patientBuilder.model.get('expired')).toEqual false
        expect(@patientBuilder.model.get('deathdate')).toEqual null

      afterEach -> @patientBuilder.remove()

  describe 'CQL', ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      @cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/core_measures/CMS134/CMS134v6.json'), parse: true
      # preserve atomicity
      @universalValueSetsByOid = bonnie.valueSetsByOid
      @bonnie_measures_old = bonnie.measures
      bonnie.measures = new Thorax.Collections.Measures()
      bonnie.measures.add(@cqlMeasure, {parse: true});

    afterEach ->
      bonnie.valueSetsByOid = @universalValueSetsByOid
      bonnie.measures = @bonnie_measures_old

    it "laboratory test performed should have custom view for components", ->
      bonnie.valueSetsByOid = getJSONFixture('/measure_data/core_measures/CMS134/value_sets.json')
      patients = new Thorax.Collections.Patients getJSONFixture('records/core_measures/CMS134/patients.json'), parse: true
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

    it "EditCriteriaValueView does not have duplicated codes in dropdown", ->
      debugger
      bonnie.valueSetsByOid = getJSONFixture('/measure_data/core_measures/CMS134/value_sets.json')
      cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/core_measures/CMS134/CMS134v6.json'), parse: true
      bonnie.measures.add(cqlMeasure, { parse: true });
      patients = new Thorax.Collections.Patients getJSONFixture('records/core_measures/CMS134/patients.json'), parse: true
      patientBuilder = new Thorax.Views.PatientBuilder(model: patients.first(), measure: cqlMeasure)
      dataCriteria = patientBuilder.model.get('source_data_criteria').models
      laboratoryTestIndex = dataCriteria.findIndex((m) ->  m.attributes.definition is 'laboratory_test')
      laboratoryTest = dataCriteria[laboratoryTestIndex]
      editCriteriaView = new Thorax.Views.EditCriteriaView(model: laboratoryTest, measure: cqlMeasure)
      editFieldValueView = editCriteriaView.editFieldValueView
      codesInDropdown = {}

      # Each code should appear only once
      for code in editFieldValueView.context().codes
        expect(codesInDropdown[code.display_name]).toBeUndefined()
        codesInDropdown[code.display_name] = 'exists'

      # These are from direct reference codes
      expect(codesInDropdown['Birthdate']).toBeDefined()
      expect(codesInDropdown['Dead']).toBeDefined()

    it "EditCriteriaValueView allows for input field validation to happen on change event", ->
      bonnie.valueSetsByOid = getJSONFixture('/measure_data/core_measures/CMS160/value_sets.json')
      cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/core_measures/CMS160/CMS160v6.json'), parse: true
      bonnie.measures.add(cqlMeasure, { parse: true });
      patients = new Thorax.Collections.Patients getJSONFixture('records/core_measures/CMS160/patients.json'), parse: true
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
      @universalValueSetsByOid = bonnie.valueSetsByOid
      @bonnie_measures_old = bonnie.measures
  
      bonnie.valueSetsByOid = getJSONFixture('measure_data/special_measures/CMS890/value_sets.json')
      bonnie.measures = new Thorax.Collections.Measures()
      @compositeMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/special_measures/CMS890/CMS890v0.json'), parse: true
      bonnie.measures.push(@compositeMeasure)

      @components = getJSONFixture('measure_data/special_measures/CMS890/components.json')
      @components = @components.map((component) => new Thorax.Models.Measure component, parse: true)
      @components.forEach((component) => bonnie.measures.push(component))

      @compositePatients = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMS890/patients.json'), parse: true
      @compositeMeasure.populateComponents()

    afterEach ->
      bonnie.valueSetsByOid = @universalValueSetsByOid
      bonnie.measures = @bonnie_measures_old
  
    it "should floor the observ value to at most 8 decimals", ->
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
