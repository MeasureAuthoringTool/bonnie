class Thorax.Views.Measure extends Thorax.View
  template: JST['measure']
  events:
    rendered: ->
      @$("[rel='popover']").popover( html: true )

  initialize: ->
    # FIXME: display calculation for first population only for now, eventually we'll want them selectable
    @measureCalculation = new Thorax.Views.MeasureCalculation(model: @model, populationIndex: 0)
    @updateMeasureView = new Thorax.Views.ImportMeasure() # FIXME instantiate this view on use

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

  events: ->
    'click #deleteMeasure': 'deleteMeasure'
  updateMeasure: (e) ->
    measure = $(e.target).model()
    @updateMeasureView.$('.modal-title').text("[Update] #{measure.get('title')}")
    @updateMeasureView.display()
  deleteMeasure: (e) ->
    @model = $(e.target).model()
    @model.destroy()
