describe 'Production_PatientBuilderView', ->
  # these tests need to be merged into the patient_builder_spec.js.coffee file in cql_testing_overhaul
  # note: this uses a different measure and patient, so must be in a different suite

  beforeEach ->
    # preserve atomicity
    @universalValueSetsByOid = bonnie.valueSetsByOid
    @bonnie_measures_old = bonnie.measures

  afterEach ->
    bonnie.valueSetsByOid = @universalValueSetsByOid
    bonnie.measures = @bonnie_measures_old

  describe 'CMS160 tests', ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      @measure = new Thorax.Models.Measure getJSONFixture('measure_data/core_measures/CMS160/CMS160v6.json'), parse: true
      @patients = new Thorax.Collections.Patients getJSONFixture('records/core_measures/CMS160/patients.json'), parse: true
      bonnie.valueSetsByOid = getJSONFixture('measure_data/core_measures/CMS160/value_sets.json')
      bonnie.measures.add @measure

    describe 'Patient "Expired DENEX"', ->
      beforeEach ->
        @patient = @patients.findWhere(first: 'Expired', last: 'DENEX')
        @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure)
        @result = @measure.get('populations').first().calculate(@patient)
        # validate this patient is in the DENEX
        expect(@result.attributes.DENEX).toBe 1

      it 'define Expired should be true', ->
        expired_result = @result.get('statement_results').DepressionUtilizationofthePHQ9Tool['Expired'].final
        expect(expired_result).toBe 'TRUE'

      it 'should have expired code', ->
        expired_code = @result.get('statement_results').DepressionUtilizationofthePHQ9Tool['Expired'].raw[0].getCode()
        expect(expired_code).toEqual new cql.Code('419099009', 'SNOMED-CT')

  describe 'Participation tests', ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      @measure = new Thorax.Models.Measure getJSONFixture('measure_data/special_measures/CMS761/CMS761v0.json'), parse: true
      @patients = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMS761/patients.json'), parse: true
      bonnie.valueSetsByOid = getJSONFixture('measure_data/special_measures/CMS761/value_sets.json')
      bonnie.measures.add @measure

    it 'Not in numerator when no participation', ->
      patient = @patients.findWhere(first: 'No', last: 'Participation')
      patientBuilder = new Thorax.Views.PatientBuilder(model: patient, measure: @measure)
      result = @measure.get('populations').first().calculate(patient)
      expect(result.attributes.NUMER).toBe 0

    it 'In numerator when with participation', ->
      patient = @patients.findWhere(first: 'With', last: 'Participation')
      patientBuilder = new Thorax.Views.PatientBuilder(model: patient, measure: @measure)
      result = @measure.get('populations').first().calculate(patient)
      expect(result.attributes.NUMER).toBe 1
