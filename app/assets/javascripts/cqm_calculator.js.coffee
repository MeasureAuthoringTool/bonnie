###*
# The adapter for starting the CQM execution engine.
###
@CQMCalculator = class CQMCalculator extends Calculator

  calculate: (population, patient, options = {}) ->
    measure = population.collection.parent
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
    if !patient.has('cqmPatient')
      result.state = 'cancelled'
      console.log "No CQM patient for #{patient.get('_id')} - #{patient.get('first')} #{patient.get('last')}"
      return result

    if !measure.has('cqmMeasure')
      result.state = 'cancelled'
      console.log "No CQM measure for #{measure.get('cms_id')}"
      return result

    cqmMeasure = measure.get('cqmMeasure')
    cqmValueSets = measure.valueSets()
    cqmPatient = patient.get('cqmPatient')

    # attempt calcuation
    try
      cqmResults = cqm.execution.Calculator.calculate(cqmMeasure, [cqmPatient], cqmValueSets, { doPretty: true, includeClauseResults: true })
      patientResults = cqmResults[patient.id]

      measure.get('populations').forEach((measure_population) =>
        if measure_population.has('stratification')
          populationSetId = cqmMeasure.population_sets[measure_population.get('population_index')].stratifications[measure_population.get('stratification_index')].stratification_id
        else
          populationSetId = cqmMeasure.population_sets.find((pop_set) -> pop_set.title == measure_population.get('title')).population_set_id
        populationSetResults = patientResults[populationSetId]

        # if this population is requested update the object
        if measure_population == population
          result.set(populationSetResults.toObject())
          result.state = 'complete'
        # otherwise create result and put it on the cache
        else
          otherPopCacheKey = @cacheKey(measure_population, patient)
          otherPopResult = @resultsCache[otherPopCacheKey] ?= new Thorax.Models.Result({}, population: measure_population, patient: patient)
          otherPopResult.set(populationSetResults.toObject())
          otherPopResult.state = 'complete'

        console.log "finished calculation of #{cqmMeasure.cms_id} - #{patient.get('first')} #{patient.get('last')}"
      )
    catch error
      console.log error
      result.state = 'cancelled'
    return result

  calculateAll: (measure, patients, options = {}) ->
    foundIncompleteResults = false
    results = []
    resultsNeedingCalc = []

    # Build result objects for everything in the measure
    patients.forEach((patient) =>
      patientNeedsCalc = false
      measure.get('populations').forEach((population) =>
        # We store both the calculation result and the calcuation code based on keys derived from the arguments
        cacheKey = @cacheKey(population, patient)
        # We only ever generate a single result for a population / patient pair; if we've ever generated a
        # result for this pair, we use that result and return it, starting its calculation if needed
        result = @resultsCache[cacheKey] ?= new Thorax.Models.Result({}, population: population, patient: patient)
        results.push result

        # If the result is marked as 'cancelled', that means a cancellation has been requested but not yet handled in
        # the deferred calculation code; however, since we're here, that means a new calculation has been requested
        # subsequent to the cancellation; just change the state back to 'pending' to reflected our updated desire, and
        # the still pending deferred calculation will do the correct thing
        result.state = 'pending' if result.state == 'cancelled'

        # If the result already finished calculating, or is in-process with a pending calculation, we can just return it
        if result.state == 'complete'
          return

        # Since we're going to start a calculation for this one, set the state to 'pending'
        result.state = 'pending'
        foundIncompleteResults = true

        if !patient.has('cqmPatient')
          result.state = 'cancelled'
          console.log "No CQM patient for #{patient.get('_id')} - #{patient.get('first')} #{patient.get('last')}"
        else
          patientNeedsCalc = true
          resultsNeedingCalc.push result
      ) # end populations iteration
    ) # end patient iteration

    # leave if everything is calculated
    if !foundIncompleteResults
      console.log "No recalculation needed for #{measure.get('cms_id')}"
      return results

    if !measure.has('cqmMeasure')
      results.forEach((result) -> result.state = 'cancelled')
      console.log "No CQM measure for #{measure.get('cms_id')}"
      return results

    cqmMeasure = measure.get('cqmMeasure')
    cqmValueSets = measure.valueSets()
    cqmPatients = resultsNeedingCalc.map (result) -> result.patient.get('cqmPatient')

    # attempt calcuation
    try
      cqmResults = cqm.execution.Calculator.calculate(cqmMeasure, cqmPatients, cqmValueSets, { doPretty: true, includeClauseResults: true })
      # Fill result objects for everything in the measure
      resultsNeedingCalc.forEach((result) =>
        patient = result.patient
        population = result.population
        patientResults = cqmResults[patient.id]

        if population.has('stratification')
          populationSetId = cqmMeasure.population_sets[population.get('population_index')].stratifications[population.get('stratification_index')].stratification_id
        else
          populationSetId = cqmMeasure.population_sets.find((pop_set) -> pop_set.title == population.get('title')).population_set_id
        populationSetResults = patientResults[populationSetId]

        result.set(populationSetResults.toObject())
        result.state = 'complete'

        console.log "finished calculation of #{cqmMeasure.cms_id} - #{patient.get('first')} #{patient.get('last')}"
      )
      console.log "finished BATCH calculation of #{cqmMeasure.cms_id}"
    catch error
      console.log error
      results.forEach((result) -> result.state = 'cancelled')

    return results
