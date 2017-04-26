class Thorax.Views.CqlLogic extends Thorax.Views.BonnieView

  template: JST['logic/cql_logic']

  initialize: (measure, population) ->
    @parseElmAnnotations(measure)

  parseElmAnnotations: (measure) ->
    @logic = []
    elmJson = measure.model.get('elm_annotations')
    for element in elmJson['statements']
      @logic.push(new Thorax.Views.CqlClauseView(element)) 
    
  showCoverage: ->

  clearCoverage: ->

  showRationale: (result) ->

  clearRationale: ->