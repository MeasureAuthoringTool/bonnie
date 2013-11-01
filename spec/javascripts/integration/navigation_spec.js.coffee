describe 'Navigation', ->
	beforeEach ->
    @measures = Fixtures.Measures
    @patients = new Thorax.Collections.Patients getJSONFixture('patients.json')
    @sections = getJSONFixture('sections.json')
    @idMap = getJSONFixture('hqmf_template_oid_map.json')
  
  describe 'navigating the measures list view', ->

    beforeEach ->
      @measuresView = new Thorax.Views.Measures(measures: @measures)
      @measuresView.render()

    afterEach ->
      @measuresView.remove()

    # $('a[href="#patients/' + id + '"]')
    it 'should link to the matrix view', ->
      expect($('a[href="#measures/matrix"]')).toExist

    it 'should link to the import measure view', ->
      expect($('#importMeasureTrigger')).toExist

    it 'should link to the measure view for each measure', ->
      @measures.each (m) ->
        expect($('a[href="#measures/' + m.hqmf_id + '"]')).toExist

    it 'should link to the update measure view', ->
      expect($('#updateMeasureTrigger')).toExist

  describe 'navigating each measure view', ->

    it 'should link to measures list and update measure for each measure', ->
      p = @patients
      @measures.each (m) ->
        @measureView = new Thorax.Views.Measure(model: m, patients: p, allPopulationCodes: ['IPP', 'DENOM', 'NUMER', 'DENEXCEP', 'DENEX', 'MSRPOPL', 'OBSERV'])
        @measureView.render()
        expect($('a[href="#measures"]')).toExist
        expect($('#updateMeasureTrigger')).toExist
        @measureView.remove()

  describe 'navigating the patients list view', ->

    beforeEach ->
      @patientsView = new Thorax.Views.Patients(patients: @patients)
      @patientsView.render()

    afterEach ->
      @patientsView.remove()

    it 'should link to the matrix view', ->
      expect($('a[href="#measures/matrix"]')).toExist    

    it 'should link to the patient view and patient builder for each patient', ->
      @patients.each (p) ->
        expect($('a[href="#patients/' + p.id + '"]')).toExist
        expect($('a[href="#patients/' + p.id + '/build"]')).toExist

  describe 'navigating each patient view', ->

    it 'should link to edit patient and patients list for each patient', ->
      s = @sections
      im = @idMap
      @patients.each (patient) ->
        patientView = new Thorax.Views.Patient(measures: @measures, model: patient, sections: s, idMap: im)
        patientView.render()
        expect($('a[href="#patients/' + patient.id + '/build"]')).toExist
        expect($('a[href="#patients"]')).toExist
        patientView.remove()

  describe 'navigating the matrix view', ->

    beforeEach ->
      @matrixView = new Thorax.Views.Matrix(measures: @measures, patients: @patients)
      @matrixView.render()

    afterEach ->
      @matrixView.remove()

    it 'should link to the measures list', ->
      expect($('a[href="#measures"]')).toExist

  describe 'testing all the routes', ->

    afterEach ->
      Backbone.history.stop()

    it 'should route "" and "measures" to the measures list view', ->
      spyOn(BonnieRouter.prototype, "measures")
      @router = new BonnieRouter()
      @router.mainView = new Thorax.LayoutView()
      
      Backbone.history.start()
      
      @router.navigate('', true)
      expect(BonnieRouter.prototype.measures).toHaveBeenCalled()
      @router.navigate('measures', true)
      expect(BonnieRouter.prototype.measures).toHaveBeenCalled()

    it 'should route "patients" to the patients view', ->
      spyOn(BonnieRouter.prototype, "patients")
      @router = new BonnieRouter()
      @router.mainView = new Thorax.LayoutView()
      
      Backbone.history.start()
      @router.navigate('patients', true)

      expect(BonnieRouter.prototype.patients).toHaveBeenCalled()

    it 'should route "measures/matrix" to the matrix view', ->
      spyOn(BonnieRouter.prototype, "matrix")
      @router = new BonnieRouter()
      @router.mainView = new Thorax.LayoutView()
      
      Backbone.history.start()
      @router.navigate('measures/matrix', true)

      expect(BonnieRouter.prototype.matrix).toHaveBeenCalled()

    it 'should route "measures/:id" to individual measure views', ->
      spyOn(BonnieRouter.prototype, "measure")
      router = new BonnieRouter()
      router.mainView = new Thorax.LayoutView()
      
      Backbone.history.start()
      @measures.each (m) ->
        router.navigate('measures/' + m.attributes.hqmf_id, true)
        expect(BonnieRouter.prototype.measure).toHaveBeenCalledWith m.attributes.hqmf_id
      router.navigate('', true)

    it 'should route "patients/:id" to individual patient views', ->
      spyOn(BonnieRouter.prototype, "patient")
      router = new BonnieRouter()
      router.mainView = new Thorax.LayoutView()
      
      Backbone.history.start()
      @patients.each (p) ->
        if p.attributes.insurance_providers?
          router.navigate('patients/' + p.attributes.id, true)
          expect(BonnieRouter.prototype.patient).toHaveBeenCalledWith p.attributes.id
      router.navigate('', true)

    it 'should route "patients/:id/edit" to individual patient builder views', ->
      spyOn(BonnieRouter.prototype, "patientBuilder")
      router = new BonnieRouter()
      router.mainView = new Thorax.LayoutView()
      
      Backbone.history.start()
      p = @patients.detect (p) -> p.has 'insurance_providers'
      router.navigate('patients/' + p.attributes.id + '/edit', true)
      expect(BonnieRouter.prototype.patientBuilder).toHaveBeenCalledWith(null, p.attributes.id)
      router.navigate('', true)