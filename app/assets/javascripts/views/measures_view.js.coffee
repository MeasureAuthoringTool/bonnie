class MeasureRowView extends Thorax.View
  populationContext: (population) ->
    _(population.toJSON()).extend
      measure_id: @model.id
      hasFraction: !@model.get('patients').isEmpty()
      status: if @model.get('patients').isEmpty() then 'new' else 'failed'
  hasPopulations: -> @model.get('populations').length > 1
  hasFraction: -> @model.get('populations').length == 1 && !@model.get('patients').isEmpty()
  status: -> if @model.get('patients').isEmpty() then 'new' else 'failed'
  updateMeasure: (e) ->
    importMeasureView = new Thorax.Views.ImportMeasure(model: @model)
    importMeasureView.appendTo('#importUpdateContainer')
    importMeasureView.display()

class Thorax.Views.Measures extends Thorax.View
  template: JST['measures']
  measureRowView: MeasureRowView
  initialize: ->
    toFinalize = @collection.select (m) -> m.get('needs_finalize')
    @finalizeMeasuresView = new Thorax.Views.FinalizeMeasures measures: new Thorax.Collections.Measures(toFinalize)
  importMeasure: (event) ->
    importMeasureView = new Thorax.Views.ImportMeasure()
    importMeasureView.appendTo('#importUpdateContainer')
    importMeasureView.display()
