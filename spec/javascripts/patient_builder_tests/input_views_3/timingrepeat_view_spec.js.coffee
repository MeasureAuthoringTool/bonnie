describe 'InputView', ->

  describe 'TimingView', ->

    beforeEach ->
      # load up a measure so we have valuesets
      jasmine.getJSONFixtures().clearCache()
      @measure = loadFhirMeasure 'cqm_measure_data/CMS1027v0/CMS1027v0.json'
      @view = new Thorax.Views.InputTimingRepeatView(initialValue: null, name: 'repeat', codeSystemMap: @measure.codeSystemMap(), defaultYear: @measure.getMeasurePeriodYear())
      @view.render()

    it 'initializes', ->
      expect(@view.hasValidValue()).toBe false
      expect(@view.subviews).toBeDefined()
      expect(@views.subviews.length).toBe 15
