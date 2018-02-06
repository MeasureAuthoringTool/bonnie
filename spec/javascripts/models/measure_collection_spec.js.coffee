describe 'MeasureCollection', ->

  describe 'front end measures', ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      @measureCollection = new Thorax.Collections.Measures()
      @measureCMS134 = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS134/CMS134v6.json'), parse: true
      @measureCMS158 = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS158/CMS158v6.json'), parse: true
      @measureCMS160 = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS160/CMS160v6.json'), parse: true
      @measureCMS177 = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS177/CMS177v6.json'), parse: true
      @measureCMS32 = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS32/CMS32v7.json'), parse: true
      @measureCollection.add(@measureCMS134)
      @measureCollection.add(@measureCMS158)
      @measureCollection.add(@measureCMS160)
      @measureCollection.add(@measureCMS177)
      @measureCollection.add(@measureCMS32)

    it 'has the correct number of measures defined (when defining a measure object for each population)', ->
      expect(@measureCollection.length).toEqual 5

    it 'has the correct number of populations defined (when expanding measures into populations)', ->
      expect(@measureCollection.populations().length).toEqual 10

  describe 'empty_set', ->
    beforeEach ->
      @measureCollection = new Thorax.Collections.Measures()

    it 'has no measures', ->
      expect(@measureCollection.length).toEqual 0

    it 'has no populations', ->
      expect(@measureCollection.populations().length).toEqual 0
