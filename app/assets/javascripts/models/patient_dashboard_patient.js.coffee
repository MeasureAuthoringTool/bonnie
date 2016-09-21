class Thorax.Models.PatientDashboardPatient extends Thorax.Model

  initialize: (@patient, @patientDashboard, @measure, @patientResult, @populations, @populationSet) ->
    # Set known patient attributes
    @id = @patient.get('_id')
    @first = @patient.get('first')
    @last = @patient.get('last')
    @description = if @patient.get('notes') then @patient.get('notes') else ''
    @birthdate = moment.utc(@patient.get('birthdate'), 'X').format('MM/DD/YYYY hh:mm A')
    @deathdate = if @patient.get('deathdate') then moment.utc(@patient.get('deathdate'), 'X').format('MM/DD/YYYY hh:mm A') else ''
    @gender = @patient.get('gender')

    # Get expected population results; check if patient is passing
    @expected = @getExpectedResults()
    @actual = @getActualResults()
    @passes = @patientStatus()
    @actions = ''

    # Set up instance variables for use by Patient Dashboard
    @setExpectedResults()
    @setActualResults()
    @savePopulationResults()

  ###
  Updates passes status.
  ###
  updatePasses: ->
    @expected = @getExpectedResults()
    @actual = @getActualResults()
    @passes = @patientStatus()
    @setExpectedResults()
    @setActualResults()

  ###
  Sets the expected results for each population as instance variables
  of this object. These will later be accessed by DataTables when populating
  the patient dashboard.
  ###
  setExpectedResults: ->
    for population, result of @expected
      @['expected' + population] = result

  ###
  Sets the actual results for each population as instance variables
  of this object. These will later be accessed by DataTables when populating
  the patient dashboard.
  ###
  setActualResults: ->
    for population, result of @actual
      @['actual' + population] = result

  ###
  Sets the results for each individual data criteria as instance variables
  of this object. These will later be accessed by DataTables when populating
  the patient dashboard.
  ###
  savePopulationResults: ->
    for population, criteria of @patientDashboard.criteriaKeysByPopulation
      for dc in criteria
        @[population + '_' + dc] =  @getPatientCriteriaResult(dc, population)

  ###
  @returns {Object} a mapping of populations to their expected results
  ###
  getExpectedResults: ->
    expectedResults = {}
    expected_model = (model for model in @patient.get('expected_values').models when model.get('measure_id') == @measure.get('hqmf_set_id') && model.get('population_index') == @populationSet.get('index'))[0]
    for population in @populations
      if population not in expected_model.keys()
        expectedResults[population] = 0
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
