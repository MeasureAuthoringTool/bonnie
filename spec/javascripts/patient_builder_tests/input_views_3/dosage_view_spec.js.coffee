describe 'InputView', ->

  describe 'DosageView', ->

    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      @measure = loadFhirMeasure 'cqm_measure_data/CMS1027v0/CMS1027v0.json'
      @view = new Thorax.Views.InputDosageView({
        cqmValueSets: @measure.get('cqmValueSets'),
        codeSystemMap: @measure.codeSystemMap()
      })
      @view.render()

    it 'initializes', ->
      expect(@view.hasValidValue()).toBe false
      expect(@view.subviews).toBeDefined()
      expect(@view.subviews.length).toBe 14
      expect(@view.value).toBe null

    it 'with valid values for sub views', ->
      expect(@view.hasValidValue()).toBe false
      @view.sequenceView.$('input[name="value"]').val('12').change()
      expect(@view.sequenceView.hasValidValue()).toBe true
      expect(@view.sequenceView.value.value).toBe 12
      expect(@view.hasValidValue()).toBe true

      @view.textView.$('input[name="value"]').val('some text').change()
      expect(@view.textView.hasValidValue()).toBe true
      expect(@view.textView.value.value).toEqual 'some text'
      expect(@view.hasValidValue()).toBe true

      @view.additionalInstructionView.$('select[name="valueset"] > option[value="additional-instruction-codes"]').prop('selected', true).change()
      expect(@view.additionalInstructionView.hasValidValue()).toBe true
      expect(@view.additionalInstructionView.value.system.value).toEqual 'http://snomed.info/sct'
      expect(@view.additionalInstructionView.value.code.value).toEqual '311501008'
      expect(@view.hasValidValue()).toBe true

      @view.methodView.$('select[name="valueset"] > option[value="administration-method-codes"]').prop('selected', true).change()
      expect(@view.methodView.hasValidValue()).toBe true
      expect(@view.methodView.value.system.value).toEqual 'http://snomed.info/sct'
      expect(@view.methodView.value.code.value).toEqual '417924000'
      expect(@view.hasValidValue()).toBe true

      @view.typeView.$('select[name="valueset"] > option[value="dose-rate-type"]').prop('selected', true).change()
      expect(@view.typeView.hasValidValue()).toBe true
      expect(@view.typeView.value.system.value).toEqual 'http://terminology.hl7.org/CodeSystem/dose-rate-type'
      expect(@view.typeView.value.code.value).toEqual 'calculated'
      expect(@view.hasValidValue()).toBe true

      @view.rateView.$('select[name="type"] > option[value="SimpleQuantity"]').prop('selected', true).change()
      @view.rateView.$('input[name="value_value"]').val(1).change()
      @view.rateView.$('input[name="value_unit"]').val('d').change()
      expect(@view.rateView.hasValidValue()).toBe true
      expect(@view.rateView.value.value.value).toEqual 1
      expect(@view.rateView.value.unit.value).toEqual 'd'
      expect(@view.hasValidValue()).toBe true

    it 'with invalid values', ->
      expect(@view.hasValidValue()).toBe false
      @view.sequenceView.$('input[name="value"]').val('invalid').change()
      expect(@view.sequenceView.hasValidValue()).toBe false
      expect(@view.hasValidValue()).toBe false

      # correct the invalid value
      @view.sequenceView.$('input[name="value"]').val('1').change()
      expect(@view.sequenceView.hasValidValue()).toBe true
      expect(@view.hasValidValue()).toBe true
