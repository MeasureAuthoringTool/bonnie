class Thorax.Views.Measure extends Thorax.View
  template: JST['measure']
  events:
    rendered: -> @$("[rel='popover']").popover(content: @$('.popover-tmpl').text())
    'click .delete-measure': 'deleteMeasure'

  initialize: ->
    # FIXME: display calculation for first population only for now, eventually we'll want them selectable
    @measureCalculation = new Thorax.Views.MeasureCalculation(model: @model, populationIndex: 0)

    populations = @model.get 'populations'
    population = populations.first()
    populationLogicView = new Thorax.Views.PopulationLogic(model: population)

    # display layout view when there are multiple populations; otherwise, just show logic view
    if populations.length > 1
      @logicView = new Thorax.Views.PopulationsLogic collection: populations
      @logicView.setView populationLogicView
    else
      @logicView = populationLogicView
    @logicView.listenTo @measureCalculation, 'rationale:clear', -> @clearRationale()
    @logicView.listenTo @measureCalculation, 'rationale:show', (result) -> @showRationale(result)
    @measureCalculation.listenTo @logicView, 'population:update', (population) -> @updatePopulation(population)

  updateMeasure: (e) ->
    importMeasureView = new Thorax.Views.ImportMeasure(model: @model)
    importMeasureView.appendTo(@$el)
    importMeasureView.display()
  deleteMeasure: (e) ->
    @model = $(e.target).model()
    @model.destroy()
