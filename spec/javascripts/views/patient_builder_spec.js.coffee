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
          @patientBuilder.$('.dropdown-toggle:first').click()
          @patientBuilder.$('.dropdown-menu:eq(0) li:eq(0) a').click()
          @patientBuilder.$('input[name=value]:first').val(input)
          @patientBuilder.$('input[name=unit]:first').val(units)
          @patientBuilder.$('.value-form .btn-primary:first').click()
        @addCodedValue = () ->
          @patientBuilder.$('.dropdown-toggle:first').click()
          @patientBuilder.$('.dropdown-menu:eq(0) li:eq(1) a').click()
          @patientBuilder.$('.value-form .btn-primary:first').click()

      it "adds a scalar value", ->
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').length).toEqual 0
        @addScalarValue 1, 'mg'
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').length).toEqual 1
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').first().get('type')).toEqual 'PQ'

      it "adds a coded value", ->
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').length).toEqual 0
        @addCodedValue()
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').length).toEqual 1
        expect(@patientBuilder.model.get('source_data_criteria').first().get('value').first().get('type')).toEqual 'CD'

      afterEach -> @patientBuilder.remove() 

    describe "adds field values to an encounter", ->
      beforeEach ->
        @patientBuilder.appendTo 'body'
        @addScalarFieldValue = (input, units) ->
          @patientBuilder.$('select[name=id] option[value=SEVERITY]').prop('selected', true)
          @patientBuilder.$('.dropdown-toggle:eq(1)').click()
          @patientBuilder.$('.dropdown-menu:eq(0) li:eq(0) a').click()
          @patientBuilder.$('input[name=value]:eq(1)').val(input)
          @patientBuilder.$('input[name=unit]:first').val(units)
          @patientBuilder.$('.value-form .btn-primary:eq(1)').click()
        @addCodedFieldValue = () ->
          @patientBuilder.$('select[name=id] option[value=SEVERITY]').prop('selected', true)
          @patientBuilder.$('.dropdown-toggle:eq(1)').click()
          @patientBuilder.$('.dropdown-menu:eq(1) li:eq(1) a').click()
          @patientBuilder.$('.value-form .btn-primary:eq(1)').click()

      it "adds a scalar field value", ->
        expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').length).toEqual 0
        @addScalarFieldValue 1, 'mg'
        expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').length).toEqual 1
        expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').first().get('type')).toEqual 'PQ'

      it "adds a coded value to model", ->
        expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').length).toEqual 0
        @addCodedFieldValue()
        expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').length).toEqual 1
        expect(@patientBuilder.model.get('source_data_criteria').first().get('field_values').first().get('type')).toEqual 'CD'

      afterEach -> @patientBuilder.remove()