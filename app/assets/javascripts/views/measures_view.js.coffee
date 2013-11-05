class Thorax.Views.Measures extends Thorax.View
  template: JST['measures']
  initialize: ->
    @importMeasureView = new Thorax.Views.ImportMeasure()
    to_finalize = @measures.select((m) -> m.attributes.needs_finalize)
    @finalizeMeasuresView = new Thorax.Views.FinalizeMeasures(measures: new Thorax.Collections.Measures(to_finalize))
  importMeasure: (event) ->
    @importMeasureView.$('.modal-title').text('[Import] New Measure')
    @importMeasureView.display()
  updateMeasure: (e) ->
    measure = $(e.target).model()
    @importMeasureView.$('.modal-title').text("[Update] #{measure.get('title')}")
    @importMeasureView.display()
  deleteMeasure: (e) ->
    @model = $(e.target).model()
    @model.destroy()
