class Thorax.Views.CqlPopulationsLogic extends Thorax.LayoutView

  template: JST['logic/cql_layout']

  events:
    "ready": ->

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

  initialize: ->
    @statementViews = []
    _.each @model.get('elm').library.statements.def, (statement) =>
      if (statement.annotation)
        @statementViews.push new Thorax.Views.CqlStatement(statement: statement)

  context: -> _(super).extend cqlLines: @model.get('cql').split("\n")

  showCoverage: ->

  clearCoverage: ->

  showRationale: (result) ->
    for statementView in @statementViews
      statementView.showRationale result.get('statement_results')[statementView.name]

  clearRationale: ->
    for statementView in @statementViews
      statementView.clearRationale()

class Thorax.Views.CqlStatement extends Thorax.Views.BonnieView
  template: JST['logic/cql_statement']

  initialize: ->
    @text = @statement.annotation[0].s.value[0]
    @name = @statement.name

  showRationale: (result) ->
    if result == true  # Specifically a boolean true
      @_setResult true
    else if result == false  # Specifically a boolean false
      @_setResult false
    else if Array.isArray(result)  # Check if result is an array
      @_setResult result.length > 0  # Result is true if the array is not empty
    else
      @clearRationale()  # Clear the rationale if we can't make sense of the result

  _setResult: (evalResult) ->
    if evalResult == true
      @$('code').attr('class', 'eval-true')
    else
      @$('code').attr('class', 'eval-false')
  
  _

  clearRationale: ->
    @$('code').attr('class', '')
