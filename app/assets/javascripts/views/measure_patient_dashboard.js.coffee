class Thorax.Views.MeasurePatientDashboardLayout extends Thorax.LayoutView
  template: JST['measure/patient_dashboard_layout']
  className: 'patient-dashboard-layout'

  switchPopulation: (e) ->
    @population = $(e.target).model()
    @population.measure().set('displayedPopulation', @population)
    @setView new Thorax.Views.MeasurePopulationPatientDashboard measure: @population.measure(), population: @population
    @trigger 'population:update', @population

  populationContext: (population) ->
    _(population.toJSON()).extend
      isActive: population is population.measure().get('displayedPopulation')
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
    # Grab all populations related to this measure
    codes = (population['code'] for population in @measure.get('measure_logic'))
    @populations = _.intersection(Thorax.Models.Measure.allPopulationCodes, codes)

    # Create patient dashboard layout and patient editor modal
    @patientEditView = new Thorax.Views.MeasurePatientEditModal(dashboard: this)
    @pd = new Thorax.Models.PatientDashboard @measure, @populations, @population

    # Keep track of editable rows and columns
    @editableRows = []
    @editableCols = @getEditableCols()

    # Get patient calculation results
    @results = @population.calculationResults()
    @results.calculationsComplete =>
      @patientResults = @results.toJSON()
      patientData = @createHeaderRows()
      @widths = @getColWidths()
      @head1 = patientData.slice(0, 1)[0]
      @head2 = patientData.slice(1, 2)[0]

  context: ->
    _(super).extend
      patients: @patientData
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
      # On ready, create a PatientDashboardPatient for each patient, these are
      # used for each row in patient dashboard.
      @patientData = []
      for patient in @measure.get('patients').models
        @patientData.push new Thorax.Models.PatientDashboardPatient patient, @pd, @measure, @matchPatientToPatientId(patient.id), @populations, @population
      # Initialize patient dashboard using DataTables
      table = $('#patientDashboardTable').DataTable({
        data: @patientData,
        columns: @getTableColumns(@patientData[0]),
        scrollX: true,
        scrollY: "500px",
        paging: false,
        fixedColumns: { leftColumns: 5 }
      })

  ###
  @returns {Array} an array of "instructions" for each column in a row that
  tells patient dashboard how to display a PatientDashboardPatient properly
  ###
  getTableColumns: (patient) ->
    column = []
    width_index = 0
    if patient == null
      return column
    column.push data: null, width: @widths[width_index++], defaultContent: $('#editButton').html()
    column.push data: null, width: @widths[width_index++], defaultContent: $('#openButton').html()
    column.push data: 'firstname', width: @widths[width_index++]
    column.push data: 'lastname', width: @widths[width_index++]
    column.push data: 'description', width: @widths[width_index++]
    for k, v of patient._expected
      column.push data: 'expected_' + k, width: @widths[width_index++]
    for k, v of patient._actual
      column.push data: 'actual_' + k, width: @widths[width_index++]
    column.push data: 'passes', width: @widths[width_index++]
    column.push data: 'birthdate', width: @widths[width_index++]
    column.push data: 'deathdate', width: @widths[width_index++]
    column.push data: 'gender', width: @widths[width_index++]
    # Collect all actual data criteria and sort to make sure patient dashboard
    # displays dc in the correct order.
    dcStartIndex = @pd._dataInfo['gender'].index + 1
    dc = []
    for k, v of @pd._dataInfo
      if v.index >= dcStartIndex
        v['name'] = k
        dc.push v
    dc.sort (a, b) -> a.index - b.index
    for entry in dc
      column.push data: entry.name, width: @widths[width_index++]
    column

  ###
  @returns {Array} an array of widths for each column in patient dashboard
  ###
  getColWidths: ()  =>
    colWidths = []
    for dataKey in @pd.dataIndices
      colWidths.push(@pd.getWidth(dataKey))
    colWidths

  ###
  @returns {Object} a mapping of editable column field names to row indices
  ###
  getEditableCols: =>
    editableFields = ['first', 'last', 'notes', 'birthdate', 'gender', 'deathdate']
    editableCols = {}
    # Add patient characteristics to editable fields
    for editableField in editableFields
      editableCols[editableField] = @pd.getIndex editableField
    # Add expecteds to editable fields
    for population in @populations
      editableCols['expected' + population] = @pd.getIndex 'expected' + population
    return editableCols

  ###
  @returns {PatientDashboardPatient} given a row index, returns the
  PatientDashboardPatient contained in that row
  ###
  getRow: (rowIndex) ->
    $('#patientDashboardTable').DataTable().row(rowIndex).data()

  ###
  Sets a row to a PatientDashboardPatient
  ###
  setRow: (rowIndex, data) ->
    $('#patientDashboardTable').DataTable().row(rowIndex).data(data)

  ###
  Makes a patient row inline editable
  ###
  makeInlineEditable: (sender) ->
    # Get row index of selected patient
    targetCell = sender?.currentTarget?.parentElement
    rowIndex = parseInt(targetCell?.getAttribute 'data-dt-row')
    if isNaN(rowIndex)
      return
    row = @getRow(rowIndex)

    # TODO: Adam

    # Change edit button to save and cancel buttons
    targetCell.innerHTML = $('#saveEditButton').html() + $('#closeEditButton').html()

  ###
  Saves the inline edits made to a patient
  ###
  saveEdits: (sender) ->
    sender.currentTarget.parentElement.innerHTML = $('#editButton').html()
    # TODO: Adam

  ###
  Cancels the edits made to an inline patient
  ###
  cancelEdits: (sender) ->
    sender.currentTarget.parentElement.innerHTML = $('#editButton').html()
    # TODO: Adam

  ###
  Opens the full patient builder modal for more advanced patient editing
  ###
  openEditDialog: (sender) ->
    # Get row index of selected patient
    targetCell = sender?.currentTarget?.parentElement
    rowIndex = parseInt(targetCell?.getAttribute 'data-dt-row')
    if isNaN(rowIndex)
      return
    row = @getRow(rowIndex)
    # TODO: James

  ###
  @returns {Array} an array containing the contents of both headers
  ###
  createHeaderRows: ->
    row1 = []
    row2 = []
    for data in @pd.dataIndices
      row2.push(@pd.getName(data))
    row1.push('') for i in [1..row2.length]
    for key, dataCollection of @pd.dataCollections
      row1[dataCollection.firstIndex] = dataCollection.name
    [row1, row2]

  ###
  @returns {Object} the results for a given patient given that patient's id
  ###
  matchPatientToPatientId: (patient_id) =>
    patient = @results.findWhere({patient_id: patient_id}).toJSON()

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
