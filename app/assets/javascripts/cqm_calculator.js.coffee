###*
# The adapter for starting the CQM execution engine.
###
@CQMCalculator = class CQMCalculator extends Calculator

  calculate: (population, patient, options = {}) ->
    measure = population.collection.parent
    # Set Default Options
    options.doPretty = true # force doPretty to true
    # We store both the calculation result and the calcuation code based on keys derived from the arguments
    cacheKey = @cacheKey(population, patient, options)
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

    cqmMeasure = measure.get('cqmMeasure')
    cqmValueSets = measure.valueSets()
    cqmPatient = patient.get('cqmPatient')

    # attempt calcuation
    try
      cqmResults = cqm.execution.Calculator.calculate(cqmMeasure, [cqmPatient.qdmPatient], cqmValueSets, { doPretty: options.doPretty, includeClauseResults: true, requestDocument: false })
      patientResults = cqmResults[patient.get('cqmPatient').qdmPatient._id.toString()]

      measure.get('populations').forEach((measure_population) =>
        populationSetId = measure_population.get('population_set_id')
        populationSetResults = patientResults[populationSetId]
        if !populationSetResults.observation_values
          populationSetResults.observation_values = []

        # if this population is requested update the object
        if measure_population == population
          result.set(populationSetResults)
          result.state = 'complete'
        # otherwise create result and put it on the cache
        else
          otherPopCacheKey = @cacheKey(measure_population, patient, options)
          otherPopResult = @resultsCache[otherPopCacheKey] ?= new Thorax.Models.Result({}, population: measure_population, patient: patient)
          otherPopResult.set(populationSetResults)
          otherPopResult.state = 'complete'

        console.log "finished calculation of #{cqmMeasure.cms_id} - #{patient.getFirstName()} #{patient.getLastName()}"
      )
    catch error
      console.log(error)
      @clearResult(population, patient, options)
      result = new Thorax.Models.Result({}, population: population, patient: patient)
      bonnie.showError({
        title: 'Measure Calculation Error',
        summary: "There was an error calculating measure #{measure.get('cqmMeasure').cms_id}.",
        body: "One of the data elements associated with the measure is causing an issue. Please review the elements associated with the measure to verify that they are all constructed properly.<br>Error message: <b>#{error.message}</b>"
      })
    return result

  calculateAll: (measure, patients, options = {}) ->
    foundIncompleteResults = false
    results = []
    resultsNeedingCalc = []
    # Set Default Options
    options.doPretty = true # force doPretty to true
    # Build result objects for everything in the measure
    patients.forEach((patient) =>
      measure.get('populations').forEach((population) =>
        # We store both the calculation result and the calcuation code based on keys derived from the arguments
        cacheKey = @cacheKey(population, patient, options)
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
          console.log "No CQM patient for #{patient.id} - #{patient.getFirstName()} #{patient.getLastName()}"
        else
          resultsNeedingCalc.push result
      ) # end populations iteration
    ) # end patient iteration

    # leave if everything is calculated
    if !foundIncompleteResults
      console.log "No recalculation needed for #{measure.get('cqmMeasure').cms_id}"
      return results

    if !measure.has('cqmMeasure')
      results.forEach((result) -> result.state = 'cancelled')
      console.log "No CQM measure for #{measure.get('cqmMeasure')}"
      return results

    cqmMeasure = measure.get('cqmMeasure')
    cqmValueSets = measure.valueSets()
    qdmPatients = resultsNeedingCalc.map (result) -> result.patient.get('cqmPatient').qdmPatient

    # attempt calcuation
    try
      cqmResults = cqm.execution.Calculator.calculate(cqmMeasure, qdmPatients, cqmValueSets, { doPretty: options.doPretty, includeClauseResults: true, requestDocument: false })
      # Fill result objects for everything in the measure
      resultsNeedingCalc.forEach((result) =>
        patient = result.patient
        population = result.population
        patientResults = cqmResults[patient.get('cqmPatient').qdmPatient._id.toString()]

        populationSetId = population.get('population_set_id')
        populationSetResults = patientResults[populationSetId]

        if !populationSetResults.observation_values
          populationSetResults.observation_values = []

        result.set(populationSetResults)
        result.state = 'complete'

        console.log "finished calculation of #{cqmMeasure.cms_id} - #{patient.getFirstName()} #{patient.getLastName()}"
      )
      console.log "finished BATCH calculation of #{cqmMeasure.cms_id}"
    catch error
      console.log(error)
      bonnie.showError({
        title: 'Measure Calculation Error',
        summary: "There was an error calculating measure #{measure.get('cqmMeasure').cms_id}.",
        body: "One of the data elements associated with the measure is causing an issue. Please review the elements associated with the measure to verify that they are all constructed properly.<br>Error message: <b>#{error.message}</b>"
      })

    return results
