class Thorax.Views.MeasureCalculation extends Thorax.View
  template: JST['measure_calculation']
  events:
    'click button.toggle-patient': 'patientClick'
    'click button.select-all':     'selectAll'
    'click button.select-none':    'selectNone'
  initialize: ->
    @results = new Thorax.Collection()
    # FIXME: It would be nice to have the counts update dynamically without re-rendering the whole table
    @results.on 'add remove', @render, this
    @population = @model.get('populations').at(@populationIndex)
  context: ->
    _(super).extend
      IPPTotal: @results.where(IPP: 1).length
      DENOMTotal: @results.where(DENOM: 1).length
      NUMERTotal: @results.where(NUMER: 1).length
      DENEXTotal: @results.where(DENEX: 1).length
      DENEXCEPTotal: @results.where(DENEXCEP: 1).length
  patientClick: (e) ->
    patient = $(e.target).model()
    if result = @results.findWhere(patient_id: patient.id)
      @results.remove result
      @clearRationale()
    else
      @results.add @population.calculate(patient)
      @showRationale(@results.findWhere(patient_id: patient.id))


  selectAll: ->
    # FIXME: This isn't cached in any way now (still reasonably fast!)
    @allPatients.each (p) => @results.add @population.calculate(p) unless @results.findWhere(patient_id: p.id)
    @$('button.toggle-patient').addClass('active')
  selectNone: ->
    @results.set() # FIXME: Instead of reset() so we get individual adds and removes
    @$('button.toggle-patient').removeClass('active')

  showRationale: (result) ->
    rationale = result.get('rationale')
    @clearRationale()
    for code in Thorax.Models.Measure.allPopulationCodes
      if (rationale[code]?)
        for key, value of rationale
          target = $(".#{code}_children .#{key}")
          if (target.length > 0)
            evalClass = if value then 'true_eval' else 'false_eval'
            target.addClass(evalClass)
    # rationale only handles the logical true/false values
    # we need to go in and modify the highlighting based on the final specific contexts for each population
    @handleSpecificsRationale(result)

  # fix rationale coloring based on the specific occurrence results
  handleSpecificsRationale: (result) ->
    rationale = result.get('rationale')
    orCounts = @calculateOrCounts(rationale)
    for code in Thorax.Models.Measure.allPopulationCodes
      if result.get('finalSpecifics') && result.get('finalSpecifics')[code]
        specifics = result.get('finalSpecifics')[code]
        # get the referenced occurrences in the logic tree
        occurrences = $(".#{code}_children .rationale_target[data-specificoccurrence]").map(-> $(this).data('specificoccurrence'))
        # get the good and bad specifics
        occurrenceResults = @checkSpecificsForRationale(specifics, occurrences, @model.get('data_criteria'))
        # check each bad occurrence and remove highlights marking true
        for badOccurrence in occurrenceResults.bad
          target = $(".rationale .#{badOccurrence}.true_eval")
          if (target.length > 0)
            target.removeClass('true_eval')
            target.addClass('bad_specifics')
            # move up the logic tree to set AND/ORs to false based on the removal of the bad specific's true eval
            @updateLogicTree(code, target, orCounts)
        # check the good specifics with a negated parent.  If there are multiple candidate specifics
        # and one is good while the other is bad, the child of the negation will evaluate to true, we want it to
        # evaluate to false since if there's a good negation then there's an occurrence for which it evaluated to false
        for goodOccurrence in occurrenceResults.good
          target = $(".rationale .#{goodOccurrence}.true_eval.negated_parent")
          if (target.length > 0)
            target.removeClass('true_eval')
            target.addClass('bad_specifics')

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
      if good
        results.good.push(occurrence)
      else
        results.bad.push(occurrence)
    results

  # from each leaf walk up the tree updating the logical statements appropriately to false
  updateLogicTree: (code, leaves, orCounts) ->
    for leaf in leaves
      newTargetKey = $(leaf).data('parentkey')
      hasParent = newTargetKey?
      while hasParent
        hasParent = false
        newTarget = $(".#{code}_children .#{newTargetKey}")
        if (!newTarget.hasClass('bad_specifics') && !newTarget.data('negation'))
          # if this is an OR then remove a true increment since it's a bad true
          if orCounts[newTargetKey]?
            orCounts[newTargetKey] = orCounts[newTargetKey] - 1
          # if we're either an AND or we're an OR and the count is zero then switch to false and move up the tree
          if (!orCounts[newTargetKey]? || orCounts[newTargetKey] == 0)
            newTarget.removeClass('true_eval')
            newTarget.addClass('bad_specifics')
            newTargetKey = $(newTarget).data('parentkey')
            hasParent = newTargetKey?

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

