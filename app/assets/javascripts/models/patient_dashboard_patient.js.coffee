class Thorax.Models.PatientDashboardPatient extends Thorax.Model

  initialize: (@patient, @pd, @measure, @patientResult, @populations, @population) ->
    # Set known patient attributes
    @id = @patient.get('_id')
    @first = @patient.get('first')
    @last = @patient.get('last')
    @description = if @patient.get('notes') then @patient.get('notes') else ''
    @birthdate = @patient.get('birthdate')
    @birthdate = moment.utc(@birthdate, 'X').format('L')
    @deathdate = @patient.get('deathdate')
    @deathdate = if @deathdate then moment.utc(@deathdate, 'X').format('L') else ''
    @gender = @patient.get('gender')

    # Get expected population results; check if patient is passing
    @expected = @getExpectedResults()
    @actual = @getActualResults()
    @passes = JST['pd_result_text']({ passes: @patientStatus() == "PASS" })
    @actions = JST['pd_action_gears']({})

    # Set up instance variables for use by Patient Dashboard
    @saveExpectedResults()
    @saveActualResults()
    @savePopulationResults()

  ###
  Sets the expected results for each population as instance variables
  of this object. These will later be accessed by DataTables when populating
  the patient dashboard.
  ###
  saveExpectedResults: ->
    for k, v of @expected
      @['expected' + k] = v

  ###
  Sets the actual results for each population as instance variables
  of this object. These will later be accessed by DataTables when populating
  the patient dashboard.
  ###
  saveActualResults: ->
    for k, v of @actual
      @['actual' + k] = v

  ###
  Sets the results for each individual data criteria as instance variables
  of this object. These will later be accessed by DataTables when populating
  the patient dashboard.
  ###
  savePopulationResults: ->
    for k, v of @pd.criteriaKeysByPopulation
      for dc in v
        @[k + '_' + dc] =  @getPatientCriteriaResult(dc, k)

  ###
  @returns {Object} a mapping of populations to their expected results
  ###
  getExpectedResults: ->
    expectedResults = {}
    expected_model = (model for model in @patient.get('expected_values').models when model.get('measure_id') == @measure.get('hqmf_set_id') && model.get('population_index') == @population.get('index'))[0]
    for population in @populations
      if population not in expected_model.keys()
        expectedResults[population] = ' '
      else
        expectedResults[population] = expected_model.get(population)
    expectedResults

  ###
  @returns {Object} a mapping of populations to their actual results
  ###
  getActualResults: ->
    actualResults = {}
    for population in @populations
      if population == 'OBSERV'
        if 'values' of @patientResult && population of @patientResult['rationale']
          actualResults[population] = @patientResult['values'].toString()
        else
          actualResults[population] = 0
      else
        actualResults[population] = @patientResult[population]
    actualResults

  ###
  @returns {String} describes the patient's result for a single data criteria
  ###
  getPatientCriteriaResult: (criteriaKey, populationKey) ->
    if criteriaKey of @patientResult['rationale']
      value = @patientResult['rationale'][criteriaKey]
      if value != null && value != 'false' && value != false
        result = 'TRUE'
      else if value == 'false' || value == false
        result = 'FALSE'
      value = result
      if 'specificsRationale' of @patientResult && populationKey of @patientResult['specificsRationale']
        specific_value = @patientResult['specificsRationale'][populationKey][criteriaKey]
        if specific_value == false && value == 'TRUE'
          result = 'SPECIFICALLY FALSE'
        else if specific_value == true && value == 'FALSE'
          result = 'SPECIFICALLY TRUE'
    else
      result = ''
    result

  ###
  @returns {String} describes if the patient is passing
  ###
  patientStatus: ->
    for population in @populations
      if @expected[population] != @actual[population]
        return "FAIL"
    return "PASS"
