class Thorax.Views.MeasurePatientDashboardLayout extends Thorax.LayoutView
  template: JST['patient_dashboard/layout']

  initialize: ->
    # Highlights correct button, based on selected view
    if @showFixedColumns
      $('#patient-dashboard-button').addClass('btn-primary')
      $('#508-patient-dashboard-button').removeClass('btn-primary')
    else
      $('#patient-dashboard-button').removeClass('btn-primary')
      $('#508-patient-dashboard-button').addClass('btn-primary')
    $('#measure-details-button').removeClass('btn-primary')

  ###
  Switches populations (changes the population displayed by patient dashboard)
  ###
  switchPopulation: (e) ->
    @population = $(e.target).model()
    @population.measure().set('displayedPopulation', @population)
    @setView new Thorax.Views.MeasurePopulationPatientDashboard measure: @population.measure(), population: @population
    @trigger 'population:update', @population

  ###
  Marks the population as active and gives it a title
  ###
  populationContext: (population) ->
    _(population.toJSON()).extend
      isActive: population is population.measure().get('displayedPopulation')
      populationTitle: population.get('title') || population.get('sub_id')

  ###
  Sets the view after results have been calculated
  ###
  setView: (view) ->
    results = @population.calculationResults()
    results.calculationsComplete =>
      view.results = results
      super(view)


class Thorax.Views.MeasurePopulationPatientDashboard extends Thorax.Views.BonnieView
  template: JST['patient_dashboard/table']
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

    @patientData = []
    headerData = @createHeaderRows()
    @head1 = headerData[0]
    @head2 = headerData[1]
    @columnsWithChildrenCriteria = @detectChildrenCriteria(@head2)

  context: ->
    _(super).extend
      cms_id: @measure.get('cms_id')
      patients: @patientData
      head1: @head1
      head2: @head2

  events:
    'ready': 'setup'

    rendered: ->
      $('.container').removeClass('container').addClass('container-fluid')
      @patientEditView.appendTo(@$el)

      # Initialize patient dashboard using DataTables
      tableOptions =
        data: @patientData,
        columns: @getTableColumns(),
        dom: '<if<"scrolling-table"t>>', # Places table info and filter, then table, then nothing
        language:
          emptyTable: '<i aria-hidden="true" class="fa fa-fw fa-user"></i> Test Cases Loading...'
        order: [], # Disable initial sorting
        paging: false
        preDrawCallback: => @updateDisplay()
        createdRow: (row, data, rowIndex) ->
          # DT adds the 'row' ARIA role to each table body row. This adds the required children roles.
          $(row).find('td').each (colIndex) -> $(this).attr('role', 'gridcell')
          $(row).find('th').each (colIndex) -> $(this).attr('role', 'rowheader')

      if @showFixedColumns
        # Add options necessary to enable fixed columns, scrolling, etc.
        tableOptions = _.extend tableOptions,
          fixedColumns:
            leftColumns: 4 + @populations.length
          scrollX: true,
          scrollY: "600px",
          scrollCollapse: true

      table = @$('#patientDashboardTable').DataTable(tableOptions)
      @updateDisplay() # Highlights the actual warnings on the flat table.

      # Removes the form-inline class from the wrapper so that inputs in our table can
      # take on full width. This is expected to be fixed in a future release of DataTables.
      @$('#patientDashboardTable_wrapper').removeClass('form-inline')
      @$('#patientDashboardTable_filter').addClass('form-inline') # Search input

      # If table scrolls, remove popovers screen
      $('div.dataTables_scrollBody, .dataTables_wrapper').scroll () =>
        $('.popover').popover('destroy')

    destroyed: ->
      $('.container-fluid').removeClass('container-fluid').addClass('container')

  setup: ->
    # Get patient calculation results
    @results = @population.calculationResults()

    # On results being calculated, construct patient data and initialize the
    # table.
    @results.calculationsComplete =>
      # Use toJSON() to add specificsRationale to the JSON object.
      @patientResults = @results.toJSON()

      # Create a PatientDashboardPatient for each patient, these are used for
      # each row in patient dashboard.
      for patient in @measure.get('patients').models
        @patientData.push new Thorax.Models.PatientDashboardPatient patient, @pd, @measure, @matchPatientToPatientId(patient.id), @populations, @population

      @render()

  ###
  Manages logic highlighting.
  ###
  showRationaleForPopulation: (code, rationale, updatedRationale) ->
    for key, value of rationale
      target = $(".#{code}_children .#{key}")
      targettext = $(".#{code}_children .#{key}")
      targetrect = $("rect[precondition=#{key}]")
      if (targettext.length > 0)
        [targetClass, targetPanelClass, srTitle] = if updatedRationale[code]?[key] is false
          ['eval-bad-specifics', 'eval-panel-bad-specifics', '(status: bad specifics)']
        else
          bool = !!value
          ["eval-#{bool}", "eval-panel-#{bool}", "(status: #{bool})"]
        targetrect.attr "class", (index, classNames) -> "#{classNames} #{targetClass}"
        targettext.addClass(targetClass)
        targettext.children('.sr-highlight-status').html(srTitle)
        targettext.children('.criteria-title').children('.sr-highlight-status').html(srTitle)

  ###
  Performs some actions on the DOM to properly render popovers,
  patient names, and warnings.
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
  getTableColumns: ->
    columns = []
    columns.push data: 'actions', orderable: false
    columns.push data: 'passes'
    columns.push
      data: 'last',
      cellType: "th" # Makes this cell a header element
      createdCell: (td, cellData, rowData, row, col) => $(td).attr('scope', 'row')
    columns.push
      data: 'first',
      cellType: "th" # Makes this cell a header element
      createdCell: (td, cellData, rowData, row, col) => $(td).attr('scope', 'row')
    for population in @populations
      columns.push
        data: 'actual' + population
        className: 'value'
        render: @insertResultValue
    for population in @populations
      columns.push
        data: 'expected' + population
        className: 'value'
        render: @insertResultValue
    columns.push data: 'description'
    columns.push data: 'birthdate'
    columns.push data: 'deathdate'
    columns.push data: 'gender'
    # Collect all actual data criteria and sort to make sure patient dashboard
    # displays data criteria in the correct order.
    dcStartIndex = @pd.dataInfo['gender'].index + 1
    dc = []
    for k, v of @pd.dataCollections
      if v.firstIndex >= dcStartIndex
          dc = dc.concat v.items
    for entry in dc
      columns.push data: entry, render: @insertTextAndPatientData
    columns

  ###
  Renders the calculation result for a population.
  TODO: get OBSERV_UNIT for CV measures
  ###
  insertResultValue: (data, type, row, meta) =>
    if row
      JST['pd_result_checkbox']({
        result: data,
        episodeOfCare: row.measure.get('episode_of_care'),
        continuousVariable: row.measure.get('continuous_variable')  })
    else
      return ''

  ###
  Populates the Popover with children data criteria if they exist and populates
  the table cells with the datacriteria value.
  ###
  insertTextAndPatientData: (data, type, row, meta) =>
    if data
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
  @returns {Object} a mapping of editable column field names to row indices
  ###
  getEditableCols: ->
    editableFields = ['first', 'last', 'description', 'gender', 'birthdate', 'deathdate']
    editableCols = {}
    # Add patient characteristics to editable fields
    for editableField in editableFields
      editableCols[editableField] = @pd.dataInfo[editableField].index
    # Add expecteds to editable fields
    # for population in @populations
    #   editableCols['expected' + population] = @pd.dataInfo['expected' + population].index
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
  Scrolls the table to a selected population
  ###
  scrollToPopulation: (e) ->
    if @showFixedColumns
      leftOffset = $('.DTFC_Cloned').outerWidth() + $('.DTFC_Cloned').offset().left
      @$('.dataTables_scrollBody').scrollTo @$('#'+ $(e.currentTarget).text()), offset: left: -leftOffset
    else
      $('.dataTables_wrapper').scrollTo @$('#'+ $(e.currentTarget).text())

  ###
  Updates actual warnings for a given row index
  ###
  updateActualWarnings: (rowIndex) ->
    nodes = $('#patientDashboardTable').DataTable().row(rowIndex).nodes()
    row = $('#patientDashboardTable').DataTable().row(rowIndex).data()
    for population in @populations
      actualIndex = (@pd.dataInfo['actual' + population].index) + 1
      td = $('td:nth-child(' + actualIndex + ')', nodes[0])
      if row['expected' + population] != row['actual' + population]
        td.addClass('warn')
      else
        td.removeClass('warn')

  ###
  Updates actual warnings for all rows
  ###
  updateAllActualWarnings: ->
    if @patientData?.length > 0 # Check if the list is populated.
      for i in [0..@patientData.length-1]
        @updateActualWarnings(i)

  ###
  Makes a patient row inline editable
  ###
  makeInlineEditable: (sender) ->
    # Get row index and data of selected patient
    targetCell = $(sender.currentTarget).closest('td')
    row = @getRowData(targetCell)
    rowIndex = @getRowIndex(targetCell)

    # Clone the old patient in case the user decides to cancel their edits
    row['old'] = jQuery.extend(true, {}, row)

    for k, v of @editableCols
      if k == 'gender'
        # Gender (needs a dropdown)
        row[k] = JST['pd_edit_gender']({ rowIndex: rowIndex, femaleSelected: row[k] == 'F', key: k })
      else if k in ['birthdate', 'deathdate']
        # Birth and death date (need date pickers)
        row[k] = JST['pd_date_field']({ rowIndex: rowIndex, key: k })
      else if /expected/i.test(k)
        # Expected values in non-CV measure (needs check boxes)
        row[k] = JST['pd_actual_expected_value']({
          rowIndex: rowIndex,
          key: k,
          value: row[k],
          episodeOfCare: row.measure.get('episode_of_care'),
          continuousVariable: row.measure.get('continuous_variable') })
      else
        row[k] = JST['pd_input_field']({ rowIndex: rowIndex, key: k })

    # Change edit button to save and cancel buttons
    row['actions'] = JST['pd_edit_controls']({})

    # Update row
    @setRowData(rowIndex, row)
    @selectRow(rowIndex)

    # Set current values in added inputs
    for k, v of @editableCols
      if k != 'gender' && !/expected/i.test(k)
        $('[name=' + k + rowIndex + ']').val(row['old'][k])

    # Initialize birthdate and deathdate date pickers
    @$('#birthdate' + rowIndex).datepicker()
    @$('#deathdate' + rowIndex).datepicker()

    @updateDisplay(rowIndex)
    #tell SR something changed
    update_message = "Editing turned on for patient " + row.patient.get('last') + row.patient.get('first') + ". Can edit columns for " + _.keys(@editableCols).join(", ") + " by navigating to the associated cells in this table row."
    $('#ariaalerts').html update_message
  ###
  Saves the inline edits made to a patient
  ###
  saveEdits: (sender) ->
    # Get row index and data of selected patient
    targetCell = $(sender.currentTarget).closest('td')
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
      else if /expected/i.test(k)
        if $('#' + k + rowIndex)[0].checked
          editedData[k] = 1
        else
          editedData[k] = 0
      else if /birthdate/i.test(k)
        editedData[k] = moment.utc(row[k], 'L').unix()
      else if /deathdate/i.test(k)
        editedData[k] = moment.utc(row[k], 'L').unix()
        editedData['expired'] = true if editedData[k]
      else
        editedData[k] = row[k]

    $('#ariaalerts').html "Saving edits on this patient."

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
    targetCell = $(sender.currentTarget).closest('td')
    row = @getRowData(targetCell)
    rowIndex = @getRowIndex(targetCell)
    @setRowData(rowIndex, row['old'])
    # Remove row selection
    @deselectRow(rowIndex)
    @updateDisplay()

    $('#ariaalerts').html "Canceling edits on this patient."

  ###
  Opens the full patient builder modal for more advanced patient editing
  ###
  openEditDialog: (sender) ->
    # Get row index and data of selected patient
    targetCell = $(sender.currentTarget).closest('td')
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
    targetCell = $(sender.currentTarget).closest('td')
    row = @getRowData(targetCell)
    rowIndex = @getRowIndex(targetCell)

    # Clone the old patient in case the user decides to cancel their edits
    row['old'] = jQuery.extend(true, {}, row)
    row['actions'] = JST['pd_delete_controls']({})
    @setRowData(rowIndex, row)

    $('#ariaalerts').html "Confirm patient deletion by pressing 'Delete Patient'"

  ###
  Replaces the Delete button and cancel button with the actions button.
  ###
  hideDelete: (sender) ->
    # Get row index and data of selected patient
    targetCell = $(sender.currentTarget).closest('td')
    row = @getRowData(targetCell)
    rowIndex = @getRowIndex(targetCell)
    @setRowData(rowIndex, row['old'])

    $('#ariaalerts').html "Canceling delete patient."

  ###
  Removes patient from the table
  ###
  deletePatient: (sender) ->
    # Get row index and data of selected patient
    targetCell = $(sender.currentTarget).closest('td')
    row = @getRowData(targetCell)
    rowIndex = @getRowIndex(targetCell)
    @removePatientFromDataSources(row)
    patient = _.findWhere(@measure.get('patients').models, {id: row.id})
    patient.destroy()
    $('#patientDashboardTable').DataTable().row(rowIndex).remove().draw()

    $('#ariaalerts').html "Deleting patient."

  ###
  Generates the views for the popover and attaches it to the DOM.
  ###
  populatePopover: (sender) ->
    sender.preventDefault()
    dataCriteria = @pd.dataIndices[$(sender.target).attr('columnNumber')] # Formatted "PopulationKey_DataCriteriaKey"
    dataCriteriaKey = dataCriteria.substring(dataCriteria.indexOf('_') + 1)
    populationKey = dataCriteria.substring(0, dataCriteria.indexOf('_'))
    popoverHTML = "<div class='measure-viz rationale panel-group " + populationKey + "_children'>"
    popoverView = new Thorax.Views.PatientDashboardPopover measure: @measure, populationKey: populationKey, dataCriteriaKey: dataCriteriaKey, allChildrenCriteria: @pd.dataCriteriaChildrenKeys dataCriteriaKey
    popoverView.appendTo(@$('.rationale'))
    popoverHTML = popoverHTML + popoverView.$el[0].outerHTML
    popoverHTML = popoverHTML + "</div></div>"

    # Add the html to the popover
    $(sender.currentTarget).attr('data-content', popoverHTML)
    # Attaches popover to currentTarget.
    $(sender.currentTarget).popover('show')

    # Update rationale for popoverover.
    patientResult = @results.findWhere({ patient_id: $(sender.target).attr('patientId') })
    updatedRationale = patientResult.specificsRationale()
    @showRationaleForPopulation(populationKey, patientResult.get('rationale'), updatedRationale)

    # When popover loses focus (hides), destroy popover so content doesn't flicker on next 'show' event.
    $(sender.currentTarget).one 'hide.bs.popover', =>
      $('.popover').popover('destroy')

  ###
  @returns {Array} an array containing the contents of both headers
  ###
  createHeaderRows: =>
    row1 = []
    row2 = @pd.dataIndices.map (d) => @pd.dataInfo[d].name
    row1_full = row2.map (d) => '' # Creates an array of empty strings same length as row2

    for key, dataCollection of @pd.dataCollections
      row1_full[dataCollection.firstIndex] = dataCollection.name
    # Construct the top header using colspans for the number of columns
    # they should cover
    for header, index in row1_full
      if !!header
        row1.push title: header, colspan: 1, width: @pd.dataInfo[@pd.dataIndices[index]].width
      else if row1[row1.length - 1]? and !!row1[row1.length - 1].title
        row1[row1.length - 1].colspan = row1[row1.length - 1].colspan + 1
        row1[row1.length - 1].width = row1[row1.length - 1].width + @pd.dataInfo[@pd.dataIndices[index]].width
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
    patient = @results.findWhere({ patient_id: patient_id }).toJSON()

  ###
  Opens up a patient edit modal to create a new patient.
  ###
  createNewPatient: (sender) ->
    patient = new Thorax.Models.Patient {measure_ids: [@measure.get('hqmf_set_id')]}, parse: true
    @patientEditView.display patient, null # Set rowIndex to null because it is a new patient.

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
  template: JST['patient_dashboard/edit_modal']

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
    @patientBuilderView = new Thorax.Views.PatientBuilder model: patient, measure: @measure, patients: @patients, measures: @measures, showCompleteView: false, routeToPatientDashboard: true
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
      @$('.modal-body').empty() # Clear out patientBuilderView
      @result = @population.calculateResult patient
      @result.calculationsComplete =>
        @patientResult = @result.toJSON()[0] # Grab the first and only item from collection
        @patientData = new Thorax.Models.PatientDashboardPatient patient, @dashboard.pd, @measure, @patientResult, @populations, @population
        @dashboard.updatePatientDataSources @result, @patientData
        if @rowIndex?
          $('#patientDashboardTable').DataTable().row(@rowIndex).data(@patientData).draw()
          @dashboard.updateDisplay(@rowIndex)
        else
          $('#patientDashboardTable').DataTable().row.add(@patientData).draw()
          @dashboard.updateDisplay()

  close: ->
    @$('.modal-body').empty() # Clear out patientBuilderView
