describe 'PatientBuilderView', ->

  beforeEach ->

    @patient = new Thorax.Models.Patient getJSONFixture('patients.json')[0], parse: true
    @measure = bonnie.measures.first()
    @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure)
    @patientBuilder.render()
    @$el = @patientBuilder.$el

  it 'renders the builder correctly', ->
    expect(@$el.find(":input[name='first']")).toHaveValue @patient.get('first')

  describe "adding encounters to patient", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'
      # simulate dragging an encounter onto the patient
      @addEncounter = (position) ->
        $('.element-title').click() # Expand the criteria to make draggables visible
        criteria = @$el.find(".draggable:eq(#{position})").draggable()
        criteriaOffset = criteria.offset()
        droppableOffset = @$el.find('.patient-data-list.droppable').offset()
        criteria.simulate 'drag', dx: droppableOffset.left - criteriaOffset.left, dy: droppableOffset.top - criteriaOffset.top

    it "adds data criteria to model when dragged", ->
      expect(@patientBuilder.model.get('source_data_criteria').length).toEqual 1 # Patient starts with existing criteria
      @addEncounter 1
      expect(@patientBuilder.model.get('source_data_criteria').length).toEqual 2

    it "can add multiples of the same criterion", ->
      expect(@patientBuilder.model.get('source_data_criteria').length).toEqual 1
      @addEncounter 1
      @addEncounter 1 # add the same one again
      expect(@patientBuilder.model.get('source_data_criteria').length).toEqual 3

    afterEach -> @patientBuilder.remove()

  describe "adds values to an encounter", ->
      beforeEach ->
        @patientBuilder.appendTo 'body'
        @addScalarValue = (input, units) ->
          $('.dropdown-toggle').click()
          $($('.dropdown-menu li')[0]).click()
          $('input[name=value]').val(input)
          $('input[name=unit]').val(units)
          $('.value-form .btn-primary').click()
        @addCodedValue = (oid) ->
          $('.dropdown-toggle').click()
          $($('.dropdown-menu li')[1]).click()
          $('option[value=oid]').prop('selected', true)
          $('.value-form .btn-primary').click()

      it "adds a scalar value", ->
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').length).toEqual 0
        @addScalarValue 1, 'mg'
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').length).toEqual 1
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').first().get('type')).toEqual 'PQ'

      it "adds a coded value", ->
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').length).toEqual 0
        @addCodedValue '2.16.840.1.113883.3.464.1003.196.12.1171'
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').length).toEqual 1
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').first().get('type')).toEqual 'PQ'

    describe "adds field values to an encounter", ->
      beforeEach ->
        @patientBuilder.appendTo 'body'
        @addScalarFieldValue = (input, units) ->
          $('option[value=SEVERITY]').prop('selected', true)
          $($('.dropdown-toggle')[1]).click()
          $($($('.dropdown-menu')[1]).find('li')[0]).click()
          $($('input[name=value]')[1]).val(input)
          $($('input[name=unit]')[1]).val(units)
          $($('.value-form .btn-primary')[1]).click()
        # @addCodedValue = (oid) ->
        #   $('.dropdown-toggle').click()
        #   $($('.dropdown-menu li')[1]).click()
        #   $('option[value=oid]').prop('selected', true)
        #   $('.value-form .btn-primary').click()

      it "adds a scalar field value", ->
        expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').length).toEqual 0
        @addScalarFieldValue 1, 'mg'
        expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').length).toEqual 1
        expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').first().get('type')).toEqual 'PQ'

      # it "adds a coded value to model", ->
      #   expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').length).toEqual 0
      #   @addCodedValue '2.16.840.1.113883.3.464.1003.196.12.1171'
      #   expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').length).toEqual 1
      #   expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').first().get('type')).toEqual 'PQ'
