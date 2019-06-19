describe 'Production_PatientBuilderView', ->
  # these tests need to be merged into the patient_builder_spec.js.coffee file in cql_testing_overhaul
  # note: this uses a different measure and patient, so must be in a different suite

  beforeAll ->
    # preserve atomicity
    @bonnie_measures_old = bonnie.measures

  afterAll ->
    bonnie.measures = @bonnie_measures_old

  describe 'CMS160 tests', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS160v6/CMS160v6.json', 'cqm_measure_data/CMS160v6/value_sets.json'
      expiredDenex = getJSONFixture('patients/CMS160v6/Expired_DENEX.json')
      passNum2 = getJSONFixture('patients/CMS160v6/Pass_NUM2.json')
      @patients = new Thorax.Collections.Patients [expiredDenex, passNum2], parse: true
      bonnie.measures.add @measure

    describe 'Patient "Expired DENEX"', ->
      beforeAll ->
        @patient = @patients.at(0) # Expired DENEX
        @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure)
        @result = @measure.get('populations').first().calculate(@patient)
        # validate this patient is in the DENEX
        expect(@result.attributes.DENEX).toBe 1

      it 'define Expired should be true', ->
        expired_result = @result.get('statement_results').DepressionUtilizationofthePHQ9Tool['Expired'].final
        expect(expired_result).toBe 'TRUE'

      it 'should have expired code', ->
        expired_code = @result.get('statement_results').DepressionUtilizationofthePHQ9Tool['Expired'].raw[0].getCode()
        expect(expired_code[0].hasMatch(new cql.Code('419099009', 'SNOMED-CT'))).toBe(true)

  describe 'CMS722 Tests', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      @bonnie_measures_old = bonnie.measures
      @cqlMeasure = loadMeasureWithValueSets 'cqm_measure_data/CMS722v0/CMS722v0.json', 'cqm_measure_data/CMS722v0/value_sets.json'
      bonnie.measures = new Thorax.Collections.Measures()
      bonnie.measures.add @cqlMeasure
      patientTest = getJSONFixture('patients/CMS722v0/Patient_Test.json')
      patientWithCodeTest = getJSONFixture('patients/CMS722v0/Patient With Code_Test.json')
      @patients = new Thorax.Collections.Patients [patientTest, patientWithCodeTest], parse: true

      @addCodedValue = (codeListId, submit=true) ->
        @patientBuilder.$('select[name=type]:first').val('CD').change()
        @patientBuilder.$('select[name=code_list_id]').val(codeListId).change()
        @patientBuilder.$('.value-formset .btn-primary:first').click() if submit

    afterAll ->
      bonnie.measures = @bonnie_measures_old

    xit "Can Add A Coded Result To DiagnosticStudyPerformed Data Criteria", ->
      # SKIP Re-endable when code section of new Patient Builder enabled (adjust addCodedValue above)
      patient = @patients.first() # Patient Test
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
      patient = @patients.last() # Patient With Code :Test
      result = @cqlMeasure.get('populations').first().calculate(patient)
      expect(result.get('statement_results').Test31['Newborn Hearing Screening Right'].final).toEqual "TRUE"

  describe 'Medicare Fee For Service', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS759v1/CMS759v1.json', 'cqm_measure_data/CMS759v1/value_sets.json'
      numerPass = getJSONFixture('patients/CMS759v1/Numer_PASS.json')
      @patients = new Thorax.Collections.Patients [numerPass], parse: true

      @bonnie_measures_old = bonnie.measures
      bonnie.measures = new Thorax.Collections.Measures()
      bonnie.measures.add @measure

      @patient = @patients.at(0) # Numer Pass
      @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure)
      @result = @measure.get('populations').first().calculate(@patient)

    afterAll ->
      bonnie.measures = @bonnie_measures_old
      @patientBuilder.remove()

    it 'characteristic should be visible', ->
      @patientBuilder.render()
      @patientBuilder.appendTo 'body'
      expect(@patientBuilder.$('.ui-draggable')[4]).toContainText('Medicare Fee For Service')
      expect(@patientBuilder.$('.ui-draggable')[4]).toBeVisible()

    it 'should calculate correctly', ->
      expect(@result.attributes.IPP).toBe 1
      expect(@result.attributes.NUMER).toBe 1
      expect(@result.attributes.DENOM).toBe 1

  describe 'Direct Reference Code tests', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS52v7/CMS52v7.json', 'cqm_measure_data/CMS52v7/value_sets.json'
      elementDirectReferenceCode = getJSONFixture('patients/CMS52v7/Element_Direct Reference Code.json')
      @patients = new Thorax.Collections.Patients [elementDirectReferenceCode], parse: true

      bonnie.measures = new Thorax.Collections.Measures()
      bonnie.measures.add @measure, parse: true

    describe 'Patient Direct Reference Code Element', ->
      beforeAll ->
        @patient = @patients.at(0) # Element Direct Reference Code
        expect(@measure.get('source_data_criteria').last().get('description')).toBe('Medication, Order: Dapsone 100 MG / Pyrimethamine 12.5 MG Oral Tablet')
        @patientBuilderView = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure, patients: @patients, measures: bonnie.measures, inPatientDashboard: false)
        medicationOrdered = @patientBuilderView.model.get('source_data_criteria').at(3) # Medication, Oder
        @editCriteriaView = new Thorax.Views.EditCriteriaView(model: medicationOrdered, measure: @measure)
        @editFieldValueView = @editCriteriaView.editFieldValueView
        @result = @measure.get('populations').first().calculate(@patient)
        @patientBuilderView.appendTo 'body'
        @patientBuilderView.render()

      afterAll ->
        @patientBuilderView.remove()

      it 'should have Dapsone in Elements', ->
        expect($('strong.ui-draggable')[14]).toContainText('Dapsone 100 MG / Pyrimethamine 12.5 MG Oral Tablet')

      xit 'should have Dapsone in field value code dropdown', ->
        # SKIP: To be re-enabled when field value / attributes dropdown is re-added
        codes = @editFieldValueView.context().codes
        expect(codes[3].display_name).toBe('Dapsone 100 MG / Pyrimethamine 12.5 MG Oral Tablet')

      it 'should calculate using direct reference code', ->
        clauseResults = @result.attributes.clause_results.HIVAIDSPneumocystisJiroveciPneumoniaPCPProphylaxis
        expect(clauseResults[244].raw[0].description).toBe('Medication, Order: Dapsone 100 MG / Pyrimethamine 12.5 MG Oral Tablet')
        expect(clauseResults[244].final).toBe('TRUE')

  describe 'Participation tests', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS761v0/CMS761v0.json', 'cqm_measure_data/CMS761v0/value_sets.json'
      noParticipation = getJSONFixture 'patients/CMS761v0/No_Participation.json'
      withParticipation = getJSONFixture 'patients/CMS761v0/With_Participation.json'
      @patients = new Thorax.Collections.Patients [noParticipation, withParticipation], parse: true
      bonnie.measures.add @measure

    it 'Not in numerator when no participation', ->
      patient = @patients.at(0) # No Participation
      patientBuilder = new Thorax.Views.PatientBuilder(model: patient, measure: @measure)
      result = @measure.get('populations').first().calculate(patient)
      expect(result.attributes.NUMER).toBe 0

    it 'In numerator when with participation', ->
      patient = @patients.at(1) # With Participation
      patientBuilder = new Thorax.Views.PatientBuilder(model: patient, measure: @measure)
      result = @measure.get('populations').first().calculate(patient)
      expect(result.attributes.NUMER).toBe 1

  describe 'QDM 5.4', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      @measure = loadMeasureWithValueSets 'cqm_measure_data/CMSv54321/CMSv54321.json', 'cqm_measure_data/CMSv54321/value_sets.json'
      assessmentOrderPass = getJSONFixture 'patients/CMSv54321/Pass_AssessmentOrder.json'
      communicationPass = getJSONFixture 'patients/CMSv54321/Pass_Communication.json'
      medSettingPass = getJSONFixture 'patients/CMSv54321/Pass_MedSetting.json'
      @patients = new Thorax.Collections.Patients [assessmentOrderPass, communicationPass, medSettingPass], parse: true
      bonnie.measures.add @measure

    it 'Assessment Order calculates correctly', ->
      patient = @patients.at(0) # AssessmentOrder Pass
      patientBuilder = new Thorax.Views.PatientBuilder(model: patient, measure: @measure)
      result = @measure.get('populations').first().calculate(patient)
      expect(result.attributes.IPP).toBe 1

    it 'Communication calculates correctly', ->
      patient = @patients.at(1) # Communication Pass
      patientBuilder = new Thorax.Views.PatientBuilder(model: patient, measure: @measure)
      result = @measure.get('populations').first().calculate(patient)
      expect(result.attributes.IPP).toBe 1

    it 'Medication Order: Setting calculates correctly', ->
      patient = @patients.at(2) # MedSetting Pass
      patientBuilder = new Thorax.Views.PatientBuilder(model: patient, measure: @measure)
      result = @measure.get('populations').first().calculate(patient)
      expect(result.attributes.IPP).toBe 1
