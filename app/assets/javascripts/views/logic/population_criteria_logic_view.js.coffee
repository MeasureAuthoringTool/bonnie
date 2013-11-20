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
  aggregator_map:
    'MEAN':'Mean of'
    'MEDIAN':'Median of'


  initialize: ->
    @rootPreconditon = @population.preconditions[0] if @population.preconditions?.length > 0
    @aggregator = @population.aggregator

  translate_population: (code) ->
    @population_map[code]

  translate_aggregator: (code) ->
    @aggregator_map[code]
