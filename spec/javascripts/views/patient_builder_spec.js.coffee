describe 'PatientBuilderView', ->

  beforeEach ->

    @patient = new Thorax.Models.Patient getJSONFixture('patients.json')[0], parse: true
    @measure = bonnie.measures.findWhere(cms_id: 'CMS146v2')
    @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure)
    @firstCriteria = @patientBuilder.model.get('source_data_criteria').first()
    # Normally the first criteria can't have a value (wrong type); for testing we allow it
    @firstCriteria.canHaveResult = -> true
    @patientBuilder.render()
    spyOn(@patientBuilder.model, 'materialize')
    spyOn(@patientBuilder.originalModel, 'save').and.returnValue(true)
    @$el = @patientBuilder.$el

  it 'renders the builder correctly', ->
    expect(@$el.find(":input[name='first']")).toHaveValue @patient.get('first')

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
      @patientBuilder.model.get('source_data_criteria').first().set end_date: endDate
      @addEncounter 1, '.criteria-data.droppable:first'
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
      @patientBuilder.$('button[data-call-method=toggleDetails]:first').click()
      @patientBuilder.$(':input[name=start_date]:first').val('01/1/2012')
      @patientBuilder.$(':input[name=start_time]:first').val('3:33')
      @patientBuilder.$(':input[name=end_date_is_undefined]:first').click()
      # verify DOM as well
      expect(@patientBuilder.$(':input[name=end_date]:first')).toBeDisabled()
      expect(@patientBuilder.$(':input[name=end_time]:first')).toBeDisabled()
      @patientBuilder.$("button[data-call-method=save]").click()

    it "serializes the attributes correctly", ->
      expect(@patientBuilder.model.get('source_data_criteria').first().get('start_date')).toEqual moment.utc('01/1/2012 3:33', 'L LT').format('X') * 1000
      expect(@patientBuilder.model.get('source_data_criteria').first().get('end_date')).toBeUndefined()

    afterEach -> @patientBuilder.remove()


  describe "setting a criteria as not performed", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'
      @patientBuilder.$('.criteria-data').children().toggleClass('hide')
      @patientBuilder.$('input[name=negation]:first').click()
      @patientBuilder.$('select[name=negation_code_list_id]:first').val('2.16.840.1.113883.3.464.1003.101.12.1061')
      @patientBuilder.$("button[data-call-method=save]").click()

    it "serializes correctly", ->
      expect(@patientBuilder.model.get('source_data_criteria').first().get('negation')).toBe true
      expect(@patientBuilder.model.get('source_data_criteria').first().get('negation_code_list_id')).toEqual '2.16.840.1.113883.3.464.1003.101.12.1061'

    afterEach -> @patientBuilder.remove()


  describe "blurring basic fields of a criteria", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'
      @patientBuilder.$(':text[name=start_date]:first').blur()

    it "materializes the patient", ->
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

  describe "adding values to an encounter", ->
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
      @addCodedValue '2.16.840.1.113883.3.464.1003.101.12.1061'
      expect(@firstCriteria.get('value').length).toEqual 1
      expect(@firstCriteria.get('value').first().get('type')).toEqual 'CD'
      expect(@firstCriteria.get('value').first().get('code_list_id')).toEqual '2.16.840.1.113883.3.464.1003.101.12.1061'
      expect(@firstCriteria.get('value').first().get('title')).toEqual 'Ambulatory/ED Visit'

    it "materializes the patient", ->
      expect(@patientBuilder.model.materialize).not.toHaveBeenCalled()
      @addScalarValue 1, 'mg'
      expect(@patientBuilder.model.materialize).toHaveBeenCalled()
      expect(@patientBuilder.model.materialize.calls.count()).toEqual 1
      @addCodedValue '2.16.840.1.113883.3.464.1003.101.12.1061'
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
      @addCodedFieldValue 'REASON', '2.16.840.1.113883.3.464.1003.102.12.1011'
      expect(@firstCriteria.get('field_values').length).toEqual 1
      expect(@firstCriteria.get('field_values').first().get('type')).toEqual 'CD'
      expect(@firstCriteria.get('field_values').first().get('key')).toEqual 'REASON'
      expect(@firstCriteria.get('field_values').first().get('code_list_id')).toEqual '2.16.840.1.113883.3.464.1003.102.12.1011'
      expect(@firstCriteria.get('field_values').first().get('title')).toEqual 'Acute Pharyngitis'

    it "materializes the patient", ->
      expect(@patientBuilder.model.materialize).not.toHaveBeenCalled()
      @addScalarFieldValue 'SOURCE', 1, 'unit'
      expect(@patientBuilder.model.materialize).toHaveBeenCalled()
      expect(@patientBuilder.model.materialize.calls.count()).toEqual 1
      @addCodedFieldValue 'REASON', '2.16.840.1.113883.3.464.1003.102.12.1011'
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

    it "serializes the expected values correctly", ->
      @selectPopulationEV('DENOM')
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 1
      expect(expectedValues.get('DENOM')).toEqual 1
      expect(expectedValues.get('NUMER')).toEqual 0

    it "auto selects IPP when DENOM is selected", ->
      @selectPopulationEV('DENOM', true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 1
      expect(expectedValues.get('DENOM')).toEqual 1
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
