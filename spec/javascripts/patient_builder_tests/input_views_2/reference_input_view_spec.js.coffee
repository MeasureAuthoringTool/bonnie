describe 'InputView', ->

  describe 'ReferenceView', ->

    beforeAll ->
      # load up a measure so we have valuesets
      jasmine.getJSONFixtures().clearCache()
      @measure = loadFhirMeasure 'fhir_measures/CMS108/CMS108.json'

    it 'starts with no valid value, no valueset or referenceType', ->
      view = new Thorax.Views.InputReferenceView(cqmValueSets: @measure.get('cqmValueSets'), referenceTypes: ['Condition', 'Procedure'])
      view.render()
      expect(view.hasValidValue()).toBe false
      expect(view.value?.type).toBe null
      expect(view.value?.vs).toBe null
      expect(view.$('select[name="valueset"]').val()).toBe '--'
      expect(view.$('select[name="referenceType"]').val()).toBe ''

    it 'starts with no valid value, selects from value set, and goes back to no selection', ->
      view = new Thorax.Views.InputReferenceView(cqmValueSets: @measure.get('cqmValueSets'), referenceTypes: ['Condition', 'Procedure'])
      view.render()
      expect(view.hasValidValue()).toBe false
      expect(view.value?.type).toBe null
      expect(view.value?.vs).toBe null
      expect(view.$('select[name="valueset"]').val()).toBe '--'
      expect(view.$('select[name="referenceType"]').val()).toBe ''

      # pick referenceType
      view.$('select[name="referenceType"] > option[value="Condition"]').prop('selected', true).change()

      # pick valueset
      view.$('select[name="valueset"] > option[value="2.16.840.1.113883.3.666.5.307"]').prop('selected', true).change()

      expect(view.hasValidValue()).toBe true

      # check reference information
      expect(view.value.type).toEqual 'Condition'
      expect(view.value.vs).toEqual '2.16.840.1.113883.3.666.5.307'

      # go back to no selection
      view.$('select[name="valueset"] > option:first').prop('selected', true).change()
      expect(view.$('select[name="valueset"]').val()).toBe '--'
      expect(view.value?.type).toBe 'Condition'
      expect(view.value?.vs).toBe null
      expect(view.hasValidValue()).toBe false

      view.$('select[name="referenceType"] > option:first').prop('selected', true).change()
      expect(view.$('select[name="referenceType"]').val()).toBe ''
      expect(view.value?.type).toBe null
      expect(view.value?.vs).toBe null
      expect(view.hasValidValue()).toBe false
