describe 'InputView', ->

  describe 'CodeView', ->

    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      @measure = loadFhirMeasure 'fhir_measures/CMS108/CMS108.json'

    it 'null is not valid when required', ->
      view = new Thorax.Views.InputCodeView(cqmValueSets: FhirValueSets.ENCOUNTER_STATUS_VS, codeSystemMap: @measure.codeSystemMap())
      view.render()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null
      expect(view.$('select[name="valueset"]').val()).toBe '--'

    it 'null is valid when not required', ->
      view = new Thorax.Views.InputCodeView(cqmValueSets: FhirValueSets.ENCOUNTER_STATUS_VS, allowNull: true, codeSystemMap: @measure.codeSystemMap())
      view.render()
      expect(view.hasValidValue()).toBe true
      expect(view.value).toBe null
      expect(view.$('select[name="valueset"]').val()).toBe '--'

    it 'start with a valid code', ->
      initialCode = 'planned'
      view = new Thorax.Views.InputCodeView(initialValue: initialCode, cqmValueSets: FhirValueSets.ENCOUNTER_STATUS_VS, codeSystemMap: @measure.codeSystemMap())
      view.render()
      expect(view.hasValidValue()).toBe true
      expect(view.value).toBe 'planned'
      expect(view.$('select[name="valueset"]').val()).toBe '--'
      expect(view.$('select[name="vs_codesystem"]').val()).toBe null
      expect(view.$('select[name="vs_code"]').val()).toBe null

    it 'starts with no valid value, selects from value set, and goes back to no selection', ->
      view = new Thorax.Views.InputCodeView(cqmValueSets: FhirValueSets.ENCOUNTER_STATUS_VS)
      view.render()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null
      expect(view.$('select[name="valueset"]').val()).toBe '--'

      # pick valueset
      view.$('select[name="valueset"] > option[value="encounter-status"]').prop('selected', true).change()
      expect(view.$('select[name="valueset"]').val()).toBe 'encounter-status'
      expect(view.hasValidValue()).toBe true

      # pick system
      view.$('select[name="vs_codesystem"] > option[value="encounter-status"]').prop('selected', true).change()
      expect(view.$('select[name="vs_codesystem"]').val()).toBe 'http://hl7.org/fhir/encounter-status'
      expect(view.hasValidValue()).toBe true

      # pick code
      view.$('select[name="vs_code"] > option[value="arrived"]').prop('selected', true).change()
      # check value
      expect(view.value).toEqual 'arrived'

      # go back to no selection
      view.$('select[name="valueset"] > option:first').prop('selected', true).change()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

    it 'starts with no valid value, selects from value set, and goes back to no selection', ->
      view = new Thorax.Views.InputCodeView(cqmValueSets: FhirValueSets.ENCOUNTER_STATUS_VS, codeSystemMap: @measure.codeSystemMap())
      view.render()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null
      expect(view.$('select[name="valueset"]').val()).toBe '--'

      # pick valueset
      view.$('select[name="valueset"] > option[value="encounter-status"]').prop('selected', true).change()
      expect(view.hasValidValue()).toBe true

      # pick system
      view.$('select[name="vs_codesystem"] > option[value="encounter-status"]').prop('selected', true).change()
      expect(view.hasValidValue()).toBe true

      # pick code
      view.$('select[name="vs_code"] > option[value="arrived"]').prop('selected', true).change()
      # check value
      expect(view.value).toEqual 'arrived'

      # go back to no selection
      view.$('select[name="valueset"] > option:first').prop('selected', true).change()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

    it 'starts with no valid value, selects from value set, and goes back to no selection using clear function', ->
      view = new Thorax.Views.InputCodeView(cqmValueSets: FhirValueSets.ENCOUNTER_STATUS_VS, codeSystemMap: @measure.codeSystemMap())
      view.render()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null
      expect(view.$('select[name="valueset"]').val()).toBe '--'

      # pick valueset
      view.$('select[name="valueset"] > option[value="encounter-status"]').prop('selected', true).change()
      expect(view.hasValidValue()).toBe true

      # pick code system
      view.$('select[name="vs_codesystem"] > option[value="encounter-status"]').prop('selected', true).change()
      expect(view.hasValidValue()).toBe true

      # pick code
      view.$('select[name="vs_code"] > option[value="planned"]').prop('selected', true).change()
      # check value
      expect(view.value).toEqual 'planned'

      # go back to no selection
      view.resetCodeSelection()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

    it 'starts with no valid value, selects custom value', ->
      view = new Thorax.Views.InputCodeView(cqmValueSets: FhirValueSets.ENCOUNTER_STATUS_VS, codeSystemMap: @measure.codeSystemMap())
      view.render()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null
      expect(view.$('select[name="valueset"]').val()).toBe '--'

      # pick valueset
      view.$('select[name="valueset"] > option[value="custom"]').prop('selected', true).change()
      expect(view.$('select[name="valueset"]').val()).toBe 'custom'

      # verify code system
      expect(view.$('select[name="custom_codesystem_select"]').prop('disabled')).toBe true
      expect(view.$('select[name="custom_codesystem_select"]').val()).toBe 'http://hl7.org/fhir/encounter-status'
      expect(view.$('input[name="custom_codesystem"]').prop('disabled')).toBe true
      view.$('input[name="custom_codesystem"]').prop('disabled', false)
      expect(view.$('input[name="custom_codesystem"]').val()).toBe 'encounter-status'

      # pick code
      view.$('input[name="custom_code"]').val('random value').change();
      expect(view.$('input[name="custom_code"]').val()).toBe 'random value'

      # check value
      expect(view.hasValidValue()).toBe true
      expect(view.value).toEqual 'random value'

      # go back to no selection
      view.resetCodeSelection()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null
