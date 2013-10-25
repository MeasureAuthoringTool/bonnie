describe 'PatientBuilderView', ->

  beforeEach ->

    @patient = new Thorax.Models.Patient getJSONFixture('patients.json')[0], parse: true
    @measure = Fixtures.Measures.first()
    @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure)
    @patientBuilder.render()
    @$el = @patientBuilder.$el

  it 'renders the builder correctly', ->
    expect(@$el.find(":input#first")).toHaveValue @patient.get('first')

  describe "adding encounters to patient", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'
      # simulate dragging an encounter onto the patient
      @addEncounter = (position) ->
        criteria = @$el.find(".draggable:eq(#{position})").draggable()
        criteriaOffset = criteria.offset()
        droppableOffset = @$el.find('.droppable.well').offset()
        criteria.simulate 'drag', dx: droppableOffset.left - criteriaOffset.left, dy: droppableOffset.top - criteriaOffset.top

    it "adds data criteria to model when dragged", ->
      expect(@patient.get('source_data_criteria').length).toEqual 1 # Patient starts with existing criteria
      @addEncounter 1
      expect(@patient.get('source_data_criteria').length).toEqual 2

    it "can add multiples of the same criterion", ->
      expect(@patient.get('source_data_criteria').length).toEqual 1
      @addEncounter 1
      @addEncounter 1 # add the same one again
      expect(@patient.get('source_data_criteria').length).toEqual 3

    afterEach -> @patientBuilder.remove()