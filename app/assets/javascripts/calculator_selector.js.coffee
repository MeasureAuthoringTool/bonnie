# Selector class that will choose which calculator to call the functions on.
@CalculatorSelector = class CalculatorSelector

  calculate: (population, patient, options = {}) ->
    if population.collection.parent.has('cql')
      bonnie.cql_calculator.calculate population, patient, options
    else
      bonnie.qdm_calculator.calculate population, patient

  clearResult: (population, patient) ->
    if population.collection.parent.has('cql')
      bonnie.cql_calculator.clearResult population, patient
    else
      bonnie.qdm_calculator.clearResult population, patient

  # Cancels all calculations, used when nagivating routes. (See router.js.coffee)
  cancelCalculations: ->
    bonnie.cql_calculator.cancelCalculations()
    bonnie.qdm_calculator.cancelCalculations()