###*
# Contains helpers that generate useful data for coverage and highlighing. These structures are added to the Result
# object in the CQLCalculator.
###
class CQLResultsHelpers

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
  # @public
  # @param {object} populationRelevance - The `population_relevance` map, used at the starting point.
  # @param {cqmMeasure} measure - The measure.
  # @param {population} populationSet - The population set being calculated.
  # @returns {object} The `statement_relevance` map that maps each statement to its relevance status for a calculation.
  #   This structure is put in the Result object's attributes.
  ###
  @buildStatementRelevanceMap: (populationRelevance, cqmMeasure, populationSet) ->
    # build map defaulting to not applicable (NA) using cql_statement_dependencies structure
    statementRelevance = {}
    for library in cqmMeasure.cql_libraries
      statementRelevance[library.library_name] = {}
      for statement in library.statement_dependencies
        statementRelevance[library.library_name][statement.statement_name] = "NA"

    if cqmMeasure.calculate_sdes && populationSet.get('supplemental_data_elements')
      for statement in populationSet.get('supplemental_data_elements')
        # Mark all Supplemental Data Elements as relevant
        @_markStatementRelevant(cqmMeasure.cql_libraries, statementRelevance, cqmMeasure.main_cql_library, statement.statement_name, "TRUE")

    for population, relevance of populationRelevance
      # If the population is values, that means we need to mark relevance for the OBSERVs
      if (population == 'values')
        for observation in populationSet.get('observations')
          @_markStatementRelevant(cqmMeasure.cql_libraries, statementRelevance, cqmMeasure.main_cql_library, observation.observation_function.statement_name, relevance)
      else
        relevantStatement = populationSet.get('populations')[population].statement_name
        @_markStatementRelevant(cqmMeasure.cql_libraries, statementRelevance, cqmMeasure.main_cql_library, relevantStatement, relevance)
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
  @_markStatementRelevant: (cql_statement_dependencies, statementRelevance, libraryName, statementName, relevant) ->
    # only mark the statement if it is currently 'NA' or 'FALSE'. Otherwise it already has been marked 'TRUE'
    if statementRelevance[libraryName][statementName] == 'NA' || statementRelevance[libraryName][statementName] == 'FALSE'
      statementRelevance[libraryName][statementName] = if relevant then 'TRUE' else 'FALSE'

      for lib in cql_statement_dependencies
        statement = (stat for stat in lib.statement_dependencies when stat.statement_name is statementName)
        for stat in statement
          if !stat.statement_references
            continue
          for dependentStatement in stat.statement_references
            @_markStatementRelevant(cql_statement_dependencies, statementRelevance, dependentStatement.library_name, dependentStatement.statement_name, relevant)
      return []

  ###*
  # Builds the result structures for the statements and the clauses. These are named `statement_results` and
  # `clause_results` respectively when added Result object's attributes.
  #
  # The `statement_results` structure indicates the result for each statement taking into account the statement
  # relevance in determining the result. This is a two level map just like `statement_relevance`. The first level key is
  # the library name and the second key level is the statement name. The value is an object that has three properties,
  # 'raw', 'final' and 'pretty'. 'raw' is the raw result from the execution engine for that statement. 'final' is the final
  # result that takes into account the relevance in this calculation. 'pretty' is a human readable description of the result
  # that is only generated if doPretty is true.
  # The value of 'final' will be one of the following strings:
  # 'NA', 'UNHIT', 'TRUE', 'FALSE'.
  #
  # Here's what they mean:
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
  #     "Patient": { "raw": "???", "final": "NA", "pretty": "NA" },
  #     "SDE Ethnicity": { "raw": "???", "final": "NA", "pretty": "NA" },
  #     "SDE Payer": { "raw": "???", "final": "NA", "pretty": "NA" },
  #     "SDE Race": { "raw": "???", "final": "NA", "pretty": "NA" },
  #     "SDE Sex": { "raw": "???", "final": "NA", "pretty": "NA" },
  #     "Most Recent Delivery": { "raw": "???", "final": "TRUE", "pretty": "???" },
  #     "Most Recent Delivery Overlaps Diagnosis": { "raw": "???", "final": "TRUE", "pretty": "???" },
  #     "Initial Population": { "raw": "???", "final": "TRUE", "pretty": "???" },
  #     "Numerator": { "raw": "???", "final": "TRUE", "pretty": "???" },
  #     "Denominator Exceptions": { "raw": "???", "final": "UNHIT", "pretty": "UNHIT" },
  #   },
  #  "TestLibrary": {
  #     "Numer Helper": { "raw": "???", "final": "TRUE", "pretty": "???" },
  #     "Denom Excp Helper": { "raw": "???", "final": "UNHIT", "pretty": "UNHIT" },
  #     "Unused statement": { "raw": "???", "final": "NA", "pretty": "???" },
  #     "false statement": { "raw": "???", "final": "FALSE", "pretty": "FALSE: []" },
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
  # @public
  # @param {Measure} measure - The measure.
  # @param {object} rawClauseResults - The raw clause results from the calculation engine.
  # @param {object} statementRelevance - The `statement_relevance` map. Used to determine if they were hit or not.
  # @param {boolean} doPretty - If true, also generate pretty versions of result.
  # @returns {object} Object with the statement_results and clause_results structures, keyed as such.
  ###
  @buildStatementAndClauseResults: (thoraxMeasure, rawClauseResults, statementRelevance, doPretty = false) ->
    statementResults = {}
    clauseResults = {}
    emptyResultClauses = []
    cqmMeasure = thoraxMeasure.get('cqmMeasure')
    for library in cqmMeasure.cql_libraries
      statementResults[library.library_name] = {}
      clauseResults[library.library_name] = {}
      for statement in library.statement_dependencies
        rawStatementResult = @_findResultForStatementClause(cqmMeasure, library.library_name, statement.statement_name, rawClauseResults)
        statementResults[library.library_name][statement.statement_name] = { raw: rawStatementResult}
        isSDE = CQLMeasureHelpers.isSupplementalDataElementStatement(cqmMeasure.population_sets[0].get('supplemental_data_elements'), statement.statement_name)
        if (!cqmMeasure.calculate_sdes && isSDE) || statementRelevance[library.library_name][statement.statement_name] == 'NA'
          statementResults[library.library_name][statement.statement_name].final = 'NA'
          statementResults[library.library_name][statement.statement_name].pretty = 'NA' if doPretty
        else if statementRelevance[library.library_name][statement.statement_name] == 'FALSE' || !rawClauseResults[library.library_name]?
          statementResults[library.library_name][statement.statement_name].final = 'UNHIT'
          # even if the statement wasn't hit, we want the pretty result to just be FUNCTION for functions
          if CQLMeasureHelpers.isStatementFunction(library, statement.statement_name)
            statementResults[library.library_name][statement.statement_name].pretty = "FUNCTION" if doPretty
          else
            statementResults[library.library_name][statement.statement_name].pretty = 'UNHIT' if doPretty
        else
          if @_doesResultPass(rawStatementResult)
            statementResults[library.library_name][statement.statement_name].final = 'TRUE'
            statementResults[library.library_name][statement.statement_name].pretty = @prettyResult(rawStatementResult) if doPretty
          else
            statementResults[library.library_name][statement.statement_name].final = 'FALSE'
            if rawStatementResult instanceof Array && rawStatementResult.length == 0
              # Special case, handle empty array.
              statementResults[library.library_name][statement.statement_name].pretty = "FALSE ([])" if doPretty
            else if CQLMeasureHelpers.isStatementFunction(library, statement.statement_name)
              statementResults[library.library_name][statement.statement_name].pretty = "FUNCTION" if doPretty
            else
              statementResults[library.library_name][statement.statement_name].pretty = "FALSE (#{rawStatementResult})" if doPretty

        # create clause results for all localIds in this statement
        localIds = thoraxMeasure.findAllLocalIdsInStatementByName(library.library_name, statement.statement_name)
        for localId, clause of localIds
          clauseResult =
            # if this clause is an alias or a usage of alias it will get the raw result from the sourceLocalId.
            raw: rawClauseResults[library.library_name]?[if clause.sourceLocalId? then clause.sourceLocalId else localId],
            statementName: statement.statement_name

          clauseResult.final = @_setFinalResults(
            statementRelevance: statementRelevance,
            statementName: statement.statement_name,
            rawClauseResults: rawClauseResults
            lib: library.library_name,
            localId: localId,
            clause: clause,
            rawResult: clauseResult.raw)

          clauseResults[library.library_name][localId] = clauseResult

    return { statement_results: statementResults, clause_results: clauseResults }

  ###*
  # Generates a pretty human readable representation of a result.
  #
  # @param {(Array|object|boolean|???)} result - The result from the calculation engine.
  # @param {Integer} indentLevel - For nested objects, the indentLevel indicates how far to indent.
  #                                Note that 1 is the base because Array(1).join ' ' returns ''.
  # @returns {String} a pretty version of the given result
  ###
  @prettyResult: (result, indentLevel = 1, keyIndent = 1) ->
    keyIndentation = Array(keyIndent).join ' '
    currentIndentation = Array(indentLevel).join ' '

    if result instanceof cql.DateTime
      moment.utc(result.toString()).format('MM/DD/YYYY h:mm A')
    else if result instanceof cql.Interval
      "INTERVAL: #{@prettyResult(result['low'])} - #{@prettyResult(result['high'])}"
    else if result instanceof cql.Code
      "CODE: #{result['system']} #{result['code']}"
    else if result instanceof cql.Quantity
      quantityResult = "QUANTITY: #{result['value']}"
      if result['unit']
        quantityResult = quantityResult + " #{result['unit']}"
      quantityResult
    else if result instanceof CQL_QDM.QDMDatatype
      result.toString().replace /\n/g, "\n#{currentIndentation}#{keyIndentation}"
    else if result instanceof String or typeof(result) == 'string'
      '"' + result + '"'
    else if result instanceof Array
      prettyResult = _.map result, (value) => @prettyResult(value, indentLevel, keyIndent)
      "[#{prettyResult.join(",\n#{currentIndentation}#{keyIndentation}")}]"
    else if result instanceof Object
      prettyResult = '{\n'
      baseIndentation = Array(3).join ' '
      sortedKeys = Object.keys(result).sort()
      for key in sortedKeys
        value = result[key]
        # add 2 spaces per indent
        nextIndentLevel = indentLevel + 2
        # key length + ': '
        keyIndent = key.length + 3
        prettyResult = prettyResult.concat("#{baseIndentation}#{currentIndentation}#{key}: #{@prettyResult(value, nextIndentLevel, keyIndent)}")

        # append commas if it isn't the last key
        if key == sortedKeys[sortedKeys.length - 1]
          prettyResult += '\n'
        else
          prettyResult += ',\n'

      prettyResult = prettyResult + "#{currentIndentation}}"

      prettyResult
    else
      if result then JSON.stringify(result, null, 2) else 'null'

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
  @_setFinalResults: (params) ->
    finalResult = 'FALSE'
    if params.clause.isUnsupported?
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
  # @param {cqmMeasure} measure - The measure.
  # @param {string} libraryName - The library name.
  # @param {string} statementName - The statement name.
  # @param {object} rawClauseResults - The raw clause results from the engine.
  # @returns {(Array|object|Interval|??)} The raw result from the calculation engine for the given statement.
  ###
  @_findResultForStatementClause: (cqmMeasure, libraryName, statementName, rawClauseResults) ->
    library = null
    statement = null
    for lib in cqmMeasure.cql_libraries
      if lib.elm.library.identifier.id == libraryName
        library = lib
    for curStatement in library.elm.library.statements.def
      if curStatement.name == statementName
        statement = curStatement
    return rawClauseResults[libraryName]?[statement.localId]

  ###*
  # Determines if a result (for a statement or clause) from the execution engine is a pass or fail.
  # @private
  # @param {(Array|object|boolean|???)} result - The result from the calculation engine.
  # @returns {boolean} true or false
  ###
  @_doesResultPass: (result) ->
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
    # Return false if an empty cql.Code is the result
    else if result instanceof cql.Code && !result.code?
      return false
    else if result is null || result is undefined # Specifically no result
      return false
    else
      return true
