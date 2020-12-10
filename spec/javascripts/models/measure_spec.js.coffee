describe 'Measure', ->

  describe 'Continuous Variable Measure', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      @measure = loadFhirMeasure 'fhir_measures/CMS111/CMS111.json'

    it 'has basic attributes available', ->
      expect(@measure.get('cqmMeasure').set_id).toEqual "CABB66B0-5A83-45D9-9651-CEBCE118393C"
      expect(@measure.get('cqmMeasure').title).toEqual "CMS111Test"

    it 'has the expected number of populations', ->
      expect(@measure.get('populations').length).toEqual 3

    it 'has all the population criteria', ->
      populations = @measure.populationCriteria()
      # OBSERV should be included along with population criteria for cv measure
      expect(populations).toEqual ['IPP', 'MSRPOPL', 'MSRPOPLEX', 'OBSERV']

    it 'can calculate results for a patient using first population if no observations applicable', ->
      noObsPatient = getJSONFixture 'fhir_patients/CMS111/IPP_MSRPOPL_MSRPOPEX_NO_OBS.json'
      collection = new Thorax.Collections.Patients [noObsPatient], parse: true
      patient = collection.at(0)
      results = @measure.get('populations').at(0).calculate(patient)
      expect(results.get('IPP')).toEqual 1
      expect(results.get('MSRPOPL')).toEqual 1
      expect(results.get('IPP')).toEqual 1
      expect(results.get('MSRPOPLEX')).toEqual 1
      expect(results.get('OBSERV')).toBeUndefined()

  describe 'Proportion Measure', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      @measure = loadFhirMeasure 'fhir_measures/CMS124/CMS124.json'
    it 'has basic attributes available', ->
      expect(@measure.get('cqmMeasure').set_id).toEqual "4F661027-8C11-4FDB-A15D-14F2597007F7"
      expect(@measure.get('cqmMeasure').title).toEqual "EXM124"

    it 'has the expected number of populations', ->
      expect(@measure.get('populations').length).toEqual 1

    it 'has all the population criteria', ->
      populations = @measure.populationCriteria()
      # No OBSERV for non cv measure
      expect(populations).toEqual ['IPP', 'DENOM', 'DENEX', 'NUMER']
