class Calculator

  constructor: ->
    @calculator = {}
    @calculatorLoaded = {}
    @resultsCache = {}

  calculationKey: (population) -> "#{population.measure().id}/#{population.get('index')}"

  cacheKey: (population, patient) -> "#{@calculationKey(population)}/#{patient.id || patient.cid}"

  setCalculator: (population, calcFunction) -> @calculator[@calculationKey(population)] = calcFunction

  calculate: (population, patient, options = {}) ->
    options = _(options).defaults cache: true

    cacheKey = @cacheKey(population, patient)
    calcKey = @calculationKey(population)

    return @resultsCache[cacheKey] if options.cache && @resultsCache[cacheKey]?

    result = new Thorax.Models.Result({}, population: population, patient: patient)

    @resultsCache[cacheKey] = result

    @calculatorLoaded[calcKey] ?= $.ajax(url: "#{population.url()}/calculate_code.js", dataType: "script", cache: true)
    @calculatorLoaded[calcKey].done => result.set @calculator[calcKey](patient.toJSON())

    return result
