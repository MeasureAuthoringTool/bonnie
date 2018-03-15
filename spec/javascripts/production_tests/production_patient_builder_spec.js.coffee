describe 'Production_PatientBuilderView', ->
  # these tests need to be merged into the patient_builder_spec.js.coffee file in cql_testing_overhaul
  # note: this uses a different measure and patient, so must be in a different suite

  describe 'CMS160 tests', ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      @measure = new Thorax.Models.Measure getJSONFixture('measure_data/core_measures/CMS160/CMS160v6.json'), parse: true
      @patients = new Thorax.Collections.Patients getJSONFixture('records/core_measures/CMS160/patients.json'), parse: true

      # preserve atomicity
      @universalValueSetsByOid = bonnie.valueSetsByOid
      @bonnie_measures_old = bonnie.measures
      bonnie.valueSetsByOid = getJSONFixture('measure_data/core_measures/CMS160/value_sets.json')
      bonnie.measures.add @measure

    afterEach ->
      bonnie.valueSetsByOid = @universalValueSetsByOid
      bonnie.measures = @bonnie_measures_old

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
        expect(expired_code).toBe '419099009'

  describe 'Medicare Fee For Service tests', ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      @measure = new Thorax.Models.Measure getJSONFixture('measure_data/special_measures/TestMFFS_v5_4_Artifacts/CMSv0.json'), parse: true
      @patients = new Thorax.Collections.Patients getJSONFixture('records/special_measures/TestMFFS_v5_4_Artifacts/patients.json'), parse: true

      @universalValueSetsByOid = bonnie.valueSetsByOid
      bonnie.valueSetsByOid = getJSONFixture('measure_data/special_measures/TestMFFS_v5_4_Artifacts/value_sets.json')
      @bonnie_measures_old = bonnie.measures
      bonnie.measures = new Thorax.Collections.Measures()
      bonnie.measures.add @measure
    afterEach ->
      bonnie.valueSetsByOid = @universalValueSetsByOid
      bonnie.measures = @bonnie_measures_old

    describe 'Patient "Numer PASS"', ->
      beforeEach ->
        @patient = @patients.findWhere(first: 'Numer', last: 'PASS')
        @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure)
        @result = @measure.get('populations').first().calculate(@patient)

      it 'Medicare Fee for Service characteristic should be visible', ->
        @patientBuilder.render()
        @patientBuilder.appendTo 'body'
        expect(@patientBuilder.$('.ui-draggable')[2]).toContainText('MedicareFeeForService')
        expect(@patientBuilder.$('.ui-draggable')[2]).toBeVisible()

      it 'should calculate correctly', ->
        expect(@result.attributes.IPP).toBe 1
        expect(@result.attributes.NUMER).toBe 1
        expect(@result.attributes.DENOM).toBe 1
