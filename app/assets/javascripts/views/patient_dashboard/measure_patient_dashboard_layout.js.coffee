class Thorax.Views.MeasurePatientDashboardLayout extends Thorax.LayoutView
  template: JST['patient_dashboard/layout']

  initialize: ->
    # Highlights correct button, based on selected view
    $('#patient-dashboard-button').addClass('btn-primary')
    $('#measure-details-button').removeClass('btn-primary')

  ###
  Switches populations (changes the population displayed by patient dashboard)
  ###
  switchPopulation: (e) ->
    @populationSet = $(e.target).model()
    @populationSet.measure().set('displayedPopulation', @populationSet)
    @setView new Thorax.Views.MeasurePopulationPatientDashboard measure: @populationSet.measure(), populationSet: @populationSet, showFixedColumns: @showFixedColumns
    @trigger 'population:update', @populationSet

  ###
  Marks the population as active and gives it a title
  ###
  populationContext: (population) ->
    _(population.toJSON()).extend
      isActive: population is population.measure().get('displayedPopulation')
      populationTitle: population.get('title') || population.get('sub_id')

  ###
  Sets the view after results have been calculated
  ###
  setView: (view) ->
    results = @populationSet.calculationResults()
    results.calculationsComplete =>
      view.results = results
      super(view)
