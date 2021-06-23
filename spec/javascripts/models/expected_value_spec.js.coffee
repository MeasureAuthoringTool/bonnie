  describe 'Expected vs  Actual Comparisons', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      bonnie.measures = new Thorax.Collections.Measures()
      @cqlMeasure = loadMeasureWithValueSets 'cqm_measure_data/CMS890v0/CMS890v0.json', 'cqm_measure_data/CMS890v0/value_sets.json'
      @population = @cqlMeasure.get('populations').at(0)
      observationDecimal = getJSONFixture 'patients/CMS890v0/Observation_Decimal.json'
      @cqlPatients = new Thorax.Collections.Patients [observationDecimal], parse: true
      @cqlMeasure.set('patients', @cqlPatients)
      @measureView = new Thorax.Views.Measure(model: @cqlMeasure, patients: @cqlPatients, populations: @cqlMeasure.get('populations'), population: @cqlMeasure.get('displayedPopulation'))
      bonnie.measures.add @cqlMeasure
      @measureView.appendTo 'body'

    afterAll ->
      @measureView.remove()

    it 'compares actual vs expected to only 8 decimal places', ->
      passes = $("div.patient-name:contains('Decimal Observation')").closest('.panel-heading').next().find('.pass').length
      expect(passes).toEqual 4

    it 'displays actual and expected to only 8 decimal places', ->
      observ_td = $("td:contains('OBSERV_1')")
      expected = observ_td.next()[0].innerText.trim()
      actual = observ_td.next().next()[0].innerText.trim()
      expect(expected).toEqual "0.33333333"
      expect(actual).toEqual "0.33333333"
