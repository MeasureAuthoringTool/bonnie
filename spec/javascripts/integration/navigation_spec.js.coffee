describe 'Navigation', ->

  beforeEach ->
    window.bonnieRouterCache.load('base_set')
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

    beforeEach ->
      @measureView = new Thorax.Views.MeasureLayout(measure: @measures.first(), patients: @patients)
      @measureView = @measureView.showMeasure()

    afterEach ->
      @measureView.remove()

    it 'should link to the update measure view', ->
      expect($('button[data-call-method="updateMeasure"]', @measureView.el).length).toEqual(1)

    it 'should link to the show delete view', ->
      expect($('button[data-call-method="showDelete"]', @measureView.el).length).toEqual(1)

    it 'should link to the delete measure view', ->
      expect($('button[data-call-method="deleteMeasure"]', @measureView.el).length).toEqual(1)
