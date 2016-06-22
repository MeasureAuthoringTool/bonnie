class Thorax.Models.PatientDashboardPatient extends Thorax.Model

  initialize: (@patient, @pd, @measure, @patientResult, @populations, @population) ->
    # Set known patient attributes
    @_id = @patient.get('_id')
    @first = @patient.get('first')
    @last = @patient.get('last')
    @description = if @patient.get('notes') then @patient.get('notes') else ''
    @_birthdate = @patient.get('birthdate')
    @birthdate = if @_birthdate then moment.utc(@_birthdate, 'X').format('L') else ''
    @_deathdate = @patient.get('deathdate')
    @deathdate = if @_deathdate then moment.utc(@_deathdate, 'X').format('L') else ''
    unless @_deathdate
      @deathtime = 28800 # Default to 8 AM
    @gender = @patient.get('gender')

    # Get expected population results; check if patient is passing
    @_expected = @getExpectedResults()
    @_actual = @getActualResults()
    @passes = @isPatientPassing()

    # Actions button
    @actions

    # Set up instance variables for use by Patient Dashboard
    @saveExpectedResults()
    @saveActualResults()
    @savePopulationResults()

  ###
  @returns {String} id of this patient
  ###
  id: ->
    @_id

  ###
  Sets the expected results for each population as instance variables
  of this object. These will later be accessed by DataTables when populating
  the patient dashboard.
  ###
  saveExpectedResults: ->
    for k, v of @_expected
      @['expected' + k] = v

  ###
  Sets the actual results for each population as instance variables
  of this object. These will later be accessed by DataTables when populating
  the patient dashboard.
  ###
  saveActualResults: ->
    for k, v of @_actual
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
      else if population of @patientResult
        actualResults[population] = @patientResult[population]
      else
        actualResults[population] = ' '
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
  isPatientPassing: ->
    for population in @populations
      if @_expected[population] != @_actual[population]
        return "FALSE"
    return "TRUE"
