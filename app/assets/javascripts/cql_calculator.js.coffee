@CQLCalculator = class CQLCalculator

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

    # If the result already finished calculating, or is in-process with a pending calculation, we can just return it
    return result if result.state == 'complete' || result.state == 'pending'

    # Since we're going to start a calculation for this one, set the state to 'pending'
    result.state = 'pending'


    #TODO Find a better way to check if patient should be calculated
    return result if !patient.has('birthdate')

    #try #TODO Add this back in

    patientSource = new PatientSource([patient])
    params = {"Measurement Period": new cql.Interval(cql.DateTime.fromDate(moment(population.collection.parent.get('measure_period').low.value, 'YYYYMDDHHmm').toDate()), cql.DateTime.fromDate(moment(population.collection.parent.get('measure_period').high.value, 'YYYYMDDHHmm').toDate()) ) }
    results = executeSimpleELM(population.collection.parent.get('elm'), patientSource, @valueSetsForCodeService(), params)
    # Loop over all populations code TODO
    # Look for keys using populated codes
    # Grab the values from patientResult
    population_values = {}
    for popCode in Thorax.Models.Measure.allPopulationCodes # EX: IPP
      if population.collection.parent.get('populations_map')[popCode]
        cql_code = population.collection.parent.get('populations_map')[popCode] # EX: Initial Pop
        value = results['patientResults'][patient.id][cql_code]
        if typeof value is 'object' and value.length > 0
          population_values[popCode] = 1
        else if typeof value is 'boolean' and value
          population_values[popCode] = 1
        else
          population_values[popCode] = 0

    result.set population_values
    result.state = 'complete'
  #  catch error
  #    bonnie.showError({title: "Measure Calculation Error", summary: "There was an error calculating the measure #{result.measure.get('cms_id')}.", body: "One of the data elements associated with the measure is causing an issue.  Please review the elements associated with the measure to verify that they are all constructed properly.  Error message: #{error.message}."})

    return result

  clearResult: (population, patient) ->
    delete @resultsCache[@cacheKey(population, patient)]

  # Format ValueSets for use by CQL4Browsers
  valueSetsForCodeService: ->
    valueSetsForCodeService = {}
    for oid, vs of bonnie.valueSetsByOid
      continue unless vs.concepts
      valueSetsForCodeService[oid] ||= {}
      valueSetsForCodeService[oid][vs.version] ||= []
      for concept in vs.concepts
        valueSetsForCodeService[oid][vs.version].push code: concept.code, system: concept.code_system_name, version: vs.version
    valueSetsForCodeService
