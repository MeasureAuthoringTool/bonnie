describe 'PatientDashboardPopoverView', ->
  
  beforeEach (done) ->
    window.bonnieRouterCache.load('base_set')
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

    @dataCriteriaKey = 'qdm_var_SatisfiesAny_899DFA04_7197_4DB9_8E22_3DE5B351FE79_15479A20_DCBF_423F_A895_FDEEDB4F44BF'
    @popoverView = new Thorax.Views.PatientDashboardPopover(measure: @measure, populationKey: 'IPP', dataCriteriaKey: @dataCriteriaKey, allChildrenCriteria: @patientDashboard.dataCriteriaChildrenKeys @dataCriteriaKey)
    done()

  it 'initialized properly', ->
    expect(@popoverView.rootPrecondition.preconditions?).toEqual(false) # the precondition associated with the dataCriteriaKey has no child statements
    expect(@popoverView.rootPrecondition.reference).toEqual(@dataCriteriaKey)
    
    expect(@popoverView.parentPrecondition.preconditions?).toEqual(true) # has precondition assocaited with the IPP has child statements
    expect(@popoverView.parentPrecondition.preconditions.length).toEqual(4) # there are four logic clauses in the IPP
    expect(@popoverView.copyParentPrecondition.preconditions?).toEqual(true)
    # the copy of the parentpreconditions are filtered to only contain 1 precondition upon initialization
    # the one precondition that is contained is the one relevant to the particular popoverview selected
    expect(@popoverView.copyParentPrecondition.preconditions.length).toEqual(1)
    
    expect(@popoverView.variables.length).toEqual(1) # there is one variable referenced in the statement
    expect(@popoverView.variables.at(0).get('source_data_criteria')).toEqual(@dataCriteriaKey) # the variable is our referenced logic clause
    
    
    
    
