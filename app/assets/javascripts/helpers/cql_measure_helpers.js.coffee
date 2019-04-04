###*
# Contains helpers that generate additional data for CQL measures. These functions provide extra data useful in working
# with calculation results.
###
class CQLMeasureHelpers

  ###*
  # Builds a map of define statement name to the statement's text from a measure.
  # @public
  # @param {Measure} measure - The measure to build the map from.
  # @return {Hash} Map of statement definitions to full statement
  ###
  @buildDefineToFullStatement: (measure) ->
    ret = {}
    for lib in measure.cql_libraries
      lib_statements = {}
      for statement in lib.elm_annotations.statements
        lib_statements[statement.define_name] = @_parseAnnotationTree(statement.children)
      ret[lib] = lib_statements
    return ret


  ###*
  # Recursive function that parses an annotation tree to extract text statements.
  # @param {Node} children - the node to be traversed.
  # @return {String} the text of the node or its children.
  ###
  @_parseAnnotationTree: (children) ->
    ret = ""
    if children.text != undefined
      return _.unescape(children.text).replace("&#13", "").replace(";", "")
    else if children.children != undefined
      for child in children.children
        ret = ret + @_parseAnnotationTree(child)
    else
      for child in children
        ret = ret + @_parseAnnotationTree(child)
    return ret

  ###*
  # Finds all localIds in a statement by it's library and statement name.
  # @public
  # @param {Measure} measure - The measure to find localIds in.
  # @param {string} libraryName - The name of the library the statement belongs to.
  # @param {string} statementName - The statement name to search for.
  # @return {Hash} List of local ids in the statement.
  ###
  @findAllLocalIdsInStatementByName: (cqmMeasure, libraryName, statementName) ->
    # create place for aliases and their usages to be placed to be filled in later. Aliases and their usages (aka scope)
    # and returns do not have localIds in the elm but do in elm_annotations at a consistent calculable offset.
    # BE WEARY of this calaculable offset.
    emptyResultClauses = []

    # find the library and statement in the elm.
    library = null
    statement = null
    for lib in cqmMeasure.cql_libraries
      if lib.library_name == libraryName
        library = lib
    for curStatement in library.elm.library.statements.def
      if curStatement.name == statementName
        statement = curStatement

    aliasMap = {}
    # recurse through the statement elm for find all localIds
    localIds = @_findAllLocalIdsInStatement(statement, libraryName, statement.annotation, {}, aliasMap, emptyResultClauses, null)
    # Create/change the clause for all aliases and their usages
    for alias in emptyResultClauses
      # Only do it if we have a clause for where the result should be fetched from
      # and have a localId for the clause that the result should map to
      if localIds[alias.expressionLocalId]? && alias.aliasLocalId?
        localIds[alias.aliasLocalId] =
          localId: alias.aliasLocalId,
          sourceLocalId: alias.expressionLocalId

    # We do not yet support coverage/coloring of Function statements
    # Mark all the clauses as unsupported so we can mark them 'NA' in the clause_results
    if statement.type == "FunctionDef"
      for localId, clause of localIds
        clause.isUnsupported = true
    return localIds

  ###*
  # Finds all localIds in the statement structure recursively.
  # @private
  # @param {Object} statement - The statement structure or child parts of it.
  # @param {String} libraryName - The name of the library we are looking at.
  # @param {Array} annotation - The JSON annotation for the entire structure, this is occasionally needed.
  # @param {Object} localIds - The hash of localIds we are filling.
  # @param {Object} aliasMap - The map of aliases.
  # @param {Array} emptyResultClauses - List of clauses that will have empty results from the engine. Each object on
  #    this has info on where to find the actual result.
  # @param {Object} parentNode - The parent node, used for some special situations.
  # @return {Array[Integer]} List of local ids in the statement. This is same array, localIds, that is passed in.
  ###
  @_findAllLocalIdsInStatement: (statement, libraryName, annotation, localIds, aliasMap, emptyResultClauses, parentNode) ->
    # looking at the key and value of everything on this object or array
    for k, v of statement
      if k == 'return'
        # Keep track of the localId of the expression that the return references. 'from's without a 'return' dont have
        # localId's. So it doesn't make sense to mark them.
        if statement.return.expression.localId?
          aliasMap[v] = statement.return.expression.localId
          alId = statement.return.localId
          emptyResultClauses.push({lib: libraryName, aliasLocalId: alId, expressionLocalId: aliasMap[v]}) if alId

        @_findAllLocalIdsInStatement(v, libraryName, annotation, localIds, aliasMap, emptyResultClauses, statement)
      else if k == 'alias'
        if statement.expression? && statement.expression.localId?
          # Keep track of the localId of the expression that the alias references
          aliasMap[v] = statement.expression.localId
          # Determine the localId in the elm_annotation for this alias.
          alId = parseInt(statement.expression.localId) + 1
          emptyResultClauses.push({lib: libraryName, aliasLocalId: alId, expressionLocalId: aliasMap[v]})
      else if k == 'scope'
        # The scope entry references an alias but does not have an ELM local ID. Hoever it DOES have an elm_annotations localId
        # The elm_annotation localId of the alias variable is the localId of it's parent (one less than)
        # because the result of the scope clause should be equal to the clause that the scope is referencing
        alId = parseInt(statement.localId) - 1
        emptyResultClauses.push({lib: libraryName, aliasLocalId: alId, expressionLocalId: aliasMap[v]})
      else if k == 'asTypeSpecifier'
        # Map the localId of the asTypeSpecifier (Code, Quantity...) to the result of the result it is referencing
        # For example, in the CQL code 'Variable.result as Code' the typeSpecifier does not produce a result, therefore
        # we will set its result to whatever the result value is for 'Variable.result'
        alId = statement.asTypeSpecifier.localId
        if alId?
          typeClauseId = parseInt(statement.asTypeSpecifier.localId) - 1
          emptyResultClauses.push({lib: libraryName, aliasLocalId: alId, expressionLocalId: typeClauseId})
      else if k == 'sort'
        # Sort is a special case that we need to recurse into separately and set the results to the result of the statement the sort clause is in
        @_findAllLocalIdsInSort(v, libraryName, localIds, aliasMap, emptyResultClauses, parentNode)
      else if k == 'let'
        # let is a special case where it is an array, one for each defined alias. These aliases work slightly different
        # and execution engine does return results for them on use. The Initial naming of them needs to be properly pointed
        # to what they are set to.
        for aLet in v
          # Add the localId for the definition of this let to it's source.
          localIds[aLet.localId] = { localId: aLet.localId, sourceLocalId: aLet.expression.localId }
          @_findAllLocalIdsInStatement(aLet.expression, libraryName, annotation, localIds, aliasMap, emptyResultClauses, statement)
      # If 'First' and 'Last' expressions, the result of source of the clause should be set to the expression
      else if k=='type' && (v =='First' || v == 'Last')
        if statement.source && statement.source.localId?
          alId = statement.source.localId
          emptyResultClauses.push({lib: libraryName, aliasLocalId: alId, expressionLocalId: statement.localId})
        # Continue to recurse into the 'First' or 'Last' expression
        @_findAllLocalIdsInStatement(v, libraryName, annotation, localIds, aliasMap, emptyResultClauses, statement)
      # If this is a FunctionRef or ExpressionRef and it references a library, find the clause for the library reference and add it.
      else if k == 'type' && (v =='FunctionRef' || v == 'ExpressionRef') && statement.libraryName?
        libraryClauseLocalId = @_findLocalIdForLibraryRef(annotation, statement.localId, statement.libraryName)
        if libraryClauseLocalId != null # only add the clause if the localId for it is found
          # the sourceLocalId is the FunctionRef itself to match how library statement references work.
          localIds[libraryClauseLocalId] = { localId: libraryClauseLocalId, sourceLocalId: statement.localId }
      # else if they key is localId push the value
      else if k == 'localId'
        localIds[v] = { localId: v }
      # if the value is an array or object, recurse
      else if (Array.isArray(v) || typeof v is 'object')
        @_findAllLocalIdsInStatement(v, libraryName, annotation, localIds, aliasMap, emptyResultClauses, statement)

    return localIds

  ###*
  # Finds all localIds in the sort structure recursively and sets the expressionLocalId to the parent statement.
  # @private
  # @param {Object} statement - The statement structure or child parts of it.
  # @param {String} libraryName - The name of the library we are looking at.
  # @param {Object} localIds - The hash of localIds we are filling.
  # @param {Object} aliasMap - The map of aliases.
  # @param {Array} emptyResultClauses - List of clauses that will have empty results from the engine. Each object on
  #    this has info on where to find the actual result.
  # @param {Object} rootStatement - The rootStatement.
  ###
  @_findAllLocalIdsInSort: (statement, libraryName, localIds, aliasMap, emptyResultClauses, rootStatement) ->
    alId = statement.localId
    emptyResultClauses.push({lib: libraryName, aliasLocalId: alId, expressionLocalId: rootStatement.localId})
    for k, v of statement
      if (Array.isArray(v) || typeof v is 'object')
        @_findAllLocalIdsInSort(v, libraryName, localIds, aliasMap, emptyResultClauses, rootStatement)

  ###*
  # Find the localId of the library reference in the JSON elm annotation. This recursively searches the annotation structure
  # for the clause of the library ref. When that is found it knows where to look inside of that for where the library
  # reference may be.
  #
  # Consider the following example of looking for function ref with id "55" and library "global".
  # CQL for this is "global.CalendarAgeInYearsAt(...)". The following annotation snippet covers the call of the
  # function.
  #
  # {
  #  "r": "55",
  #  "s": [
  #    {
  #      "r": "49",
  #      "s": [
  #        {
  #          "value": [
  #            "global"
  #          ]
  #        }
  #      ]
  #    },
  #    {
  #      "value": [
  #        "."
  #      ]
  #    },
  #    {
  #      "r": "55",
  #      "s": [
  #        {
  #          "value": [
  #            "\"CalendarAgeInYearsAt\"",
  #            "("
  #          ]
  #        },
  #
  # This method will recurse through the structure until it stops on this snippet that has "r": "55". Then it will check
  # if the value of the first child is simply an array with a single string equaling "global". If that is indeed the
  # case then it will return the "r" value of that first child, which is the clause localId for the library part of the
  # function reference. If that is not the case, it will keep recursing and may eventually return null.
  #
  # @private
  # @param {Object|Array} annotation - The annotation structure or child in the annotation structure.
  # @param {String} refLocalId - The localId of the library ref we should look for.
  # @param {String} libraryName - The library reference name, used to find the clause.
  # @return {String} The localId of the clause for the library reference or null if not found.
  ###
  @_findLocalIdForLibraryRef: (annotation, refLocalId, libraryName) ->
    # if this is an object it should have an "r" for localId and "s" for children or leaf nodes
    if Array.isArray(annotation)
      for child in annotation
        # in the case of a list of children only return if there is a non null result
        ret = @_findLocalIdForLibraryRef(child, refLocalId, libraryName)
        if ret != null
          return ret
    else if typeof annotation is 'object'
      # if we found the function ref
      if annotation.r? && annotation.r == refLocalId
        # check if the first child has the first leaf node with the library name
        # refer to the method comment for why this is done.
        if annotation.s[0].s?[0].value?[0] == libraryName
          # return the localId if there is one
          if annotation.s[0].r?
            return annotation.s[0].r
          else
            # otherwise return null because the library ref is in the same clause as extpression ref.
            # this is common with expressionRefs for some reason.
            return null

      # if we made it here, we should travserse down the child nodes
      if Array.isArray(annotation.s)
        for child in annotation.s
          # in the case of a list of children only return if there is a non null result
          ret = @_findLocalIdForLibraryRef(child, refLocalId, libraryName)
          if ret != null
            return ret
      else if typeof annotation.s is 'object'
        return @_findLocalIdForLibraryRef(annotation.s, refLocalId, libraryName)

    # if nothing above caused this to return, then we are at a leaf node and should return null
    return null

  ###*
  # Builds a statement_relevance map assuming that every single population in the population set is relevant.
  # This is used by the logic view to determine which statements are unused to bin them properly. This is effectively
  # creating a statement_relevance map that doesn't regard results at all, to be used when you don't have a result.
  # @public
  # @param {cqmMeasure} measure - The measure.
  # @param {Population} populationSet - The populationSet we wish to get statement relevance for.
  # @return {object} Statement relevance map for the population set.
  ###
  @getStatementRelevanceForPopulationSet: (cqmMeasure, populationSet) ->
    # create a population relevance map where every population is true.
    populationRelevance = {}
    for popCode in Thorax.Models.Measure.allPopulationCodes
      if popCode == 'OBSERV'
        populationRelevance['values'] = true

      if populationSet.get('populations')[popCode]
        populationRelevance[popCode] = true

    # builds and returns this statement relevance map.
    return CQLResultsHelpers.buildStatementRelevanceMap(populationRelevance, cqmMeasure, populationSet)

  ###*
  # Figure out if a statement is a function given the measure, library name and statement name.
  # @public
  # @param {string} library - The name of the library the statement belongs to.
  # @param {string} statementName - The statement name to search for.
  # @return {boolean} If the statement is a function or not.
  ###
  @isStatementFunction: (library, statementName) ->
    # find the library and statement in the elm.
    statement = null
    for curStatement in library.elm.library.statements.def
      if curStatement.name == statementName
        statement = curStatement

    if library? && statement?
      return statement.type == "FunctionDef"
    else
      return false

  ###*
  # Figure out if a statement is in a Supplemental Data Element given the statement name.
  # @public
  # @param {array} supplementalDataElements - The Supplemental Data Elements
  # @param {string} statementDefine - The statement define to search for.
  # @return {boolean} Statement does or does not belong to a Supplemental Data Element.
  ###
  @isSupplementalDataElementStatement: (supplementalDataElements, statementDefine) ->
    return Array.isArray(supplementalDataElements) && (supplementalDataElements?.filter (d) -> d.statement_name is statementDefine).length > 0

  ###*
  # Format stratifications as population sets to be added to the measure's population sets
  # @param {object} popSets - The populationSets.
  ###
  @getStratificationsAsPopulationSets: (popSets) ->
    stratificationsAsPopulationSets = []
    for populationSet in popSets.toObject()
      if (populationSet.stratifications)
        for stratification in populationSet.stratifications
          clonedSet = @deepCopyPopulationSet(populationSet)
          clonedSet.population_set_id = stratification.stratification_id
          clonedSet.populations.STRAT = stratification.statement
          clonedSet.title = stratification.title
          stratificationsAsPopulationSets.push clonedSet
    return stratificationsAsPopulationSets

  ###*
  # Returns a copy of the given population set
  # @public {original} populationSet - The population set to be copied
  ###
  @deepCopyPopulationSet: (original) ->
    copy = {}
    copy.title = original.title
    copy.observations = original.observations
    copy.populations = {}
    for popCode of original.populations
      copyPop = {}
      copyPop.library_name = original.populations[popCode].library_name
      copyPop.statement_name = original.populations[popCode].statement_name
      copy.populations[popCode] = copyPop
    return copy
