class Thorax.Views.Measures extends Thorax.View
  template: JST['measures']
  initialize: ->
    @importMeasureView = new Thorax.Views.ImportMeasure()
    to_finalize = @measures.select((m) -> m.attributes['needs_finalize'])
    @finalizeMeasuresView = new Thorax.Views.FinalizeMeasures(measures: new Thorax.Collections.Measures(to_finalize))
  events:
    'click #importMeasureTrigger': 'importMeasure'
    'click #updateMeasureTrigger': 'updateMeasure'
    'submit form': 'deleteMeasure'
  importMeasure: (event) ->
    @importMeasureView.$('.modal-title').text('New Measure')
    @importMeasureView.display()
    event.preventDefault()
  updateMeasure: (event) ->
    @importMeasureView.$('.modal-title').text('Reimport Measure')
    @importMeasureView.display()
    event.preventDefault()
  deleteMeasure: (e) ->
    e.preventDefault()
    @serialize()
    @model = $(e.target).model()
    @model.destroy({data: {authenticity_token: $('meta[name="csrf-token"]')[0].content}, processData: true})