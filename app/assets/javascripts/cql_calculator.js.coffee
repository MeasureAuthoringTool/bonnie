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

      # Grab ELM JSON from measure
      elm = population.collection.parent.get('elm')

      # Calculate results for each CQL statement
      results = executeSimpleELM(elm, patientSource, @valueSetsForCodeService(), params)

      # Parse CQL statement results into population values
      population_values = @createPopulationValues population, results, patient

      if population_values?
        result.set population_values
        result.set {'patient_id': patient['id']} # Add patient_id to result in order to delete patient from population_calculation_view
        result.state = 'complete'
    catch error
      bonnie.showError({title: "Measure Calculation Error", summary: "There was an error calculating the measure #{result.measure.get('cms_id')}.", body: "One of the data elements associated with the measure is causing an issue.  Please review the elements associated with the measure to verify that they are all constructed properly.  Error message: #{error.message}."})

    return result

  createPopulationValues: (population, results, patient) ->
    population_values = {}
    cql_map = population.collection.parent.get('populations_cql_map')
    # Loop over each population's expected
    for expected in patient.get('expected_values').models
      # Loop over all population codes ("IPP", "DENOM", etc.)
      for popCode in Thorax.Models.Measure.allPopulationCodes # EX: IPP
        if cql_map[popCode]
          cql_code = cql_map[popCode].replace(/[0-9]/g, '') # Ignore population indicies
          # Try to see if the measure has definitions for more than one population
          pop_num = expected.get('population_index') + 1
          pop_name = cql_code + ' ' + pop_num
          unless results['patientResults'][patient.id][pop_name]?
            # Population did not have an index (ex: "Denominator Exclusions")
            pop_name = cql_code
          # Grab CQL result value and adjust for Bonnie
          value = results['patientResults'][patient.id][pop_name]
          if typeof value is 'object' and value.length > 0
            population_values[popCode] = 1
          else if typeof value is 'boolean' and value
            population_values[popCode] = 1
          else
            population_values[popCode] = 0
      # We've hit the population we are supposed to be calculating; return
      if expected.get('population_index') == population.get('index')
        return @handlePopulationValues population_values
    return null

  # Takes in the initial values from result object and checks to see if some values should not be calculated.
  handlePopulationValues: (population_values) ->
    # TODO: Handle CV measures
    # Setting values of populations if the correct populations are not set.
    if @isValueZero('STRAT', population_values) # Set all values to 0
      for key, value of population_values
        population_values[key] = 0
    else if @isValueZero('IPP', population_values)
      for key, value of population_values
        if key != 'STRAT'
          population_values[key] = 0
    else if @isValueZero('DENOM', population_values) or @isValueZero('MSRPOPL', population_values)
      if 'DENEX' of population_values
        population_values['DENEX'] = 0
      if 'DENEXCEP' of population_values
        population_values['DENEXCEP'] = 0
      if 'NUMER' of population_values
        population_values['NUMER'] = 0
    else if @isValueZero('NUMER', population_values)
      if 'NUMEX' of population_values
        population_values['NUMEX'] = 0

    return population_values

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
