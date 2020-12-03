  describe 'Expected vs  Actual Comparisons', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      bonnie.measures = new Thorax.Collections.Measures()
      @cqlMeasure = loadFhirMeasure'fhir_measures/CMS111/CMS111.json'
      @population = @cqlMeasure.get('populations').at(0)
      observationDecimal = getJSONFixture 'fhir_patients/CMS111/Observation_Decimal.json'
      @cqlPatients = new Thorax.Collections.Patients [observationDecimal], parse: true
      @cqlMeasure.set('patients', @cqlPatients)
      @measureView = new Thorax.Views.Measure(model: @cqlMeasure, patients: @cqlPatients, populations: @cqlMeasure.get('populations'), population: @cqlMeasure.get('displayedPopulation'))
      bonnie.measures.add @cqlMeasure
      @measureView.appendTo 'body'

    afterAll ->
      @measureView.remove()

    it 'compares actual vs expected to only 8 decimal places', ->
      passes = $("div.patient-name:contains('Decimal Observation')").closest('.panel-heading').next().find('.pass').length
      expect(passes).toEqual 3

    xit 'displays actual and expected to only 8 decimal places', ->
      observ_td = $("td:contains('OBSERV')")
      expected = observ_td.next()[0].innerText.trim()
      actual = observ_td.next().next()[0].innerText.trim()
      expect(expected).toEqual "0.33333333"
      expect(actual).toEqual "0.33333333"
