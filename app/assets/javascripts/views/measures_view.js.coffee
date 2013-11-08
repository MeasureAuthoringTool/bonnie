class MeasureRowView extends Thorax.View
  initialize: ->
    @importMeasureView = new Thorax.Views.ImportMeasure()
  populationContext: (population) ->
    _(population.toJSON()).extend
      measure_id: @model.id
      hasFraction: !@model.get('patients').isEmpty()
      status: if @model.get('patients').isEmpty() then 'new' else 'failed'
  hasPopulations: -> @model.get('populations').length > 1
  hasFraction: -> @model.get('populations').length == 1 && !@model.get('patients').isEmpty()
  status: -> if @model.get('patients').isEmpty() then 'new' else 'failed'
  updateMeasure: (e) ->
    # TODO ImportMeasure view should be responsible for setting its title
    @importMeasureView.$('.modal-title').text("[Update] #{@model.get('title')}")
    @importMeasureView.display()

class Thorax.Views.Measures extends Thorax.View
  template: JST['measures']
  measureRowView: MeasureRowView
  initialize: ->
    @importMeasureView = new Thorax.Views.ImportMeasure()
    toFinalize = @collection.select (m) -> m.get('needs_finalize')
    @finalizeMeasuresView = new Thorax.Views.FinalizeMeasures measures: new Thorax.Collections.Measures(toFinalize)
  importMeasure: (event) ->
    # TODO ImportMeasure view should be responsible for setting its title
    @importMeasureView.$('.modal-title').text('[Import] New Measure')
    @importMeasureView.display()
