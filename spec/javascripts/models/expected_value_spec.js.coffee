  describe 'Expected vs  Actual Comparisons', ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      @universalValueSetsByMeasureId = bonnie.valueSetsByMeasureId
      bonnie.valueSetsByMeasureId = getJSONFixture('cqm_measure_data/special_measures/CMS890/value_sets.json')
      bonnie.measures = new Thorax.Collections.Measures()
      @cqlMeasure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/special_measures/CMS890/CMS890v0.json'), parse: true
      @population = @cqlMeasure.get('populations').at(0)
      @cqlPatients = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMS890/patients.json'), parse: true
      @cqlMeasure.set('patients',@cqlPatients)
      @measureView = new Thorax.Views.Measure(model: @cqlMeasure, patients: @cqlPatients, populations: @cqlMeasure.get('populations'), population: @cqlMeasure.get('displayedPopulation'))
      bonnie.measures.add @cqlMeasure      
      @measureView.appendTo 'body'

    afterEach ->
      bonnie.valueSetsByMeasureId = @universalValueSetsByMeasureId
      @measureView.remove()

    it 'compares actual vs expected to only 8 decimal places', ->
      pt1_passes = $("div.patient-name:contains('doe jon')").closest('.panel-heading').next().find('.pass').length
      pt2_passes = $("div.patient-name:contains('smith jane')").closest('.panel-heading').next().find('.pass').length
      expect(pt1_passes).toEqual 4
      expect(pt2_passes).toEqual 4

    it 'displays actual and expected to only 8 decimal places', ->
      observ_td = $("td:contains('OBSERV_1')")
      expected = observ_td.next()[0].innerText.trim()
      actual = observ_td.next().next()[0].innerText.trim()
      expect(expected).toEqual "0.33333333"
      expect(actual).toEqual "0.33333333"
