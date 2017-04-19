@Calculator = class Calculator

  constructor: ->
    @calculator = {}
    @calculatorLoaded = {}
    @resultsCache = {}

  # Key for storing calculators on a population
  calculationKey: (population) -> "#{population.measure().id}/#{population.get('index')}"

  # Key for storing results for a patient / population calculation; we use the CID for the patient portion
  # of the key so that clones can have different calculation results
  cacheKey: (population, patient) -> "#{@calculationKey(population)}/#{patient.cid}"

  # Utility function for setting the calculator function for a population, used in the calculator loading JS
  setCalculator: (population, calcFunction) -> @calculator[@calculationKey(population)] = calcFunction

  # Cancel all pending calculations; this just marks the result as 'cancelled', the actual stopping of the calculation is
  # handled in the deferred calculation code
  cancelCalculations: ->
    result.state = 'cancelled' for key, result of @resultsCache when result.state == 'pending'

  # Generate a calculation result for a population / patient pair; this always returns a result immediately,
  # but may return a blank result object that later gets filled in through a deferred calculation, so views
  # that display results must be able to handle a state of "not yet calculated"
  calculate: (population, patient) ->

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

    # save patient id as a backbone attribute
    result.set({patient_id: patient.id})

    # If the result already finished calculating, or is in-process with a pending calculation, we can just return it
    return result if result.state == 'complete' || result.state == 'pending'

    # If the result is already present on the patient we will use that.
    if patient.getCalculatedResultsValues(population)
      result.set(patient.getCalculatedResultsValues(population))
      result.state = 'complete'
      return result

    # Since we're going to start a calculation for this one, set the state to 'pending'
    result.state = 'pending'

    # Load the calculator code if not already loaded
    @calculatorLoaded[calcKey] ?= $.ajax(url: "#{population.url()}/calculate_code.js", dataType: "script", cache: true)

    # Once the calculation code is loaded, we can call it
    @calculatorLoaded[calcKey].done =>
      # Create a deferred calculation that can be canceled
      deferredCalculation = =>
        # If this calculation has been cancelled, move the state back to unstarted and don't process it
        if result.state == 'cancelled'
          result.state = 'unstarted'
          return
        result.state = 'complete'
        # Capture calculation errors that may arise and handle them using Costanza
        Costanza.run 'measure-calculation', {cms_id: result.measure.get('cms_id')}, () =>
          result.set @calculator[calcKey](patient.toJSON())

      setTimeout deferredCalculation, 0

    return result

  clearResult: (population, patient) ->
    delete @resultsCache[@cacheKey(population, patient)]
