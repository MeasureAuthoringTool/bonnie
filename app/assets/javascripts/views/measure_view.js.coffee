class Thorax.Views.Measure extends Thorax.View
  template: JST['measure']
  initialize: ->
    # FIXME: display calculation and logic for first population only for now, eventually we'll want them selectable
    @measureCalculation = new Thorax.Views.MeasureCalculation(model: @model, populationIndex: 0)
    @updateMeasureView = new Thorax.Views.ImportMeasure()
    @population = @model.get('populations').at(0)
    @logicView = new Thorax.Views.PopulationLogic(model: @population)
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
