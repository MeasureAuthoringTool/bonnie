class Thorax.Views.CqlLogic extends Thorax.Views.BonnieView

  template: JST['logic/cql_logic']

  context: -> _(super).extend cqlLines: @model.get('cql').split("\n")

  showCoverage: ->

  clearCoverage: ->

  showRationale: ->

  clearRationale: ->
