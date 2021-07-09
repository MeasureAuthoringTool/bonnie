class Thorax.Views.PopulationCriteriaLogic extends Thorax.Views.BonnieView
  template: JST['logic/population_criteria']
  events:
    'click .panel-population' : -> @$('.toggle-icon').toggleClass('fa-angle-right fa-angle-down')
  population_map:
    'IPP': 'Initial Population'
    'STRAT': 'Stratification'
    'DENOM': 'Denominator'
    'NUMER': 'Numerator'
    'NUMEX': 'Numerator Exclusions'
    'DENEXCEP': 'Denominator Exceptions'
    'DENEX': 'Denominator Exclusions'
    'MSRPOPL': 'Measure Population'
    'OBSERV': 'Measure Observations'
    'MSRPOPLEX': 'Measure Population Exclusions'
  aggregator_map:
    'MEAN':'Mean of'
    'MEDIAN':'Median of'

  initialize: ->
    @rootPreconditon = @population.preconditions[0] if @population.preconditions?.length > 0
    @aggregator = @population.aggregator
    @deferRender = @exceedsComplexityThreshold()
    @comments = _(@rootPreconditon?.comments || []).union(@population?.comments || [])

  translate_population: (code) ->
    @population_map[code]

  translate_aggregator: (code) ->
    @aggregator_map[code]

  render: ->
    # If this population is big and complex, the first render just renders a placeholder image (not visible
    # because the population isn't expanded), and we render again immediately after in a deferred fashion
    result = super
    if @deferRender
      @deferRender = false
      setTimeout (=> @render()), 0
    result
