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

  describe 'CMS722 Tests', ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      # preserve atomicity
      @universalValueSetsByOid = bonnie.valueSetsByOid
      @bonnie_measures_old = bonnie.measures
      bonnie.valueSetsByOid = getJSONFixture('measure_data/special_measures/CMS722/value_sets.json')
      @cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/special_measures/CMS722/CMS722v0.json'), parse: true
      bonnie.measures = new Thorax.Collections.Measures()
      bonnie.measures.add @cqlMeasure
      patients = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMS722/patients.json'), parse: true
      @patientBuilder = new Thorax.Views.PatientBuilder(model: patients.first(), measure: @cqlMeasure)
      @patientBuilder.render()
      @addCodedValue = (codeListId, submit=true) ->
        @patientBuilder.$('select[name=type]:first').val('CD').change()
        @patientBuilder.$('select[name=code_list_id]').val(codeListId).change()
        @patientBuilder.$('.value-formset .btn-primary:first').click() if submit
  
    afterEach -> 
      @patientBuilder.remove()
      bonnie.valueSetsByOid = @universalValueSetsByOid
      bonnie.measures = @bonnie_measures_old
  
    it "Can Add A Coded Result To DiagnosticStudyPerformed Data Criteria", ->
      @patientBuilder.appendTo 'body'
      code_list_id = '2.16.840.1.114222.4.1.214079.1.1.6'
      @diagnosisDataCriteria = @patientBuilder.model.get('source_data_criteria').first()
      resultValue = @diagnosisDataCriteria.get("value").models[0]
      expect(resultValue).toEqual undefined
      @addCodedValue code_list_id
      resultValue = @diagnosisDataCriteria.get("value").models[0]
      expect(resultValue.get('title')).toEqual "Pass Or Refer"
      expect(resultValue.get('code_list_id')).toEqual code_list_id
