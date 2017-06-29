class Thorax.Model.Coverage extends Thorax.Model
  initialize: (attrs, options) ->
    @population = options.population
    @differences = @population.differencesFromExpected()
    @measureCriteria = @population.dataCriteriaKeys()
    @clauseResults = []
    for difference in @differences.models
      patient_id = difference.result.get('patient_id')
      clauseResult = difference.result.get('localIdPatientResultsMap')[patient_id]
      @clauseResults.push(clauseResult)
    @listenTo @differences, 'change add reset destroy remove', @update
    @update()

  update: ->
    if @population.measure().get('cql')
      # Coverage is 0 if there are no patients
      if @clauseResults.length == 0
        @set coverage: 0
      else
        all_clauses = {}
        total_clauses = 0
        passed_clauses = 0
        # Initialize all_clauses list to all false and count number of clauses
        for local_id of @clauseResults[0]
          if !@ignoreClause(@clauseResults[0][local_id])
            total_clauses += 1
            all_clauses[local_id] = false
        # Iterate over each patients map of clauses
        for clauseResult in @clauseResults
          # If there is a datacriteria mapped to the localId of the clause
          for local_id of clauseResult
            # Do not set values for clauses that were ignored
            if all_clauses[local_id]?
              all_clauses[local_id] = (all_clauses[local_id] || clauseResult[local_id].length > 0)
        # Count total number of clauses that evalueated to true
        for local_id of all_clauses
          if all_clauses[local_id]
            passed_clauses += 1
        # Set coverage to the ratio of evaluated clauses to total clauses   
        @set coverage: ( passed_clauses * 100 / total_clauses ).toFixed()
    else
      # Find all unique criteria that evaluated true in the rationale that are also in the measure
      @rationaleCriteria = []
      @differences.each (difference) => if difference.get('done')
        result = difference.result
        rationale = result.get('rationale')
        @rationaleCriteria.push(criteria) for criteria, result of rationale when result
      @rationaleCriteria = _(@rationaleCriteria).intersection(@measureCriteria)

      # Set coverage to the fraction of measure criteria that were true in the rationale
      @set coverage: ( @rationaleCriteria.length * 100 / @measureCriteria.length ).toFixed()

  ignoreClause: (clause) ->
    # Ignore value set clauses
    if clause.constructor.name? && clause.constructor.name == "ValueSet"
      return true
    # Ignore the supplemental data elements included by the MAT
    if clause["name"] && clause["name"].startsWith("SDE ")
      return true
    return false
