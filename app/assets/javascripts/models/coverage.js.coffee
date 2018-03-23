class Thorax.Model.Coverage extends Thorax.Model
  initialize: (attrs, options) ->
    @population = options.population
    @differences = @population.differencesFromExpected()
    @measureCriteria = @population.dataCriteriaKeys()

    @listenTo @differences, 'change add reset destroy remove', @update
    @update()

  update: ->
    # get the latest set of clause_results
    @clauseResults = @differences.map (difference) -> difference.result.get('clause_results')

    # Coverage is 0 if there are no patients
    if @clauseResults.length == 0
      @set coverage: 0
    else
      allClauses = {}
      @rationaleCriteria = {}
      totalClauses = 0
      passedClauses = 0
      for patientResults in @clauseResults
        for libraryName, library of patientResults 
          for localId, clauseResult of library
            if !@ignoreClause(clauseResult)
              key = libraryName.concat('_',localId)
              # Initialize allClauses list to all false and count number of clauses
              if !allClauses[key]?
                totalClauses += 1
                allClauses[key] = false
              allClauses[key] = allClauses[key] || @determineCovered(clauseResult)
              # Build rationaleCriteria structure for coverage highlighting
              if allClauses[key]
                if !@rationaleCriteria[libraryName]?
                  @rationaleCriteria[libraryName] = []
                @rationaleCriteria[libraryName][localId] = clauseResult
              
      # Count total number of clauses that evalueated to true
      for localId of allClauses
        if allClauses[localId]
          passedClauses += 1
      # Set coverage to the percentage of evaluated clauses to total clauses   
      @set coverage: Math.floor( passedClauses * 100 / totalClauses )

  determineCovered: (clause) ->
    if clause.final == "TRUE"
      return true
    else
      return false

  ignoreClause: (clause) ->
    # Ignore value set clauses
    if clause.raw? && clause.raw.name? && clause.raw.name == "ValueSet"
      return true    
    # Ignore clauses that were not used in logic, for example unused defines from an included library
    if clause.final == "NA"
      return true      
    return false
