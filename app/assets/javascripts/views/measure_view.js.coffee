class Thorax.Views.Measure extends Thorax.View
  template: JST['measure']
  events:
    rendered: -> 
      @$("[rel='popover']").popover(content: @$('.popover-tmpl').text())
      $('html').click( (e) -> 
        unless $(e.target).hasClass('popover-content')
          if $('#settings').has(e.target).length == 0 or $(e.target).is('.close') then $('#settings').popover('hide'))
    'click .delete-measure': 'deleteMeasure'

  initialize: ->
    populations = @model.get 'populations'
    population = populations.first()
    populationLogicView = new Thorax.Views.PopulationLogic(model: population)

    # display layout view when there are multiple populations; otherwise, just show logic view
    if populations.length > 1
      @logicView = new Thorax.Views.PopulationsLogic collection: populations
      @logicView.setView populationLogicView
    else
      @logicView = populationLogicView

    @populationCalculation = new Thorax.Views.PopulationCalculation(model: population)

    @populationCalculation.listenTo @logicView, 'population:update', (population) -> @updatePopulation(population)
    # FIXME: change the name of these events to reflect what the measure calculation view is actually saying
    @logicView.listenTo @populationCalculation, 'rationale:clear', -> @clearRationale()
    @logicView.listenTo @populationCalculation, 'rationale:show', (result) -> @showRationale(result)

  updateMeasure: (e) ->
    importMeasureView = new Thorax.Views.ImportMeasure(model: @model)
    importMeasureView.appendTo(@$el)
    importMeasureView.display()

  deleteMeasure: (e) ->
    @model = $(e.target).model()
    @model.destroy()
