describe 'InputView', ->

  describe 'TimingRepeatView', ->

    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      @measure = loadFhirMeasure 'cqm_measure_data/CMS1027v0/CMS1027v0.json'
      @view = new Thorax.Views.InputTimingRepeatView(initialValue: null, name: 'repeat', codeSystemMap: @measure.codeSystemMap(), defaultYear: @measure.getMeasurePeriodYear())
      @view.render()
      spyOn(@view, 'trigger')

    it 'initializes', ->
      expect(@view.hasValidValue()).toBe false
      expect(@view.subviews).toBeDefined()
      expect(@view.subviews.length).toBe 15

    it 'bounds changed with valid value', ->
      expect(@view.hasValidValue()).toBe false
      @view.$('.timing-repeat-bounds-view select[name="type"] > option[value="Duration"]').prop('selected', true).change()
      @view.$(".timing-repeat-bounds-view input[name='value_value']").val('135').change()
      @view.$(".timing-repeat-bounds-view input[name='value_unit']").val('s').change()
      expect(@view.boundsView.value).toBeDefined()
      expect(@view.boundsView.value.value.value).toBe 135
      expect(@view.boundsView.value.unit.value).toBe 's'
      expect(@view.value).toBeDefined()
      expect(@view.hasValidValue()).toBe true
      expect(@view.value.bounds.value.value).toBe 135
      expect(@view.value.bounds.unit.value).toBe 's'

    it 'offset changed with valid value', ->
      expect(@view.hasValidValue()).toBe false
      @view.$('.timing-repeat-offset-view input').val('13').change()
      expect(@view.offsetView.value).toBeDefined()
      expect(@view.offsetView.value.value).toBe 13
      expect(@view.value).toBeDefined()
      expect(@view.hasValidValue()).toBe true
      expect(@view.value.offset.value).toBe 13

    it 'offset changed with invalid value', ->
      expect(@view.hasValidValue()).toBe false
      @view.$('.timing-repeat-offset-view input').val('-13').change()
      expect(@view.offsetView.value).toBeDefined()
      expect(@view.offsetView.hasValidValue()).toBe false
      expect(@view.hasValidValue()).toBe false

    it 'count changed with valid value', ->
      expect(@view.hasValidValue()).toBe false
      @view.$('.timing-repeat-count-view input').val('13').change()
      expect(@view.countView.value).toBeDefined()
      expect(@view.countView.value.value).toBe 13
      expect(@view.value).toBeDefined()
      expect(@view.hasValidValue()).toBe true
      expect(@view.value.count.value).toBe 13

    it 'count changed with invalid value', ->
      expect(@view.hasValidValue()).toBe false
      @view.$('.timing-repeat-count-view input').val('-13').change()
      expect(@view.countView.value).toBeDefined()
      expect(@view.countView.hasValidValue()).toBe false
      expect(@view.hasValidValue()).toBe false

    it 'countMax changed with valid value', ->
      expect(@view.hasValidValue()).toBe false
      @view.$('.timing-repeat-count-max-view input').val('13').change()
      expect(@view.countMaxView.value).toBeDefined()
      expect(@view.countMaxView.value.value).toBe 13
      expect(@view.value).toBeDefined()
      expect(@view.hasValidValue()).toBe true
      expect(@view.value.countMax.value).toBe 13

    it 'countMax changed with invalid value', ->
      expect(@view.hasValidValue()).toBe false
      @view.$('.timing-repeat-count-max-view input').val('-13').change()
      expect(@view.countMaxView.value).toBeDefined()
      expect(@view.countMaxView.hasValidValue()).toBe false
      expect(@view.hasValidValue()).toBe false

    it 'duration changed with valid value', ->
      expect(@view.hasValidValue()).toBe false
      @view.$('.timing-repeat-duration-view input').val('13').change()
      expect(@view.durationView.value).toBeDefined()
      expect(@view.durationView.value.value).toBe 13
      expect(@view.value).toBeDefined()
      expect(@view.hasValidValue()).toBe true
      expect(@view.value.duration.value).toBe 13

    it 'duration changed with invalid value', ->
      expect(@view.hasValidValue()).toBe false
      @view.$('.timing-repeat-duration-view input').val('-1-3').change()
      expect(@view.durationView.value).toBeDefined()
      expect(@view.durationView.hasValidValue()).toBe false
      expect(@view.hasValidValue()).toBe false

    it 'durationMax changed with valid value', ->
      expect(@view.hasValidValue()).toBe false
      @view.$('.timing-repeat-duration-max-view input').val('13').change()
      expect(@view.durationMaxView.value).toBeDefined()
      expect(@view.durationMaxView.value.value).toBe 13
      expect(@view.value).toBeDefined()
      expect(@view.hasValidValue()).toBe true
      expect(@view.value.durationMax.value).toBe 13

    it 'durationMax changed with invalid value', ->
      expect(@view.hasValidValue()).toBe false
      @view.$('.timing-repeat-duration-max-view input').val('-1-3').change()
      expect(@view.durationMaxView.value).toBeDefined()
      expect(@view.durationMaxView.hasValidValue()).toBe false
      expect(@view.hasValidValue()).toBe false

    it 'frequency changed with valid value', ->
      expect(@view.hasValidValue()).toBe false
      @view.$('.timing-repeat-frequency-view input').val('13').change()
      expect(@view.frequencyView.value).toBeDefined()
      expect(@view.frequencyView.value.value).toBe 13
      expect(@view.value).toBeDefined()
      expect(@view.hasValidValue()).toBe true
      expect(@view.value.frequency.value).toBe 13

    it 'frequency changed with invalid value', ->
      expect(@view.hasValidValue()).toBe false
      @view.$('.timing-repeat-frequency-view input').val('-1-3').change()
      expect(@view.frequencyView.value).toBeDefined()
      expect(@view.frequencyView.hasValidValue()).toBe false
      expect(@view.hasValidValue()).toBe false

    it 'frequencyMax changed with valid value', ->
      expect(@view.hasValidValue()).toBe false
      @view.$('.timing-repeat-frequency-max-view input').val('13').change()
      expect(@view.frequencyMaxView.value).toBeDefined()
      expect(@view.frequencyMaxView.value.value).toBe 13
      expect(@view.value).toBeDefined()
      expect(@view.hasValidValue()).toBe true
      expect(@view.value.frequencyMax.value).toBe 13

    it 'frequencyMax changed with invalid value', ->
      expect(@view.hasValidValue()).toBe false
      @view.$('.timing-repeat-frequency-max-view input').val('-1-3').change()
      expect(@view.frequencyMaxView.value).toBeDefined()
      expect(@view.frequencyMaxView.hasValidValue()).toBe false
      expect(@view.hasValidValue()).toBe false

    it 'period changed with valid value', ->
      expect(@view.hasValidValue()).toBe false
      @view.$('.timing-repeat-period-view input').val('13').change()
      expect(@view.periodView.value).toBeDefined()
      expect(@view.periodView.value.value).toBe 13
      expect(@view.value).toBeDefined()
      expect(@view.hasValidValue()).toBe true
      expect(@view.value.period.value).toBe 13

    it 'period changed with invalid value', ->
      expect(@view.hasValidValue()).toBe false
      @view.$('.timing-repeat-period-view input').val('-1-3').change()
      expect(@view.periodView.value).toBeDefined()
      expect(@view.periodView.hasValidValue()).toBe false
      expect(@view.hasValidValue()).toBe false

    it 'periodMax changed with valid value', ->
      expect(@view.hasValidValue()).toBe false
      @view.$('.timing-repeat-period-max-view input').val('13').change()
      expect(@view.periodMaxView.value).toBeDefined()
      expect(@view.periodMaxView.value.value).toBe 13
      expect(@view.value).toBeDefined()
      expect(@view.hasValidValue()).toBe true
      expect(@view.value.periodMax.value).toBe 13

    it 'periodMax changed with invalid value', ->
      expect(@view.hasValidValue()).toBe false
      @view.$('.timing-repeat-period-max-view input').val('-1-3').change()
      expect(@view.periodMaxView.value).toBeDefined()
      expect(@view.periodMaxView.hasValidValue()).toBe false
      expect(@view.hasValidValue()).toBe false

    it 'durationUnit changed with valid value', ->
      expect(@view.hasValidValue()).toBe false
      expect(@view.value).toBe null
      expect(@view.$('.timing-repeat-duration-unit-view select[name="valueset"]').val()).toBe '--'

      # pick valueset
      @view.$('.timing-repeat-duration-unit-view select[name="valueset"] > option[value="units-of-time"]').prop('selected', true).change()
      expect(@view.hasValidValue()).toBe true

      # pick system
      @view.$('.timing-repeat-duration-unit-view select[name="vs_codesystem"] > option[value="http://unitsofmeasure.org"]').prop('selected', true).change()
      expect(@view.hasValidValue()).toBe true

      # pick code
      @view.$('.timing-repeat-duration-unit-view select[name="vs_code"] > option[value="min"]').prop('selected', true).change()
      # check value
      expect(@view.value).toBeDefined()
      expect(@view.hasValidValue()).toBe true
      expect(@view.value.durationUnit.value).toEqual 'min'

    it 'periodUnit changed with valid value', ->
      expect(@view.hasValidValue()).toBe false
      expect(@view.value).toBe null
      expect(@view.$('.timing-repeat-period-unit-view select[name="valueset"]').val()).toBe '--'

      # pick valueset
      @view.$('.timing-repeat-period-unit-view select[name="valueset"] > option[value="units-of-time"]').prop('selected', true).change()
      expect(@view.hasValidValue()).toBe true

      # pick system
      @view.$('.timing-repeat-period-unit-view select[name="vs_codesystem"] > option[value="http://unitsofmeasure.org"]').prop('selected', true).change()
      expect(@view.hasValidValue()).toBe true

      # pick code
      @view.$('.timing-repeat-period-unit-view select[name="vs_code"] > option[value="min"]').prop('selected', true).change()
      # check value
      expect(@view.value).toBeDefined()
      expect(@view.hasValidValue()).toBe true
      expect(@view.value.periodUnit.value).toEqual 'min'

    it 'dayOfWeek changed with valid value', ->
      expect(@view.hasValidValue()).toBe false
      expect(@view.value).toBe null
      expect(@view.$('.timing-repeat-dayofweek-view select[name="valueset"]').val()).toBe '--'

      # pick valueset
      @view.$('.timing-repeat-dayofweek-view select[name="valueset"] > option[value="days-of-week"]').prop('selected', true).change()
      expect(@view.hasValidValue()).toBe true

      # pick system
      @view.$('.timing-repeat-dayofweek-view select[name="vs_codesystem"] > option[value="http://hl7.org/fhir/days-of-week"]').prop('selected', true).change()
      expect(@view.hasValidValue()).toBe true

      # pick code
      @view.$('.timing-repeat-dayofweek-view select[name="vs_code"] > option[value="thu"]').prop('selected', true).change()
      # check value
      expect(@view.value).toBeDefined()
      expect(@view.hasValidValue()).toBe true
      expect(@view.value.dayOfWeek[0].value).toEqual 'thu'

    it 'when changed with valid value', ->
      expect(@view.hasValidValue()).toBe false
      expect(@view.value).toBe null
      expect(@view.$(".timing-repeat-when-view select[name='valueset']").val()).toBe '--'

      # pick valueset
      @view.$('.timing-repeat-when-view select[name="valueset"] > option[value="event-timing"]').prop('selected', true).change()
      expect(@view.hasValidValue()).toBe true

      # pick system
      @view.$('.timing-repeat-when-view select[name="vs_codesystem"] > option[value="http://hl7.org/fhir/event-timing"]').prop('selected', true).change()
      expect(@view.hasValidValue()).toBe true

      # pick code
      @view.$('.timing-repeat-when-view select[name="vs_code"] > option[value="EVE"]').prop('selected', true).change()
      # check value
      expect(@view.value).toBeDefined()
      expect(@view.hasValidValue()).toBe true
      expect(@view.value.when[0].value).toEqual 'EVE'

    it 'timeofday changed with valid value', ->
      expect(@view.hasValidValue()).toBe false
      @view.$(".timing-repeat-timeofday-view input[name='time_is_defined']").prop('checked', true).change()
      @view.$(".timing-repeat-timeofday-view input[name='time']").val('09:45').change()
      expect(@view.timeOfDayView.value).toBeDefined()
      expect(@view.timeOfDayView.value.value).toBe '09:45'
      expect(@view.value).toBeDefined()
      expect(@view.hasValidValue()).toBe true
      expect(@view.value.timeOfDay[0].value).toBe '09:45'
