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
  # @param {Object} options - miscellaneous options.
  ###
  calculate: (population, patient, options = {}) ->
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

      # Create the execution DateTime that we pass into the engine
      executionDateTime = cql.DateTime.fromDate(new Date(), '0')

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

      # Set all value set versions to 'undefined' so the execution engine does not grab the specified version in the ELM
      elm = @setValueSetVersionsToUndefined(elm)

      # Grab the correct version of value sets to pass into the exectuion engine.
      measure_value_sets = @valueSetsForCodeService(population.collection.parent.get('value_set_oid_version_objects'), population.collection.parent.get('hqmf_set_id'))

      # Calculate results for each CQL statement
      results = executeSimpleELM(elm, patientSource, measure_value_sets, population.collection.parent.get('main_cql_library'), main_library_version, executionDateTime, params)

      # Parse CQL statement results into population values
      [population_results, episode_results] = @createPopulationValues population, results, patient, observation_defs

      if population_results?
        result.set population_results
        population_relevance = {}

        # handle episode of care measure results
        if population.collection.parent.get('episode_of_care')
          result.set {'episode_results': episode_results}
          # calculate relevance only if there were recorded episodes
          if Object.keys(episode_results).length > 0
            # In episode of care based measures, episode_results contains the population results
            # for EACH episode, so we need to build population_relevance based on a combonation
            # of the episode_results. IE: If DENEX is irrelevant for one episode but relevant for
            # another, the logic view should not highlight it as irrelevant
            population_relevance = @_populationRelevanceForAllEpisodes(episode_results)
          else
            # use the patient based relevance if there are no episodes. This will properly set IPP or STRAT to true.
            population_relevance = @_buildPopulationRelevanceMap(population_results)
        else
          # calculate relevance for patient based measure
          population_relevance = @_buildPopulationRelevanceMap(population_results)
    
        result.set {'population_relevance': population_relevance }
        # Add 'statement_relevance', 'statement_results' and 'clause_results' generated in the CQLResultsHelpers class.
        result.set {'statement_relevance': CQLResultsHelpers.buildStatementRelevanceMap(population_relevance, population.collection.parent, population) }
        result.set CQLResultsHelpers.buildStatementAndClauseResults(population.collection.parent, results.localIdPatientResultsMap[patient['id']], result.get('statement_relevance'), !!options['doPretty'])

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
  # @returns {[object, object]} The population results. Map of "POPNAME" to Integer result. Except for OBSERVs,
  #   their key is 'value' and value is an array of results. Second result is the the episode results keyed by
  #   episode id and with the value being a set just like the patient results.
  ###
  createPopulationValues: (population, results, patient, observation_defs) ->
    population_results = {}
    episode_results = null
    # patient based measure
    if !population.collection.parent.get('episode_of_care')
      population_results = @handlePopulationValues(@createPatientPopulationValues(population, results, patient, observation_defs))
    else # episode of care based measure
      # collect results per episode
      episode_results = @createEpisodePopulationValues(population, results, patient, observation_defs)

      # initialize population counts
      for popCode in Thorax.Models.Measure.allPopulationCodes
        if population.get(popCode)?
          if popCode == 'OBSERV'
            population_results.values = []
          else
            population_results[popCode] = 0

      # count up all population results for a patient level count
      for _, episode_result of episode_results
        for popCode, popResult of episode_result
          if popCode == 'values'
            for value in popResult
              population_results.values.push(value)
          else
            population_results[popCode] += popResult
    return [population_results, episode_results]

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
    # Denominator exception (DENEXCEP): Identify those in the DENOM and NOT in the DENEX and NOT in the NUMER that meet the DENEXCEP criteria.
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
      if 'NUMEX' of population_results
        population_results['NUMEX'] = 0
      if 'MSRPOPLEX' of population_results
        population_results['MSRPOPLEX'] = 0
      if 'values' of population_results
        population_results['values'] = []
    # Can not be in the numerator if the same or more are excluded from the denominator
    else if (population_results["DENEX"]? && !@isValueZero('DENEX', population_results) && (population_results["DENEX"] >= population_results["DENOM"]))
      if 'NUMER' of population_results
        population_results['NUMER'] = 0
      if 'NUMEX' of population_results
        population_results['NUMEX'] = 0
      if 'DENEXCEP' of population_results
        population_results['DENEXCEP'] = 0
    else if (population_results["MSRPOPLEX"]? && !@isValueZero('MSRPOPLEX', population_results))
      if 'values' of population_results
        population_results['values'] = []
    else if @isValueZero('NUMER', population_results)
      if 'NUMEX' of population_results
        population_results['NUMEX'] = 0
    else if !@isValueZero('NUMER', population_results)
      if 'DENEXCEP' of population_results
        population_results["DENEXCEP"] = 0
    return population_results

  ###*
  # Create patient population values (aka results) for all populations in the population set using the results from the
  # calculator.
  # @param {Population} population - The population set we are getting the values for.
  # @param {object} results - The raw results object from the calculation engine.
  # @param {Patient} patient - The patient we are getting results for.
  # @param {Array} observation_defs - List of observation defines we add to the elm for calculation OBSERVs.
  # @returns {object} The population results. Map of "POPNAME" to Integer result. Except for OBSERVs,
  #   their key is 'value' and value is an array of results.
  ###
  createPatientPopulationValues: (population, results, patient, observation_defs) ->
    population_results = {}
    # Grab the mapping between populations and CQL statements
    cql_map = population.collection.parent.get('populations_cql_map')
    # Grab the correct expected for this population
    populationIndex = population.get('index')
    measureId = population.collection.parent.get('hqmf_set_id')
    expected = patient.get('expected_values').findWhere(measure_id: measureId, population_index: populationIndex)
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
          obs_results = results['patientResults']?[patient.id]?[ob_def]

          for obs_result in obs_results
          # Add the single result value to the values array on the results of
          # this calculation (allowing for more than one possible observation).
            if obs_result?.hasOwnProperty('value')
              # If result is a cql.Quantity type, add its value
              population_results['values'].push(obs_result.observation.value)
            else
              # In all other cases, add result
              population_results['values'].push(obs_result.observation)
    return population_results


  ###*
  # Create population values (aka results) for all episodes using the results from the calculator. This is
  # used only for the episode of care measures
  # @param {Population} population - The population set we are getting the values for.
  # @param {object} results - The raw results object from the calculation engine.
  # @param {Patient} patient - The patient we are getting results for.
  # @param {Array} observation_defs - List of observation defines we add to the elm for calculation OBSERVs.
  # @returns {object} The episode results. Map of episode id to population results which is a map of "POPNAME"
  # to Integer result. Except for OBSERVs, their key is 'value' and value is an array of results.
  ###
  createEpisodePopulationValues: (population, results, patient, observation_defs) ->
    episode_results = {}
    # Grab the mapping between populations and CQL statements
    cql_map = population.collection.parent.get('populations_cql_map')
    # Loop over all population codes ("IPP", "DENOM", etc.) to deterine ones included in this population.
    popCodesInPopulation = []
    for popCode in Thorax.Models.Measure.allPopulationCodes
      if population.get(popCode)?
        popCodesInPopulation.push popCode

    for popCode in popCodesInPopulation
      if cql_map[popCode]
        defined_pops = cql_map[popCode]

        popIndex = population.getPopIndexFromPopName(popCode)
        cql_population = defined_pops[popIndex]
        # Is there a patient result for this population? and does this populationCriteria contain the population
        # We need to check if the populationCriteria contains the population so that a STRAT is not set to zero if there is not a STRAT in the populationCriteria
        if population.get(popCode)?
          # Grab CQL result value and store for each episode found
          values = results['patientResults'][patient.id][cql_population]
          if Array.isArray(values)
            for value in values
              if value.id()?
                # if an episode has already been created set the result for the population to 1
                if episode_results[value.id().value]?
                  episode_results[value.id().value][popCode] = 1

                # else create a new episode using the list of all popcodes for the population
                else
                  newEpisode = { }
                  for pop in popCodesInPopulation
                    newEpisode[pop] = 0 unless pop == 'OBSERV'
                  newEpisode[popCode] = 1
                  episode_results[value.id().value] = newEpisode
          else
            console.log('WARNING: CQL Results not an array') if console?
      else if popCode == 'OBSERV' && observation_defs?.length > 0
        # Handle observations using the names of the define statements that
        # were added to the ELM to call the observation functions.
        for ob_def in observation_defs
          # Observations only have one result, based on how the HQMF is
          # structured (note the single 'value' section in the
          # measureObservationDefinition clause).
          obs_results = results['patientResults']?[patient.id]?[ob_def]

          for obs_result in obs_results
            result_value = null
            episodeId = obs_result.episode.id().value
            # Add the single result value to the values array on the results of
            # this calculation (allowing for more than one possible observation).
            if obs_result?.hasOwnProperty('value')
              # If result is a cql.Quantity type, add its value
              result_value = obs_result.observation.value
            else
              # In all other cases, add result
              result_value = obs_result.observation

            # if the episode_result object already exist create or add to to the values structure
            if episode_results[episodeId]?
              if episode_results[episodeId].values?
                episode_results[episodeId].values.push(result_value)
              else
                episode_results[episodeId].values = [result_value]
            # else create a new episode_result structure
            else
              newEpisode = { }
              for pop in popCodesInPopulation
                newEpisode[pop] = 0 unless pop == 'OBSERV'
              newEpisode.values = [result_value]
              episode_results[episodeId] = newEpisode
      else if popCode == 'OBSERV' && observation_defs?.length <= 0
        console.log('WARNING: No function definition injected for OBSERV') if console?
    # Correct any inconsistencies. ex. In DENEX but also in NUMER using same function used for patients.
    for episodeId, episode_result of episode_results
      episode_results[episodeId] = @handlePopulationValues(episode_result)
    return episode_results

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

    # If DENEX is greater than or equal to DENOM then NUMER, NUMEX and DENEXCEP not calculated
    if result.DENEX? && result.DENEX >= result.DENOM
      resultShown.NUMER = false if resultShown.NUMER?
      resultShown.NUMEX = false if resultShown.NUMEX?
      resultShown.DENEXCEP = false if resultShown.DENEXCEP?

    # If NUMER is 0 then NUMEX is not calculated
    if result.NUMER? && result.NUMER == 0
      resultShown.NUMEX = false if resultShown.NUMEX?

    # If NUMER is 1 then DENEXCEP is not calculated
    if result.NUMER? && result.NUMER >= 1
      resultShown.DENEXCEP = false if resultShown.DENEXCEP?

    # If MSRPOPL is 0 then OBSERVs and MSRPOPLEX are not calculateed
    if result.MSRPOPL? && result.MSRPOPL == 0
      resultShown.values = false if resultShown.values?
      resultShown.MSRPOPLEX = false if resultShown.MSRPOPLEX

    # If MSRPOPLEX is greater than or equal to MSRPOPL then OBSERVs are not calculated
    if result.MSRPOPLEX? && result.MSRPOPLEX >= result.MSRPOPL
      resultShown.values = false if resultShown.values?

    return resultShown

  ###
  # Iterate over episode results, call _buildPopulationRelevanceMap for each result 
  # OR population relevances together so that populations are marked as relevant
  # based on all episodes instead of just one
  # @private
  # @param {episode_results} result - Population_results for each episode
  # @returns {object} Map that tells if a population calculation was considered/relevant in any episode
  ###
  _populationRelevanceForAllEpisodes: (episode_results) ->
    masterRelevanceMap = {}
    for key, episode_result of episode_results
      popRelMap = @_buildPopulationRelevanceMap(episode_result)
      for pop, popRel of popRelMap
        if !masterRelevanceMap[pop]?
          masterRelevanceMap[pop] = false
        masterRelevanceMap[pop] = masterRelevanceMap[pop] || popRel
    return masterRelevanceMap

  isValueZero: (value, population_set) ->
    if value of population_set and population_set[value] == 0
      return true
    return false

  # Set all value set versions to 'undefined' so the execution engine does not grab the specified version in the ELM
  setValueSetVersionsToUndefined: (elm) ->
    for elm_library in elm
      if elm_library['library']['valueSets']?
        for valueSet in elm_library['library']['valueSets']['def']
          if valueSet['version']?
            valueSet['version'] = undefined
    elm

  # Format ValueSets for use by CQL4Browsers
  valueSetsForCodeService: (value_set_oid_version_objects, hqmf_set_id) ->
    # Cache this refactoring so it only happens once per user rather than once per measure population
    if !bonnie.valueSetsByOidCached
      bonnie.valueSetsByOidCached = {}

    if !bonnie.valueSetsByOidCached[hqmf_set_id]
      valueSets = {}
      for value_set in value_set_oid_version_objects
        specific_value_set = bonnie.valueSetsByOid[value_set['oid']][value_set['version']]
        continue unless specific_value_set.concepts
        valueSets[specific_value_set['oid']] ||= {}
        valueSets[specific_value_set['oid']][specific_value_set['version']] ||= []
        for concept in specific_value_set.concepts
          valueSets[specific_value_set['oid']][specific_value_set['version']].push code: concept.code, system: concept.code_system_name, version: specific_value_set['version']
      bonnie.valueSetsByOidCached[hqmf_set_id] = valueSets
    bonnie.valueSetsByOidCached[hqmf_set_id]

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
            type: 'Tuple',
            element: [
              {
                name: "episode",
                value: {
                  name: 'MP',
                  type: 'AliasRef'
                }
              },
              {
                name: "observation",
                value: {
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
                }
              }
            ]
