describe 'Navigation', ->

  beforeEach ->
    # Clear the fixtures cache so that getJSONFixture does not return stale/modified fixtures
    jasmine.getJSONFixtures().clearCache()
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
      @measureView = new Thorax.Views.MeasureLayout(measure: @measures.first(), patients: p)
      @measureView = @measureView.showMeasure()
      expect(@measureView.$('a[href="#measures"]')).toExist
      expect(@measureView.$('#updateMeasureTrigger')).toExist
      @measureView.remove()
