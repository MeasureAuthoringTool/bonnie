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
    'click #updateMeasureTrigger': 'updateMeasure'

  importMeasure: (event) ->
    @importMeasureView.$('.modal-title').text('New Measure')
    @importMeasureView.display()
    event.preventDefault()

  updateMeasure: (event) ->
    @importMeasureView.$('.modal-title').text('Reimport Measure')
    @importMeasureView.display()
    event.preventDefault()