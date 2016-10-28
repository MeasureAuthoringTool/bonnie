class Thorax.Views.CqlPatientBuilderLogic extends Thorax.Views.BonnieView

  template: JST['logic/cql_patient_builder_logic']

  initialize: ->

  context: -> _(super).extend cqlLines: @model.get('cql').split("\n")

  showCoverage: ->

  clearCoverage: ->

  showRationale: (result) ->

  clearRationale: ->
