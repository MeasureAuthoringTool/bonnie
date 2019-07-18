describe 'InputView', ->

  describe 'CodeView', ->

    beforeAll ->
      # load up a measure so we have valuesets
      jasmine.getJSONFixtures().clearCache()
      @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS160v6/CMS160v6.json', 'cqm_measure_data/CMS160v6/value_sets.json'

    it 'starts with no valid value', ->
      view = new Thorax.Views.InputCodeView(cqmValueSets: @measure.get('cqmValueSets'), codeSystemMap: @measure.codeSystemMap())
      view.render()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null
      expect(view.$('select[name="valueset"]').val()).toBe '--'

    it 'starts with no valid value but allows for null', ->
      view = new Thorax.Views.InputCodeView(cqmValueSets: @measure.get('cqmValueSets'), codeSystemMap: @measure.codeSystemMap(), allowNull: true)
      view.render()
      expect(view.hasValidValue()).toBe true
      expect(view.value).toBe null
      expect(view.$('select[name="valueset"]').val()).toBe '--'

    it 'starts with value in measure value sets', ->
      # in "Bipolar Disorder" oid "2.16.840.1.113883.3.67.1.101.1.128"
      initialCode = new cqm.models.CQL.Code('191618007', '2.16.840.1.113883.6.96', undefined, "Bipolar affective disorder, current episode manic (disorder)")
      view = new Thorax.Views.InputCodeView(initialValue: initialCode, cqmValueSets: @measure.get('cqmValueSets'), codeSystemMap: @measure.codeSystemMap())
      view.render()
      expect(view.hasValidValue()).toBe true
      expect(view.value).toEqual initialCode
      expect(view.$('select[name="valueset"]').val()).toBe '2.16.840.1.113883.3.67.1.101.1.128'
      expect(view.$('select[name="vs_codesystem"]').val()).toBe '2.16.840.1.113883.6.96'
      expect(view.$('select[name="vs_code"]').val()).toBe '191618007'

    it 'starts with value not in measure value sets', ->
      # SNOMED-CT: 467186001 "Cross-country skiing exerciser (physical object)""
      initialCode = new cqm.models.CQL.Code('467186001', '2.16.840.1.113883.6.96', undefined, "Cross-country skiing exerciser (physical object)")
      view = new Thorax.Views.InputCodeView(initialValue: initialCode, cqmValueSets: @measure.get('cqmValueSets'), codeSystemMap: @measure.codeSystemMap())
      view.render()
      expect(view.hasValidValue()).toBe true
      expect(view.value.code).toEqual '467186001'
      expect(view.value.system).toEqual '2.16.840.1.113883.6.96'
      expect(view.$('select[name="valueset"]').val()).toBe 'custom'
      expect(view.$('select[name="custom_codesystem_select"]').val()).toBe '2.16.840.1.113883.6.96'
      expect(view.$('input[name="custom_codesystem"]').val()).toBe 'SNOMED-CT'
      expect(view.$('input[name="custom_codesystem"]').prop('disabled')).toBe true
      expect(view.$('input[name="custom_code"]').val()).toBe '467186001'

    it 'starts with value not in measure value sets and custom codesystem', ->
      # completely random code
      initialCode = new cqm.models.CQL.Code('1233.22', 'QUODE', undefined, undefined)
      view = new Thorax.Views.InputCodeView(initialValue: initialCode, cqmValueSets: @measure.get('cqmValueSets'), codeSystemMap: @measure.codeSystemMap())
      view.render()
      expect(view.hasValidValue()).toBe true
      expect(view.value.code).toEqual '1233.22'
      expect(view.value.system).toEqual 'QUODE'
      expect(view.$('select[name="valueset"]').val()).toBe 'custom'
      expect(view.$('select[name="custom_codesystem_select"]').val()).toBe ''
      expect(view.$('input[name="custom_codesystem"]').val()).toBe 'QUODE'
      expect(view.$('input[name="custom_codesystem"]').prop('disabled')).toBe false
      expect(view.$('input[name="custom_code"]').val()).toBe '1233.22'

    it 'starts with no valid value, selects from value set, and goes back to no selection', ->
      view = new Thorax.Views.InputCodeView(cqmValueSets: @measure.get('cqmValueSets'), codeSystemMap: @measure.codeSystemMap())
      view.render()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null
      expect(view.$('select[name="valueset"]').val()).toBe '--'

      # pick "Bipolar Disorder" valueset
      view.$('select[name="valueset"] > option[value="2.16.840.1.113883.3.67.1.101.1.128"]').prop('selected', true).change()
      expect(view.hasValidValue()).toBe true

      # pick ICD-9-CM code system "2.16.840.1.113883.6.103"
      view.$('select[name="vs_codesystem"] > option[value="2.16.840.1.113883.6.103"]').prop('selected', true).change()
      expect(view.hasValidValue()).toBe true

      # pick "Bipolar I disorder, most recent episode (or current) mixed, in partial or unspecified remission"
      view.$('select[name="vs_code"] > option[value="296.65"]').prop('selected', true).change()
      # check value
      expect(view.value).toEqual new cqm.models.CQL.Code("296.65", "2.16.840.1.113883.6.103", undefined, "Bipolar I disorder, most recent episode (or current) mixed, in partial or unspecified remission")

      # go back to no selection
      view.$('select[name="valueset"] > option:first').prop('selected', true).change()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

    it 'starts with no valid value, selects from value set, and goes back to no selection using clear function', ->
      view = new Thorax.Views.InputCodeView(cqmValueSets: @measure.get('cqmValueSets'), codeSystemMap: @measure.codeSystemMap())
      view.render()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null
      expect(view.$('select[name="valueset"]').val()).toBe '--'

      # pick "Bipolar Disorder" valueset
      view.$('select[name="valueset"] > option[value="2.16.840.1.113883.3.67.1.101.1.128"]').prop('selected', true).change()
      expect(view.hasValidValue()).toBe true

      # pick ICD-9-CM code system "2.16.840.1.113883.6.103"
      view.$('select[name="vs_codesystem"] > option[value="2.16.840.1.113883.6.103"]').prop('selected', true).change()
      expect(view.hasValidValue()).toBe true

      # pick "Bipolar I disorder, most recent episode (or current) mixed, in partial or unspecified remission"
      view.$('select[name="vs_code"] > option[value="296.65"]').prop('selected', true).change()
      # check value
      expect(view.value).toEqual new cqm.models.CQL.Code("296.65", "2.16.840.1.113883.6.103", undefined, "Bipolar I disorder, most recent episode (or current) mixed, in partial or unspecified remission")

      # go back to no selection
      view.resetCodeSelection()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null