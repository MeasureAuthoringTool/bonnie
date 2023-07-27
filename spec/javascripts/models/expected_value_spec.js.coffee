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

  describe 'Expected vs  Actual Comparisons for episode based ratio measure', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      bonnie.measures = new Thorax.Collections.Measures()
      @cqmMeasure = loadMeasureWithValueSets 'cqm_measure_data/CMS871v2/CMS871v2.json', 'cqm_measure_data/CMS871v2/value_sets.json'
      @population = @cqmMeasure.get('populations').at(0)
      patient = getJSONFixture 'patients/CMS871v2/patient_1.json'
      @cqmPatients = new Thorax.Collections.Patients [patient], parse: true
      @cqmMeasure.set('patients', @cqmPatients)
      @measureView = new Thorax.Views.Measure(model: @cqmMeasure, patients: @cqmPatients, populations: @cqmMeasure.get('populations'), population: @cqmMeasure.get('displayedPopulation'))
      bonnie.measures.add @cqmMeasure
      @measureView.appendTo 'body'

    afterAll ->
      @measureView.remove()

    it 'compares actual vs expected', ->
      passes = $("div.patient-name:contains('1Denom1Denex1NumerPass Test')").closest('.panel-heading').next().find('i.pass').length
      expect(passes).toEqual 5
      episode1DenomObs = $("td:contains('DENOM OBSERV_1')")
      expected = episode1DenomObs.next()[0].innerText.trim()
      actual = episode1DenomObs.next().next()[0].innerText.trim()
      expect(expected).toEqual "5"
      expect(actual).toEqual "5"

      episode2DenomObs = $("td:contains('DENOM OBSERV_2')")
      expected = episode2DenomObs.next()[0].innerText.trim()
      actual = episode2DenomObs.next().next()[0].innerText.trim()
      expect(expected).toEqual "2"
      expect(actual).toEqual "N/A"

      episode1NumerObs = $("td:contains('NUMER OBSERV_1')")
      expected = episode1NumerObs.next()[0].innerText.trim()
      actual = episode1NumerObs.next().next()[0].innerText.trim()
      expect(actual).toEqual "1"
      expect(expected).toEqual "1"

  describe 'Expected vs  Actual Comparisons for patient based ratio measure', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      bonnie.measures = new Thorax.Collections.Measures()
      @cqmMeasure = loadMeasureWithValueSets 'cqm_measure_data/QPRMOEv0/QPRMOEv0.json', 'cqm_measure_data/QPRMOEv0/value_sets.json'
      @population = @cqmMeasure.get('populations').at(0)
      patient1 = getJSONFixture 'patients/QPRMOEv0/patient_1.json'
      patient2 = getJSONFixture 'patients/QPRMOEv0/patient_2.json'
      @cqmPatients = new Thorax.Collections.Patients [patient1, patient2], parse: true
      @cqmMeasure.set('patients', @cqmPatients)
      @measureView = new Thorax.Views.Measure(model: @cqmMeasure, patients: @cqmPatients, populations: @cqmMeasure.get('populations'), population: @cqmMeasure.get('displayedPopulation'))
      bonnie.measures.add @cqmMeasure
      @measureView.appendTo 'body'

    afterAll ->
      @measureView.remove()

    it 'compares actual vs expected for patient: "IPDENEXNUMER Pass"', ->
      passes = $("div.patient-name:contains('IPDENEXNUMER Pass')").closest('.panel-heading').next().find('i.pass').length
      expect(passes).toEqual 4
      denomObs = $("td:contains('DENOM OBSERV')")
      expected = denomObs.next()[0].innerText.trim()
      actual = denomObs.next().next()[0].innerText.trim()
      expect(expected).toEqual "1"
      expect(actual).toEqual "N/A"

      numerObs = $("td:contains('NUMER OBSERV')")
      expected = numerObs.next()[0].innerText.trim()
      actual = numerObs.next().next()[0].innerText.trim()
      expect(expected).toEqual "1"
      expect(actual).toEqual "2"

    it 'compares actual vs expected for patient: "NoOBSERV Test"', ->
      passes = $("div.patient-name:contains('NoOBSERV Test')").closest('.panel-heading').next().find('i.pass').length
      expect(passes).toEqual 5
      denomObs = $("div.patient-name:contains('NoOBSERV Test')").closest('.panel-heading').next().find('td:contains(\'DENOM OBSERV\')')
      expect(denomObs.length).toEqual 0
      numerObs = $("div.patient-name:contains('NoOBSERV Test')").closest('.panel-heading').next().find('td:contains(\'NUMER OBSERV\')')
      expect(numerObs.length).toEqual 0
