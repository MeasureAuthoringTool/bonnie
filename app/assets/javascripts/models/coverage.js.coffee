class Thorax.Model.Coverage extends Thorax.Model
  initialize: (attrs, options) ->
    @population = options.population
    @differences = @population.differencesFromExpected()
    @measureCriteria = @population.dataCriteriaKeys()
    @clauseResults = []
    for difference in @differences.models
      clauseResult = difference.result.get('clause_results')
      @clauseResults.push(clauseResult)
      
    @listenTo @differences, 'change add reset destroy remove', @update
    @update()

  update: ->
    if @population.measure().get('cql')
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
    else
      # Find all unique criteria that evaluated true in the rationale that are also in the measure
      @rationaleCriteria = []
      @differences.each (difference) => if difference.get('done')
        result = difference.result
        rationale = result.get('rationale')
        @rationaleCriteria.push(criteria) for criteria, result of rationale when result
      @rationaleCriteria = _(@rationaleCriteria).intersection(@measureCriteria)

      # Set coverage to the fraction of measure criteria that were true in the rationale
      @set coverage: Math.floor( @rationaleCriteria.length * 100 / @measureCriteria.length )

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
