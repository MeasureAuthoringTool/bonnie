class Thorax.Views.MeasureLogic extends Thorax.View
  
  template: JST['logic/logic']
  
  initialize: ->
    @submeasurePopulations = []
    populationMap = @population.toJSON()
    population_criteria = @model.get('population_criteria')
    for population_code in Thorax.Models.Measure.allPopulationCodes
      match = population_criteria[populationMap[population_code]]
      @submeasurePopulations.push(match) if match

  showRationale: (result) ->
    rationale = result.get('rationale')
    @clearRationale()
    # rationale only handles the logical true/false values
    # we need to go in and modify the highlighting based on the final specific contexts for each population
    updatedRationale = @fixSpecificsRationale(result, @model)
    for code in Thorax.Models.Measure.allPopulationCodes
      if (rationale[code]?)
        for key, value of rationale
          target = @$(".#{code}_children .#{key}")
          if (target.length > 0)
            evalClass = if value then 'true_eval' else 'false_eval'
            evalClass = 'bad_specifics' if updatedRationale[code][key] == false
            target.addClass(evalClass)

  fixSpecificsRationale: (result, measure) ->
    updatedRationale = {}
    rationale = result.get('rationale')
    orCounts = @calculateOrCounts(rationale)
    for code in Thorax.Models.Measure.allPopulationCodes
      if result.get('finalSpecifics') && result.get('finalSpecifics')[code]
        updatedRationale[code] ||= {}
        specifics = result.get('finalSpecifics')[code]
        # get the referenced occurrences in the logic tree
        occurrences = @getOccurrences(measure.get('population_criteria')[code])
        # get the good and bad specifics
        occurrenceResults = @checkSpecificsForRationale(specifics, occurrences, @model.get('data_criteria'))
        parentMap = @buildParentMap(@model.get('population_criteria')[code])

        # check each bad occurrence and remove highlights marking true
        for badOccurrence in occurrenceResults.bad
          if (rationale[badOccurrence])
            updatedRationale[code][badOccurrence] = false
            # move up the logic tree to set AND/ORs to false based on the removal of the bad specific's true eval
            @updateLogicTree2(updatedRationale, code, badOccurrence, orCounts, parentMap)
        # check the good specifics with a negated parent.  If there are multiple candidate specifics
        # and one is good while the other is bad, the child of the negation will evaluate to true, we want it to
        # evaluate to false since if there's a good negation then there's an occurrence for which it evaluated to false
        for goodOccurrence in occurrenceResults.good
          @updatedNegatedGood(updatedRationale[code], rationale, goodOccurrence, parentMap)
    return updatedRationale
  
  updatedNegatedGood: (updatedRationale, rationale, goodOccurrence, parentMap) ->
    parent = parentMap[goodOccurrence]
    while parent
      if (parent.negation && rationale[goodOccurrence])
        updatedRationale[goodOccurrence] = false 
        return
      parent = parentMap["precondition_#{parent.id}"]

  getOccurrences: (child) ->
    occurrences = []
    return occurrences unless child
    if (child.preconditions && child.preconditions.length > 0)
      for precondition in child.preconditions
        occurrences = occurrences.concat @getOccurrences(precondition)
    else if (child.reference)
      occurrences = occurrences.concat @getOccurrences(@model.get('data_criteria')[child.reference])
    else
      if (child.type == 'derived' && child.children_criteria)
        for dataCriteriaKey in child.children_criteria
          dataCriteria = @model.get('data_criteria')[dataCriteriaKey]
          occurrences = occurrences.concat @getOccurrences(dataCriteria)
      else
        if (child.specific_occurrence)
          occurrences.push(child.key)
    return occurrences
      
  # get good and bad specific occurrences referenced in this part of the measure
  checkSpecificsForRationale: (finalSpecifics, occurrences, dataCriteriaMap) ->
    results = {bad: occurrences, good: []}
    # if we dont't have any specifics rows then they are all bad
    return results if (finalSpecifics.length) == 0
    results.bad = []
    # check for good and bad specifics.  Bad will be used to clear out logical true values that are false
    # when specifics are applied.  Good will be used to fix negations of specific occurrences
    for occurrence in occurrences
      index = hqmf.SpecificsManager.indexLookup[dataCriteriaMap[occurrence].source_data_criteria]
      good = false
      # we're good if the occurrence is referenced by ID, Any indicates that we did not use it in the true path, thus it's bad
      for row in finalSpecifics
        good = true if row[index] != hqmf.SpecificsManager.any
      if good then results.good.push(occurrence) else results.bad.push(occurrence)
    results

  # from each leaf walk up the tree updating the logical statements appropriately to false
  updateLogicTree2: (updatedRationale, code, badOccurrence, orCounts, parentMap) ->
    parent = parentMap[badOccurrence]
    while parent
      parentKey = if parent.id? then "precondition_#{parent.id}" else parent.type
      negated = parent.negation
      parent = null
      if (updatedRationale[code][parentKey] != false && !negated)
        # if this is an OR then remove a true increment since it's a bad true
        if orCounts[parentKey]?
          orCounts[parentKey] = orCounts[parentKey] - 1
        # if we're either an AND or we're an OR and the count is zero then switch to false and move up the tree
        if (!orCounts[parentKey]? || orCounts[parentKey] == 0)
          updatedRationale[code][parentKey] = false
          parent = parentMap[parentKey]

  buildParentMap: (root) ->
    parentMap = {}
    return parentMap unless root
    if (root.preconditions && root.preconditions.length > 0)
      for precondition in root.preconditions
        parentMap["precondition_#{precondition.id}"] = root
        _.extend(parentMap, @buildParentMap(precondition))
      parentMap
    else
      parentMap[root.reference] = root
      parentMap

  # Or counts are used to know when to turn an OR from green to red.  Once we negate all the true ors, we can switch to red
  calculateOrCounts: (rationale) ->
    orCounts = {}
    for code in Thorax.Models.Measure.allPopulationCodes
      population_criteria = @model.get('population_criteria')[@population.get(code)]
      if (population_criteria?)
        _.extend(orCounts, @calculateOrCountsRecursive(rationale, population_criteria.preconditions))
    orCounts

  # recursively walk preconditions to count true values for child ORs moving down the tree
  calculateOrCountsRecursive: (rationale, preconditions) ->
    orCounts = {}
    return orCounts unless preconditions? && preconditions.length > 0
    for precondition in preconditions
      if (precondition.conjunction_code == 'atLeastOneTrue' && !precondition.negation)
        trueCount = 0
        for child in precondition.preconditions
          if (child.preconditions)
            key = "precondition_#{child.id}"
          else
            key = child.reference
          trueCount += 1 if rationale[key]
        orCounts["precondition_#{precondition.id}"] = trueCount
      _.extend(orCounts, @calculateOrCountsRecursive(rationale, precondition.preconditions))
    return orCounts

  clearRationale: ->
    $('.rationale .rationale_target').removeClass('false_eval true_eval bad_specifics')

