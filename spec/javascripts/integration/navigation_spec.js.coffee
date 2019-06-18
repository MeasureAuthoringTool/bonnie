describe 'Navigation', ->

  beforeAll ->
    jasmine.getJSONFixtures().clearCache()
    @measures = new Thorax.Collections.Measures()
    measure = loadMeasureWithValueSets 'cqm_measure_data/CMS160v6/CMS160v6.json', 'cqm_measure_data/CMS160v6/value_sets.json'
    @measures.add(measure)
    @patients = new Thorax.Collections.Patients [], parse: true

  describe 'navigating the measures list view', ->

    beforeAll ->
      @measuresView = new Thorax.Views.Measures(collection: @measures)
      @measuresView.render()

    afterAll ->
      @measuresView.remove()

    it 'should link to the import measure view', ->
      expect($('button[data-call-method="importMeasure"]', @measuresView.el).length).toEqual(1)

    it 'should link to the measure view for a measure', ->
      expect($('a[href="#measures/' + @measures.first().get('cqmMeasure').hqmf_set_id + '"]', @measuresView.el).length).toEqual(1)

    it 'should link to the update measure view', ->
      expect($('button[data-call-method="updateMeasure"]', @measuresView.el).length).toEqual(@measures.length)

  describe 'navigating each measure view', ->

    beforeAll ->
      @measureView = new Thorax.Views.MeasureLayout(measure: @measures.first(), patients: @patients)
      @measureView = @measureView.showMeasure()

    afterAll ->
      @measureView.remove()

    it 'should link to the update measure view', ->
      expect($('button[data-call-method="updateMeasure"]', @measureView.el).length).toEqual(1)

    it 'should link to the show delete view', ->
      expect($('button[data-call-method="showDelete"]', @measureView.el).length).toEqual(1)

    it 'should link to the delete measure view', ->
      expect($('button[data-call-method="deleteMeasure"]', @measureView.el).length).toEqual(1)
