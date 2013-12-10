class MeasureRowView extends Thorax.View
  initialize: ->
    # only check against the first one since there is only one population
    if @hasFraction
      @matching = @model.get('populations').first().exactMatches()
      @percentage = 0
      unless @model.get('patients').isEmpty()
        @percentage = ((@matching / @model.get('patients').length) * 100).toFixed(0)
      @success = @matching is @model.get('patients').length
    if @model.get('continuous_variable') is true then console.log "CV: #{@model.get('measure_id')}"
    if @model.get('episode_of_care') is true then console.log "EoC: #{@model.get('measure_id')}"
  context: ->
    s = @status()
    _(super).extend
      status: s
  populationContext: (population) ->
    matching = population.exactMatches()
    percentage = 0
    unless @model.get('patients').isEmpty()
      percentage = ((matching / @model.get('patients').length) * 100).toFixed(0)
    success = matching is @model.get('patients').length
    _(population.toJSON()).extend
      measure_id: @model.id
      hasFraction: !@model.get('patients').isEmpty()
      status: if @model.get('patients').isEmpty() then 'new' else if success is true then 'pass' else 'fail'
      expectedPercentage: if @model.get('patients').isEmpty() then '-' else "#{percentage}"
      matches: if @model.get('patients').isEmpty() then 0 else matching
  hasPopulations: -> @model.get('populations').length > 1
  hasFraction: -> @model.get('populations').length == 1 && !@model.get('patients').isEmpty()
  status: -> 
    if @hasFraction
      if @model.get('patients').isEmpty() then 'new' 
      else 
        if @success is true then 'pass' else 'fail'
  updateMeasure: (e) ->
    importMeasureView = new Thorax.Views.ImportMeasure(model: @model)
    importMeasureView.appendTo(@$el)
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
    importMeasureView.appendTo(@$el)
    importMeasureView.display()
  events:
    rendered: ->
      @$('.dial').knob()
      if @collection.length is 0 then @importMeasure()
