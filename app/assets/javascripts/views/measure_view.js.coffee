class Thorax.Views.MeasureLayout extends Thorax.LayoutView
  template: JST['measure_layout']
  className: 'measure-layout'

  initialize: ->
    @populations = @measure.get 'populations'

  context: ->
    _(super).extend
      cms_id: @measure.get 'cms_id'
      hqmf_set_id: @measure.get 'hqmf_set_id'

  # Navigates to the Patient Dashboard
  showDashboard: (showFixedColumns) ->
    # because of how thorax transitions between views (it removes the $el associated with the view - line 2080 thorax.js)
    # the view needs to be re-created each time it is shown.
    populationSet = @measure.get 'displayedPopulation'
    populationPatientDashboardView = new Thorax.Views.MeasurePopulationPatientDashboard measure: @measure, populationSet: populationSet, showFixedColumns: showFixedColumns
    patientDashboardView = new Thorax.Views.MeasurePatientDashboardLayout collection: @populations, populationSet: populationSet, showFixedColumns: showFixedColumns

    # NOTE: the populationPatientDashboard view has to be set as the subview at this point in time. Otherwise,
    # the rendering order is off and the dashboard renders terribly
    if @populations.length > 1
      @setView patientDashboardView
      patientDashboardView.setView populationPatientDashboardView
    else
      @setView populationPatientDashboardView

  # Navigates to the measure details view
  showMeasure: ->
    # because of how thorax transitions between views (it removes the $el associated with the view - line 2080 thorax.js)
    # the view needs to be re-created each time it is shown. super annoying...
    population = @measure.get 'displayedPopulation'
    @setView new Thorax.Views.Measure(model: @measure, patients: @patients, populations: @populations, population: population)


class Thorax.Views.Measure extends Thorax.Views.BonnieView
  template: JST['measure']

  events:
    rendered: ->
      @exportPatientsView = new Thorax.Views.ExportPatientsView() # Modal dialogs for exporting
      @exportPatientsView.appendTo(@$el)
      @$('.d3-measure-viz, .btn-viz-text').hide()

  context: ->
    _(super).extend
      isPrimaryView: @isPrimaryView

  initialize: ->
    # ensure that @suppressDataCriteriaHighlight is true if it isn't passed in
    # We don't want to have the highlighting on the measure view as the data elements aren't displayed
    @suppressDataCriteriaHighlight ?= true
    populationLogicView = new Thorax.Views.PopulationLogic(model: @population, suppressDataCriteriaHighlight: @suppressDataCriteriaHighlight)
    @measureViz = Bonnie.viz.measureVisualzation().fontSize("1.25em").rowHeight(20).rowPadding({top: 14, right: 6}).dataCriteria(@model.get("data_criteria")).measurePopulation(@population).measureValueSets(@model.valueSets())

    # display layout view when there are multiple populations; otherwise, just show logic view
    if @populations.length > 1
      @logicView = new Thorax.Views.PopulationsLogic collection: @populations, suppressDataCriteriaHighlight: @suppressDataCriteriaHighlight
      @logicView.setView populationLogicView
    else
      @logicView = populationLogicView

    @complexityView = new Thorax.Views.MeasureComplexity model: @model
    @complexityView.listenTo @logicView, 'population:update', (population) -> @updatePopulation(population)

    @valueSetsView = new Thorax.Views.MeasureValueSets model: @model

    @populationCalculation = new Thorax.Views.PopulationCalculation(model: @population, dontShowMeasureHistory: bonnie.isPortfolio)
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

  showCQL: (e) ->
    cqlView = new Thorax.Views.CQLPlaygroundView(collection: @model.get('patients'), measure: @model)
    cqlView.appendTo(@$el)

  exportQrdaPatients: (e) ->
    @exportPatientsView.exporting()

    @model.get('populations').whenDifferencesComputed =>
      differences = []
      @model.get('populations').each (population) ->
        differences.push(_(population.differencesFromExpected().toJSON()).extend(population.coverage().toJSON()))

      $.fileDownload "patients/qrda_export?hqmf_set_id=#{@model.get('hqmf_set_id')}",
        successCallback: => @exportPatientsView.qrdaSuccess()
        failCallback: => @exportPatientsView.fail()
        httpMethod: "POST"
        data: {authenticity_token: $("meta[name='csrf-token']").attr('content'), results: differences }

  exportExcelPatients: (e) ->
    @exportPatientsView.exporting()

    @model.get('populations').whenDifferencesComputed =>
      differences = []
      @model.get('populations').each (population) ->
        differences.push(_(population.calculationResults().toJSON()).extend(population.coverage().toJSON()))

      $.fileDownload "patients/excel_export?hqmf_set_id=#{@model.get('hqmf_set_id')}",
        successCallback: => @exportPatientsView.excelSuccess()
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
