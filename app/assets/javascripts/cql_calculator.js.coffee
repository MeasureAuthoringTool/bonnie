@CQLCalculator = class CQLCalculator extends Calculator

  # Returns a JSON function to add to the ELM before ELM JSON is used to calculate results
  # This ELM template was generated by the CQL-to-ELM Translation Service
  generateELMJSONFunction: (functionName, parameter) ->
    elmFunction = 
      name: 'BonnieFunction_' + functionName,
      context: 'Patient',
      accessLevel: 'Public',
      expression:
        type: 'Query',
        source: [
          {
            alias: 'MP',
            expression: {
              name: parameter,
              type: 'ExpressionRef'
             }
          }
        ]
        relationship: [],
        return: 
          distinct: false,
          expression: 
            name: functionName,
            type: 'FunctionRef',
            operand: [
              {
                type: 'As',
                operand: {
                  name: 'MP',
                  type: 'AliasRef'
                }
              }
            ]
      
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

    try
      # Necessary structure for the CQL (ELM) Execution Engine. Uses CQL_QDM Patient API to map Bonnie patients to correct format.
      patientSource = new PatientSource([patient])

      # Grab start and end of Measurement Period
      start = @getConvertedTime population.collection.parent.get('measure_period').low.value
      end = @getConvertedTime population.collection.parent.get('measure_period').high.value
      start_cql = cql.DateTime.fromDate(start, 0) # No timezone offset for start
      end_cql = cql.DateTime.fromDate(end, 0) # No timezone offset for stop

      # Construct CQL params
      params = {"Measurement Period": new cql.Interval(start_cql, end_cql)}

      # Grab ELM JSON from measure, use clone so that the function added from observations does not get added over and over again
      elm = _.clone(population.collection.parent.get('elm'))
      observations = population.collection.parent.get('observations')
      if observations
         for obs in observations
           generatedELMJSON =  @generateELMJSONFunction(obs.function_name, obs.parameter)
           # Check to see if the gneratedELMJSON function is already in the definitions
           if (elm["library"]["statements"]["def"].filter (def) -> def.name == generatedELMJSON.name).length == 0
             elm["library"]["statements"]["def"].push generatedELMJSON

      # Calculate results for each CQL statement
      results = executeSimpleELM(elm, patientSource, @valueSetsForCodeService(), params)

      # Parse CQL statement results into population values
      population_results = @createPopulationValues population, results, patient

      if population_results?
        result.set {'statement_results': results.patientResults[patient['id']]}
        result.set population_results
        result.set {'patient_id': patient['id']} # Add patient_id to result in order to delete patient from population_calculation_view
        result.state = 'complete'
    catch error
      result.state = 'cancelled'
      # Since the line above is needed to handle the error cleanup we are using Costanza.emit to push this error
      Costanza.emit({
        section: 'cql-measure-calculation',
        cms_id: result.measure.get('cms_id'),
        stack: error.stack,
        msg: error.message,
        type: 'javascript'
        }, error)
    return result

  createPopulationValues: (population, results, patient) ->
    population_results = {}
    # Grab the mapping between populations and CQL statements
    cql_map = population.collection.parent.get('populations_cql_map')
    # Grab the correct expected for this population
    index = population.get('index')
    expected = patient.get('expected_values').findWhere(measure_id: population.collection.parent.get('hqmf_set_id'), population_index: index)
    # Loop over all population codes ("IPP", "DENOM", etc.)
    for popCode in Thorax.Models.Measure.allPopulationCodes
      if cql_map[popCode]
        # This code is supporting measures that were uploaded 
        # before the parser returned multiple populations in an array.
        # TODO: Remove this check when we move over to production.
        if _.isString(cql_map[popCode])
          defined_pops = [cql_map[popCode]]
        else
          defined_pops = cql_map[popCode]
        index = 0 unless defined_pops.length > 1
        # If a stratified population, we need to set the index to the populationCriteria
        # that the stratification is on so that the correct (IPOP, DENOM, NUMER..) are retrieved
        index = population.get('population_index') if population.get('stratification')?
        # If retrieving the STRAT, set the index to the correct STRAT in the cql_map
        index = population.get('stratification_index') if popCode == "STRAT" && population.get('stratification')?
        cql_population = defined_pops[index]
        # Is there a patient result for this population? and does this populationCriteria contain the population
        # We need to check if the populationCriteria contains the population so that a STRAT is not set to zero if there is not a STRAT in the populationCriteria
        if results['patientResults'][patient.id][cql_population]? && population.get(popCode)?
          # Grab CQL result value and adjust for Bonnie
          value = results['patientResults'][patient.id][cql_population]
          if Array.isArray(value) and value.length > 0
            population_results[popCode] = value.length
          else if typeof value is 'boolean' and value
            population_results[popCode] = 1
          else
            population_results[popCode] = 0
    @handlePopulationValues population_results

  # Takes in the initial values from result object and checks to see if some values should not be calculated.
  handlePopulationValues: (population_results) ->
    # TODO: Handle CV measures
    # Setting values of populations if the correct populations are not set based on the following logic guidelines
    # Initial Population (IPP): The set of patients or episodes of care to be evaluated by the measure.
    # Denominator (DENOM): A subset of the IPP.
    # Denominator Exclusions (DENEX): A subset of the Denominator that should not be considered for inclusion in the Numerator.
    # Denominator Exceptions (DEXCEP): A subset of the Denominator. Only those members of the Denominator that are considered 
    # for Numerator membership and are not included are considered for membership in the Denominator Exceptions.
    # Numerator (NUMER): A subset of the Denominator. The Numerator criteria are the processes or outcomes expected for each patient,
    # procedure, or other unit of measurement defined in the Denominator.
    # Numerator Exclusions (NUMEX): A subset of the Numerator that should not be considered for calculation.
    if population_results["STRAT"]? && @isValueZero('STRAT', population_results) # Set all values to 0
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
    # Can not be in the numerator if excluded from the denominator
    else if (population_results["DENEX"]? && !@isValueZero('DENEX', population_results))
      if 'NUMER' of population_results
        population_results['NUMER'] = 0
      if 'NUMEX' of population_results
        population_results['NUMEX'] = 0
    else if @isValueZero('NUMER', population_results)
      if 'NUMEX' of population_results
        population_results['NUMEX'] = 0
    # Can not be in the numerator if explicitly excluded
    else if population_results["NUMEX"]? && !@isValueZero('NUMEX', population_results)
      if 'NUMER' of population_results
        population_results['NUMER'] = 0
    else if !@isValueZero('NUMER', population_results)
      if 'DENEXCEP' of population_results
        population_results["DENEXCEP"] = 0
    return population_results

  isValueZero: (value, population_set) ->
    if value of population_set and population_set[value] == 0
      return true
    return false

  # Format ValueSets for use by CQL4Browsers
  valueSetsForCodeService: ->
    valueSets = {}
    for oid, vs of bonnie.valueSetsByOid
      continue unless vs.concepts
      valueSets[oid] ||= {}
      valueSets[oid][vs.version] ||= []
      for concept in vs.concepts
        valueSets[oid][vs.version].push code: concept.code, system: concept.code_system_name, version: vs.version
    valueSets

  # Converts the given time to the correct format using momentJS
  getConvertedTime: (timeValue) ->
    moment.utc(timeValue, 'YYYYMDDHHmm').toDate()
