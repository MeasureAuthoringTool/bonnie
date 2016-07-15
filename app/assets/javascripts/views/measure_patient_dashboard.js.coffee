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
    @widths = @getColWidths()

    # Get patient calculation results
    @results = @population.calculationResults()
    @results.calculationsComplete =>
      @patientResults = @results
      headerData = @createHeaderRows()
      @head1 = headerData.slice(0, 1)[0]
      @head2 = headerData.slice(1, 2)[0]
      @columnsWithChildrenCriteria = @detectChildrenCriteria(@head2)

    # create a PatientDashboardPatient for each patient, these are
    # used for each row in patient dashboard.
    # TODO: Use a Thorax collection for this instead of array?
    @patientData = []
    for patient in @measure.get('patients').models
      @patientData.push new Thorax.Models.PatientDashboardPatient patient, @pd, @measure, @matchPatientToPatientId(patient.id), @populations, @population

  context: ->
    _(super).extend
      patients: @patientData
      head1: @head1
      head2: @head2
      widths: @widths

  events:
    'ready': 'setup'

    rendered: ->
      $('.container').removeClass('container').addClass('container-fluid')
      @patientEditView.appendTo(@$el)

    destroyed: ->
      $('.container-fluid').removeClass('container-fluid').addClass('container')

  setup: ->
    # Create column access info for use by DataTables
    @tableColumns = @getTableColumns(@patientData?[0])

    # Initialize patient dashboard using DataTables
    table = @$('#patientDashboardTable').DataTable(
      data: @patientData,
      columns: @tableColumns,
      dom: '<if<"scrolling-table"t>>', # places table info and filter, then table, then nothing
      deferRender: true,
      scrollX: true,
      scrollY: "600px",
      scrollCollapse: true,
      order: [], # disables initial sorting
      paging: false,
      fixedColumns:
        leftColumns: 2 + @populations.length
      preDrawCallback: => @updateDisplay()
    )

    # Removes the form-inline class from the wrapper so that inputs in our table can
    # take on full width. This is expected to be fixed in a future release of DataTables.
    @$('#patientDashboardTable_wrapper').removeClass('form-inline')
    @$('#patientDashboardTable_filter').addClass('form-inline') # Search input

  ###
  Performs some actions on the DOM to properly render popovers,
  patient names, and warnings
  ###
  updateDisplay: (rowIndex) =>
    # Update actual warnings
    if rowIndex
      @updateActualWarnings(rowIndex)
    else
      @updateAllActualWarnings()

  ###
  @returns {Array} an array of "instructions" for each column in a row that
  tells patient dashboard how to display a PatientDashboardPatient properly
  ###
  getTableColumns: (patient) ->
    column = []
    column.push data: 'passes'
    for population in @populations
      column.push data: 'actual' + population, className: 'value', render: @insertResultValue
    column.push data: 'actions'
    for population in @populations
      column.push data: 'expected' + population, className: 'value', render: @insertResultValue
    column.push data: 'description', className: 'limited'
    column.push data: 'birthdate'
    column.push data: 'deathdate'
    column.push data: 'gender'
    # Collect all actual data criteria and sort to make sure patient dashboard
    # displays dc in the correct order.
    dcStartIndex = @pd._dataInfo['gender'].index + 1
    dc = []
    for k, v of @pd.dataCollections
      if v.firstIndex >= dcStartIndex
          dc = dc.concat v.items
    for entry in dc
      column.push data: entry, render: @insertTextAndPatientData
    column

  ###
  Adjusts the result 0 and 1 to the more familiar checkboxes.
  TODO: Check the type of measure and adjust this method for it
  ###
  insertResultValue: (data, type, row, meta) =>
    if row
      JST['pd_result_checkbox']({ result: data })

  ###
  Populates the Popover with children data criteria if they exist and populates
  the table cells with the datacriteria value.
  ###
  insertTextAndPatientData: (data, type, row, meta) =>
    if data != ""
      popoverContent = @columnsWithChildrenCriteria[meta.col]
      return JST['pd_result_with_popover']({
        content: if popoverContent?
                   'TRUE'
                 else
                    ''
        columnNumber: meta.col
        patientId: row.id
        result: JST['pd_result_detail']({
          passes: data == "TRUE",
          specifically: data.indexOf('SPECIFICALLY') >= 0
        })
      })
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
    #editableFields = ['first', 'last', 'description', 'gender']
    editableFields = ['description', 'gender']
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
    $(nodes).addClass('active')
    $.fn.dataTable.tables(visible: true, api: true).columns.adjust().fixedColumns().update()

  ###
  Removes highlighting of the row at the given index
  ###
  deselectRow: (rowIndex) ->
    nodes = $('#patientDashboardTable').DataTable().row(rowIndex).nodes()
    $(nodes).removeClass('active')
    $.fn.dataTable.tables(visible: true, api: true).columns.adjust().fixedColumns().update()

  ###
  Scrolls the table to a particular population
  ###
  scrollToPopulation: (sender) ->
    pop = sender?.currentTarget.innerText
    @$('.dataTables_scrollBody').scrollTo($('#' + pop), offset: left: -@pd.getHorizontalScrollOffset())

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
        td.addClass('warn')
      else
        td.removeClass('warn')

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
    # TODO: Set keyboard focus on the newly editable elements!
    # Get row index and data of selected patient
    targetCell = sender?.currentTarget?.parentElement
    row = @getRowData(targetCell)
    rowIndex = @getRowIndex(targetCell)

    # Clone the old patient in case the user decides to cancel their edits
    row['old'] = jQuery.extend(true, {}, row)

    for k, v of @editableCols
      if k in ['description']
        row[k] = JST['pd_input_field']({ rowIndex: rowIndex, key: k })
      else if k == 'gender'
        row[k] = JST['pd_edit_gender']({ rowIndex: rowIndex, femaleSelected: row[k] == 'F' })

    # Change edit button to save and cancel buttons
    row['actions'] = JST['pd_edit_controls']({})

    # Update row
    @setRowData(rowIndex, row)
    @selectRow(rowIndex)

    # Set current values in added inputs
    for k, v of @editableCols
      if k != 'gender'
        $('[name=' + k + rowIndex + ']').val(row['old'][k])

    # Make datepickers active
    $('.birthdate' + rowIndex).datepicker()
    $('.deathdate' + rowIndex).datepicker()

    @updateDisplay(rowIndex)

  ###
  Saves the inline edits made to a patient
  ###
  saveEdits: (sender) ->
    # Get row index and data of selected patient
    targetCell = sender?.currentTarget?.parentElement
    row = @getRowData(targetCell)
    rowIndex = @getRowIndex(targetCell)

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
    patient = @getRowData(rowIndex).patient
    editedData = {}

    for k, v of @editableCols
      if k == 'description'
        editedData['notes'] = row[k]
      else
        editedData[k] = row[k]

    # Update row on recalculation
    patient.save editedData,
      success: (model) =>
        result = @population.calculateResult patient
        result.calculationsComplete =>
          row['actions'] = row['old']['actions']
          @patientData[rowIndex] = row
          @results.add result.first()
          @setRowData(rowIndex, row)
          @deselectRow(rowIndex)
          @updateDisplay(rowIndex)

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
    @updateDisplay()

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
  Shows the actions associated with each patient row.
  ###
  expandActions: (e) ->
    e.preventDefault()
    @$(e.currentTarget).next('.pd-settings').toggleClass('pd-settings-expanded')

  ###
  Shows the Delete button and cancel button
  ###
  showDelete: (sender) ->
    # Get row index and data of selected patient
    targetCell = sender?.currentTarget?.parentElement
    row = @getRowData(targetCell)
    rowIndex = @getRowIndex(targetCell)

    # Clone the old patient in case the user decides to cancel their edits
    row['old'] = jQuery.extend(true, {}, row)
    row['actions'] = JST['pd_delete_controls']({})
    @setRowData(rowIndex, row)

  ###
  Replaces the Delete button and cancel button with the actions button.
  ###
  hideDelete: (sender) ->
    # Get row index and data of selected patient
    targetCell = sender?.currentTarget?.parentElement
    row = @getRowData(targetCell)
    rowIndex = @getRowIndex(targetCell)
    @setRowData(rowIndex, row['old'])

  ###
  Removes patient from the table
  ###
  deletePatient: (sender) ->
    # Get row index and data of selected patient
    targetCell = sender?.currentTarget?.parentElement
    row = @getRowData(targetCell)
    rowIndex = @getRowIndex(targetCell)

    @removePatientFromDataSources(row)
    patient = _.findWhere(@measure.get('patients').models, {id: row.id})
    patient.destroy()
    $('#patientDashboardTable').DataTable().row(rowIndex).remove().draw()

  ###
  @returns {Array} an array of child criteria objects
  Grabs the children data criteria to display in a list for the selected cell.
  ###
  populatePopover: (sender) ->
    dataCriteria = @pd.dataIndices[$(sender.target).attr('columnNumber')] # Formatted "PopulationKey_DataCriteriaKey"
    dataCriteriaKey = dataCriteria.substring(dataCriteria.indexOf('_') + 1)
    populationKey = dataCriteria.substring(0, dataCriteria.indexOf('_'))
    children_criteria = @pd.getChildrenCriteria dataCriteriaKey
    patientResult = @matchPatientToPatientId($(sender.target).attr('patientId'))
    criteriaList = []

    for childDataCriteriaKey, childDataCriteriaText of children_criteria
      if childDataCriteriaKey != dataCriteriaKey
        patientDashboardPatient = _(@patientData).findWhere({ id: $(sender.target).attr('patientId') })
        result = patientDashboardPatient.getPatientCriteriaResult childDataCriteriaKey, populationKey

        criteriaList.push({
          text: childDataCriteriaText,
          passes: result == "TRUE",
          specifically: result.indexOf('SPECIFICALLY') >= 0
        })

    $(sender.currentTarget).attr('data-content', JST['pd_criteria_list']({ criteria: criteriaList}))
    # Attaches popover to currentTarget.
    $(sender.currentTarget).popover('show')

  ###
  @returns {Array} an array containing the contents of both headers
  ###
  createHeaderRows: =>
    row1 = []
    row1_full = []
    row2 = []
    for data in @pd.dataIndices
      row2.push(@pd.getName(data))
    row1_full.push('') for i in [1..row2.length]
    for key, dataCollection of @pd.dataCollections
      row1_full[dataCollection.firstIndex] = dataCollection.name
    # Construct the top header using colspans for the number of columns
    # they should cover
    for header, index in row1_full
      if !!header
        row1.push title: header, colspan: 1, width: @widths[index]
      else if row1[row1.length - 1]? and !!row1[row1.length - 1].title
        row1[row1.length - 1].colspan = row1[row1.length - 1].colspan + 1
        row1[row1.length - 1].width = row1[row1.length - 1].width + @widths[index]
    [row1, row2]

  ###
  @returns {object} the column numbers that have children criteria and the dataCriteriaKey
  ###
  detectChildrenCriteria: (columns) =>
    columnWithChildrenCriteria = {}
    for header, columnNumber in columns
      dataCriteria = @pd.dataIndices[columnNumber] # Formatted "PopulationKey_DataCriteriaKey"
      dataCriteriaKey = dataCriteria.substring(dataCriteria.indexOf('_') + 1)
      children_criteria = @pd.getChildrenCriteria dataCriteriaKey
      if Object.keys(children_criteria).length > 0
        columnWithChildrenCriteria[columnNumber] = dataCriteria
    columnWithChildrenCriteria

  ###
  @returns {Object} the results for a given patient given that patient's id
  ###
  matchPatientToPatientId: (patient_id) =>
    patient = @results.findWhere({ patient_id: patient_id })

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

  ###
  Removes the passed in patient from the patientData array.
  ###
  removePatientFromDataSources: (currentPatient) =>
    @patientData = _.without @patientData, _.findWhere @patientData, id: currentPatient.id

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
        @patientResult = @result.first() #Grab the first and only item from collection
        @patientData = new Thorax.Models.PatientDashboardPatient patient, @dashboard.pd, @measure, @patientResult, @populations, @population
        @dashboard.updatePatientDataSources @result, @patientData

        if @rowIndex?
          $('#patientDashboardTable').DataTable().row(@rowIndex).data(@patientData).draw()
          @dashboard.updateDisplay(@rowIndex)
        else
          $('#patientDashboardTable').DataTable().row.add(@patientData).draw()
          @dashboard.updateAllActualWarnings()

  close: ->
    @$('.modal-body').empty() # clear out patientBuilderView
