describe 'InputView', ->

  describe 'CodingView', ->

    beforeAll ->
      # load up a measure so we have valuesets
      jasmine.getJSONFixtures().clearCache()
      @measure = loadFhirMeasure 'fhir_measures/CMS108/CMS108.json'

    it 'starts with no valid value', ->
      view = new Thorax.Views.InputCodingView(cqmValueSets: @measure.get('cqmValueSets'))
      view.render()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null
      expect(view.$('select[name="valueset"]').val()).toBe '--'

    it 'starts with no valid value but allows for null', ->
      view = new Thorax.Views.InputCodingView(cqmValueSets: @measure.get('cqmValueSets'), allowNull: true)
      view.render()
      expect(view.hasValidValue()).toBe true
      expect(view.value).toBe null
      expect(view.$('select[name="valueset"]').val()).toBe '--'

    it 'starts with value in measure value sets', ->
      initialCode = new cqm.models.Coding()
      initialCode.system = cqm.models.PrimitiveUri.parsePrimitive('SNOMEDCT')
      initialCode.code = cqm.models.PrimitiveCode.parsePrimitive('183452005')
      view = new Thorax.Views.InputCodingView(initialValue: initialCode, cqmValueSets: @measure.get('cqmValueSets'))
      view.render()
      expect(view.hasValidValue()).toBe true
      expect(view.value.code.value).toEqual  initialCode.code.value
      expect(view.value.system.value).toEqual  initialCode.system.value
      expect(view.$('select[name="valueset"]').val()).toBe '2.16.840.1.113883.3.666.5.307'
      expect(view.$('select[name="vs_codesystem"]').val()).toBe 'SNOMEDCT'
      expect(view.$('select[name="vs_code"]').val()).toBe '183452005'

    it 'starts with value not in measure value sets', ->
      initialCode = new cqm.models.Coding()
      initialCode.system = cqm.models.PrimitiveUri.parsePrimitive('SNOMEDCT')
      initialCode.code = cqm.models.PrimitiveCode.parsePrimitive('467186001')

      view = new Thorax.Views.InputCodingView(initialValue: initialCode, cqmValueSets: @measure.get('cqmValueSets'))
      view.render()
      expect(view.hasValidValue()).toBe true
      expect(view.value.code.value).toEqual '467186001'
      expect(view.value.system.value).toEqual 'SNOMEDCT'
      expect(view.$('select[name="valueset"]').val()).toBe 'custom'
      expect(view.$('select[name="custom_codesystem_select"]').val()).toBe 'SNOMEDCT'
      expect(view.$('input[name="custom_codesystem"]').val()).toBe 'SNOMEDCT'
      expect(view.$('input[name="custom_codesystem"]').prop('disabled')).toBe true
      expect(view.$('input[name="custom_code"]').val()).toBe '467186001'

    it 'starts with value not in measure value sets and custom codesystem', ->
      # completely random code
      initialCode = new cqm.models.Coding()
      initialCode.system = cqm.models.PrimitiveUri.parsePrimitive('QUODE')
      initialCode.code = cqm.models.PrimitiveCode.parsePrimitive('1233.22')

      view = new Thorax.Views.InputCodingView(initialValue: initialCode, cqmValueSets: @measure.get('cqmValueSets'))
      view.render()
      expect(view.hasValidValue()).toBe true
      expect(view.value.code.value).toEqual '1233.22'
      expect(view.value.system.value).toEqual 'QUODE'
      expect(view.$('select[name="valueset"]').val()).toBe 'custom'
      expect(view.$('select[name="custom_codesystem_select"]').val()).toBe ''
      expect(view.$('input[name="custom_codesystem"]').val()).toBe 'QUODE'
      expect(view.$('input[name="custom_codesystem"]').prop('disabled')).toBe false
      expect(view.$('input[name="custom_code"]').val()).toBe '1233.22'

    it 'starts with no valid value, selects from value set, and goes back to no selection', ->
      view = new Thorax.Views.InputCodingView(cqmValueSets: @measure.get('cqmValueSets'))
      view.render()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null
      expect(view.$('select[name="valueset"]').val()).toBe '--'

      # pick valueset
      view.$('select[name="valueset"] > option[value="2.16.840.1.113883.3.666.5.307"]').prop('selected', true).change()
      expect(view.hasValidValue()).toBe true

      # pick system
      view.$('select[name="vs_codesystem"] > option[value="SNOMEDCT"]').prop('selected', true).change()
      expect(view.hasValidValue()).toBe true

      # pick code
      view.$('select[name="vs_code"] > option[value="32485007"]').prop('selected', true).change()
      # check value
      expect(view.value.code.value).toEqual '32485007'
      expect(view.value.system.value).toEqual 'SNOMEDCT'

      # go back to no selection
      view.$('select[name="valueset"] > option:first').prop('selected', true).change()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

    it 'starts with no valid value, selects from value set, and goes back to no selection using clear function', ->
      view = new Thorax.Views.InputCodingView(cqmValueSets: @measure.get('cqmValueSets'))
      view.render()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null
      expect(view.$('select[name="valueset"]').val()).toBe '--'

      # pick valueset
      view.$('select[name="valueset"] > option[value="2.16.840.1.113883.3.666.5.307"]').prop('selected', true).change()
      expect(view.hasValidValue()).toBe true

      # pick code system
      view.$('select[name="vs_codesystem"] > option[value="SNOMEDCT"]').prop('selected', true).change()
      expect(view.hasValidValue()).toBe true

      # pick code
      view.$('select[name="vs_code"] > option[value="32485007"]').prop('selected', true).change()
      # check value
      expect(view.value.code.value).toEqual '32485007'
      expect(view.value.system.value).toEqual 'SNOMEDCT'

      # go back to no selection
      view.resetCodeSelection()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null