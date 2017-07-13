@CQLCalculator = class CQLCalculator extends Calculator

  # List of statements added by the MAT that are not useful to the user.
  @SKIP_STATEMENTS = ["SDE Ethnicity", "SDE Payer", "SDE Race", "SDE Sex"]
  # List of statements that we don't support coverage/coloring of yet
  unsupported_statements = []
  
  # THIS IS NOT FOREVER
  @aliass = []

  # Generate a calculation result for a population / patient pair; this always returns a result immediately,
  # but may return a blank result object that later gets filled in through a deferred calculation, so views
  # that display results must be able to handle a state of "not yet calculated"
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

  createPopulationValues: (population, results, patient, observation_defs) ->
    population_results = {}
    # Grab the mapping between populations and CQL statements
    cql_map = population.collection.parent.get('populations_cql_map')
    # Grab the correct expected for this population
    index = population.get('index')
    expected = patient.get('expected_values').findWhere(measure_id: population.collection.parent.get('hqmf_set_id'), population_index: index)
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
        index = 0 unless defined_pops.length > 1
        # If a stratified population, we need to set the index to the populationCriteria
        # that the stratification is on so that the correct (IPOP, DENOM, NUMER..) are retrieved
        index = population.get('population_index') if population.get('stratification')?
        # If retrieving the STRAT, set the index to the correct STRAT in the cql_map
        index = population.get('stratification_index') if popCode == "STRAT" && population.get('stratification')?
        cql_population = defined_pops[index]
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

  # Takes in the initial values from result object and checks to see if some values should not be calculated.
  handlePopulationValues: (population_results) ->
    # TODO: Handle CV measures
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
  # Build a map of population to boolean of if the result of the define statement result should be shown or not. This is
  # what determines if we don't highlight the statements that are "not calculated".
  # @private
  # @param {Result} result - The population result object.
  # @return {object} Map that tells if a population calculation was considered/relevant.
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
  # Builds a map of relevance for the statements in this calculation.
  # @private
  # @param {object} populationRelevance - The map of population relevance used as the starting point.
  # @param {Measure} measure - The measure.
  # @param {population} populationSet - The population set being calculated.
  # @return {object} The statement_relevance map that tells if each statement was relevant for calculation.
  ###
  _buildStatementRelevanceMap: (populationRelevance, measure, populationSet) ->
    # build map defaulting to false using cql_statement_dependencies structure
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
        index = populationSet.get('index')
        # If displaying a stratification, we need to set the index to the associated populationCriteria
        # that the stratification is on so that the correct (IPOP, DENOM, NUMER..) are retrieved
        index = populationSet.get('population_index') if populationSet.get('stratification')?
        # If retrieving the STRAT, set the index to the correct STRAT in the cql_map
        index = populationSet.get('stratification_index') if population == "STRAT" && populationSet.get('stratification')?

        relevantStatement = measure.get('populations_cql_map')[population][index]
        @_markStatementRelevant(measure.get('cql_statement_dependencies'), statementRelevance, measure.get('main_cql_library'), relevantStatement, relevance)

    return statementRelevance

  ###*
  # Mark a statement as relevant if it hasn't already been marked relevant. Mark all dependent statement
  # as relevant.
  # @private
  # @param {object} cql_statement_dependencies - Dependency map for the measure.
  # @param {object} statementRelevance - The relevance map to fill.
  # @param {string} libraryName - The library name.
  # @param {string} statementName - The statement name.
  ###
  _markStatementRelevant: (cql_statement_dependencies, statementRelevance, libraryName, statementName, relevant) ->
    if statementRelevance[libraryName][statementName] == 'NA' || statementRelevance[libraryName][statementName] == 'FALSE'
      statementRelevance[libraryName][statementName] = if relevant then 'TRUE' else 'FALSE'
      for dependentStatement in cql_statement_dependencies[libraryName][statementName]
        @_markStatementRelevant(cql_statement_dependencies, statementRelevance, dependentStatement.library_name, dependentStatement.statement_name, relevant)

  ###*
  # Builds the result structures for the statements and the clauses.
  # @private
  # @param {Measure} measure - The measure.
  # @param {object} rawStatementResults - The raw statement results from the calculation engine.
  # @param {object} rawClauseResults - The raw clause results from the calculation engine.
  # @param {object} statementRelevance - The statement relevance map.
  # @return {object} Object with statement_results and clause_results built.
  ###
  _buildStatementAndClauseResults: (measure, rawClauseResults, statementRelevance) ->
    statementResults = {}
    clauseResults = {}
    @aliass = []
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
        localIds = @_findAllLocalIdsInStatementByName(measure, lib, statementName)
        for localId, clause of localIds
          clauseResults[lib][localId] = { raw: rawClauseResults[lib]?[localId], statementName: statementName }
          clauseResults[lib][localId].final = @_setFinalResults(
            statementRelevance: statementRelevance,
            statementName: statementName,
            rawClauseResults: rawClauseResults,
            lib: lib,
            localId: localId,
            clause: clause)   
      
      for alias in @aliass
        if clauseResults[alias.lib]? && clauseResults[alias.lib][alias.expressionLocalId]?
          clauseResults[alias.lib][alias.aliasLocalId] = clauseResults[alias.lib][alias.expressionLocalId]
        
    return { statement_results: statementResults, clause_results: clauseResults }


  ###*
  # Determines the final result (for coloring and coverage) of clauses
  # @private
  # @param {object} rawClauseResults - The raw clause results from the calculation engine.
  # @param {object} statementRelevance - The statement relevance map.
  # @param {object} statementName - The name of the statement the clause is in
  # @param {object} lib - The name of the libarary the clause is in
  # @param {object} localId - The localId of the current clause
  # @param {object} clause - The clause we are getting the final result of
  ###
  _setFinalResults: (params) ->
    finalResult = 'FALSE'
    # Alias clauses do not have results, so they are irrelevant for highlighting and coverage
    if params.clause.alias?
      if params.clause.expression? && params.clause.expression.localId?
        @aliass.push({lib: params.lib, aliasLocalId: params.localId, expressionLocalId: params.clause.expression.localId})
      finalResult = 'NA'
    else if CQLCalculator.SKIP_STATEMENTS.includes(params.statementName) || unsupported_statements.includes(params.statementName) || params.statementRelevance[params.lib][params.statementName] == 'NA'
      finalResult = 'NA'
    else if params.statementRelevance[params.lib][params.statementName] == 'FALSE' || !params.rawClauseResults[params.lib]?
      finalResult = 'UNHIT'
    else if @_doesResultPass(params.rawClauseResults[params.lib]?[params.localId]) 
      finalResult = 'TRUE'
    return finalResult



  ###*
  # Finds all localIds in a statement by it's library and statement name.
  # @private
  # @param {Measure} measure - The measure.
  # @param {string} libraryName - The name of the library the statement belongs to.
  # @param {string} statementName - The statement name to search for.
  # @return {Array[Integer]} List of local ids in the statement.
  ###
  _findAllLocalIdsInStatementByName: (measure, libraryName, statementName) ->
    library = measure.get('elm').find((lib) -> lib.library.identifier.id == libraryName)
    statement = library.library.statements.def.find((statement) -> statement.name == statementName)
    return @_findAllLocalIdsInStatement(statement,libraryName)

  ###*
  # Finds all localIds in the statement structure recursively.
  # @private
  # @param {Object} statement - The statement structure or child parts of it.
  # @return {Array[Integer]} List of local ids in the statement.
  ###
  _findAllLocalIdsInStatement: (statement, libraryName, localIds, aliasMap) ->
    if !localIds?
      localIds = {}
    if !aliasMap?
      aliasMap = {}
    # looking at the key and value of everything on this object or array
    for k, v of statement
      # if the value is an array or object, recurse
      if (Array.isArray(v) || typeof v is 'object')
        @_findAllLocalIdsInStatement(v, libraryName, localIds, aliasMap)
      # else if they key is localId push the value
      else if k == 'localId'
        localIds[v] = statement
        # We do not yet support coverage/coloring of Function statements
        # Keep track of all of the functiondef statement names so we can mark them as 'NA' in the statementResults
        if statement.type? && statement.type == "FunctionDef"
          if statement.name?
            unsupported_statements.push(statement.name)
      else if k == 'alias'
        if statement.expression? && statement.expression.localId?
          # Keep track of the localId of the expression that the alias references
          aliasMap[v] = statement.expression.localId
          alId = (parseInt(statement.expression.localId) + 1).toString()
          @aliass.push({lib: libraryName, aliasLocalId: alId, expressionLocalId: aliasMap[v]})
      else if k == 'scope'
        # The scope entry references an alias but does not have an ELM local ID. Hoever it DOES have an elm_annotations localId
        # The elm_annotation localId of the alias variable is one less than the result that the
        alId = (parseInt(statement.localId) - 1).toString()
        @aliass.push({lib: libraryName, aliasLocalId: alId, expressionLocalId: aliasMap[v]})

    return localIds

  ###*
  # Finds the clause localId for a statement and gets the result for that clause.
  # @private
  # @param {Measure} measure - The measure.
  # @param {string} libraryName - The library name.
  # @param {string} statementName - The statement name.
  # @param {object} rawClauseResults - The raw clause results from the engine.
  ###
  _findResultForStatementClause: (measure, libraryName, statementName, rawClauseResults) ->
    library = measure.get('elm').find((lib) -> lib.library.identifier.id == libraryName)
    statement = library.library.statements.def.find((statement) -> statement.name == statementName)
    return rawClauseResults[libraryName]?[statement.localId]

  ###*
  # Determines if a result (for a statement or clause) is a pass or fail.
  # @private
  # @param result - The result from the calculation engine.
  # @return {boolean} true or false
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
