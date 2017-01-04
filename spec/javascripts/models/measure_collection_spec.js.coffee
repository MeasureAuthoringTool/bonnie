describe 'MeasureCollection', ->

  describe 'base_set', ->
    beforeEach ->
      window.bonnieRouterCache.load('base_set')

    it 'has the correct number of measures defined (when defining a measure object for each population)', ->
      expect(bonnie.measures.length).toEqual 6

    it 'has the correct number of populations defined (when expanding measures into populations)', ->
      expect(bonnie.measures.populations().length).toEqual 14

  describe 'empty_set', ->
    beforeEach ->
      window.bonnieRouterCache.load('empty_set')

    it 'has no measures', ->
      expect(bonnie.measures.length).toEqual 0

    it 'has no populations', ->
      expect(bonnie.measures.populations().length).toEqual 0
