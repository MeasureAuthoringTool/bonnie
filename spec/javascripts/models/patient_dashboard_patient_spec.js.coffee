describe 'PatientDashboardPatient', ->
  
  # TODO: need to get a patient and a measure that will contain specific occurrences so can look at 'SPECIFICALLY FALSE'
  
  beforeEach (done) ->
    window.bonnieRouterCache.load('base_set')
    @measure = bonnie.measures.findWhere(cms_id: 'CMS128v5')
    
    # getting a particular patient whose characteristics we know about.
    # patient: Harriot Clawson
    #  DOB: 4/05/1927
    #  Diagnosis: Major Depression 01/01/2012
    #  Medication, Dispensed: Antidepressant Medication 01/15/2012-01/15/2012
    #  Medication, Active: Antidepressant Medication 05/08/2012 - 05/08/2012
    #  Encounter, Performed: Annual Wellness Visit 12/31/2012 - 12/31/2012
    collection = new Thorax.Collections.Patients getJSONFixture('records/base_set/patients.json'), parse: true
    @patient = collection.filter((patient) => 
      @measure.get('hqmf_set_id') in patient.get('measure_ids') && patient.get('first') == "Harriot")[0]
    
    # getting the population sets relevant to the model (IPP, DENOM, etc.)
    codes = (population['code'] for population in @measure.get('measure_logic'))
    @populations = _.intersection(Thorax.Models.Measure.allPopulationCodes, codes)
    
    @populationSet = @measure.get('populations').at(0)
    
    # need to pass in defined widths
    widths =
      population: 30
      meta_huge: 200
      meta_large: 110
      meta_medium: 100
      meta_small: 40
      freetext: 240
      criteria: 200
      result: 80

    @patientDashboard = new Thorax.Models.PatientDashboard @measure, @populations, @populationSet, widths
    
    # retrieving the calculation result for the patients relevant to the measure.
    # this is a deferred operation. We create the @patientDashboardPatient once this completes.
    @result = @populationSet.calculateResult(@patient)
    @result.calculationComplete =>
      # there is only one result because we calculated for just a single patient
      # need to get the JSON representation because this adds additional information to the model
      # (and it's what the code expects).
      @result = @result.toJSON()
      @patientDashboardPatient = new Thorax.Models.PatientDashboardPatient(@patient, @patientDashboard, @measure, @result, @populations, @populationSet)
      done()
    
  it 'intialized properly', ->
    expect(@patientDashboardPatient.id).toEqual('543b538f69702d691af00300')
    expect(@patientDashboardPatient.first).toEqual('Harriot')
    expect(@patientDashboardPatient.last).toEqual('Clawson')
    expect(@patientDashboardPatient.description).toEqual('Correct age. Encounter takes place during MP. Diagnosis of depression takes place within the allowed time frame (<=60 day(s) SBSO or SASO Occ A Medications). Occ A of medication dispensed is outside the allowed time frame (>90 days SASO MP). Medicati')
    expect(@patientDashboardPatient.birthdate).toEqual('04/05/1927 08:00 AM')
    expect(@patientDashboardPatient.deathdate).toEqual('')
    expect(@patientDashboardPatient.gender).toEqual('F')
    expect(@patientDashboardPatient.expected).toEqual({IPP: 1, DENOM: 1, DENEX: 0, NUMER: 1})
    expect(@patientDashboardPatient.actual).toEqual({IPP: 1, DENOM: 1, DENEX: 0, NUMER: 1})
    expect(@patientDashboardPatient.passes).toEqual('PASS')
    expect(@patientDashboardPatient.actions).toEqual('')
    
    expect(@patientDashboardPatient.expectedIPP).toEqual(1)
    expect(@patientDashboardPatient.expectedDENOM).toEqual(1)
    expect(@patientDashboardPatient.expectedDENEX).toEqual(0)
    expect(@patientDashboardPatient.expectedNUMER).toEqual(1)
  
    expect(@patientDashboardPatient.actualIPP).toEqual(1)
    expect(@patientDashboardPatient.actualDENOM).toEqual(1)
    expect(@patientDashboardPatient.actualDENEX).toEqual(0)
    expect(@patientDashboardPatient.actualNUMER).toEqual(1)
    
    expect(@patientDashboardPatient.IPP_Agegrtr_thn_eql_18yearsat_017BF72A_2885_4350_B259_80D19397C35F_8C7B3095_A649_4913_A90D_11A5AE59387E).toEqual('TRUE')
    expect(@patientDashboardPatient.IPP_During_108F51AF_1144_4F16_ABC6_B1ED2B2DB800_92C21CCE_9DD7_4A9D_AC39_A40DEFF1E643).toEqual('TRUE')
    expect(@patientDashboardPatient.IPP_qdm_var_SatisfiesAny_9D7195EC_6B92_4B06_BAD9_5888FAF7E6B8_7C54FB26_C89F_4630_8044_5676529EE9C5).toEqual('TRUE')
    expect(@patientDashboardPatient.IPP_qdm_var_SatisfiesAny_899DFA04_7197_4DB9_8E22_3DE5B351FE79_15479A20_DCBF_423F_A895_FDEEDB4F44BF).toEqual('TRUE')
    expect(@patientDashboardPatient.DENEX_less_thn_eql_105daysStartsBeforeStartOf_0457E84E_FAC2_4D58_815C_EAED430BB231_43B4B0F6_EA34_42B4_95B2_6A943CABDF52).toEqual('FALSE')
    expect(@patientDashboardPatient.NUMER_less_thn_eql_114daysEndsAfterStartOf_01B99489_936F_47EC_A457_7151F9049A75_988EB0D7_AC7A_41BE_90DC_ACEE9C6B575E).toEqual('TRUE')

  it 'handles expected result change', ->
    expectedResultSet = @patientDashboardPatient.patient.get('expected_values').findWhere(measure_id: @measure.get('hqmf_set_id', population_index: @populationSet.get('index')))
    expectedResultSet.set('NUMER', 0)
    
    # no updates yet so expectations are the same as original
    expect(@patientDashboardPatient.expected).toEqual({IPP: 1, DENOM: 1, DENEX: 0, NUMER: 1})
    expect(@patientDashboardPatient.actual).toEqual({IPP: 1, DENOM: 1, DENEX: 0, NUMER: 1})
    expect(@patientDashboardPatient.expectedIPP).toEqual(1)
    expect(@patientDashboardPatient.expectedDENOM).toEqual(1)
    expect(@patientDashboardPatient.expectedDENEX).toEqual(0)
    expect(@patientDashboardPatient.expectedNUMER).toEqual(1)
    expect(@patientDashboardPatient.actualIPP).toEqual(1)
    expect(@patientDashboardPatient.actualDENOM).toEqual(1)
    expect(@patientDashboardPatient.actualDENEX).toEqual(0)
    expect(@patientDashboardPatient.actualNUMER).toEqual(1)
    expect(@patientDashboardPatient.passes).toEqual('PASS')
    
    @patientDashboardPatient.updatePasses()
    
    # now expect patient to fail
    expect(@patientDashboardPatient.expected).toEqual({IPP: 1, DENOM: 1, DENEX: 0, NUMER: 0})
    expect(@patientDashboardPatient.actual).toEqual({IPP: 1, DENOM: 1, DENEX: 0, NUMER: 1})
    expect(@patientDashboardPatient.expectedIPP).toEqual(1)
    expect(@patientDashboardPatient.expectedDENOM).toEqual(1)
    expect(@patientDashboardPatient.expectedDENEX).toEqual(0)
    expect(@patientDashboardPatient.expectedNUMER).toEqual(0)
    expect(@patientDashboardPatient.actualIPP).toEqual(1)
    expect(@patientDashboardPatient.actualDENOM).toEqual(1)
    expect(@patientDashboardPatient.actualDENEX).toEqual(0)
    expect(@patientDashboardPatient.actualNUMER).toEqual(1)
    expect(@patientDashboardPatient.passes).toEqual('FAIL')
    
    # reset expected result
    expectedResultSet.set('NUMER', 1)
    @patientDashboardPatient.updatePasses()
    
