###*
# Contains helpers that generate useful data for coverage and highlighing. These structures are added to the Result
# object in the CQLCalculator.
###
@CQLResultsHelpers = class CQLResultsHelpers

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
      if (population == 'observation_values')
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
