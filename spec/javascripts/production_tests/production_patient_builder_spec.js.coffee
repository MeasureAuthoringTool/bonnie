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
      @patients = new Thorax.Collections.Patients getJSONFixture('cqm_patients/CMS160/patients.json'), parse: true
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
      @patients = new Thorax.Collections.Patients getJSONFixture('cqm_patients/CMS722/patients.json'), parse: true

      @addCodedValue = (codeListId, submit=true) ->
        @patientBuilder.$('select[name=type]:first').val('CD').change()
        @patientBuilder.$('select[name=code_list_id]').val(codeListId).change()
        @patientBuilder.$('.value-formset .btn-primary:first').click() if submit
  
    afterEach -> 
      bonnie.valueSetsByOid = @universalValueSetsByOid
      bonnie.measures = @bonnie_measures_old
  
    it "Can Add A Coded Result To DiagnosticStudyPerformed Data Criteria", ->
      patient = @patients.first()
      @patientBuilder = new Thorax.Views.PatientBuilder(model: patient, measure: @cqlMeasure)
      @patientBuilder.render()
      @patientBuilder.appendTo 'body'
      code_list_id = '2.16.840.1.114222.4.1.214079.1.1.6'
      @diagnosisDataCriteria = @patientBuilder.model.get('source_data_criteria').first()
      resultValue = @diagnosisDataCriteria.get("value").models[0]
      expect(resultValue).toEqual undefined
      @addCodedValue code_list_id
      resultValue = @diagnosisDataCriteria.get("value").models[0]
      expect(resultValue.get('title')).toEqual "Pass Or Refer"
      expect(resultValue.get('code_list_id')).toEqual code_list_id
      @patientBuilder.remove()

    it "Calculates Patient With Coded Result", ->
      patient = @patients.last()
      result = @cqlMeasure.get('populations').first().calculate(patient)
      expect(result.get('statement_results').Test31['Newborn Hearing Screening Right'].final).toEqual "TRUE"

  describe 'Medicare Fee For Service tests', ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      @measure = new Thorax.Models.Measure getJSONFixture('measure_data/special_measures/CMS759v1/CMS759v1.json'), parse: true
      @patients = new Thorax.Collections.Patients getJSONFixture('cqm_patients/CMS759v1/patients.json'), parse: true

      @universalValueSetsByOid = bonnie.valueSetsByOid
      bonnie.valueSetsByOid = getJSONFixture('measure_data/special_measures/CMS759v1/value_sets.json')
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

      afterEach ->
        @patientBuilder.remove()

      it 'Medicare Fee for Service characteristic should be visible', ->
        @patientBuilder.render()
        @patientBuilder.appendTo 'body'
        expect(@patientBuilder.$('.ui-draggable')[2]).toContainText('MedicareFeeForService')
        expect(@patientBuilder.$('.ui-draggable')[2]).toBeVisible()

      it 'should calculate correctly', ->
        expect(@result.attributes.IPP).toBe 1
        expect(@result.attributes.NUMER).toBe 1
        expect(@result.attributes.DENOM).toBe 1

  describe 'Direct Reference Code tests', ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      # bonnie.valueSetsByOid must be loaded before measure because measure.parse depends on it.
      bonnie.valueSetsByOid = getJSONFixture('measure_data/special_measures/CMS52v7/value_sets.json')
      @measure = new Thorax.Models.Measure getJSONFixture('measure_data/special_measures/CMS52v7/CMS52v7.json'), parse: true
      @patients = new Thorax.Collections.Patients getJSONFixture('cqm_patients/CMS52v7/patients.json'), parse: true

      @universalValueSetsByOid = bonnie.valueSetsByOid
      @bonnie_measures_old = bonnie.measures
      bonnie.measures = new Thorax.Collections.Measures()
      bonnie.measures.add @measure, parse: true

    afterEach ->
      bonnie.valueSetsByOid = @universalValueSetsByOid
      bonnie.measures = @bonnie_measures_old

    describe 'Patient Direct Reference Code Element', ->
      beforeEach ->
        @patient = @patients.findWhere(first: 'Element', last: 'Direct Reference Code')
        expect(@measure.get('source_data_criteria').models[18].get('description')).toBe('Medication, Order: Dapsone 100 MG / Pyrimethamine 12.5 MG Oral Tablet')
        @patientBuilderView = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure, patients: @patients, measures: bonnie.measures, inPatientDashboard: false)
        medicationOrdered = @patientBuilderView.model.get('source_data_criteria').first()
        @editCriteriaView = new Thorax.Views.EditCriteriaView(model: medicationOrdered, measure: @measure)
        @editFieldValueView = @editCriteriaView.editFieldValueView
        @result = @measure.get('populations').first().calculate(@patient)
        @patientBuilderView.appendTo 'body'
        @patientBuilderView.render()

      afterEach ->
        @patientBuilderView.remove()

      it 'should have Dapsone in Elements', ->
        expect($('.ui-draggable')[31]).toContainText('Dapsone 100 MG / Pyrimethamine 12.5 MG Oral Tablet')

      it 'should have Dapsone in field value code dropdown', ->
        codes = @editFieldValueView.context().codes
        expect(codes[3].display_name).toBe('Dapsone 100 MG / Pyrimethamine 12.5 MG Oral Tablet')

      it 'should calculate using direct reference code', ->
        clauseResults = @result.attributes.clause_results.HIVAIDSPneumocystisJiroveciPneumoniaPCPProphylaxis
        expect(clauseResults[244].raw[0]._description).toBe('Medication, Order: Dapsone 100 MG / Pyrimethamine 12.5 MG Oral Tablet')
        expect(clauseResults[244].final).toBe('TRUE')

  describe 'Participation tests', ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      bonnie.valueSetsByOid = getJSONFixture('measure_data/special_measures/CMS761/value_sets.json')
      @measure = new Thorax.Models.Measure getJSONFixture('measure_data/special_measures/CMS761/CMS761v0.json'), parse: true
      @patients = new Thorax.Collections.Patients getJSONFixture('cqm_patients/CMS761/patients.json'), parse: true
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

  describe 'QDM 5.4', ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      bonnie.valueSetsByOid = getJSONFixture('measure_data/special_measures/CMSv54321/value_sets.json')
      @measure = new Thorax.Models.Measure getJSONFixture('measure_data/special_measures/CMSv54321/CMSv54321.json'), parse: true
      @patients = new Thorax.Collections.Patients getJSONFixture('cqm_patients/CMSv54321/patients.json'), parse: true
      bonnie.measures.add @measure

    it 'Assessment Order calculates correctly', ->
      patient = @patients.findWhere(first: 'Pass', last: 'AssessmentOrder')
      patientBuilder = new Thorax.Views.PatientBuilder(model: patient, measure: @measure)
      result = @measure.get('populations').first().calculate(patient)
      expect(result.attributes.IPP).toBe 1

    it 'Communication calculates correctly', ->
      patient = @patients.findWhere(first: 'Pass', last: 'Communication')
      patientBuilder = new Thorax.Views.PatientBuilder(model: patient, measure: @measure)
      result = @measure.get('populations').first().calculate(patient)
      expect(result.attributes.IPP).toBe 1

    it 'Medication Order: Setting calculates correctly', ->
      patient = @patients.findWhere(first: 'Pass', last: 'MedSetting')
      patientBuilder = new Thorax.Views.PatientBuilder(model: patient, measure: @measure)
      result = @measure.get('populations').first().calculate(patient)
      expect(result.attributes.IPP).toBe 1
