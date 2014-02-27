describe 'Navigation', ->
	beforeEach ->
    @measures = bonnie.measures
    @patients = new Thorax.Collections.Patients getJSONFixture('patients.json')

  describe 'navigating the measures list view', ->

    beforeEach ->
      @measuresView = new Thorax.Views.Measures(collection: @measures)
      @measuresView.render()

    afterEach ->
      @measuresView.remove()

    it 'should link to the import measure view', ->
      expect($('button[data-call-method="importMeasure"]', @measuresView.el).length).toEqual(1)

    it 'should link to the measure view for a measure', ->
      expect($('a[href="#measures/' + @measures.first().get('hqmf_set_id') + '"]', @measuresView.el).length).toEqual(1)

    it 'should link to the update measure view', ->
      expect($('button[data-call-method="updateMeasure"]', @measuresView.el).length).toEqual(@measures.length)

  describe 'navigating each measure view', ->

    it 'should link to measures list and update measure for a measure', ->
      p = @patients
      @measureView = new Thorax.Views.Measure(model: @measures.first(), patients: p)
      @measureView.render()
      expect(@measureView.$('a[href="#measures"]')).toExist
      expect(@measureView.$('#updateMeasureTrigger')).toExist
      @measureView.remove()

  # FIXME: We're not currently using the patient view; consider removing it and all the following tests
  describe 'navigating the patients list view', ->

    beforeEach ->
      @patientsView = new Thorax.Views.Patients(patients: @patients)
      @patientsView.render()

    afterEach ->
      @patientsView.remove()

    xit 'should link to the patient view and patient builder for a patient', ->
      expect($('a[href="#patients/' + @patients.first().id + '"]')).toExist
      expect($('a[href="#patients/' + @patients.first().id + '/build"]')).toExist

  describe 'navigating each patient view', ->

    xit 'should link to edit patient and patients list for each patient', ->
      patientView = new Thorax.Views.Patient(measures: @measures, model: @patients.first())
      patientView.render()
      expect($('a[href="#patients/' + @patients.first().id + '/build"]')).toExist
      expect($('a[href="#patients"]')).toExist
      patientView.remove()
