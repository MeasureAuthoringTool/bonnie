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
    for lib of measure.get("elm_annotations")
      lib_statements = {}
      for statement in measure.get("elm_annotations")[lib].statements
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
  @findAllLocalIdsInStatementByName: (measure, libraryName, statementName) ->
    # create place for aliases and their usages to be placed to be filled in later. Aliases and their usages (aka scope)
    # and returns do not have localIds in the elm but do in elm_annotations at a consistent calculable offset.
    # BE WEARY of this calaculable offset.
    emptyResultClauses = []

    # find the library and statement in the elm.
    library = null
    statement = null
    for lib in measure.get('elm')
      if lib.library.identifier.id == libraryName
        library = lib
    for curStatement in library.library.statements.def
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
      # If this is a FunctionRef and it references a library, find the clause for the library reference and add it.
      else if k == 'type' && v =='FunctionRef' && statement.libraryName?
        libraryClauseLocalId = @_findLocalIdForLibraryFunctionRef(annotation, statement.localId, statement.libraryName)
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
  # Find the localId of the function call in the JSON elm annotation.
  # @private
  # @param {Object|Array} annotation - The annotation structure or child in the annotation structure.
  # @param {String} functionRefLocalId - The localId of the library function ref we should look for.
  # @param {String} libraryName - The library reference name, used to find the clause.
  # @return {String} The localId of the clause for the library reference or null if not found.
  ###
  @_findLocalIdForLibraryFunctionRef: (annotation, functionRefLocalId, libraryName) ->
    # if this is an object it should have an "r" for localId and "s" for children or leaf nodes
    if Array.isArray(annotation)
      for child in annotation
        # in the case of a list of children only return if there is a non null result
        ret = @_findLocalIdForLibraryFunctionRef(child, functionRefLocalId, libraryName)
        if ret != null
          return ret
    else if typeof annotation is 'object'
      # if we found the function ref
      if annotation.r? && annotation.r == functionRefLocalId
        # check if the first child has the first leaf node with the library name
        if annotation.s[0].s?[0].value[0] == libraryName
          # return that ID now.
          return annotation.s[0].r

      # if we made it here, we should travserse down the child nodes
      if Array.isArray(annotation.s)
        for child in annotation.s
          # in the case of a list of children only return if there is a non null result
          ret = @_findLocalIdForLibraryFunctionRef(child, functionRefLocalId, libraryName)
          if ret != null
            return ret
      else if typeof annotation.s is 'object'
        return @_findLocalIdForLibraryFunctionRef(annotation.s, functionRefLocalId, libraryName)

    # if nothing above caused this to return, then we are at a leaf node and should return null
    return null

  ###*
  # Builds a statement_relevance map assuming that every single population in the population set is relevant.
  # This is used by the logic view to determine which statements are unused to bin them properly. This is effectively
  # creating a statement_relevance map that doesn't regard results at all, to be used when you don't have a result.
  # @public
  # @param {Measure} measure - The measure.
  # @param {Population} populationSet - The populationSet we wish to get statement relevance for.
  # @return {object} Statement relevance map for the population set.
  ###
  @getStatementRelevanceForPopulationSet: (measure, populationSet) ->
    # create a population relevance map where every population is true.
    populationRelevance = {}
    for popCode in Thorax.Models.Measure.allPopulationCodes
      if populationSet.has(popCode)
        if popCode == 'OBSERV'
          populationRelevance['values'] = true
        else
          populationRelevance[popCode] = true

    # builds and returns this statement relevance map.
    return CQLResultsHelpers.buildStatementRelevanceMap(populationRelevance, measure, populationSet)

  ###*
  # Figure out if a statement is a function given the measure, library name and statement name.
  # @public
  # @param {Measure} measure - The measure to find localIds in.
  # @param {string} libraryName - The name of the library the statement belongs to.
  # @param {string} statementName - The statement name to search for.
  # @return {boolean} If the statement is a function or not.
  ###
  @isStatementFunction: (measure, libraryName, statementName) ->
    # find the library and statement in the elm.
    library = null
    statement = null
    for lib in measure.get('elm')
      if lib.library.identifier.id == libraryName
        library = lib
    for curStatement in library.library.statements.def
      if curStatement.name == statementName
        statement = curStatement

    if library? && statement?
      return statement.type == "FunctionDef"
    else
      return false
