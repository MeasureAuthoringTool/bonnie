describe 'PatientBuilderView', ->

  beforeEach ->

    @patient = new Thorax.Models.Patient getJSONFixture('patients.json')[0], parse: true
    @measure = bonnie.measures.first()
    @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure)
    @patientBuilder.render()
    spyOn(@patientBuilder.model, 'materialize')
    spyOn(@patientBuilder.originalModel, 'save')
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
      expect(@patientBuilder.model.get('birthdate')).toEqual moment('01/02/1993 1:15 PM').format('X')
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
      expect(@patientBuilder.model.materialize.calls.length).toEqual 2


  describe "adding encounters to patient", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'
      # simulate dragging an encounter onto the patient
      @addEncounter = (position, targetSelector) ->
        $('.panel-title').click() # Expand the criteria to make draggables visible
        criteria = @$el.find(".draggable:eq(#{position})").draggable()
        criteriaOffset = criteria.offset()
        droppableOffset = @$el.find(targetSelector).offset()
        criteria.simulate 'drag', dx: droppableOffset.left - criteriaOffset.left, dy: droppableOffset.top - criteriaOffset.top

    it "adds data criteria to model when dragged", ->
      expect(@patientBuilder.model.get('source_data_criteria').length).toEqual 3 # Patient starts with existing criteria
      @addEncounter 1, '.criteria-container.droppable'
      expect(@patientBuilder.model.get('source_data_criteria').length).toEqual 4

    it "can add multiples of the same criterion", ->
      expect(@patientBuilder.model.get('source_data_criteria').length).toEqual 3
      @addEncounter 1, '.criteria-container.droppable'
      @addEncounter 1, '.criteria-container.droppable' # add the same one again
      expect(@patientBuilder.model.get('source_data_criteria').length).toEqual 5

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
      @patientBuilder.$(':input[name=start_date]:first').val('08/10/2012')
      @patientBuilder.$(':input[name=start_time]:first').val('3:33')
      @patientBuilder.$(':input[name=end_date_is_undefined]:first').click()
      @patientBuilder.$("button[data-call-method=save]").click()

    it "serializes the attributes correctly", ->
      expect(@patientBuilder.model.get('source_data_criteria').first().get('start_date')).toEqual moment('08/10/2012 3:33').format('X') * 1000
      expect(@patientBuilder.model.get('source_data_criteria').first().get('end_date')).toBeUndefined()

    afterEach -> @patientBuilder.remove()


  describe "setting a criteria as not performed", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'
      @patientBuilder.$('input[name=negation]:first').click()
      @patientBuilder.$('select[name=negation_code_list_id]:first').val('2.16.840.1.113883.3.464.1003.196.12.1253')
      @patientBuilder.$("button[data-call-method=save]").click()

    it "serializes correctly", ->
      expect(@patientBuilder.model.get('source_data_criteria').first().get('negation')).toBe true
      expect(@patientBuilder.model.get('source_data_criteria').first().get('negation_code_list_id')).toEqual '2.16.840.1.113883.3.464.1003.196.12.1253'

    afterEach -> @patientBuilder.remove()


  describe "blurring basic fields of a criteria", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'
      @patientBuilder.$(':text[name=start_date]:first').blur()

    it "materializes the patient", ->
      expect(@patientBuilder.model.materialize).toHaveBeenCalled()
      expect(@patientBuilder.model.materialize.calls.length).toEqual 1

    afterEach -> @patientBuilder.remove()


  describe "adding values to an encounter", ->
      beforeEach ->
        @patientBuilder.appendTo 'body'
        @addScalarValue = (input, units) ->
          @patientBuilder.$('select[name=type]:first').val('PQ').change()
          @patientBuilder.$('input[name=value]:first').val(input)
          @patientBuilder.$('input[name=unit]:first').val(units)
          @patientBuilder.$('.value-formset .btn-primary:first').click()
        @addCodedValue = (codeListId) ->
          @patientBuilder.$('select[name=type]:first').val('CD').change()
          @patientBuilder.$('select[name=code_list_id]').val(codeListId)
          @patientBuilder.$('.value-formset .btn-primary:first').click()

      it "adds a scalar value", ->
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').length).toEqual 0
        @addScalarValue 1, 'mg'
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').length).toEqual 1
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').first().get('type')).toEqual 'PQ'
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').first().get('value')).toEqual '1'
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').first().get('unit')).toEqual 'mg'

      it "adds a coded value", ->
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').length).toEqual 0
        @addCodedValue '2.16.840.1.113883.3.464.1003.101.12.1001'
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').length).toEqual 1
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').first().get('type')).toEqual 'CD'
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').first().get('code_list_id')).toEqual '2.16.840.1.113883.3.464.1003.101.12.1001'
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').first().get('title')).toEqual 'Office Visit'

      it "materializes the patient", ->
        expect(@patientBuilder.model.materialize).not.toHaveBeenCalled()
        @addScalarValue 1, 'mg'
        expect(@patientBuilder.model.materialize).toHaveBeenCalled()
        expect(@patientBuilder.model.materialize.calls.length).toEqual 1
        @addCodedValue '2.16.840.1.113883.3.464.1003.101.12.1001'
        expect(@patientBuilder.model.materialize.calls.length).toEqual 2

      afterEach -> @patientBuilder.remove()


  describe "adding field values to an encounter", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'
      @addScalarFieldValue = (fieldType, input, units) ->
        @patientBuilder.$('select[name=key]').val(fieldType)
        @patientBuilder.$('select[name=type]:eq(1)').val('PQ').change()
        @patientBuilder.$('input[name=value]:eq(1)').val(input)
        @patientBuilder.$('input[name=unit]:eq(1)').val(units)
        @patientBuilder.$('.field-value-formset .btn-primary:first').click()
      @addCodedFieldValue = (fieldType, codeListId) ->
        @patientBuilder.$('select[name=key]').val(fieldType)
        @patientBuilder.$('select[name=type]:eq(1)').val('CD').change()
        @patientBuilder.$('select[name=code_list_id]').val(codeListId)
        @patientBuilder.$('.field-value-formset .btn-primary:first').click()

    it "adds a scalar field value", ->
      expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').length).toEqual 0
      @addScalarFieldValue 'DOSE', 1, 'mg'
      expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').length).toEqual 1
      expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').first().get('type')).toEqual 'PQ'
      expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').first().get('key')).toEqual 'DOSE'
      expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').first().get('value')).toEqual '1'
      expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').first().get('unit')).toEqual 'mg'

    it "adds a coded field value", ->
      expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').length).toEqual 0
      @addCodedFieldValue 'REASON', '2.16.840.1.113883.3.464.1003.101.12.1023'
      expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').length).toEqual 1
      expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').first().get('type')).toEqual 'CD'
      expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').first().get('key')).toEqual 'REASON'
      expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').first().get('code_list_id')).toEqual '2.16.840.1.113883.3.464.1003.101.12.1023'
      expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').first().get('title')).toEqual 'Preventive Care Services-Initial Office Visit, 18 and Up'

    it "materializes the patient", ->
      expect(@patientBuilder.model.materialize).not.toHaveBeenCalled()
      @addScalarFieldValue 1, 'mg'
      expect(@patientBuilder.model.materialize).toHaveBeenCalled()
      expect(@patientBuilder.model.materialize.calls.length).toEqual 1
      @addCodedFieldValue()
      expect(@patientBuilder.model.materialize.calls.length).toEqual 2

    afterEach -> @patientBuilder.remove()


  describe "seting expected values", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'
      @patientBuilder.$('input[type=checkbox][name=DENOM]:first').click()
      @patientBuilder.$("button[data-call-method=save]").click()

    it "serializes the expected values correctly", ->
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 0
      expect(expectedValues.get('DENOM')).toEqual 1
      expect(expectedValues.get('NUMER')).toEqual 0

    afterEach -> @patientBuilder.remove()
