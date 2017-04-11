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

  # Returns a JSON function to add to the ELM before ELM JSON is used to calculate results
  generateELMJSONFunction: (functionName, parameter) ->
    elmFunction = 
        name: 'BonnieFunction' + functionName,
        context: 'Patient',
        accessLevel: 'Public',
        expression:
          name: functionName,
          type: 'FunctionRef',
          operand:
              name: parameter,
              type: 'ExpressionRef'

  # Generate a calculation result for a population / patient pair; this always returns a result immediately,
  # but may return a blank result object that later gets filled in through a deferred calculation, so views
  # that display results must be able to handle a state of "not yet calculated"
  calculate: (population, patient) ->
    #console.log(population.get('index') + ' ' + patient.get('first'))
    
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

    try
      patientSource = new PatientSource([patient])

      # Grab start and end of Measurement Period
      start = moment.utc(population.collection.parent.get('measure_period').low.value, 'YYYYMDDHHmm').toDate()
      end = moment.utc(population.collection.parent.get('measure_period').high.value, 'YYYYMDDHHmm').toDate()
      start_cql = cql.DateTime.fromDate(start, 0) # No timezone offset for start
      end_cql = cql.DateTime.fromDate(end, 0) # No timezone offset for stop

      # Construct CQL params
      params = {"Measurement Period": new cql.Interval(start_cql, end_cql)}

      # Grab ELM JSON from measure, use clone so that the function added from observations does not get added over and over again
      elm = _.clone(population.collection.parent.get('elm'))
      observations = population.collection.parent.get('observations')
      elm["library"]["statements"]["def"].push @generateELMJSONFunction(obs.function_name, obs.parameter) for obs in observations if observations

      # Calculate results for each CQL statement
      results = executeSimpleELM(elm, patientSource, @valueSetsForCodeService(), params)

      # Parse CQL statement results into population values
      population_results = @createPopulationValues population, results, patient

      if population_results?
        result.set population_results
        result.set {'patient_id': patient['id']} # Add patient_id to result in order to delete patient from population_calculation_view
        result.state = 'complete'
    catch error
      bonnie.showError({title: "Measure Calculation Error", summary: "There was an error calculating the measure #{result.measure.get('cms_id')}.", body: "One of the data elements associated with the measure is causing an issue.  Please review the elements associated with the measure to verify that they are all constructed properly.  Error message: #{error.message}."})

    return result

  createPopulationValues: (population, results, patient) ->
    population_results = {}
    # Grab the mapping between populations and CQL statements
    cql_map = population.collection.parent.get('populations_cql_map')
    # Grab the correct expected for this population
    index = population.get('index')
    expected = patient.get('expected_values').models[index]
    # Loop over all population codes ("IPP", "DENOM", etc.)
    for popCode in Thorax.Models.Measure.allPopulationCodes
      if cql_map[popCode]
        if _.isString(cql_map[popCode])
          defined_pops = [cql_map[popCode]]
        else
          defined_pops = cql_map[popCode]
        target_map_index = if defined_pops.length > 1 then index else 0
        cql_population = defined_pops[target_map_index]
        # Is there a patient result for this population?
        if results['patientResults'][patient.id][cql_population]?
          # Grab CQL result value and adjust for Bonnie
          value = results['patientResults'][patient.id][cql_population]
          if typeof value is 'object' and value.length > 0
            population_results[popCode] = value.length
          else if typeof value is 'boolean' and value
            population_results[popCode] = 1
          else
            population_results[popCode] = 0
    @handlePopulationValues population_results

  # Takes in the initial values from result object and checks to see if some values should not be calculated.
  handlePopulationValues: (population_results) ->
    # TODO: Handle CV measures
    # Setting values of populations if the correct populations are not set.
    if @isValueZero('STRAT', population_results) # Set all values to 0
      for key, value of population_results
        population_results[key] = 0
    else if @isValueZero('IPP', population_results)
      for key, value of population_results
        if key != 'STRAT'
          population_results[key] = 0
    else if @isValueZero('DENOM', population_results) or @isValueZero('MSRPOPL', population_results)
      if 'DENEX' of population_results
        population_results['DENEX'] = 0
      if 'DENEXCEP' of population_results
        population_results['DENEXCEP'] = 0
      if 'NUMER' of population_results
        population_results['NUMER'] = 0
    else if @isValueZero('NUMER', population_results)
      if 'NUMEX' of population_results
        population_results['NUMEX'] = 0
    return population_results

  isValueZero: (value, population_set) ->
    if value of population_set and population_set[value] == 0
      return true
    return false

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
