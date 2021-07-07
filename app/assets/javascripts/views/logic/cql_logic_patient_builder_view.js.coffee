class Thorax.Views.CqlPatientBuilderLogic extends Thorax.Views.BonnieView

  template: JST['logic/cql_patient_builder_logic']

  initialize: ->
    # Grab the names of populations from the population set's population map.
    @population_names = Object.keys(@population.get('populations'))

    # Default results for all populations to 0.
    @results = {}
    for pop in @population_names
      @results[pop] = 0
    @cqlLogicView = new Thorax.Views.CqlPopulationLogic(model: @model, highlightPatientDataEnabled: true, population: @population)

  showRationale: (result) ->
    for pop in @population_names
      @results[pop] = result.get(pop)
    if !result.isPopulated()
      @cqlLogicView.clearRationale()
    else
      @cqlLogicView.showRationale result
    @render()
