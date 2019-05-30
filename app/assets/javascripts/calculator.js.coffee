@Calculator = class Calculator

  constructor: ->
    @calculator = {}
    @calculatorLoaded = {}
    @resultsCache = {}

  # Key for storing calculators on a population
  calculationKey: (population) -> "#{population.measure().get('cqmMeasure').id}/#{population.get('index')}"

  # Key for storing results for a patient / population calculation; we use the CID for the patient portion
  # of the key so that clones can have different calculation results
  cacheKey: (population, patient) -> "#{@calculationKey(population)}/#{patient.cid}"

  # Utility function for setting the calculator function for a population, used in the calculator loading JS
  setCalculator: (population, calcFunction) -> @calculator[@calculationKey(population)] = calcFunction

  # Cancel all pending calculations; this just marks the result as 'cancelled', the actual stopping of the calculation is
  # handled in the deferred calculation code
  cancelCalculations: ->
    result.state = 'cancelled' for key, result of @resultsCache when result.state == 'pending'

  clearResult: (population, patient) ->
    delete @resultsCache[@cacheKey(population, patient)]
