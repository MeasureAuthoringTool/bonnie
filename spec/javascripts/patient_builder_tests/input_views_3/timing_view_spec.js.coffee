describe 'InputView', ->

  describe 'TimingView', ->

    beforeEach ->
      # load up a measure so we have valuesets
      jasmine.getJSONFixtures().clearCache()
      @measure = loadFhirMeasure 'cqm_measure_data/CMS1027v0/CMS1027v0.json'
      @view = new Thorax.Views.InputTimingView(initialValue: null, name: 'repeat', codeSystemMap: @measure.codeSystemMap(), defaultYear: @measure.getMeasurePeriodYear())
      @view.render()

    it 'initializes', ->
      expect(@view.hasValidValue()).toBe false
      expect(@view.subviews).toBeDefined()
      expect(@view.subviews.length).toBe 3
      expect(@view.hasValidValue()).toBe false
      expect(@view.value).toBe null

    it 'tests something', ->
      @view.$('.bounds bounds[name="type"] > option[value="Boolean"]').prop('selected', true).change()
