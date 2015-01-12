class Thorax.Views.Measure extends Thorax.Views.BonnieView
  template: JST['measure']

  events:
    rendered: ->
      @exportPatientsView = new Thorax.Views.ExportPatientsView() # Modal dialogs for exporting
      @exportPatientsView.appendTo(@$el)
      @$('.d3-measure-viz, .btn-viz-text').hide()

  initialize: ->
    populations = @model.get 'populations'
    population = populations.first()
    populationLogicView = new Thorax.Views.PopulationLogic(model: population)
    @measureViz = Bonnie.viz.measureVisualzation().fontSize("1.25em").rowHeight(20).rowPadding({top: 14, right: 6}).dataCriteria(@model.get("data_criteria")).measurePopulation(population).measureValueSets(@model.valueSets())

    # display layout view when there are multiple populations; otherwise, just show logic view
    if populations.length > 1
      @logicView = new Thorax.Views.PopulationsLogic collection: populations
      @logicView.setView populationLogicView
    else
      @logicView = populationLogicView

    @complexityView = new Thorax.Views.MeasureComplexity model: @model
    @complexityView.listenTo @logicView, 'population:update', (population) -> @updatePopulation(population)

    @populationCalculation = new Thorax.Views.PopulationCalculation(model: population)
    @logicView.listenTo @populationCalculation, 'logicView:showCoverage', -> @showCoverage()
    @logicView.listenTo @populationCalculation, 'logicView:clearCoverage', -> @clearCoverage()

    @populationCalculation.listenTo @logicView, 'population:update', (population) -> @updatePopulation(population)
    @listenTo @logicView, 'population:update', (population) =>
      @$('.panel, .right-sidebar').animate(backgroundColor: '#fcf8e3').animate(backgroundColor: 'inherit')
      @$('.d3-measure-viz').empty()
      @$('.d3-measure-viz, .btn-viz-text').hide()
      @$('.btn-viz-chords').show()
      @measureViz = Bonnie.viz.measureVisualzation().fontSize("1.25em").rowHeight(20).dataCriteria(@model.get("data_criteria")).measurePopulation(population).measureValueSets(@model.valueSets())
    # FIXME: change the name of these events to reflect what the measure calculation view is actually saying
    @logicView.listenTo @populationCalculation, 'rationale:clear', -> @clearRationale()
    @logicView.listenTo @populationCalculation, 'rationale:show', (result) -> @showRationale(result)
    @measures = @model.collection

  episodesOfCare: ->
    @model.get('source_data_criteria').filter((sdc) => sdc.get('source_data_criteria') in @model.get('episode_ids'))

  updateMeasure: (e) ->
    importMeasureView = new Thorax.Views.ImportMeasure(model: @model)
    importMeasureView.appendTo(@$el)
    importMeasureView.display()

  exportPatients: (e) ->
    @exportPatientsView.exporting()

    @model.get('populations').whenDifferencesComputed =>
      differences = []
      @model.get('populations').each (population) ->
        differences.push(_(population.differencesFromExpected().toJSON()).extend(population.coverage().toJSON()))

      $.fileDownload "patients/export?hqmf_set_id=#{@model.get('hqmf_set_id')}", 
        successCallback: => @exportPatientsView.success()
        failCallback: => @exportPatientsView.fail()
        httpMethod: "POST"
        data: {authenticity_token: $("meta[name='csrf-token']").attr('content'), results: differences }

  deleteMeasure: (e) ->
    @model = $(e.target).model()
    @model.destroy()
    bonnie.navigate '', trigger: true

  measureSettings: (e) ->
    e.preventDefault()
    @$('.btn-measure-viz:visible').click() if @$('.btn-measure-viz:visible').hasClass('btn-viz-text')
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
    @$('.btn-viz-chords, .btn-viz-text, .measure-viz, .d3-measure-viz').toggle()
    if @$('.d3-measure-viz').children().length == 0
      d3.select(@el).select('.d3-measure-viz').datum(@model.get("population_criteria")).call(@measureViz) 
      @$('rect').popover()
      if @populationCalculation.toggledPatient? then @logicView.showRationale(@populationCalculation.toggledPatient) else @logicView.showCoverage()
