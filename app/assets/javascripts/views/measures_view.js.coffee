class MeasureRowView extends Thorax.View
  initialize: ->
    # only check against the first one since there is only one population
    if @hasFraction
      @matching = @model.get('populations').first().exactMatches()
      @percentage = 0
      unless @model.get('patients').isEmpty()
        @percentage = ((@matching / @model.get('patients').length) * 100).toFixed(0)
      @success = @matching is @model.get('patients').length
  populationContext: (population) ->
    matching = population.exactMatches()
    percentage = 0
    unless @model.get('patients').isEmpty()
      percentage = ((matching / @model.get('patients').length) * 100).toFixed(0)
    success = matching is @model.get('patients').length
    _(population.toJSON()).extend
      measure_id: @model.id
      hasFraction: !@model.get('patients').isEmpty()
      status: if @model.get('patients').isEmpty() then 'new' else if success is true then 'success' else 'failed'
      expectedPercentage: if @model.get('patients').isEmpty() then '-' else "#{percentage}"
      matches: if @model.get('patients').isEmpty() then 0 else matching
  hasPopulations: -> @model.get('populations').length > 1
  hasFraction: -> @model.get('populations').length == 1 && !@model.get('patients').isEmpty()
  status: -> 
    if @hasFraction
      if @model.get('patients').isEmpty() then 'new' 
      else 
        if @success is true then 'success' else 'failed'
  updateMeasure: (e) ->
    importMeasureView = new Thorax.Views.ImportMeasure(model: @model)
    importMeasureView.appendTo('#importUpdateContainer')
    importMeasureView.display()
  expectedPercentage: ->
    if @hasFraction
      if @model.get('patients').isEmpty() then '-' else "#{@percentage}"
  matches: ->
    if @hasFraction
      if @model.get('patients').isEmpty() then 0 else @matching

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
  events:
    rendered: ->
      console.log "Measure View Rendered"
      @$('.dial').knob()
    
