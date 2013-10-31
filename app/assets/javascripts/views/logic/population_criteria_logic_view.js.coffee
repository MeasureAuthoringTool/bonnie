class Thorax.Views.PopulationCriteriaLogic extends Thorax.View
  
  template: JST['logic/population_criteria']
  population_map: 
    'IPP': 'Initial Patient Population'
    'DENOM': 'Denominator'
    'NUMER': 'Numerator'
    'DENEXCEP': 'Denominator Exceptions'
    'DENEX': 'Denominator Exclusions'
    'MSRPOPL': 'Measure Population'
    'OBSERV': 'Measure Observations'

  initialize: ->
  	@rootPreconditon = @population.preconditions[0] if @population.preconditions && @population.preconditions.length > 0

  translate_population: (code) ->
  	@population_map[code]