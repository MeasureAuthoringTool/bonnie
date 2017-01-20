class Thorax.Views.CqlPatientBuilderLogic extends Thorax.Views.BonnieView

  template: JST['logic/cql_patient_builder_logic']

  initialize: ->
    @population_names = Object.keys(@model.get('populations_cql_map'))
    @results = {}
    for pop in @population_names
      @results[pop] = 0

  context: -> _(super).extend cqlLines: @model.get('cql').split("\n")

  showCoverage: ->

  clearCoverage: ->

  showRationale: (result) ->
    for pop in @population_names
      @results[pop] = result.get(pop)
    @render()

  clearRationale: ->
