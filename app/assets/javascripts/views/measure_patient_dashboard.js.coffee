class Thorax.Views.MeasurePatientDashboardLayout extends Thorax.LayoutView
  template: JST['measure/patient_dashboard_layout']
  className: 'patient-dashboard-layout'

  switchPopulation: (e) ->
    @population = $(e.target).model()
    @population.measure().set('displayedPopulation', @population)
    @setView new Thorax.Views.MeasurePopulationPatientDashboard(measure: population.measure(), population: @population)
    @trigger 'population:update', @population

  populationContext: (population) ->
    _(population.toJSON()).extend
      isActive:  population is population.measure().get('displayedPopulation')
      populationTitle: population.get('title') || population.get('sub_id')

  setView: (view) ->
    results = @population.calculationResults()
    results.calculationsComplete =>
      view.results = results
      super(view)

class Thorax.Views.MeasurePopulationPatientDashboard extends Thorax.Views.BonnieView
  template: JST['measure/patient_dashboard']
  className: 'patient-dashboard'

  initialize: ->
    #Grab all populations related to this measure
    @patientEditView = new Thorax.Views.MeasurePatientEditModal(dashboard: this)

    codes = (population['code'] for population in @measure.get('measure_logic'))
    @populations = _.intersection(Thorax.Models.Measure.allPopulationCodes, codes)

    @pd = new Thorax.Models.PatientDashboard(@measure,@populations,@population)

    @FIXED_ROWS = 2
    @FIXED_COLS = @getFixedColumnCount()

    @editableRows = [] # used to ensure rows marked for inline editing stay that way after re-render

    @editableCols = @getEditableCols() # these are the fields that should be inline editable

    @results = @population.calculationResults()
    @results.calculationsComplete =>
      @patientResults = @results.toJSON()
      container = @$('#patient_dashboard_table').get(0)
      patients = @measure.get('patients')
      patientData = @createData(patients)
      @widths = @getColWidths()
      @head1 = patientData.slice(0,1)[0]
      @head2 = patientData.slice(1,2)[0]
      @data = patientData.slice(2)

  context: ->
    _(super).extend
      patients: @data
      head1: @head1
      head2: @head2
      widths: @widths

  events:
    rendered: ->
      $('.container').removeClass('container').addClass('container-fluid')
      @patientEditView.appendTo(@$el)
    destroyed: ->
      $('.container-fluid').removeClass('container-fluid').addClass('container')

    ready: ->
      table = $('#patientDashboardTable').DataTable({
        autoWidth: false,
        columns: @getColWidths(),
        scrollX: true,
        scrollY: "500px",
        paging: false,
        fixedColumns: { leftColumns: 5 }
        })

  getColWidths: ()  =>
    colWidths = []
    for dataKey in @pd.dataIndices
      colWidths.push(@pd.getWidth(dataKey))
    colWidths

  createData: (patients) =>
    data = []
    headers = @createHeaderRows(patients)
    data.push(headers[0])
    data.push(headers[1])

    @createPatientRows(patients, data)

    return data

  # TODO: this should be done differently and more dynamically
  getFixedColumnCount: () =>
    @pd.getCollectionLastIndex('expected') + 1

  getEditableCols:() =>
    #editableFields = ["first", "last", "notes", "birthdate", "ethnicity", "race", "gender", "deathdate"]
    editableFields = ["first", "last", "notes", "birthdate", "gender", "deathdate"]
    editableCols = []

    for editableField in editableFields
      editableCols.push(@pd.getIndex(editableField))

    # make expected population results editable
    for population in @populations
      editableCols.push(@pd.getIndex('expected' + population))

    return editableCols

  makeInlineEditable: ->
    console.log 'edit'
    # do something here

  openEditDialog: ->
    console.log 'open'
    # show @patientEditView

  createHeaderRows: (patients) =>
    row1 = []
    row2 = []

    for data in @pd.dataIndices
      row2.push(@pd.getName(data))

    row1.push('') for i in [1..row2.length]

    for key, dataCollection of @pd.dataCollections
      row1[dataCollection.firstIndex] = dataCollection.name

    [row1, row2]

  createPatientRows: (patients, data) =>
    for patient, i in patients.models
      patientRow = @createPatientRow(patient);
      data.push(patientRow);

  createPatientRow: (patient) =>
    patient_values = []

    patient_result = @matchPatientToPatientId(patient.id)

    expectedResults = @getExpectedResults(patient)
    actualResults = @getActualResults(patient_result)

    for dataType in @pd.dataIndices
      key = @pd.getRealKey(dataType)
      # TODO: How to make these buttons trigger events??
      if dataType == 'edit'
        patient_values.push('
          <button class="btn btn-xs btn-primary" data-call-method="makeInlineEditable">
            <i aria-hidden="true" class="fa fa-fw fa-pencil"></i>
            <span class="sr-only">Edit this patient inline</span>
          </button>')
      else if dataType == 'open'
        patient_values.push('
          <button class="btn btn-xs btn-default" data-call-method="openEditDialog">Open...</button>')
      else if dataType == 'result'
        patient_values.push(@isPatientPassing(expectedResults, actualResults))
      else if @pd.isExpectedValue(dataType)
        value = expectedResults[key]
        if value != actualResults[key]
          value = "__WARN__" + value # TODO: this is a hack to show discrepencies with expected/actual. work out better way to do this
        patient_values.push(value)
      else if @pd.isActualValue(dataType)
        value = actualResults[key]
        if value != expectedResults[key]
          value = "__WARN__" + value # TODO: this is a hack to show discrepencies with expected/actual. work out better way to do this
        patient_values.push(value)
      # else if dataType == 'ethnicity'
      #   patient_values.push(@ethnicity_map[patient.get(key)])
      # else if dataType == 'race'
      #   patient_values.push(@race_map[patient.get(key)])
      else if (key == 'birthdate' || key == 'deathdate') && patient.get(key) != null
        patient_values.push(moment.utc(patient.get(key), 'X').format('L'))
      else if @pd.isCriteria(dataType)
        population = @pd.getCriteriaPopulation(dataType)
        patient_values.push(@getPatientCriteriaResult(key, population, patient_result))
      else
        patient_values.push(patient.get(dataType))

    patient_values

  matchPatientToPatientId: (patient_id) =>
    patient = @results.findWhere({patient_id: patient_id}).toJSON()

  isPatientPassing: (expectedResults, actualResults) =>
    for population in @populations
      if expectedResults[population] != actualResults[population]
        return 'FALSE'
    return 'TRUE'

  getExpectedResults: (patient) =>
    expectedResults = {}
    expected_model = (model for model in patient.get('expected_values').models when model.get('measure_id') == @measure.get('hqmf_set_id') && model.get('population_index') == @population.get('index'))[0]

    for population in @populations
      if population not in expected_model.keys()
        expectedResults[population] = ' '
      else
        expectedResults[population] = expected_model.get(population)

    expectedResults

  getActualResults: (patient_result) =>
    actualResults = {}

    for population in @populations
      # TODO: check this logic
      if population == 'OBSERV'
        if 'values' of patient_result && population of patient_result['rationale']
          actualResults[population] = patient_result['values'].toString()
        else
          actualResults[population] = 0
        if !actualResults[population]
          # TODO: if the OBSERV value was undefined, the rendering messed up previously.
          # this fixes that but we should potentially take another approach.
          # e.g. make it so a cell can better handle an empty value. Put something other than a blank here. Etc.
          actualResults[population] = " "
      else if population of patient_result
        actualResults[population] = patient_result[population]
      else
        actualResults[population] = ' '

    actualResults

  getPatientCriteriaResult: (criteriaKey, population, patientResult) =>
    # TODO: check this logic
    if criteriaKey of patientResult['rationale']
      value = patientResult['rationale'][criteriaKey]
      if value != null && value != 'false' && value != false
        result = 'TRUE'
      else if value == 'false' || value == false
        result = 'FALSE'

      value = result

      if 'specificsRationale' of patientResult && population of patientResult['specificsRationale']
        specific_value = patientResult['specificsRationale'][population][criteriaKey]
        if specific_value == false  && value == 'TRUE'
          result = 'SPECIFICALLY FALSE'
        else if specific_value == true && value == 'FALSE'
          result = 'SPECIFICALLY TRUE'

    else
      result = ''

    result

class Thorax.Views.MeasurePatientEditModal extends Thorax.Views.BonnieView
  template: JST['measure/patient_edit_modal']

  events:
    'ready': 'setup'

  setup: ->
    @editDialog = @$("#patientEditModal")

  display: (model, measure, patients, measures) ->
    @patientBuilderView = new Thorax.Views.PatientBuilder(model: model, measure: measure, patients: patients, measures: measures, showCompleteView: false)
    @patientBuilderView.appendTo(@$('.modal-body'))
    @editDialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true).find('.modal-dialog').css('width','80%') # The same width defined in $modal-lg

  save: (e)->
    @patientBuilderView.save(e)
    @editDialog.modal('hide')
    @$('.modal-body').empty() # clear out patientBuilderView
    # @dashboard.createTable()

  close: ->
    @$('.modal-body').empty() # clear out patientBuilderView
