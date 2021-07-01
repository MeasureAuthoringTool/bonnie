describe 'MeasureCollection', ->

  describe 'front end measures', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      @measureCollection = new Thorax.Collections.Measures()
      @measureCMS134 = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/CMS134v6/CMS134v6.json'), parse: true
      @measureCMS158 = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/CMS158v6/CMS158v6.json'), parse: true
      @measureCMS160 = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/CMS160v6/CMS160v6.json'), parse: true
      @measureCMS177 = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/CMS177v6/CMS177v6.json'), parse: true
      @measureCMS903 = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/CMS903v0/CMS903v0.json'), parse: true
      @measureCollection.add(@measureCMS134)
      @measureCollection.add(@measureCMS158)
      @measureCollection.add(@measureCMS160)
      @measureCollection.add(@measureCMS177)
      @measureCollection.add(@measureCMS903)

    it 'has the correct number of measures defined (when defining a measure object for each population)', ->
      expect(@measureCollection.length).toEqual 5

    it 'has the correct number of populations defined (when expanding measures into populations)', ->
      expect(@measureCollection.populations().length).toEqual 10

  describe 'empty_set', ->
    beforeAll ->
      @measureCollection = new Thorax.Collections.Measures()

    it 'has no measures', ->
      expect(@measureCollection.length).toEqual 0

    it 'has no populations', ->
      expect(@measureCollection.populations().length).toEqual 0
