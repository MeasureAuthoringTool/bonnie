class Thorax.Views.MeasureLayout extends Thorax.LayoutView
  template: JST['measure_layout']
  className: 'measure-layout'

  initialize: ->
    @populations = @measure.get 'populations'

  context: ->
    _(super).extend
      cms_id: @measure.get 'cms_id'
      hqmf_set_id: @measure.get 'hqmf_set_id'
      cql: @measure.has('cql') # Hide certain features in handlebars if the measure is cql.

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
      @$('a[data-toggle="tooltip"]').tooltip()

  context: ->
    _(super).extend
      isPrimaryView: @isPrimaryView

  initialize: ->
    @measureViz = Bonnie.viz.measureVisualzation().fontSize("1.25em").rowHeight(20).rowPadding({top: 14, right: 6}).dataCriteria(@model.get("data_criteria")).measurePopulation(@population).measureValueSets(@model.valueSets())
    # Determine which population logic view use
    if @model.has('cql')
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @model, population: @population)
    else
      populationLogicView = new Thorax.Views.PopulationLogic(model: @population)
  
    # Determine which populations logic view to use
    if @populations.length > 1
      if @model.has('cql') # CQL Based measure with multiple populations
        @logicView = new Thorax.Views.CqlPopulationsLogic model: @model, collection: @populations
      else
        @logicView = new Thorax.Views.PopulationsLogic collection: @populations
      @logicView.setView populationLogicView
    else
      @logicView = populationLogicView

    @complexityView = new Thorax.Views.MeasureComplexity model: @model
    @complexityView.listenTo @logicView, 'population:update', (population) -> @updatePopulation(population)

    @valueSetsView = new Thorax.Views.MeasureValueSets model: @model

    @populationCalculation = new Thorax.Views.PopulationCalculation(model: @population, isCQL: @model.get('cql')?)
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
    return null unless @model.has('episode_ids')
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
        data: {authenticity_token: $("meta[name='csrf-token']").attr('content'), results: differences, isCQL: @model.has('cql')}

  exportExcelPatients: (e) ->
    @exportPatientsView.exporting()
    
    calc_results = {}
    patient_details = {}
    population_details = {}
    statement_details = CQLMeasureHelpers.buildDefineToFullStatement(@model)
    file_name = @model.get('cms_id')
    debugger
    # Loop iterates over the populations and gets the calculations for each population.
    # From this it builds a map of pop_key->patient_key->results
    for pop in @model.get('populations').models
      for patient in @model.get('patients').models
        if calc_results[pop.cid] == undefined
          calc_results[pop.cid] = {}
        result = pop.calculate(patient)
        result_criteria = {}
        for pop_crit of result.get('population_relevance')
          result_criteria[pop_crit] = result.get(pop_crit)
        calc_results[pop.cid][patient.cid] = {statement_results: @removeRaw(result.get("statement_results")), criteria: result_criteria}
        # Populates the patient details
        if (patient_details[patient.cid] == undefined)
          patient_details[patient.cid] = {
            first: patient.get("first")
            last: patient.get("last")
            expected_values: patient.get("expected_values")
            birthdate: patient.get("birthdate")
            expired: patient.get("expired")
            deathdate: patient.get("deathdate")
            ethnicity: patient.get("ethnicity")
            race: patient.get("race")
            gender: patient.get("gender")
            notes: patient.get("notes")
          }
        # Populates the population details
        if (population_details[pop.cid] == undefined)
          population_details[pop.cid] = {title: pop.get("title"), statement_relevance: result.get("statement_relevance")}
          criteria = []
          for popAttrs of pop.attributes
            if (popAttrs != "title" && popAttrs != "sub_id" && popAttrs != "title")
              criteria.push(popAttrs)
          population_details[pop.cid]["criteria"] = criteria

    $.fileDownload "patients/excel_export",
      successCallback: => @exportPatientsView.excelSuccess(),
      failCallback: => @exportPatientsView.fail(),
      httpMethod: "POST",
      data: {
        authenticity_token: $("meta[name='csrf-token']").attr('content')
        calc_results: JSON.stringify(calc_results)
        patient_details: JSON.stringify(patient_details)
        population_details: JSON.stringify(population_details)
        statement_details: JSON.stringify(statement_details)
        file_name: file_name
      }
  # Iterates through the results to remove extraneous fields.
  removeRaw: (results) ->
    ret = {}
    for libKey of results
      ret[libKey] = {}
      for statementKey of results[libKey]
        ret[libKey][statementKey] = results[libKey][statementKey].final
    return ret

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
