class Thorax.Views.MeasureHistoryView extends Thorax.Views.BonnieView
  template: JST['measure_history']

  initialize: ->
    @patientData = undefined
    @measureData = undefined
    @measureDiffView = new Thorax.Views.MeasureHistoryDiffView(model: @model)
    @measureTimelineView = new Thorax.Views.MeasureHistoryTimelineView(model: @model, upload_summaries: @upload_summaries, patients: @patients)
    
  switchPopulation: (e) ->
    population = $(e.target).model()
    population.measure().set('displayedPopulation', population)
    @trigger 'population:update', population
    @measureDiffView.updatePopulation(population)
    @measureTimelineView.updatePopulation(population)
  
  populationContext: (population) ->
    _(population.toJSON()).extend
      isActive:  population is population.measure().get('displayedPopulation')
      populationTitle: population.get('title') || population.get('sub_id')
