class Thorax.Views.Measures extends Thorax.View
  template: JST['measures']
  context: ->
    collapsedCount: @measures.collapsed().length

  initialize: ->
    @importMeasureView = new Thorax.Views.ImportMeasure()
    to_finalize = @measures.select((m) -> m.attributes['needs_finalize'])
    @finalizeMeasuresView = new Thorax.Views.FinalizeMeasures(measures: new Thorax.Collections.Measures(to_finalize))

  events:
    'click #importMeasureTrigger': 'importMeasure'

  importMeasure: (event) ->
    @importMeasureView.display()
    event.preventDefault()

