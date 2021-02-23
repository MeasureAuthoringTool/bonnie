describe 'InputView', ->

  describe 'TimingView', ->

    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      @measure = loadFhirMeasure 'cqm_measure_data/CMS1027v0/CMS1027v0.json'
      @view = new Thorax.Views.InputTimingView({ initialValue: null, codeSystemMap: @measure.codeSystemMap(), defaultYear: @measure.getMeasurePeriodYear() })
      @view.render()

    it 'initializes', ->
      expect(@view.hasValidValue()).toBe false
      expect(@view.subviews).toBeDefined()
      expect(@view.subviews.length).toBe 3
      expect(@view.hasValidValue()).toBe false
      expect(@view.value).toBe null

    it 'event changed with valid value', ->
      expect(@view.hasValidValue()).toBe false
      expect(@view.timingEventView.hasValidValue()).toBe false
      @view.$(".timing-event-view input[name='date_is_defined']").prop('checked', true).change()
      @view.$('.timing-event-view input[name="date"]').val('02/11/2010').datepicker('update')
      @view.$('.timing-event-view input[name="time"]').val('8:00 AM').timepicker('setTime', '8:00 AM')
      expect(@view.timingEventView.hasValidValue()).toBe true
      expect(@view.timingEventView.value).toBeDefined()
      expect(@view.timingEventView.value.year).toBe 2010
      expect(@view.timingEventView.value.month).toBe 2
      expect(@view.timingEventView.value.day).toBe 11
      expect(@view.timingEventView.value.hour).toBe 8
      expect(@view.timingEventView.value.minute).toBe 0
      expect(@view.timingEventView.value.second).toBe 0
      expect(@view.value).toBeDefined()
      expect(@view.hasValidValue()).toBe true
      expect(@view.value.event[0].value).toBe '2010-02-11T08:00:00.000+00:00'

    it 'code changed with valid value', ->
      expect(@view.hasValidValue()).toBe false
      expect(@view.value).toBe null
      expect(@view.$(".timing-code-view select[name='valueset']").val()).toBe '--'

      # pick valueset
      @view.$('.timing-code-view select[name="valueset"] > option[value="timing-abbreviation"]').prop('selected', true).change()
      expect(@view.hasValidValue()).toBe true

      # pick system
      @view.$('.timing-code-view select[name="vs_codesystem"] > option[value="http://terminology.hl7.org/CodeSystem/v3-GTSAbbreviation"]').prop('selected', true).change()
      expect(@view.hasValidValue()).toBe true

      # pick code
      @view.$('.timing-code-view select[name="vs_code"] > option[value="Q4H"]').prop('selected', true).change()
      # check value
      expect(@view.value).toBeDefined()
      expect(@view.hasValidValue()).toBe true
      expect(@view.value.code.coding[0].code.value).toEqual 'Q4H'
      expect(@view.value.code.coding[0].system.value).toEqual 'http://terminology.hl7.org/CodeSystem/v3-GTSAbbreviation'
