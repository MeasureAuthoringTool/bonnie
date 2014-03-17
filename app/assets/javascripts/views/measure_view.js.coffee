class Thorax.Views.Measure extends Thorax.View
  template: JST['measure']

  events:
    rendered: ->
      @exportPatientsView = new Thorax.Views.ExportPatientsView() # Modal dialogs for exporting
      @exportPatientsView.appendTo(@$el)
      @$('.d3-measure-viz').hide()

  initialize: ->
    populations = @model.get 'populations'
    population = populations.first()
    populationLogicView = new Thorax.Views.PopulationLogic(model: population)
    @measureViz = Bonnie.viz.measureVisualzation().dataCriteria(@model.get("data_criteria")).measurePopulation(population)

    # display layout view when there are multiple populations; otherwise, just show logic view
    if populations.length > 1
      @logicView = new Thorax.Views.PopulationsLogic collection: populations
      @logicView.setView populationLogicView
    else
      @logicView = populationLogicView

    @populationCalculation = new Thorax.Views.PopulationCalculation(model: population)
    @logicView.listenTo @populationCalculation, 'logicView:showCoverage', -> @showCoverage()
    @logicView.listenTo @populationCalculation, 'logicView:clearCoverage', -> @clearCoverage()

    @populationCalculation.listenTo @logicView, 'population:update', (population) -> @updatePopulation(population)
    @listenTo @logicView, 'population:update', (population) ->
      @$('.d3-measure-viz').empty()
      @$('.d3-measure-viz').hide()
      @$('.btn-measure-viz').removeClass('btn-primary').addClass('btn-default')
      @measureViz = Bonnie.viz.measureVisualzation().dataCriteria(@model.get("data_criteria")).measurePopulation(population)

    # FIXME: change the name of these events to reflect what the measure calculation view is actually saying
    @logicView.listenTo @populationCalculation, 'rationale:clear', -> @clearRationale()
    @logicView.listenTo @populationCalculation, 'rationale:show', (result) -> @showRationale(result)

  updateMeasure: (e) ->
    importMeasureView = new Thorax.Views.ImportMeasure(model: @model)
    importMeasureView.appendTo(@$el)
    importMeasureView.display()

  exportPatients: (e) ->
    @exportPatientsView.exporting()
    $.fileDownload "patients/export?hqmf_set_id=#{@model.get('hqmf_set_id')}",
      successCallback: => @exportPatientsView.success()
      failCallback: => @exportPatientsView.fail()

  deleteMeasure: (e) ->
    @model = $(e.target).model()
    @model.destroy()
    bonnie.renderMeasures()

  measureSettings: (e) ->
    e.preventDefault()
    @$('.delete-icon').click() if @$('.delete-measure').is(':visible')
    @$('.measure-settings').toggleClass('measure-settings-expanded')

  patientsSettings: (e) ->
    e.preventDefault()
    @$('.patients-settings').toggleClass('patients-settings-expanded')

  showDelete: (e) ->
    e.preventDefault()
    $btn = $(e.currentTarget)
    $btn.toggleClass('btn-danger btn-danger-inverse').prev().toggleClass('hide')

  toggleVisualization: (e) ->
    @$('.btn-measure-viz').toggleClass('btn-default btn-primary')
    @$('.measure-viz').toggle()
    @$('.d3-measure-viz').toggle()
    if @$('.d3-measure-viz').children().length == 0
      try
        d3.select(@el).select('.d3-measure-viz').datum(@model.get("population_criteria")).call(@measureViz) 
        @$('rect').popover()
        @$('.d3-measure-viz').css('height', ( d3.selectAll('rect').size() + @populationCalculation.model.populationCriteria().length) * 30)
        # @$('.d3-measure-viz').css('width', 5000)
        # @$('.d3-measure-viz').css('height', 5000)
      catch error
        @$('svg').toggle()
        @$('.d3-measure-viz').append( "<p>Sorry, this measure visualization isn't ready yet!</p>" )
        console.log error
