describe 'PatientDashboardPatient', ->
  
  # TODO: need to get a patient and a measure that will contain specific occurrences so can look at 'SPECIFICALLY FALSE'
  
  beforeEach (done) ->
    window.bonnieRouterCache.load('bad_code_checker_set')
    @measure = bonnie.measures.findWhere(cms_id: 'CMS123v6')
    
    # getting a particular patient whose characteristics we know about.
    # patient: Harriot Clawson
    #  DOB: 4/05/1927
    #  Diagnosis: Major Depression 01/01/2012
    #  Medication, Dispensed: Antidepressant Medication 01/15/2012-01/15/2012
    #  Medication, Active: Antidepressant Medication 05/08/2012 - 05/08/2012
    #  Encounter, Performed: Annual Wellness Visit 12/31/2012 - 12/31/2012
    @collection = new Thorax.Collections.Patients getJSONFixture('records/bad_code_checker_set/patients.json'), parse: true

    
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
    done()
    
  it 'determines BAD for patient passing with a bad code', (done) ->
    @patient = @collection.filter((patient) => 
      @measure.get('hqmf_set_id') in patient.get('measure_ids') && patient.get('first') == "George")[0]
    
    # retrieving the calculation result for the patient relevant to the test
    # this is a deferred operation. We create the @patientDashboardPatient once this completes.
    @result = @populationSet.calculateResult(@patient)
    @result.calculationComplete =>
      # there is only one result because we calculated for just a single patient
      # need to get the JSON representation because this adds additional information to the model
      # (and it's what the code expects).
      @result = @result.toJSON()
      @patientDashboardPatient = new Thorax.Models.PatientDashboardPatient(@patient, @patientDashboard, @measure, @result, @populations, @populationSet)
    
      expect(@patientDashboardPatient.id).toEqual('5936ccdc5cc975216200037e')
      expect(@patientDashboardPatient.first).toEqual('George')
      expect(@patientDashboardPatient.last).toEqual('Edison')
      expect(@patientDashboardPatient.passes).toEqual('BAD')
      done()

  it 'determines BAD for patient failing with a bad code', (done) ->
    @patient = @collection.filter((patient) => 
      @measure.get('hqmf_set_id') in patient.get('measure_ids') && patient.get('first') == "Reginald")[0]
    
    # retrieving the calculation result for the patient relevant to the test
    # this is a deferred operation. We create the @patientDashboardPatient once this completes.
    @result = @populationSet.calculateResult(@patient)
    @result.calculationComplete =>
      # there is only one result because we calculated for just a single patient
      # need to get the JSON representation because this adds additional information to the model
      # (and it's what the code expects).
      @result = @result.toJSON()
      @patientDashboardPatient = new Thorax.Models.PatientDashboardPatient(@patient, @patientDashboard, @measure, @result, @populations, @populationSet)
    
      expect(@patientDashboardPatient.id).toEqual('5936cd345cc97521620003f6')
      expect(@patientDashboardPatient.first).toEqual('Reginald')
      expect(@patientDashboardPatient.last).toEqual('Danger')
      expect(@patientDashboardPatient.passes).toEqual('BAD')
      done()

  it 'determines PASS for patient passing with good codes', (done) ->
    @patient = @collection.filter((patient) => 
      @measure.get('hqmf_set_id') in patient.get('measure_ids') && patient.get('first') == "John")[0]
    
    # retrieving the calculation result for the patient relevant to the test
    # this is a deferred operation. We create the @patientDashboardPatient once this completes.
    @result = @populationSet.calculateResult(@patient)
    @result.calculationComplete =>
      # there is only one result because we calculated for just a single patient
      # need to get the JSON representation because this adds additional information to the model
      # (and it's what the code expects).
      @result = @result.toJSON()
      @patientDashboardPatient = new Thorax.Models.PatientDashboardPatient(@patient, @patientDashboard, @measure, @result, @populations, @populationSet)
    
      expect(@patientDashboardPatient.id).toEqual('5936cc865cc975216200031c')
      expect(@patientDashboardPatient.first).toEqual('John')
      expect(@patientDashboardPatient.last).toEqual('Smith')
      expect(@patientDashboardPatient.passes).toEqual('PASS')
      done()

  it 'determines FAIL for patient failing with good codes', (done) ->
    @patient = @collection.filter((patient) => 
      @measure.get('hqmf_set_id') in patient.get('measure_ids') && patient.get('first') == "Bernard")[0]
    
    # retrieving the calculation result for the patient relevant to the test
    # this is a deferred operation. We create the @patientDashboardPatient once this completes.
    @result = @populationSet.calculateResult(@patient)
    @result.calculationComplete =>
      # there is only one result because we calculated for just a single patient
      # need to get the JSON representation because this adds additional information to the model
      # (and it's what the code expects).
      @result = @result.toJSON()
      @patientDashboardPatient = new Thorax.Models.PatientDashboardPatient(@patient, @patientDashboard, @measure, @result, @populations, @populationSet)
    
      expect(@patientDashboardPatient.id).toEqual('5936ccab5cc975216200034e')
      expect(@patientDashboardPatient.first).toEqual('Bernard')
      expect(@patientDashboardPatient.last).toEqual('Jones')
      expect(@patientDashboardPatient.passes).toEqual('FAIL')
      done()
