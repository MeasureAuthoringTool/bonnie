  describe 'Expected vs  Actual Comparisons for CV measure', ->
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

  describe 'Expected vs  Actual Comparisons for ratio measure', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      bonnie.measures = new Thorax.Collections.Measures()
      @cqmMeasure = loadMeasureWithValueSets 'cqm_measure_data/CMS871v2/CMS871v2.json', 'cqm_measure_data/CMS871v2/value_sets.json'
      @population = @cqmMeasure.get('populations').at(0)
      patient = getJSONFixture 'patients/CMS871v2/patient.json'
      @cqmPatients = new Thorax.Collections.Patients [patient], parse: true
      @cqmMeasure.set('patients', @cqmPatients)
      @measureView = new Thorax.Views.Measure(model: @cqmMeasure, patients: @cqmPatients, populations: @cqmMeasure.get('populations'), population: @cqmMeasure.get('displayedPopulation'))
      bonnie.measures.add @cqmMeasure
      @measureView.appendTo 'body'

    afterAll ->
      @measureView.remove()

    it 'compares actual vs expected', ->
      passes = $("div.patient-name:contains('2IP1DENEXFail TEST')").closest('.panel-heading').next().find('.pass').length
      expect(passes).toEqual 8
      episode1DenomObs = $("td:contains('EPISODE 1- DENOM OBSERV')")
      expected = episode1DenomObs.next()[0].innerText.trim()
      actual = episode1DenomObs.next().next()[0].innerText.trim()
      expect(expected).toEqual "0"
      expect(actual).toEqual "0"

      episode1NumerObs = $("td:contains('EPISODE 1- NUMER OBSERV')")
      expected = episode1NumerObs.next()[0].innerText.trim()
      actual = episode1NumerObs.next().next()[0].innerText.trim()
      expect(actual).toEqual "0"
      expect(expected).toEqual "0"

      episode2DenomObs = $("td:contains('EPISODE 2- DENOM OBSERV')")
      expected = episode2DenomObs.next()[0].innerText.trim()
      actual = episode2DenomObs.next().next()[0].innerText.trim()
      expect(actual).toEqual "5"
      expect(expected).toEqual "5"

      episode2NumerObs = $("td:contains('EPISODE 2- NUMER OBSERV')")
      expected = episode2NumerObs.next()[0].innerText.trim()
      actual = episode2NumerObs.next().next()[0].innerText.trim()
      expect(actual).toEqual "1"
      expect(expected).toEqual "1"
