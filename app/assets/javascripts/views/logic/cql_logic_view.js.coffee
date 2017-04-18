class Thorax.Views.CqlPopulationsLogic extends Thorax.LayoutView

  template: JST['logic/cql_layout']

  events:
    "ready": ->
      @cqlLogicView.startAceCqlView(@model)

  initialize: ->
    @switchToGivenPopulation(@model.get('populations').models[0])

  switchPopulation: (e) ->
    population = $(e.target).model()
    @switchToGivenPopulation(population)

  switchToGivenPopulation: (pop) ->
    pop.measure().set('displayedPopulation', pop)
    @cqlLogicView = new Thorax.Views.CqlPopulationLogic(model: @model, population: pop)
    @setView @cqlLogicView
    @trigger 'population:update', pop
    @cqlLogicView.startAceCqlView(@model)

  showRationale: (result) -> @getView().showRationale(result)

  clearRationale: -> @getView().clearRationale()

  showCoverage: -> @getView().showCoverage()

  clearCoverage: -> @getView().clearCoverage()

  showSelectCoverage: (rationaleCriteria) -> @getView().showSelectCoverage(rationaleCriteria)

  populationContext: (population) ->
    _(population.toJSON()).extend
      isActive:  population is population.measure().get('displayedPopulation')
      populationTitle: population.get('title') || population.get('sub_id')


class Thorax.Views.CqlPopulationLogic extends Thorax.Views.BonnieView

  template: JST['logic/cql_logic']

  events:
    "ready": ->
      @startAceCqlView(@model)

  initialize: ->

  context: -> _(super).extend cqlLines: @model.get('cql').split("\n")

  showCoverage: ->

  clearCoverage: ->

  showRationale: (result) ->

  clearRationale: ->

  startAceCqlView: (model) ->
    if $('#editor').length
      @editor = ace.edit("editor")
      @editor.setTheme("ace/theme/chrome")
      @editor.session.setMode("ace/mode/cql")
      @editor.setReadOnly(true)
      @editor.setShowPrintMargin(false)
      @editor.setOptions(maxLines: Infinity)
      @editor.renderer.setShowGutter(false)
      options =
        readOnly: true
        highlightActiveLine: false
        highlightGutterLine: false
        wrap: true
      @editor.setOptions options
      @editor.renderer.$cursorLayer.element.style.opacity = 0
      @editor.setValue(model.get('cql'), -1)
