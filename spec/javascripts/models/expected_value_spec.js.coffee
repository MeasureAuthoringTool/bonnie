  describe 'Expected vs  Actual Comparisons', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      bonnie.measures = new Thorax.Collections.Measures()
      @cqlMeasure = loadMeasureWithValueSets 'cqm_measure_data/core_measures/CMS32/CMS32v7.json', 'cqm_measure_data/core_measures/CMS32/value_sets.json'
      @population = @cqlMeasure.get('populations').at(0)
      @cqlPatients = new Thorax.Collections.Patients getJSONFixture('cqm_patients/core_measures/CMS32/patients.json'), parse: true
      @cqlMeasure.set('patients',@cqlPatients)
      @measureView = new Thorax.Views.Measure(model: @cqlMeasure, patients: @cqlPatients, populations: @cqlMeasure.get('populations'), population: @cqlMeasure.get('displayedPopulation'))
      bonnie.measures.add @cqlMeasure
      @measureView.appendTo 'body'

    afterAll ->
      @measureView.remove()

    xit 'compares actual vs expected to only 8 decimal places', ->
      pt1_passes = $("div.patient-name:contains('Visits 2 ED')").closest('.panel-heading').next().find('.pass').length
      pt2_passes = $("div.patient-name:contains('Visits 1 Excl 2 ED')").closest('.panel-heading').next().find('.pass').length
      expect(pt1_passes).toEqual 4
      expect(pt2_passes).toEqual 4

    xit 'displays actual and expected to only 8 decimal places', ->
      observ_td = $("td:contains('OBSERV_1')")
      expected = observ_td.next()[0].innerText.trim()
      actual = observ_td.next().next()[0].innerText.trim()
      expect(expected).toEqual "0.33333333"
      expect(actual).toEqual "0.33333333"
