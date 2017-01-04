class Thorax.Views.MeasureHistoryView extends Thorax.Views.BonnieView
  template: JST['measure_history']

  # takes
  #  - @model: the measure
  #  - @patients: the patients associated iwth the measure
  #  - @upload_summaries: all of the uploads associated with the measure's history
  initialize: ->
    @patientData = null
    @measureData = null
    @measureTimelineView = new Thorax.Views.MeasureHistoryTimelineView(model: @model, upload_summaries: @upload_summaries, patients: @patients)

  switchPopulation: (e) ->
    population = $(e.target).model()
    population.measure().set('displayedPopulation', population)
    @trigger 'population:update', population
    @measureTimelineView.updatePopulation(population)

  # makes it so the tabs know what the populations are. This is used in the corresponding template.
  populationContext: (population) ->
    _(population.toJSON()).extend
      isActive:  population is population.measure().get('displayedPopulation')
      populationTitle: population.get('title') || population.get('sub_id')
