describe 'MeasureCollection', ->

  describe 'front end measures', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      @measureCollection = new Thorax.Collections.Measures()
      @measureCMS104 = loadFhirMeasure('fhir_measures/CMS104/CMS104.json')
      @measureCMS108 = loadFhirMeasure('fhir_measures/CMS108/CMS108.json')
      @measureCMS124 = loadFhirMeasure('fhir_measures/CMS124/CMS124.json')
      @measureCollection.add(@measureCMS104)
      @measureCollection.add(@measureCMS108)
      @measureCollection.add(@measureCMS124)

    it 'has the correct number of measures defined (when defining a measure object for each population)', ->
      expect(@measureCollection.length).toEqual 3

    it 'has the correct number of populations defined (when expanding measures into populations)', ->
      expect(@measureCollection.populations().length).toEqual 3

  describe 'empty_set', ->
    beforeAll ->
      @measureCollection = new Thorax.Collections.Measures()

    it 'has no measures', ->
      expect(@measureCollection.length).toEqual 0

    it 'has no populations', ->
      expect(@measureCollection.populations().length).toEqual 0
