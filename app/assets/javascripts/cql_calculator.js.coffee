###*
# The CQL calculator. This calls the CQL4Browsers engine then prepares the results for consumption by the rest of
# Bonnie.
###
@CQLCalculator = class CQLCalculator extends Calculator

  # List of statements added by the MAT that are not useful to the user.
  @SKIP_STATEMENTS = ["SDE Ethnicity", "SDE Payer", "SDE Race", "SDE Sex"]

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
        result.set {'statement_relevance': @_buildStatementRelevanceMap(result.get('population_relevance'), population.collection.parent, population) }
        result.set @_buildStatementAndClauseResults(population.collection.parent, results.localIdPatientResultsMap[patient['id']], result.get('statement_relevance'))
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

  ###*
  # Builds the `statement_relevance` map. This map gets added to the Result attributes that the calculator returns.
  #
  # The statement_relevance map indicates which define statements were actually relevant to a population inclusion
  # consideration. This makes use of the 'population_relevance' map. This is actually a two level map. The top level is
  # a map of the CQL libraries, keyed by library name. The second level is a map for statement relevance in that library,
  # which maps each statement to its relevance status. The values in this map differ from the `population_relevance`
  # because we also need to track statements that are not used for any population calculation. Therefore the values are
  # a string that is one of the following: 'NA', 'TRUE', 'FALSE'. Here is what they mean:
  #
  # 'NA' - Not applicable. This statement is not relevant to any population calculation in this population_set. Common
  #   for unused library statements or statements only used for other population sets.
  #
  # 'FALSE' - This statement is not relevant to any of this patient's population inclusion calculations.
  #
  # 'TRUE' - This statement is relevant for one or more of the population inclusion calculations.
  #
  # Here is an example structure this function returns. (the `statement_relevance` map)
  # {
  #   "Test158": {
  #     "Patient": "NA",
  #     "SDE Ethnicity": "NA",
  #     "SDE Payer": "NA",
  #     "SDE Race": "NA",
  #     "SDE Sex": "NA",
  #     "Most Recent Delivery": "TRUE",
  #     "Most Recent Delivery Overlaps Diagnosis": "TRUE",
  #     "Initial Population": "TRUE",
  #     "Numerator": "TRUE",
  #     "Denominator Exceptions": "FALSE"
  #   },
  #   "TestLibrary": {
  #     "Numer Helper": "TRUE",
  #     "Denom Excp Helper": "FALSE",
  #     "Unused statement": "NA"
  #   }
  # }
  #
  # This function relies heavily on the cql_statement_dependencies map on the Measure to recursively determine which
  # statements are used in the relevant population statements. It also uses the 'population_relevance' map to determine
  # the relevance of the population defining statement and its dependent statements.
  # @private
  # @param {object} populationRelevance - The `population_relevance` map, used at the starting point.
  # @param {Measure} measure - The measure.
  # @param {population} populationSet - The population set being calculated.
  # @returns {object} The `statement_relevance` map that maps each statement to its relevance status for a calculation.
  #   This structure is put in the Result object's attributes.
  ###
  _buildStatementRelevanceMap: (populationRelevance, measure, populationSet) ->
    # build map defaulting to not applicable (NA) using cql_statement_dependencies structure
    statementRelevance = {}
    for lib, statements of measure.get('cql_statement_dependencies')
      statementRelevance[lib] = {}
      for statementName of statements
        statementRelevance[lib][statementName] = "NA"

    for population, relevance of populationRelevance
      # If the population is values, that means we need to mark relevance for the OBSERVs
      if (population == 'values')
        for observation in measure.get('observations')
          @_markStatementRelevant(measure.get('cql_statement_dependencies'), statementRelevance, measure.get('main_cql_library'), observation.function_name, relevance)
      else
        populationIndex = populationSet.getPopIndexFromPopName(population)
        relevantStatement = measure.get('populations_cql_map')[population][populationIndex]
        @_markStatementRelevant(measure.get('cql_statement_dependencies'), statementRelevance, measure.get('main_cql_library'), relevantStatement, relevance)

    return statementRelevance

  ###*
  # Recursive helper function for the _buildStatementRelevanceMap function. This marks a statement as relevant (or not
  # relevant but applicable) in the `statement_relevance` map. It recurses and marks dependent statements also relevant
  # unless they have already been marked as 'TRUE' for their relevance statue. This function will never be called on
  # statements that are 'NA'.
  # @private
  # @param {object} cql_statement_dependencies - Dependency map from the measure object. The thing we recurse over 
  #   even though it is flat, it represents a tree.
  # @param {object} statementRelevance - The `statement_relevance` map to mark.
  # @param {string} libraryName - The library name of the statement we are marking.
  # @param {string} statementName - The name of the statement we are marking.
  # @param {boolean} relevant - true if the statement should be marked 'TRUE', false if it should be marked 'FALSE'.
  ###
  _markStatementRelevant: (cql_statement_dependencies, statementRelevance, libraryName, statementName, relevant) ->
    # only mark the statement if it is currently 'NA' or 'FALSE'. Otherwise it already has been marked 'TRUE'
    if statementRelevance[libraryName][statementName] == 'NA' || statementRelevance[libraryName][statementName] == 'FALSE'
      statementRelevance[libraryName][statementName] = if relevant then 'TRUE' else 'FALSE'
      for dependentStatement in cql_statement_dependencies[libraryName][statementName]
        @_markStatementRelevant(cql_statement_dependencies, statementRelevance, dependentStatement.library_name, dependentStatement.statement_name, relevant)

  ###*
  # Builds the result structures for the statements and the clauses. These are named `statement_results` and
  # `clause_results` respectively when added Result object's attributes.
  #
  # The `statement_results` structure indicates the result for each statement taking into account the statement
  # relevance in determining the result. This is a two level map just like `statement_relevance`. The first level key is
  # the library name and the second key level is the statement name. The value is an object that has two properties,
  # 'raw' and 'final'. 'raw' is the raw result from the execution engine for that statement. 'final' is the final result
  # that takes into account the relevance in this calculation. The value of 'final' will be one of the following
  # strings: 'NA', 'UNHIT', 'TRUE', 'FALSE'. Here's what they mean:
  #
  # 'NA' - Not applicable. This statement is not relevant to any population calculation in this population_set. Common
  #   for unused library statements or statements only used for other population sets.
  #   !!!IMPORTANT NOTE!!! All define function statements are marked 'NA' since we don't have a strategy for
  #        highlighting or coverage when it comes to functions.
  #
  # 'UNHIT' - This statement wasn't hit. This is most likely because the statement was not relevant to population
  #     calculation for this patient. i.e. 'FALSE' in the the `statement_relevance` map.
  #
  # 'TRUE' - This statement is relevant and has a truthy result.
  #
  # 'FALSE' - This statement is relevant and has a falsey result.
  #
  # Here is an example of the `statement_results` structure: (raw results have been turned into "???" for this example)
  # {
  #   "Test158": {
  #     "Patient": { "raw": "???", "final": "NA" },
  #     "SDE Ethnicity": { "raw": "???", "final": "NA" },
  #     "SDE Payer": { "raw": "???", "final": "NA" },
  #     "SDE Race": { "raw": "???", "final": "NA" },
  #     "SDE Sex": { "raw": "???", "final": "NA" },
  #     "Most Recent Delivery": { "raw": "???", "final": "TRUE" },
  #     "Most Recent Delivery Overlaps Diagnosis": { "raw": "???", "final": "TRUE" },
  #     "Initial Population": { "raw": "???", "final": "TRUE" },
  #     "Numerator": { "raw": "???", "final": "TRUE" },
  #     "Denominator Exceptions": { "raw": "???", "final": "UNHIT" }
  #   },
  #  "TestLibrary": {
  #     "Numer Helper": { "raw": "???", "final": "TRUE" },
  #     "Denom Excp Helper": { "raw": "???", "final": "UNHIT" },
  #     "Unused statement": { "raw": "???", "final": "NA" }
  #   }
  # }
  #
  #
  # The `clause_results` structure is the same as the `statement_results` but it indicates the result for each clause.
  # The second level key is the localId for the clause. The result object is the same with the same  'raw' and 'final'
  # properties but it also includes the name of the statement it resides in as 'statementName'.
  #
  # This function relies very heavily on the `statement_relevance` map to determine the final results. This function
  # returns the two structures together in an object ready to be added directly to the Result attributes.
  # @private
  # @param {Measure} measure - The measure.
  # @param {object} rawClauseResults - The raw clause results from the calculation engine.
  # @param {object} statementRelevance - The `statement_relevance` map. Used to determine if they were hit or not.
  # @returns {object} Object with the statement_results and clause_results structures, keyed as such.
  ###
  _buildStatementAndClauseResults: (measure, rawClauseResults, statementRelevance) ->
    statementResults = {}
    clauseResults = {}
    emptyResultClauses = []
    for lib, statements of measure.get('cql_statement_dependencies')
      statementResults[lib] = {}
      clauseResults[lib] = {}
      for statementName of statements
        rawStatementResult = @_findResultForStatementClause(measure, lib, statementName, rawClauseResults)
        statementResults[lib][statementName] = { raw: rawStatementResult}
        if CQLCalculator.SKIP_STATEMENTS.includes(statementName) || statementRelevance[lib][statementName] == 'NA'
          statementResults[lib][statementName].final = 'NA'
        else if statementRelevance[lib][statementName] == 'FALSE' || !rawClauseResults[lib]?
          statementResults[lib][statementName].final = 'UNHIT'
        else
          statementResults[lib][statementName].final = if @_doesResultPass(rawStatementResult) then 'TRUE' else 'FALSE'

        # create clause results for all localIds in this statement
        localIds = measure.findAllLocalIdsInStatementByName(lib, statementName)
        for localId, clause of localIds
          clauseResult =
            # if this clause is an alias or a usage of alias it will get the raw result from the sourceLocalId.
            raw: rawClauseResults[lib]?[if clause.sourceLocalId? then clause.sourceLocalId else localId],
            statementName: statementName

          clauseResult.final = @_setFinalResults(
            statementRelevance: statementRelevance,
            statementName: statementName,
            rawClauseResults: rawClauseResults
            lib: lib,
            localId: localId,
            clause: clause,
            rawResult: clauseResult.raw)

          clauseResults[lib][localId] = clauseResult
  
    return { statement_results: statementResults, clause_results: clauseResults }


  ###*
  # Determines the final result (for coloring and coverage) for a clause. The result fills the 'final' property for the
  # clause result. Look at the comments for _buildStatementAndClauseResults to get a description of what each of the
  # string results of this function are.
  # @private
  # @param {object} rawClauseResults - The raw clause results from the calculation engine.
  # @param {object} statementRelevance - The statement relevance map.
  # @param {object} statementName - The name of the statement the clause is in
  # @param {object} lib - The name of the libarary the clause is in
  # @param {object} localId - The localId of the current clause
  # @param {object} clause - The clause we are getting the final result of
  # @param {Array|Object|Interval|??} rawResult - The raw result from the calculation engine.
  # @returns {string} The final result for the clause.
  ###
  _setFinalResults: (params) ->
    finalResult = 'FALSE'
    if CQLCalculator.SKIP_STATEMENTS.includes(params.statementName) || params.clause.isUnsupported?
      finalResult = 'NA'
    else if params.statementRelevance[params.lib][params.statementName] == 'NA'
      finalResult = 'NA'
    else if params.statementRelevance[params.lib][params.statementName] == 'FALSE' || !params.rawClauseResults[params.lib]?
      finalResult = 'UNHIT'
    else if @_doesResultPass(params.rawResult) 
      finalResult = 'TRUE'
    return finalResult

  ###*
  # Finds the clause localId for a statement and gets the raw result for it from the raw clause results.
  # @private
  # @param {Measure} measure - The measure.
  # @param {string} libraryName - The library name.
  # @param {string} statementName - The statement name.
  # @param {object} rawClauseResults - The raw clause results from the engine.
  # @returns {(Array|object|Interval|??)} The raw result from the calculation engine for the given statement.
  ###
  _findResultForStatementClause: (measure, libraryName, statementName, rawClauseResults) ->
    library = measure.get('elm').find((lib) -> lib.library.identifier.id == libraryName)
    statement = library.library.statements.def.find((statement) -> statement.name == statementName)
    return rawClauseResults[libraryName]?[statement.localId]

  ###*
  # Determines if a result (for a statement or clause) from the execution engine is a pass or fail.
  # @private
  # @param {(Array|object|boolean|???)} result - The result from the calculation engine.
  # @returns {boolean} true or false
  ###
  _doesResultPass: (result) ->
    if result is true  # Specifically a boolean true
      return true
    else if result is false  # Specifically a boolean false
      return false
    else if Array.isArray(result)  # Check if result is an array
      if result.length == 0  # Result is true if the array is not empty
        return false
      else if result.length == 1 && result[0] == null # But if the array has one element that is null. Then we should make it red.
        return false
      else
        return true
    else if result instanceof cql.Interval  # make it green if and Interval is returned
      return true
    else if result is null || result is undefined # Specifically no result
      return false
    else
      return true

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
