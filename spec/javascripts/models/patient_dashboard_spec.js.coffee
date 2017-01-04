describe 'PatientDashboard', ->
  
  beforeEach ->
    window.bonnieRouterCache.load('patient_dashboard_set')
    @measure = bonnie.measures.findWhere(cms_id: 'CMS128v5')
    
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

  it 'initialized properly', ->
    expectedCriteriaKeys = {}
    expectedCriteriaKeys['IPP'] = ['Agegrtr_thn_eql_18yearsat_017BF72A_2885_4350_B259_80D19397C35F_8C7B3095_A649_4913_A90D_11A5AE59387E',
                                   'qdm_var_SatisfiesAny_9D7195EC_6B92_4B06_BAD9_5888FAF7E6B8_7C54FB26_C89F_4630_8044_5676529EE9C5',
                                   'qdm_var_SatisfiesAny_899DFA04_7197_4DB9_8E22_3DE5B351FE79_15479A20_DCBF_423F_A895_FDEEDB4F44BF',
                                   'During_108F51AF_1144_4F16_ABC6_B1ED2B2DB800_92C21CCE_9DD7_4A9D_AC39_A40DEFF1E643']
    expectedCriteriaKeys['DENOM'] = []
    expectedCriteriaKeys['DENEX'] = ['less_thn_eql_105daysStartsBeforeStartOf_0457E84E_FAC2_4D58_815C_EAED430BB231_43B4B0F6_EA34_42B4_95B2_6A943CABDF52']
    expectedCriteriaKeys['NUMER'] = ['less_thn_eql_114daysEndsAfterStartOf_01B99489_936F_47EC_A457_7151F9049A75_988EB0D7_AC7A_41BE_90DC_ACEE9C6B575E']
    expect(@patientDashboard.criteriaKeysByPopulation).toEqual(expectedCriteriaKeys)

    

  it 'properly strips leading tokens', ->
    expect(@patientDashboard.stripLeadingToken('expectedIPP')).toEqual('IPP')
    expect(@patientDashboard.stripLeadingToken('actualDENOM')).toEqual('DENOM')
    expect(@patientDashboard.stripLeadingToken('anythingBLAH')).toEqual('anythingBLAH')
    expect(@patientDashboard.stripLeadingToken('anything_BLAH')).toEqual('BLAH')

  it 'properly finds children criteria', ->
    expect(@patientDashboard.hasChildrenCriteria('Agegrtr_thn_eql_18yearsat_017BF72A_2885_4350_B259_80D19397C35F_8C7B3095_A649_4913_A90D_11A5AE59387E')).toEqual(false)
    expect(@patientDashboard.hasChildrenCriteria('qdm_var_SatisfiesAny_899DFA04_7197_4DB9_8E22_3DE5B351FE79_15479A20_DCBF_423F_A895_FDEEDB4F44BF')).toEqual(true)
    
    # MeasurePeriod is included in the returned array of data criteria keys because it is a child criteria to the data criterea
    expect(@patientDashboard.dataCriteriaChildrenKeys('Agegrtr_thn_eql_18yearsat_017BF72A_2885_4350_B259_80D19397C35F_8C7B3095_A649_4913_A90D_11A5AE59387E')).toEqual(['Agegrtr_thn_eql_18yearsat_017BF72A_2885_4350_B259_80D19397C35F_8C7B3095_A649_4913_A90D_11A5AE59387E', 'MeasurePeriod'])
    expect(@patientDashboard.dataCriteriaChildrenKeys('qdm_var_SatisfiesAny_899DFA04_7197_4DB9_8E22_3DE5B351FE79_15479A20_DCBF_423F_A895_FDEEDB4F44BF')).toEqual(['qdm_var_SatisfiesAny_899DFA04_7197_4DB9_8E22_3DE5B351FE79_15479A20_DCBF_423F_A895_FDEEDB4F44BF', 'GROUP_qdm_var_SatisfiesAny_899DFA04_7197_4DB9_8E22_3DE5B351FE79_15479A20_DCBF_423F_A895_FDEEDB4F44BF', 'less_thn_eql_270daysStartsBeforeOrConcurrentWithStartOf_D03E4E49_66B8_44A2_85ED_470964A9220A_3a1c834c_0fa5_4a0d_a1c6_7fea9915b80a', 'MeasurePeriod', 'less_thn_eql_90daysStartsAfterStartOf_B4E36072_B9A1_496F_946B_FB6A16DE3FB1_3a1c834c_0fa5_4a0d_a1c6_7fea9915b80a', 'MeasurePeriod'])

  it 'includes all patient dashboard columns', ->
    dataInfo = @patientDashboard.getDataInfo()
    # This does not include the names of the data criteria fields, just the generic named columns
    expect(dataInfo.first.name).toEqual("First Name")
    expect(dataInfo.last.name).toEqual("Last Name")
    expect(dataInfo.gender.name).toEqual("Gender")
    expect(dataInfo.result.name).toEqual("Result")
    expect(dataInfo.birthdate.name).toEqual("Birthdate")
    expect(dataInfo.deathdate.name).toEqual("Deathdate")
    expect(dataInfo.description.name).toEqual("Description")
    expect(dataInfo.actions.name).toEqual("Options")
    expect(dataInfo.actualDENEX.name).toEqual("DENEX")
    expect(dataInfo.actualDENOM.name).toEqual("DENOM")
    expect(dataInfo.actualIPP.name).toEqual("IPP")
    expect(dataInfo.actualNUMER.name).toEqual("NUMER")
    expect(dataInfo.expectedDENEX.name).toEqual("DENEX")
    expect(dataInfo.expectedDENOM.name).toEqual("DENOM")
    expect(dataInfo.expectedIPP.name).toEqual("IPP")
    expect(dataInfo.expectedNUMER.name).toEqual("NUMER")
