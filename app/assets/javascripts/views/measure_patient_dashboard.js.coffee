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

    @nonEmptyPopulations = []
    for pop in @populations
      if @pd.criteriaKeysByPopulation[pop].length > 0
        @nonEmptyPopulations.push pop

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
        deferRender: true,
        scrollX: true,
        scrollY: "700px",
        paging: false,
        fixedColumns:
          leftColumns: 5
        initComplete: (settings, json) ->
          $('.dataTables_scrollBody thead tr').css(visibility: 'collapse')
      )
      # Update actual warnings
      @updateAllActualWarnings()

      # Attaches popover to datacriteria class.
      $('.table-popover-div').popover({delay: {"show": 500, "hide": 100}})

  ###
  @returns {Array} an array of "instructions" for each column in a row that
  tells patient dashboard how to display a PatientDashboardPatient properly
  ###
  getTableColumns: (patient) ->
    column = []
    width_index = 0
    column.push data: 'edit', orderable: false, width: @widths[width_index++], defaultContent: $('#editButton').html()
    column.push data: 'open', orderable: false, width: @widths[width_index++], defaultContent: $('#openButton').html()
    column.push data: 'first', width: @widths[width_index++], className: 'limited'
    column.push data: 'last', width: @widths[width_index++], className: 'limited'
    column.push data: 'description', width: @widths[width_index++], className: 'limited'
    for population in @populations
       column.push data: 'expected' + population, width: @widths[width_index++]
     for population in @populations
       column.push data: 'actual' + population, width: @widths[width_index++]
    column.push data: 'passes', width: @widths[width_index++]
    column.push data: 'birthdate', width: @widths[width_index++]
    column.push data: 'deathdate', width: @widths[width_index++]
    column.push data: 'gender', width: @widths[width_index++]
    # Collect all actual data criteria and sort to make sure patient dashboard
    # displays dc in the correct order.
    dcStartIndex = @pd._dataInfo['gender'].index + 1
    dc = []
    for k, v of @pd.dataCollections
      if v.firstIndex >= dcStartIndex
          dc = dc.concat v.items
    for entry in dc
      column.push data: entry, width: @widths[width_index++], render: @insertTextAndPatientData
    column

  ###
  Populates the Popover with children data criteria if they exist and populates
  the table cells with the datacriteria value.
  ###
  insertTextAndPatientData: (data, type, row, meta) ->
    cloneElement = $('.table-popover-container').clone()
    if data != ""
      if data == 'SPECIFICALLY FALSE'
        $('.table-cell-popover-div', cloneElement).html($('#dcSpecFalse').html() + ' ' + data)
        $('.table-cell-popover-div', cloneElement).addClass('text-danger')
      else if data == 'FALSE'
        $('.table-cell-popover-div', cloneElement).html($('#dcFalse').html() + ' ' + data)
        $('.table-cell-popover-div', cloneElement).addClass('text-danger')
      else
        $('.table-cell-popover-div', cloneElement).html($('#dcTrue').html() + ' ' + data)
        $('.table-cell-popover-div', cloneElement).addClass('text-success')
      $('.table-cell-popover-div', cloneElement).attr('patientId', row.id)
      $('.table-cell-popover-div', cloneElement).attr('columnNumber', meta.col)
      cloneElement.html()
    else
      return ''

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
  @returns {PatientDashboardPatient} given something that identifies a row
  (see: https://datatables.net/reference/type/row-selector), returns
  the corresponding PatientDashboardPatient
  ###
  getRowData: (id) ->
    $('#patientDashboardTable').DataTable().row(id).data()

  ###
  @returns {PatientDashboardPatient} given something that identifies a row
  (see: https://datatables.net/reference/type/row-selector), returns
  the corresponding index of this row
  ###
  getRowIndex: (id) ->
    $('#patientDashboardTable').DataTable().row(id).index()

  ###
  Sets the row at the given index to a PatientDashboardPatient
  ###
  setRowData: (rowIndex, data) ->
    $('#patientDashboardTable').DataTable().row(rowIndex).data(data)
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
  Scrolls the table to a particular population
  ###
  scrollToPopulation: (sender) ->
    pop = sender?.currentTarget.innerText
    $('.dataTables_scrollBody').scrollTo($('#' + pop), offset: left: -@pd.getHorizontalScrollOffset())

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
  Updates actual warnings for all rows
  ###
  updateAllActualWarnings: ->
    if @patientData.length > 0 # Check if the list is populated.
      for i in [0..@patientData.length-1]
        @updateActualWarnings(i)

  ###
  Makes a patient row inline editable
  ###
  makeInlineEditable: (sender) ->
    # Get row index and data of selected patient
    targetCell = sender?.currentTarget?.parentElement
    row = @getRowData(targetCell)
    rowIndex = @getRowIndex(targetCell)

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
    @setRowData(rowIndex, row)
    @selectRow(rowIndex)

    # Set current values in added inputs
    for k, v of @editableCols
      if k != 'gender'
        $('.' + k + rowIndex).val(row['old'][k])

    # Make datepickers active
    $('.birthdate' + rowIndex).datepicker()
    $('.deathdate' + rowIndex).datepicker()
    # Attaches popover to datacriteria class.
    $('.table-popover-div').popover({delay: {"show": 500, "hide": 100}})


  ###
  Saves the inline edits made to a patient
  ###
  saveEdits: (sender) ->
    # Get row index and data of selected patient
    targetCell = sender?.currentTarget?.parentElement
    row = @getRowData(targetCell)
    rowIndex = @getRowIndex(targetCell)

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
      patient.save patient.toJSON()
      @updateActualWarnings(rowIndex)
      row['edit'] = $('#editButton').html()
      @enableOpenButton(row)
      @patientData[rowIndex] = row
      @setRowData(rowIndex, row)
      @deselectRow(rowIndex)
      # Attaches popover to datacriteria class.
      $('.table-popover-div').popover({delay: {"show": 500, "hide": 100}})

  ###
  Cancels the edits made to an inline patient
  ###
  cancelEdits: (sender) ->
    # Get row index and data of selected patient
    targetCell = sender?.currentTarget?.parentElement
    row = @getRowData(targetCell)
    rowIndex = @getRowIndex(targetCell)
    @setRowData(rowIndex, row['old'])
    # Remove row selection
    @deselectRow(rowIndex)
    # Attaches popover to datacriteria class.
    $('.table-popover-div').popover({delay: {"show": 500, "hide": 100}})

  ###
  Opens the full patient builder modal for more advanced patient editing
  ###
  openEditDialog: (sender) ->
    # Get row index and data of selected patient
    targetCell = sender?.currentTarget?.parentElement
    row = @getRowData(targetCell)
    rowIndex = @getRowIndex(targetCell)
    patient = _.findWhere(@measure.get('patients').models, {id: row.id})
    @patientEditView.display patient, rowIndex

  ###
  Grabs the children data criteria to display in a list for the selected cell.
  ###
  populatePopover: (sender) ->
    dataCriteria = @pd.dataIndices[$(sender.target).attr('columnNumber')] # Formatted "PopulationKey_DataCriteriaKey"
    dataCriteriaKey = dataCriteria.substring(dataCriteria.indexOf('_') + 1)
    populationKey = dataCriteria.substring(0, dataCriteria.indexOf('_'))
    children_criteria = @pd.getChildrenCriteria dataCriteriaKey
    patientResult = @matchPatientToPatientId($(sender.target).attr('patientId'))

    if Object.keys(children_criteria).length > 0
      formatCriteria = '<div class="tableScrollContainerList"><ul class="popover-ul">'
      for childDataCriteriaKey, childDataCriteriaText of children_criteria
        if patientResult.rationale[childDataCriteriaKey]? && childDataCriteriaKey != dataCriteriaKey
          # Searches patientDashboardPatients on patient id.
          patientDashboardPatient = (patient for patient in @patientData when patient.id == $(sender.target).attr('patientId'))[0]
          result = patientDashboardPatient.getPatientCriteriaResult childDataCriteriaKey, populationKey
          if result == "SPECIFICALLY FALSE"
            formatCriteria += '<li class="popover-eval-specifics-li">' + childDataCriteriaText + '</li>'
          else if result == 'TRUE'
            formatCriteria += '<li class="popover-eval-true-li">' + childDataCriteriaText + '</li>'
          else if result == 'FALSE'
            formatCriteria += '<li class="popover-eval-false-li">' + childDataCriteriaText + '</li>'
      formatCriteria += '</ul></div>'
    else
      formatCriteria = "No Children Data Criteria"

    $(sender.currentTarget).attr('data-content', formatCriteria)

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

  ###
  Opens up a patient edit modal to create a new patient.
  ###
  createNewPatient: (sender) ->
    patient = new Thorax.Models.Patient {measure_ids: [@measure.get('hqmf_set_id')]}, parse: true
    @patientEditView.display patient, null #Set rowIndex to null because it is a new patient.

  ###
  Updates the results object and patientData array with new patient data or updated patient data.
  ###
  updatePatientDataSources: (currentResult, currentPatient) =>
    # Add result to results collection
    @results.add currentResult.models

    # Add patient to patient data
    hasPatient = false
    for patient, index in @patientData
      if patient.id == currentPatient.id
        @patientData[index] = currentPatient
        hasPatient = true
        break
    unless hasPatient
      @patientData.push currentPatient


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

  save: (e) ->
    # Save via patient builder, sending a callback so we can ensure we get a patient with the ID set
    @patientBuilderView.save e, success: (patient) =>
      @editDialog.modal('hide')
      @$('.modal-body').empty() # clear out patientBuilderView
      @result = @population.calculateResult patient
      @result.calculationsComplete =>
        @patientResult = @result.toJSON()[0] #Grab the first and only item from collection
        @patientData = new Thorax.Models.PatientDashboardPatient patient, @dashboard.pd, @measure, @patientResult, @populations, @population
        if @rowIndex?
          $('#patientDashboardTable').DataTable().row(@rowIndex).data(@patientData).draw()
        else
          $('#patientDashboardTable').DataTable().row.add(@patientData).draw()
        $('.table-popover-div').popover({delay: {"show": 500, "hide": 100}})
        @dashboard.updatePatientDataSources @result, @patientData
        @dashboard.updateAllActualWarnings()

  close: ->
    @$('.modal-body').empty() # clear out patientBuilderView
