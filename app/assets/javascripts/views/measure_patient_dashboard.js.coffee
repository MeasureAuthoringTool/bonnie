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
      # Create column access info for use by DataTables
      @tableColumns = @getTableColumns(@patientData?[0])
      # Initialize patient dashboard using DataTables
      table = $('#patientDashboardTable').DataTable(
        data: @patientData,
        columns: @tableColumns,
        scrollX: true,
        scrollY: "500px",
        paging: false,
        fixedColumns:
          leftColumns: 5
      )
      # Update actual warnings
      for i in [0..@patientData.length-1]
        @updateActualWarnings(i)

  ###
  @returns {Array} an array of "instructions" for each column in a row that
  tells patient dashboard how to display a PatientDashboardPatient properly
  ###
  getTableColumns: (patient) ->
    column = []
    width_index = 0
    if patient == null
      return column
    column.push data: 'edit', orderable: false, width: @widths[width_index++], defaultContent: $('#editButton').html()
    column.push data: 'open', orderable: false, width: @widths[width_index++], defaultContent: $('#openButton').html()
    column.push data: 'first', width: @widths[width_index++]
    column.push data: 'last', width: @widths[width_index++]
    column.push data: 'description', width: @widths[width_index++]
    for k, v of patient._expected
      column.push data: 'expected' + k, width: @widths[width_index++]
    for k, v of patient._actual
      column.push data: 'actual' + k, width: @widths[width_index++]
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
  getColWidths: ()  ->
    colWidths = []
    for dataKey in @pd.dataIndices
      colWidths.push(@pd.getWidth(dataKey))
    colWidths

  ###
  @returns {Object} a mapping of editable column field names to row indices
  ###
  getEditableCols: ->
    editableFields = ['first', 'last', 'description', 'birthdate', 'gender', 'deathdate']
    editableCols = {}
    # Add patient characteristics to editable fields
    for editableField in editableFields
      editableCols[editableField] = @pd.getIndex editableField
    # Add expecteds to editable fields #TODO: Should this be an option?
    # for population in @populations
    #   editableCols['expected' + population] = @pd.getIndex 'expected' + population
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
    $('#patientDashboardTable').DataTable().row(rowIndex).data(data).draw()
    $.fn.dataTable.tables(visible: true, api: true).columns.adjust().fixedColumns().relayout()

  ###
  Highlights the row at the given index
  ###
  selectRow: (rowIndex) ->
    nodes = $('#patientDashboardTable').DataTable().row(rowIndex).nodes()
    $(nodes).addClass('pdhighlight')
    $.fn.dataTable.tables(visible: true, api: true).columns.adjust().fixedColumns().update()

  ###
  Removes highlighting of the row at the given index
  ###
  deselectRow: (rowIndex) ->
    nodes = $('#patientDashboardTable').DataTable().row(rowIndex).nodes()
    $(nodes).removeClass('pdhighlight')
    $.fn.dataTable.tables(visible: true, api: true).columns.adjust().fixedColumns().update()

  ###
  Disables the patient builder modal button for the given row
  ###
  disableOpenButton: (row) ->
    openButton = $('#openButton').clone()
    $(':first-child', openButton).attr("disabled", true)
    row['open'] = openButton.html()

  ###
  Enables the patient builder modal button for the given row
  ###
  enableOpenButton: (row) ->
    row['open'] = $('#openButton').html()

  ###
  Updates actual warnings for a given row index
  ###
  updateActualWarnings: (rowIndex) ->
    nodes = $('#patientDashboardTable').DataTable().row(rowIndex).nodes()
    row = $('#patientDashboardTable').DataTable().row(rowIndex).data()
    for population in @populations
      actualIndex = (@pd.getIndex 'actual' + population) + 1
      td = $('td:nth-child(' + actualIndex + ')', nodes[0])
      if row['expected' + population] != row['actual' + population]
        td.addClass('pdwarn')
      else
        td.removeClass('pdwarn')

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

    # Clone the old patient in case the user decides to cancel their edits
    row['old'] = jQuery.extend(true, {}, row)

    for k, v of @editableCols
      if k in ['first', 'last', 'description']
        inputFieldDiv = $('#inputField').clone()
        $(':first-child', inputFieldDiv).prop('id', k + rowIndex).prop('name', k + rowIndex).addClass(k + rowIndex)
        row[k] = inputFieldDiv.html()
      else if k in ['birthdate', 'deathdate']
        inputDateDiv = $('#inputDate').clone()
        $(':first-child', inputDateDiv).prop('id', k + rowIndex).prop('name', k + rowIndex).addClass(k + rowIndex)
        row[k] = inputDateDiv.html()
      else if k == 'gender'
        if row[k] == 'M'
          inputGenderDiv = $('#inputGenderM').clone()
        else
          inputGenderDiv = $('#inputGenderF').clone()
        $(':first-child', inputGenderDiv).prop('id', k + rowIndex).prop('name', k + rowIndex).addClass(k + rowIndex)
        row[k] = inputGenderDiv.html()

    # Change edit button to save and cancel buttons
    row['edit'] = $('#saveEditButton').html() + $('#closeEditButton').html()

    # Disable open button
    @disableOpenButton(row)

    # Update row
    @setRow(rowIndex, row)
    @selectRow(rowIndex)

    # Set current values in added inputs
    for k, v of @editableCols
      if k != 'gender'
        $('.' + k + rowIndex).val(row['old'][k])

    # Make datepickers active
    $('.birthdate' + rowIndex).datepicker()
    $('.deathdate' + rowIndex).datepicker()


  ###
  Saves the inline edits made to a patient
  ###
  saveEdits: (sender) ->
    # Get row index of selected patient
    targetCell = sender?.currentTarget?.parentElement
    rowIndex = parseInt(targetCell?.getAttribute 'data-dt-row')
    if isNaN(rowIndex)
      return
    row = @getRow(rowIndex)

    # Remove the backup row
    delete row['old']

    # Get user inputs. Since the FixedColumns plugin essentially adds another
    # whole table above a few columns of the original, these inputs are
    # actually duplicated, and changes are only registered in the top table.
    # Because of this added complexity, we need to be certain we are grabbing
    # the correct values.
    inputs = $(':input').serializeArray()
    inputGroups = []
    for k, v of @editableCols
      inputGroups.push inputs.filter (a) -> a.name == k + rowIndex
    for inputGroup in inputGroups
      different = false
      for input in inputGroup
        name = input.name.replace(rowIndex, '')
        if input.value != row[name]
          row[name] = input.value
          different = true
      unless different
        name = inputGroup?[0]?.name.replace(rowIndex, '')
        row[name?] = inputGroup?[0]?.value

    # Update Bonnie patient
    patient = _.findWhere(@measure.get('patients').models, id: row.id)
    for k, v of @editableCols
      if k == 'birthdate'
        patient.set(k, parseInt(moment.utc(row[k], 'L LT').format('X')) + row['birthtime'])
      else if k == 'deathdate'
        patient.set(k, parseInt(moment.utc(row[k], 'L LT').format('X')) + row['deathtime'])
      else
        patient.set(k, row[k])

    # Update row on recalculation
    result = @population.calculateResult patient
    result.calculationsComplete =>
      @updateActualWarnings(rowIndex)
      row['edit'] = $('#editButton').html()
      @enableOpenButton(row)
      @patientData[rowIndex] = row
      @setRow(rowIndex, row)
      @deselectRow(rowIndex)

  ###
  Cancels the edits made to an inline patient
  ###
  cancelEdits: (sender) ->
    # Get row index of selected patient
    targetCell = sender?.currentTarget?.parentElement
    rowIndex = parseInt(targetCell?.getAttribute 'data-dt-row')
    if isNaN(rowIndex)
      return
    row = @getRow(rowIndex)
    @setRow(rowIndex, row['old'])

    # Remove row selection
    @deselectRow(rowIndex)

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
    patient = _.findWhere(@measure.get('patients').models, {id: row.id})
    @patientEditView.display patient, rowIndex

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

  display: (patient, rowIndex) ->
    @patient = patient
    @rowIndex = rowIndex
    @measure = @dashboard.measure
    @population = @dashboard.population
    @populations = @dashboard.populations
    @patients = @measure.get('patients')
    @measures = @measure.collection

    @patientBuilderView = new Thorax.Views.PatientBuilder model: patient, measure: @measure, patients: @patients, measures: @measures, showCompleteView: false
    @patientBuilderView.appendTo(@$('.modal-body'))
    $("#saveButton").prop('disabled', false) # Save button was being set to disabled
    @editDialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true).find('.modal-dialog').css('width','80%') # The same width defined in $modal-lg

  save: (e)->
    @patientBuilderView.save(e)
    @editDialog.modal('hide')
    @$('.modal-body').empty() # clear out patientBuilderView
    @result = @population.calculateResult @patient
    @result.calculationsComplete =>
      @patientResult = @result.toJSON()[0] #Grab the first and only item from collection
      @patientData = new Thorax.Models.PatientDashboardPatient @patient, @dashboard.pd, @measure, @patientResult, @populations, @population
      $('#patientDashboardTable').DataTable().row(@rowIndex).data(@patientData)

  close: ->
    @$('.modal-body').empty() # clear out patientBuilderView
