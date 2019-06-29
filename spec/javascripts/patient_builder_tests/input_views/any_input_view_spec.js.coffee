describe 'InputView', ->

  describe 'AnyView', ->

    beforeAll ->
      # load up a measure so we have valuesets
      jasmine.getJSONFixtures().clearCache()
      @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS160v6/CMS160v6.json', 'cqm_measure_data/CMS160v6/value_sets.json'

    it 'starts with no valid value', ->
      view = new Thorax.Views.InputAnyView(attributeName: 'attributeNameTest', cqmValueSets: @measure, codeSystemMap: @measure.codeSystemMap())
      view.render()
      expect(view.hasValidValue()).toBe false
      expect(view.currentType).toEqual '' 
      expect(view.value).toBe null