class Thorax.Views.MeasureLayout extends Thorax.LayoutView
  template: JST['measure_layout']
  className: 'measure-layout'

  initialize: ->
    @populations = @measure.get 'populations'

  context: ->
    _(super).extend
      cms_id: @measure.get('cqmMeasure').cms_id
      hqmf_set_id: @measure.get('cqmMeasure').hqmf_set_id
      measurePeriodYear: @measure.getMeasurePeriodYear()
      component: @measure.get('cqmMeasure').component
      cql: true # Hide certain features in handlebars if the measure is cql.

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

  changeMeasurementPeriod: (e) ->
    measurementPeriodView = new Thorax.Views.MeasurementPeriod(model: @measure)
    measurementPeriodView.appendTo(@$el)
    measurementPeriodView.display()

class Thorax.Views.Measure extends Thorax.Views.BonnieView
  template: JST['measure']

  events:
    rendered: ->
      @convertPatientsView = new Thorax.Views.ConvertPatientsView() # Modal dialogs for converting
      @convertPatientsView.appendTo(@$el)

      @exportPatientsView = new Thorax.Views.ExportPatientsView() # Modal dialogs for exporting
      @exportPatientsView.appendTo(@$el)

      @exportJsonPatientsView = new  Thorax.Views.ExportJsonPatientsView() # Modal dialogs for JSON exporting
      @exportJsonPatientsView.appendTo(@$el)

      @$('.d3-measure-viz, .btn-viz-text').hide()
      @$('a[data-toggle="tooltip"]').tooltip()

  context: ->
    _(super).extend
      isPrimaryView: @isPrimaryView

  initialize: ->
    if bonnie.isPortfolio
      @measureMetadataView = new Thorax.Views.MeasureMetadataView model: @model
    # Determine which population logic view use
    populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @model, population: @population)

    # Determine which populations logic view to use
    if @populations.length > 1
      @logicView = new Thorax.Views.CqlPopulationsLogic model: @model, collection: @populations
      @logicView.setView populationLogicView
    else
      @logicView = populationLogicView

    @valueSetsView = new Thorax.Views.MeasureValueSets model: @model

    @populationCalculation = new Thorax.Views.PopulationCalculation(model: @population)
    @logicView.listenTo @populationCalculation, 'logicView:showCoverage', -> @showCoverage()
    @logicView.listenTo @populationCalculation, 'logicView:clearCoverage', -> @clearCoverage()

    @populationCalculation.listenTo @logicView, 'population:update', (population) -> @updatePopulation(population)
    @listenTo @logicView, 'population:update', (population) =>
      @$('.panel, .right-sidebar').animate(backgroundColor: '#fcf8e3').animate(backgroundColor: 'inherit')
      @$('.d3-measure-viz').empty()
      @$('.d3-measure-viz, .btn-viz-text').hide()
      @$('.btn-viz-chords').show()
    # FIXME: change the name of these events to reflect what the measure calculation view is actually saying
    @logicView.listenTo @populationCalculation, 'rationale:clear', -> @clearRationale()
    @logicView.listenTo @populationCalculation, 'rationale:show', (result) -> @showRationale(result)
    @measures = @model.collection

  updateMeasure: (e) ->
    importMeasureView = new Thorax.Views.ImportMeasure(model: @model)
    importMeasureView.appendTo(@$el)
    importMeasureView.display()

  sharePatients: (e) ->
    sharePatientsView = new Thorax.Views.SharePatients(model: @model, measures: new Thorax.Collections.Measures(@model.collection))
    sharePatientsView.appendTo(@$el)
    sharePatientsView.display()

  convertQdmPatients: (e) ->
    @convertPatientsView.converting()

    $.fileDownload "patients/convert_patients?hqmf_set_id=#{@model.get('cqmMeasure').hqmf_set_id}",
      successCallback: => @convertPatientsView.success()
      failCallback: => @convertPatientsView.fail()
      httpMethod: "POST"
      data: {authenticity_token: $("meta[name='csrf-token']").attr('content')}

  exportJsonPatients: (e) ->
    @exportJsonPatientsView.export()

    $.fileDownload "patients/json_export?hqmf_set_id=#{@model.get('cqmMeasure').hqmf_set_id}",
      successCallback: => @exportJsonPatientsView.success()
      failCallback: => @exportJsonPatientsView.fail()
      httpMethod: "POST"
      data: {authenticity_token: $("meta[name='csrf-token']").attr('content')}

  importJsonPatients: (e) ->
    importJsonPatients = new Thorax.Views.ImportJsonPatients(model: @model, measures: new Thorax.Collections.Measures(@model.collection))
    importJsonPatients.appendTo(@$el)
    importJsonPatients.display()

  exportQrdaPatients: (e) ->
    @exportPatientsView.exporting()

    @model.get('populations').whenDifferencesComputed =>
      differences = []
      @model.get('populations').each (population) ->
        differences.push(_(population.differencesFromExpected().toJSON()).extend(population.coverage().toJSON()))

      $.fileDownload "patients/qrda_export?hqmf_set_id=#{@model.get('cqmMeasure').hqmf_set_id}",
        successCallback: => @exportPatientsView.qrdaSuccess()
        failCallback: => @exportPatientsView.fail()
        httpMethod: "POST"
        data: {authenticity_token: $("meta[name='csrf-token']").attr('content'), results: differences}

  exportExcelPatients: (e) ->
    @exportPatientsView.exporting()
    calc_results = {}
    patient_details = {}
    population_details = {}
    statement_details = CQLMeasureHelpers.buildDefineToFullStatement(@model.get('cqmMeasure'))
    file_name = @model.get('cqmMeasure').cms_id
    # Loop iterates over the populations and gets the calculations for each population.
    # From this it builds a map of pop_key->patient_key->results
    for pop in @model.get('populations').models
      for patient in @model.get('patients').models
        if calc_results[pop.cid] == undefined
          calc_results[pop.cid] = {}
        # Re-calculate results before excel export (we need to include pretty result generation)
        bonnie.calculator_selector.clearResult pop, patient
        result = pop.calculate(patient, {doPretty: true})
        result_criteria = {}
        for pop_crit of result.get('population_relevance')
          result_criteria[pop_crit] = result.get(pop_crit)
        expectedValues = patient.getExpectedValues(@model);
        camMeasure = this.model.get('cqmMeasure')
        # update observations for ratio scoring
        if (camMeasure.measure_scoring == 'RATIO')
          expectedValues = @correctExpectedRatioObservations(expectedValues.models)
          if (camMeasure.calculation_method == 'EPISODE_OF_CARE')
            result_criteria['observation_values'] = @getEpisodeBasedObservations(result)
          else
            result_criteria['observation_values'] = @getPatientBsedObservations(result, pop.get('index'))

        calc_results[pop.cid][patient.cid] = {statement_results: @removeExtra(result.get("statement_results")), criteria: result_criteria}
        # Populates the patient details
        if (patient_details[patient.cid] == undefined)
          patient_details[patient.cid] = {
            first: patient.getFirstName()
            last: patient.getLastName()
            expected_values: expectedValues
            birthdate: patient.getBirthDate()
            expired: patient.get("expired")
            deathdate: patient.getDeathDate()
            ethnicity: patient.getEthnicity().code
            race: patient.getRace().code
            gender: patient.getGender().code
            notes: patient.getNotes()
          }
        # Populates the population details
        if (population_details[pop.cid] == undefined)
          population_details[pop.cid] = {title: pop.get("title"), statement_relevance: result.get("statement_relevance")}
          criteria = pop.populationCriteria()
          if pop.get('observations')?.length > 0
            criteria.push('OBSERV')
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
        measure_hqmf_set_id: @model.get('cqmMeasure').hqmf_set_id
      }

  correctExpectedRatioObservations: (expectedValues) ->
    return expectedValues.map((expectedValue) =>
      copy = $.extend({}, expectedValue);
      denomObs = expectedValue.get('DENOM_OBSERV') || []
      numerObs = expectedValue.get('NUMER_OBSERV') || []
      copy.set('OBSERV', [denomObs..., numerObs...])
      copy
    )

  getEpisodeBasedObservations: (result) ->
    if (result)
      denomObs = []
      numerObs = []
      for episodeId of result.get('episode_results')
        episodeResult = result.get('episode_results')[episodeId]
        if episodeResult['DENOM'] && !episodeResult['DENEX']
          denomObs.push(episodeResult.observation_values[0]) # denom obs is at 0 index always
        if episodeResult['NUMER'] && !episodeResult['NUMEX']
          numerObs.push(episodeResult.observation_values[1]) # numer obs is at 1 index always
      return [denomObs..., numerObs...]
    else
      return []

  getPatientBsedObservations: (result, groupIndex) ->
    observations = result.get('observation_values')
    if observations
      obsByGroups = ArrayHelpers.chunk([observations...], 2)
      currentGroupObs = obsByGroups[groupIndex]
      if currentGroupObs
        if (!result.get('DENOM') || result.get('DENEX'))
          currentGroupObs.shift() # remove first element because denom obs is first in the list
        if !result.get('NUMER') || result.get('NUMEX')
          currentGroupObs.pop() # remove last element because numer obs is last in the list
        return currentGroupObs
    return []

  # Iterates through the results to remove extraneous fields.
  removeExtra: (results) ->
    ret = {}
    for libKey of results
      ret[libKey] = {}
      for statementKey of results[libKey]
        if results[libKey][statementKey].pretty
          ret[libKey][statementKey] = results[libKey][statementKey].pretty
        else
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

  deleteAllPatients: (e) ->
    sharedPatients = @model.get('patients').filter( (p) -> p.get('cqmPatient').measure_ids.length > 1 )
    if (sharedPatients?.length)
      bonnie.showError(
        title: 'Error',
        body: 'Cannot delete Patients. Some of your Patients are shared with other measures.')
    else
      deleteDialog = new Thorax.Views.DeleteAllPatientsDialog(model: @model)
      deleteDialog.appendTo($('#bonnie'))
      deleteDialog.display()

class Thorax.Views.MeasureMetadataView extends Thorax.Views.BonnieView
  template: JST['measure/measure_metadata']

  initialize: ->
    @hqmf_version_number = @model.get('cqmMeasure').hqmf_version_number
    @cql_libraries = @model.get('cqmMeasure').cql_libraries
