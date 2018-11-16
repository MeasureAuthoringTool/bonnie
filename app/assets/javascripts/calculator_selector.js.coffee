# Selector class that will choose which calculator to call the functions on.
@CalculatorSelector = class CalculatorSelector

  calculate: (population, patient, options = {}) ->
    bonnie.cql_calculator.calculate population, patient, options

  clearResult: (population, patient) ->
    bonnie.cql_calculator.clearResult population, patient

  # Cancels all calculations, used when nagivating routes. (See router.js.coffee)
  cancelCalculations: ->
    bonnie.cql_calculator.cancelCalculations()