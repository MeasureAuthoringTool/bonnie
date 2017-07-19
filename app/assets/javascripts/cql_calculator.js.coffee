###*
# The CQL calculator. This calls the CQL4Browsers engine then prepares the results for consumption by the rest of
# Bonnie.
###
@CQLCalculator = class CQLCalculator extends Calculator

  ###*
  # Generate a calculation result for a population / patient pair; this always returns a result immediately,
  # but may return a blank result object if there was a problem. Currently we do not do CQL calculations in
  # deferred manner like we did for QDM calcuations.
  # @param {Population} population - The population set to calculate on.
  # @param {Patient} patient - The patient to run calculations on.
  ###
  calculate: (population, patient) ->
    # We store both the calculation result and the calcuation code based on keys derived from the arguments
    cacheKey = @cacheKey(population, patient)
    calcKey = @calculationKey(population)
    # We only ever generate a single result for a population / patient pair; if we've ever generated a
    # result for this pair, we use that result and return it, starting its calculation if needed
    result = @resultsCache[cacheKey] ?= new Thorax.Models.Result({}, population: population, patient: patient)

    # If the result is marked as 'cancelled', that means a cancellation has been requested but not yet handled in
    # the deferred calculation code; however, since we're here, that means a new calculation has been requested
    # subsequent to the cancellation; just change the state back to 'pending' to reflected our updated desire, and
    # the still pending deferred calculation will do the correct thing
    result.state = 'pending' if result.state == 'cancelled'

    # If the result already finished calculating, or is in-process with a pending calculation, we can just return it
    return result if result.state == 'complete' || result.state == 'pending'

    # Since we're going to start a calculation for this one, set the state to 'pending'
    result.state = 'pending'

    try
      # Necessary structure for the CQL (ELM) Execution Engine. Uses CQL_QDM Patient API to map Bonnie patients to correct format.
      patientSource = new PatientSource([patient])

      # Grab start and end of Measurement Period
      start = @getConvertedTime population.collection.parent.get('measure_period').low.value
      end = @getConvertedTime population.collection.parent.get('measure_period').high.value
      start_cql = cql.DateTime.fromDate(start, 0) # No timezone offset for start
      end_cql = cql.DateTime.fromDate(end, 0) # No timezone offset for stop

      # Construct CQL params
      params = {"Measurement Period": new cql.Interval(start_cql, end_cql)}

      # Grab ELM JSON from measure, use clone so that the function added from observations does not get added over and over again
      elm = _.clone(population.collection.parent.get('elm'))

      # Find the main library (the library that is the "measure") and
      # grab the version to pass into the execution engine
      main_library_version = ''
      main_library_index = 0
      for elm_library, index in elm
        if elm_library['library']['identifier']['id'] == population.collection.parent.get('main_cql_library')
          main_library_version = elm_library['library']['identifier']['version']
          main_library_index = index

      observations = population.collection.parent.get('observations')
      observation_defs = []
      if observations
         for obs in observations
           generatedELMJSON = @generateELMJSONFunction(obs.function_name, obs.parameter)
           # Save the name of the generated define statement, so we can check
           # its result later in the CQL calculation process. These added
           # define statements are called 'BonnieFunction_' followed by the
           # name of the function - see the 'generateELMJSONFunction' function.
           observation_defs.push('BonnieFunction_' + obs.function_name)
           # Check to see if the gneratedELMJSON function is already in the definitions
           # Added a check to support old ELM representation and new Array representation.
           if Array.isArray(elm) && (elm[main_library_index]['library']['statements']['def'].filter (def) -> def.name == generatedELMJSON.name).length == 0
             elm[main_library_index]["library"]["statements"]["def"].push generatedELMJSON
           else if !Array.isArray(elm) && (elm["library"]["statements"]["def"].filter (def) -> def.name == generatedELMJSON.name).length == 0
             elm["library"]["statements"]["def"].push generatedELMJSON

      # Calculate results for each CQL statement
      results = executeSimpleELM(elm, patientSource, @valueSetsForCodeService(), population.collection.parent.get('main_cql_library'), main_library_version, params)

      # Parse CQL statement results into population values
      population_results = @createPopulationValues population, results, patient, observation_defs

      if population_results?
        result.set population_results
        result.set {'population_relevance': @_buildPopulationRelevanceMap(population_results) }

        # Add 'statement_relevance', 'statement_results' and 'clause_results' generated in the CQLResultsHelpers class.
        result.set {'statement_relevance': CQLResultsHelpers.buildStatementRelevanceMap(result.get('population_relevance'), population.collection.parent, population) }
        result.set CQLResultsHelpers.buildStatementAndClauseResults(population.collection.parent, results.localIdPatientResultsMap[patient['id']], result.get('statement_relevance'))

        result.set {'patient_id': patient['id']} # Add patient_id to result in order to delete patient from population_calculation_view
        result.state = 'complete'
    catch error
      result.state = 'cancelled'
      # Since the line above is needed to handle the error cleanup we are using Costanza.emit to push this error
      Costanza.emit({
        section: 'cql-measure-calculation',
        cms_id: result.measure.get('cms_id'),
        stack: error.stack,
        msg: error.message,
        type: 'javascript'
        }, error)
    return result

  ###*
  # Create population values (aka results) for all populations in the population set using the results from the
  # calculator.
  # @param {Population} population - The population set we are getting the values for.
  # @param {object} results - The raw results object from the calculation engine.
  # @param {Patient} patient - The patient we are getting results for.
  # @param {Array} observation_defs - List of observation defines we add to the elm for calculation OBSERVs.
  # @returns {object} The population results. Map of "POPNAME" to Integer result. Except for OBSERVs,
  #   their key is 'value' and value is an array of results.
  ###
  createPopulationValues: (population, results, patient, observation_defs) ->
    population_results = {}
    # Grab the mapping between populations and CQL statements
    cql_map = population.collection.parent.get('populations_cql_map')
    # Grab the correct expected for this population
    popIndex = population.get('index')
    expected = patient.get('expected_values').findWhere(measure_id: population.collection.parent.get('hqmf_set_id'), population_index: popIndex)
    # Loop over all population codes ("IPP", "DENOM", etc.)
    for popCode in Thorax.Models.Measure.allPopulationCodes
      if cql_map[popCode]
        # This code is supporting measures that were uploaded 
        # before the parser returned multiple populations in an array.
        # TODO: Remove this check when we move over to production.
        if _.isString(cql_map[popCode])
          defined_pops = [cql_map[popCode]]
        else
          defined_pops = cql_map[popCode]

        popIndex = population.getPopIndexFromPopName(popCode)
        cql_population = defined_pops[popIndex]
        # Is there a patient result for this population? and does this populationCriteria contain the population
        # We need to check if the populationCriteria contains the population so that a STRAT is not set to zero if there is not a STRAT in the populationCriteria
        if population.get(popCode)?
          # Grab CQL result value and adjust for Bonnie
          value = results['patientResults'][patient.id][cql_population]
          if Array.isArray(value) and value.length > 0
            population_results[popCode] = value.length
          else if typeof value is 'boolean' and value
            population_results[popCode] = 1
          else
            population_results[popCode] = 0
      else if popCode == 'OBSERV' && observation_defs?.length > 0
        # Handle observations using the names of the define statements that
        # were added to the ELM to call the observation functions.
        for ob_def in observation_defs
          population_results['values'] = [] unless population_results['values']
          # Observations only have one result, based on how the HQMF is
          # structured (note the single 'value' section in the
          # measureObservationDefinition clause).
          obs_result = results['patientResults']?[patient.id]?[ob_def]?[0]
          if obs_result
            # Add the single result value to the values array on the results of
            # this calculation (allowing for more than one possible observation).
            if obs_result.hasOwnProperty('value')
              # If result is a cql.Quantity type, add its value
              population_results['values'].push(obs_result.value)
            else if Object(obs_result) != obs_result
              # In all other cases, only add primitives (numbers, booleans)
              population_results['values'].push(obs_result)
    @handlePopulationValues population_results

  ###*
  # Takes in the initial values from result object and checks to see if some values should not be calculated. These
  # values that should not be calculated are zeroed out.
  # @param {object} population_results - The population results. Map of "POPNAME" to Integer result. Except for OBSERVs,
  #   their key is 'value' and value is an array of results.
  # @returns {object} Population results in the same structure as passed in, but the appropiate values are zeroed out.
  ###
  handlePopulationValues: (population_results) ->
    # Setting values of populations if the correct populations are not set based on the following logic guidelines
    # Initial Population (IPP): The set of patients or episodes of care to be evaluated by the measure.
    # Denominator (DENOM): A subset of the IPP.
    # Denominator Exclusions (DENEX): A subset of the Denominator that should not be considered for inclusion in the Numerator.
    # Denominator Exceptions (DEXCEP): A subset of the Denominator. Only those members of the Denominator that are considered 
    # for Numerator membership and are not included are considered for membership in the Denominator Exceptions.
    # Numerator (NUMER): A subset of the Denominator. The Numerator criteria are the processes or outcomes expected for each patient,
    # procedure, or other unit of measurement defined in the Denominator.
    # Numerator Exclusions (NUMEX): A subset of the Numerator that should not be considered for calculation.
    if population_results["STRAT"]? && @isValueZero('STRAT', population_results) # Set all values to 0
      for key, value of population_results
        population_results[key] = 0
    else if @isValueZero('IPP', population_results)
      for key, value of population_results
        if key != 'STRAT'
          population_results[key] = 0
    else if @isValueZero('DENOM', population_results) or @isValueZero('MSRPOPL', population_results)
      if 'DENEX' of population_results
        population_results['DENEX'] = 0
      if 'DENEXCEP' of population_results
        population_results['DENEXCEP'] = 0
      if 'NUMER' of population_results
        population_results['NUMER'] = 0
    # Can not be in the numerator if excluded from the denominator
    else if (population_results["DENEX"]? && !@isValueZero('DENEX', population_results))
      if 'NUMER' of population_results
        population_results['NUMER'] = 0
      if 'NUMEX' of population_results
        population_results['NUMEX'] = 0
    else if @isValueZero('NUMER', population_results)
      if 'NUMEX' of population_results
        population_results['NUMEX'] = 0
    # Can not be in the numerator if explicitly excluded
    else if population_results["NUMEX"]? && !@isValueZero('NUMEX', population_results)
      if 'NUMER' of population_results
        population_results['NUMER'] = 0
    else if !@isValueZero('NUMER', population_results)
      if 'DENEXCEP' of population_results
        population_results["DENEXCEP"] = 0
    return population_results

  ###*
  # Builds the `population_relevance` map. This map gets added to the Result attributes that the calculator returns.
  #
  # The population_relevance map indicates which populations the patient was actually considered for inclusion in. It
  # is a simple map of "POPNAME" to true or false. true if the population was relevant/considered, false if
  # NOT relevant/considered. This is used later to determine which define statements are relevant in the calculation.
  #
  # For example: If they aren't in the IPP then they are not going to be considered for any other population and all other
  # populations will be marked NOT relevant.
  #
  # Below is an example result of this function (the 'population_relevance' map). DENEXCEP is not relevant because in
  # the population_results the NUMER was greater than zero:
  # {
  #   "IPP": true,
  #   "DENOM": true,
  #   "NUMER": true,
  #   "DENEXCEP": false
  # }
  #
  # This function is extremely verbose because this is an important and confusing calculation to make. The verbosity
  # was kept to make it more maintainable.
  # @private
  # @param {Result} result - The `population_results` object.
  # @returns {object} Map that tells if a population calculation was considered/relevant.
  ###
  _buildPopulationRelevanceMap: (result) ->
    # initialize to true for every population
    resultShown = {}
    _.each(Object.keys(result), (population) -> resultShown[population] = true)

    # If STRAT is 0 then everything else is not calculated
    if result.STRAT? && result.STRAT == 0
      resultShown.IPP = false if resultShown.IPP?
      resultShown.NUMER = false if resultShown.NUMER?
      resultShown.NUMEX = false if resultShown.NUMEX?
      resultShown.DENOM = false if resultShown.DENOM?
      resultShown.DENEX = false if resultShown.DENEX?
      resultShown.DENEXCEP = false if resultShown.DENEXCEP?
      resultShown.MSRPOPL = false if resultShown.MSRPOPL?
      resultShown.MSRPOPLEX = false if resultShown.MSRPOPLEX?
      resultShown.values = false if resultShown.values?

    # If IPP is 0 then everything else is not calculated
    if result.IPP == 0
      resultShown.NUMER = false if resultShown.NUMER?
      resultShown.NUMEX = false if resultShown.NUMEX?
      resultShown.DENOM = false if resultShown.DENOM?
      resultShown.DENEX = false if resultShown.DENEX?
      resultShown.DENEXCEP = false if resultShown.DENEXCEP?
      resultShown.MSRPOPL = false if resultShown.MSRPOPL?
      resultShown.MSRPOPLEX = false if resultShown.MSRPOPLEX?
      # values is the OBSERVs
      resultShown.values = false if resultShown.values?

    # If DENOM is 0 then DENEX, DENEXCEP, NUMER and NUMEX are not calculated
    if result.DENOM? && result.DENOM == 0
      resultShown.NUMER = false if resultShown.NUMER?
      resultShown.NUMEX = false if resultShown.NUMEX?
      resultShown.DENEX = false if resultShown.DENEX?
      resultShown.DENEXCEP = false if resultShown.DENEXCEP?

    # If DENEX is 1 then NUMER, NUMEX and DENEXCEP not calculated
    if result.DENEX? && result.DENEX >= 1
      resultShown.NUMER = false if resultShown.NUMER?
      resultShown.NUMEX = false if resultShown.NUMEX?
      resultShown.DENEXCEP = false if resultShown.DENEXCEP?

    # If NUMER is 0 then NUMEX is not calculated
    if result.NUMER? && result.NUMER == 0
      resultShown.NUMEX = false if resultShown.NUMEX?

    # If NUMER is 1 then DENEXCEP is not calculated
    if result.NUMER? && result.NUMER >= 1
      resultShown.DENEXCEP = false if resultShown.DENEXCEP?

    # If MSRPOPLEX is 1 then MSRPOPL and OBSERVs are not calculated
    if result.MSRPOPLEX? && result.MSRPOPLEX == 1
      resultShown.MSRPOPL = false if resultShown.MSRPOPL?
      resultShown.values = false if resultShown.values?

    # If MSRPOPL is 0 then OBSERVs are not calculated
    if result.MSRPOPL? && result.MSRPOPL == 0
      resultShown.values = false if resultShown.values?

    return resultShown

  isValueZero: (value, population_set) ->
    if value of population_set and population_set[value] == 0
      return true
    return false

  # Format ValueSets for use by CQL4Browsers
  valueSetsForCodeService: ->
    valueSets = {}
    for oid, vs of bonnie.valueSetsByOid
      continue unless vs.concepts
      valueSets[oid] ||= {}
      valueSets[oid][vs.version] ||= []
      for concept in vs.concepts
        valueSets[oid][vs.version].push code: concept.code, system: concept.code_system_name, version: vs.version
    valueSets

  # Converts the given time to the correct format using momentJS
  getConvertedTime: (timeValue) ->
    moment.utc(timeValue, 'YYYYMDDHHmm').toDate()

  # Returns a JSON function to add to the ELM before ELM JSON is used to calculate results
  # This ELM template was generated by the CQL-to-ELM Translation Service
  generateELMJSONFunction: (functionName, parameter) ->
    elmFunction =
      name: 'BonnieFunction_' + functionName,
      context: 'Patient',
      accessLevel: 'Public',
      expression:
        type: 'Query',
        source: [
          {
            alias: 'MP',
            expression: {
              name: parameter,
              type: 'ExpressionRef'
             }
          }
        ]
        relationship: [],
        return:
          distinct: false,
          expression:
            name: functionName,
            type: 'FunctionRef',
            operand: [
              {
                type: 'As',
                operand: {
                  name: 'MP',
                  type: 'AliasRef'
                }
              }
            ]
