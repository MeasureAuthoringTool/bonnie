class Thorax.Views.MeasurePopulationPatientDashboard extends Thorax.Views.BonnieView
  template: JST['patient_dashboard/table']
  className: 'patient-dashboard'

  initialize: ->
    # Grab all populations related to this measure
    codes = (population['code'] for population in @measure.get('measure_logic'))
    @populations = _.intersection(Thorax.Models.Measure.allPopulationCodes, codes)

    # Column widths
    @widths =
      population: 30
      meta_huge: 200
      meta_large: 110
      meta_medium: 100
      meta_small: 40
      freetext: 240
      criteria: 200
      result: 80

    # Create patient dashboard layout and patient editor modal
    @patientEditView = new Thorax.Views.MeasurePatientEditModal(dashboard: this)
    @patientDashboard = new Thorax.Models.PatientDashboard @measure, @populations, @populationSet, @widths
    @nonEmptyPopulations = []
    for pop in @populations
      if @patientDashboard.criteriaKeysByPopulation[pop].length > 0
        @nonEmptyPopulations.push pop

    # Keep track of editable rows and columns
    @editableRows = []
    @editableCols = @getEditableCols()

    # Array containing PatientDashboardPatients
    @patientData = []
    headerData = @createHeaderRows()
    @head1 = headerData[0]
    @head2 = headerData[1]
    @columnsWithChildrenCriteria = @detectChildrenCriteria(@head2)

    @episodeOfCare = @measure.get('episode_of_care')
    @continuousVariable = @measure.get('continuous_variable')
    @displayedPopulationIndex = @measure.get('displayedPopulation').index()

  context: ->
    _(super).extend
      hqmf_set_id: @measure.get('hqmf_set_id')
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
      columns = @getTableColumns()

      tableOptions =
        data: @patientData
        columns: columns
        dom: '<if<"scrolling-table"t>>' # Places table info and filter, then table, then nothing
        language:
          emptyTable: '<i aria-hidden="true" class="fa fa-fw fa-user"></i> Test Cases Loading...'
        order: @getColumnOrder(columns)
        paging: false
        createdRow: (row, data, rowIndex) ->
          # DataTables adds the 'row' ARIA role to each table body row. This adds the required children roles.
          $(row).find('td').each (colIndex) -> $(this).attr('role', 'gridcell')
          $(row).find('th').each (colIndex) -> $(this).attr('role', 'rowheader')

      if @showFixedColumns
        # Add options necessary to enable fixed columns, scrolling, etc.
        tableOptions = _.extend tableOptions,
          fixedColumns:
            leftColumns: 4 + @populations.length
          scrollX: true
          scrollY: "600px"
          scrollCollapse: true

      table = @$('#patientDashboardTable').DataTable(tableOptions)
      @updateDisplay() # Highlights the actual warnings on the flat table.

      # Removes the form-inline class from the wrapper so that inputs in our table can
      # take on full width. This is expected to be fixed in a future release of DataTables.
      @$('#patientDashboardTable_wrapper').removeClass('form-inline')
      @$('#patientDashboardTable_filter').addClass('form-inline') # Search input

      # If table scrolls, remove popover or datetimepicker screens
      $('div.dataTables_scrollBody, .dataTables_wrapper').scroll () =>
        $('.popover').popover('hide')

    destroyed: ->
      $('.container-fluid').removeClass('container-fluid').addClass('container')

  setup: ->
    # Get patient calculation results
    @results = @populationSet.calculationResults()

    # On results being calculated, construct patient data and initialize the
    # table.
    @results.calculationsComplete =>
      # Use toJSON() to add specificsRationale to the JSON object.
      @patientResults = @results.toJSON()

      # Create a PatientDashboardPatient for each patient, these are used for
      # each row in patient dashboard.
      for patient in @measure.get('patients').models
        if @patientHasExpecteds(patient, @measure)
          @patientData.push new Thorax.Models.PatientDashboardPatient patient, @patientDashboard, @measure, @getPatientResultsById(patient.id), @populations, @populationSet

      @render()

  ###
  Check to see if the given patient has expected values for the given
  measure.
  ###
  patientHasExpecteds: (patient, measure) ->
    (model for model in patient.get('expected_values').models when model.get('measure_id') == @measure.get('hqmf_set_id') && model.get('population_index') == @populationSet.get('index'))[0]?

  ###
  Set the order in DataTables to equate the ordering of patients in the Population Calculation view.
  We want to display the results sorted by 1) failures first, then 2) last name, then 3) first name
  ###
  getColumnOrder: (columns) ->
    order = []
    for item in ['passes', 'last', 'first']
    # DataTables requires indexes rather than column names. Get the indexes.
      for column, index in columns
        if column['data'] == item
          order.push [index, 'asc']
    order

  ###
  Manages logic highlighting.
  ###
  showRationaleForPopulation: (code, rationale, updatedRationale) ->
    for key, value of rationale
      targettext = $(".#{code}_children .#{key}") #text version of logic
      targetrect = $("rect[precondition=#{key}]") #viz version of logic (svg)
      if (targettext.length > 0)
        if updatedRationale[code]?[key] is false
          targetClass = 'eval-bad-specifics'
          srTitle = '(status: bad specifics)'
        else
          bool = !!value # Converts value to boolean value
          targetClass = "eval-#{bool}"
          srTitle = "(status: #{bool})"

        targetrect.attr "class", (index, classNames) -> "#{classNames} #{targetClass}" #add styling to svg without removing all the other classes
        targettext.addClass(targetClass) # This does the actually application of the highlighting to the target
        # this line is there to fix an issue with sr-only in Chrome making text in inline elements not display
        # by having the sr-only span and the DC title wrapped in a criteria-title span, the odd behavior goes away.
        targettext.children('.sr-highlight-status').html(@renderFreeText(srTitle))
        targettext.children('.criteria-title').children('.sr-highlight-status').html(@renderFreeText(srTitle))

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
    # Update fixed columns
    @updateFixedColumns()

  ###
  @returns {Array} an array of "instructions" for each column in a row that
  tells patient dashboard how to display a PatientDashboardPatient properly.
  Note: If the order of the columns change, also change the order in
  PatientDashboard Model, in the function getDataIndices().
  ###
  getTableColumns: ->
    columns = []
    columns.push
      data: 'actions'
      orderable: false
      render: @insertActions
    columns.push
      data: 'passes'
      render: @insertPassStatus
    columns.push
      data: 'last'
      cellType: "th" # Makes this cell a header element
      createdCell: (td, cellData, rowData, row, col) => $(td).attr('scope', 'row')
      render: @renderCell
    columns.push
      data: 'first'
      cellType: "th" # Makes this cell a header element
      createdCell: (td, cellData, rowData, row, col) => $(td).attr('scope', 'row')
      render: @renderCell
    for population in @populations
      columns.push
        data: 'actual' + population
        className: 'value'
        render: @insertActualValue
    for population in @populations
      columns.push
        data: 'expected' + population
        className: 'value'
        render: @insertExpectedValue
    columns.push
      data: 'description'
      render: @renderCell
    columns.push data: 'birthdate'
    columns.push data: 'deathdate'
    columns.push
      data: 'gender'
      render: @renderCell

    # Collect all actual data criteria and sort to make sure patient dashboard
    # displays data criteria in the correct order.
    dataCriteriaStartIndex = @patientDashboard.dataInfo['gender'].index + 1
    dataCriteria = []
    for k, v of @patientDashboard.dataCollections
      if v.firstIndex >= dataCriteriaStartIndex
          dataCriteria = dataCriteria.concat v.items
    for entry in dataCriteria
      columns.push data: entry, render: @insertTextAndPatientData
    columns

  ###
  Escapes HTML using built in datatables helper. Helps prevent XSS vulnerabilities.
  ###
  renderFreeText: (text) =>
      $.fn.dataTable.render.text().display(text)

  ###
  Renders a free text cell. Helps prevent XSS vulnerabilities.
  ###
  renderCell: (data, type, row, meta) =>
    # If the row is currently editable, these cells contain inputs, which have
    # been populated by their respective Handlebars template. The template
    # itself handles escaping HTML (so no extra steps are necessary).
    if row?['editable']
      data
    else
      @renderFreeText(data)

  ###
  Inserts actions gear into row
  ###
  insertActions: (data, type, row, meta) =>
    if data && data.length > 0
      data
    else
      JST['pd_action_gears']({})

  ###
  Inserts pass status into row.
  ###
  insertPassStatus: (data, type, row, meta) =>
    if row
      JST['pd_result_text']({ passes: data == "PASS" })
    else
      ''

  ###
  Creates actual result.
  ###
  insertActualValue: (data, type, row, meta) =>
    if row
      JST['pd_actual_expected']({
        editable: false,
        result: data,
        episodeOfCare: @episodeOfCare,
        continuousVariable: @continuousVariable
      })
    else
      return ''

  ###
  Creates expected result.
  ###
  insertExpectedValue: (data, type, row, meta) =>
    if row
      key = @patientDashboard.stripLeadingToken(@patientDashboard.dataIndices[meta['col']])
      expected = row.expected
      data = expected[key]
      JST['pd_actual_expected']({
        rowIndex: meta['row'],
        key: 'expected' + key,
        editable: row['editable'] unless @continuousVariable,
        result: data,
        episodeOfCare: @episodeOfCare,
        continuousVariable: @continuousVariable
      })
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
          passes: data == 'TRUE',
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
      editableCols[editableField] = @patientDashboard.dataInfo[editableField].index
    # Add expecteds to editable fields
    for population in @populations
      editableCols['expected' + population] = @patientDashboard.dataInfo['expected' + population].index
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

  ###
  Highlights the row at the given index
  ###
  selectRow: (rowIndex) ->
    nodes = $('#patientDashboardTable').DataTable().row(rowIndex).nodes()
    $(nodes).addClass('active')

  ###
  Removes highlighting of the row at the given index
  ###
  deselectRow: (rowIndex) ->
    nodes = $('#patientDashboardTable').DataTable().row(rowIndex).nodes()
    $(nodes).removeClass('active')

  ###
  Scrolls the table to a selected population
  ###
  scrollToPopulation: (e) ->
    # Calculates the offset due to fixedColumns
    leftOffset = $('.DTFC_Cloned').outerWidth() + $('.DTFC_Cloned').offset().left
    # Grab the text of the button, but not the text in the <span>
    buttonText = '#' + $(e.currentTarget).contents().get(1).nodeValue.replace(' ', '')
    @$('.dataTables_scrollBody').scrollTo @$(buttonText), offset: left: -leftOffset

  ###
  Updates actual warnings for a given row index
  ###
  updateActualWarnings: (rowIndex) =>
    nodes = $('#patientDashboardTable').DataTable().row(rowIndex).nodes()
    row = @getRowData(rowIndex)
    for population in @populations
      actualIndex = (@patientDashboard.dataInfo['actual' + population].index) + 1
      td = $('td:nth-child(' + actualIndex + ')', nodes[0])
      patient = row.patient
      expected = row.expected
      patient_results = @getPatientResultsById(patient.id)
      if expected[population] != patient_results[population]
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

    # Temporarily disable inline editing of CV measures
    if @continuousVariable
      @$('.alert').text('Inline editing of expected results for Continuous Variable Measures is temporarily disabled.').removeClass('hidden')

    # Clone the old patient in case the user decides to cancel their edits
    row['old'] = jQuery.extend(true, {}, row)

    # Record on the row object that this row is currently inline editable
    row['editable'] = true

    for k, v of @editableCols
      if k == 'gender'
        # Gender (needs a dropdown)
        row[k] = JST['pd_edit_gender']({ rowIndex: rowIndex, femaleSelected: row[k] == 'F', key: k })
      else if k == 'birthdate'
        # Birthdate
        row[k] = JST['pd_date_field']({ rowIndex: rowIndex, key: k, date: row[k] })
      else if k == 'deathdate'
        # Deathdate
        row[k] = JST['pd_date_field']({ rowIndex: rowIndex, key: k, date: row[k] })
      else if /expected/i.test(k)
        # Expected
        row[k] = JST['pd_actual_expected']({ rowIndex: rowIndex, key: k, editable: true, episodeOfCare: @measure.get('episode_of_care'), continuousVariable: @measure.get('continuous_variable') })
      else
        row[k] = JST['pd_input_field']({ rowIndex: rowIndex, key: k, value: row[k] })

    # Change edit button to save and cancel buttons
    row['actions'] = JST['pd_edit_controls']({})

    # Update row
    @setRowData(rowIndex, row)
    @selectRow(rowIndex)

    # Initialize the popovers
    $('#birthdate' + rowIndex).popover({title: 'Birthdate', placement: 'bottom', container: 'body', html: 'true', content: '<div id="birthdate' + rowIndex + '_popover"></div>'}).on('show.bs.popover', @populateDateTimePickerPopover)
    $('#deathdate' + rowIndex).popover({title: 'Deathdate', placement: 'bottom', container: 'body', html: 'true', content: '<div id="deathdate' + rowIndex + '_popover"></div>'}).on('show.bs.popover', @populateDateTimePickerPopover)

    @updateDisplay(rowIndex)

    # If the row is showing editable columns, focus on the first input
    htmlRow = $('#patientDashboardTable').DataTable().row(rowIndex).nodes()
    $(htmlRow).find('.inline-editing:first').focus()

    # Tell screen reader something changed
    update_message = "Editing turned on for patient " + row.patient.get('last') + row.patient.get('first') + ". Can edit columns for " + _.keys(@editableCols).join(", ") + " by navigating to the associated cells in this table row."
    $('#ariaalerts').html @renderFreeText(update_message)

  ###
  Populates a datetime popover with a datetime picker.
  ###
  populateDateTimePickerPopover: (sender) ->
    pickerOptions =
      icons:
        time: 'fa fa-clock-o',
        date: 'fa fa-calendar',
        up: 'fa fa-chevron-up',
        down: 'fa fa-chevron-down',
        previous: 'fa fa-chevron-left',
        next: 'fa fa-chevron-right',
        today: 'fa fa-plus',
        clear: 'fa fa-trash',
        close: 'fa fa-remove'
      useCurrent:
        false
      inline:
        true
      defaultDate:
        $(sender.currentTarget).val()
    $('#' + $(sender.currentTarget).attr('id') + '_popover').datetimepicker(pickerOptions).on('dp.change', @updateDateFieldValue)

  ###
  If the datetime picker's date or time was changed, update the datetime field
  to reflect the new value.
  ###
  updateDateFieldValue: (sender) ->
    datetimeField = $('#' + $(sender.currentTarget).attr('id').replace('_popover', ''))
    datetimeField.val(sender.date.format('MM/DD/YYYY hh:mm A'))

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
      inputGroups.push inputs.filter (input) -> input.name == k + rowIndex
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
    patient = row.patient
    expected = patient.get('expected_values').findWhere(measure_id: @measure.get('hqmf_set_id'), population_index: @displayedPopulationIndex)
    editedData = {}

    for k, v of @editableCols
      if k == 'description'
        editedData['notes'] = row[k]
      else if /expected/i.test(k)
        if @measure.get('episode_of_care') || @measure.get('continuous_variable')
          expected.set(k.replace('expected', ''), $('#' + k + rowIndex).val())
        else
          isChecked = $('#' + k + rowIndex)[0].checked
          result = if isChecked then 1 else 0
          expected.set(k.replace('expected', ''), result)
      else if /birthdate/i.test(k)
        editedData[k] = moment.utc($('#' + k + rowIndex).val(), 'MM/DD/YYYY hh:mm A').format('X')
        editedData[k] = 1 if editedData[k] == 0 # TODO
      else if /deathdate/i.test(k)
        if moment.utc($('#' + k + rowIndex).val(), 'MM/DD/YYYY hh:mm A').isValid()
          editedData[k] = moment.utc($('#' + k + rowIndex).val(), 'MM/DD/YYYY hh:mm A').format('X')
          editedData[k] = 1 if editedData[k] == 0 # TODO
          editedData['expired'] = true
        else
          editedData['expired'] = false
      else
        editedData[k] = row[k]
    editedData['expected_values'] = patient.get('expected_values')

    $('#ariaalerts').html "Saving edits on this patient."

    # Update row on recalculation
    status = patient.calculateAndSave editedData,
      success: (model) =>
        result = @populationSet.calculateResult patient
        result.calculationComplete =>
          row['actions'] = row['old']['actions']
          row['birthdate'] = $('#birthdate' + rowIndex).val()
          row['deathdate'] = $('#deathdate' + rowIndex).val()
          row['editable'] = false
          @updatePatientDataSources result, row
          row.patientResult = @getPatientResultsById(patient.id)
          row.updatePasses()
          @setRowData(rowIndex, row)
          @deselectRow(rowIndex)
          @updateDisplay(rowIndex)
          @$('.alert').text('').addClass('hidden')
    unless status
      messages = []
      for [cid, field, message] in patient.validationError
        messages.push message
      @$('.alert').text(_(messages).uniq().join('; ')).removeClass('hidden')

  ###
  Cancels the edits made to an inline patient
  ###
  cancelEdits: (sender) ->
    # Get row index and data of selected patient
    targetCell = $(sender.currentTarget).closest('td')
    row = @getRowData(targetCell)
    rowIndex = @getRowIndex(targetCell)
    row['old']['editable'] = false
    @setRowData(rowIndex, row['old'])
    # Remove row selection
    @deselectRow(rowIndex)
    @updateDisplay(rowIndex)
    @$('.alert').text('').addClass('hidden')
    $('#ariaalerts').html "Canceling edits on this patient."

  ###
  Opens the full patient builder modal for more advanced patient editing
  ###
  openEditDialog: (sender) ->
    # Get row index and data of selected patient
    targetCell = $(sender.currentTarget).closest('td')
    row = @getRowData(targetCell)
    rowIndex = @getRowIndex(targetCell)
    @patientEditView.display row.patient, rowIndex

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
    @updateFixedColumns()
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
    @updateFixedColumns()
    $('#ariaalerts').html "Canceling delete patient."

  ###
  Updates the fixedColumns table, using Datatables FixedColumns api
  ###
  updateFixedColumns: ->
    $.fn.dataTable.tables(visible: true, api: true).columns.adjust().fixedColumns().update()

  ###
  Removes patient from the table
  ###
  deletePatient: (sender) ->
    # Get row index and data of selected patient
    targetCell = $(sender.currentTarget).closest('td')
    row = @getRowData(targetCell)
    rowIndex = @getRowIndex(targetCell)
    @removePatientFromDataSources(row)
    row.patient.destroy()
    $('#patientDashboardTable').DataTable().row(rowIndex).remove().draw()

    $('#ariaalerts').html "Deleting patient."

  ###
  Generates the views for the popover and attaches it to the DOM.
  ###
  populatePopover: (sender) ->
    sender.preventDefault()
    dataCriteria = @patientDashboard.dataIndices[$(sender.target).attr('columnNumber')] # Formatted "PopulationKey_DataCriteriaKey"
    dataCriteriaKey = @patientDashboard.stripLeadingToken(dataCriteria)
    populationKey = @populationSet.get(dataCriteria.substring(0, dataCriteria.indexOf('_'))).code # Retrieves population based key. ie: IPP -> IPP_1
    popoverHTML = "<div class='measure-viz rationale panel-group " + populationKey + "_children'>"
    popoverView = new Thorax.Views.PatientDashboardPopover measure: @measure, populationKey: populationKey, dataCriteriaKey: dataCriteriaKey, allChildrenCriteria: @patientDashboard.dataCriteriaChildrenKeys dataCriteriaKey
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
  When a user toggles an expected population, make sure the change is valid.
  ###
  toggledExpected: (sender) =>
    # Get row index, data, and current value of selected population
    targetCell = $(sender.currentTarget).closest('td')
    row = @getRowData(targetCell)
    rowIndex = @getRowIndex(targetCell)
    population = @patientDashboard.stripLeadingToken($(sender.target).attr('id')).replace(/[0-9+]/g, '')
    unless $(sender.target)[0].checked
      @selectDependentPopulations(population, 0, rowIndex)
    else
      @deselectDependingPopulations(population, 1, rowIndex)

  ###
  Recursive function that handles expected population logic downselects.
  ###
  selectDependentPopulations: (population, value, rowIndex) =>
    switch population
      when 'STRAT'
        @setPopulation('IPP', value, rowIndex)
        @selectDependentPopulations('IPP', value, rowIndex)
      when 'IPP'
        @setPopulation('DENOM', value, rowIndex)
        @setPopulation('MSRPOPL', value, rowIndex)
        # Only down select for DENOM because it's the same as for MSRPOPL
        @selectDependentPopulations('DENOM', value, rowIndex)
      when 'DENOM', 'MSRPOPL'
        @setPopulation('DENEX', value, rowIndex)
        @setPopulation('DENEXCEP', value, rowIndex)
        @setPopulation('NUMER', value, rowIndex)
        # A down select for DENEX and DENEXCEP is not required because they
        # don't have any dependent populations
        @selectDependentPopulations('NUMER', value, rowIndex)
      when 'NUMER'
        @setPopulation('NUMEX', value, rowIndex)

  ###
  Recursive function that handles expected population logic upselects.
  ###
  deselectDependingPopulations: (population, value, rowIndex) =>
    switch population
      when 'NUMEX'
        @setPopulation('NUMER', value, rowIndex)
        @deselectDependingPopulations('NUMER', value, rowIndex)
      when 'DENEX', 'DENEXCEP', 'NUMER'
        @setPopulation('DENOM', value, rowIndex)
        @setPopulation('MSRPOPL', value, rowIndex)
        @deselectDependingPopulations('DENOM', value, rowIndex)
      when 'DENOM', 'MSRPOPL'
        @setPopulation('IPP', value, rowIndex)
        @deselectDependingPopulations('IPP', value, rowIndex)
      when 'IPP'
        @setPopulation('STRAT', value, rowIndex)
        @deselectDependingPopulations('STRAT', value, rowIndex)

  ###
  Sets a single expected population's value.
  ###
  setPopulation: (population, value, rowIndex) =>
    if population of @patientDashboard.criteriaKeysByPopulation
      if !!value
        $('#expected' + population + rowIndex).prop('checked', true)
      else
        $('#expected' + population + rowIndex).prop('checked', false)

  ###
  @returns {Array} an array containing the contents of both headers
  ###
  createHeaderRows: =>
    row1 = []
    row2 = @patientDashboard.dataIndices.map (d) => @renderFreeText(@patientDashboard.dataInfo[d].name)
    row1_full = row2.map (d) => '' # Creates an array of empty strings same length as row2

    for key, dataCollection of @patientDashboard.dataCollections
      row1_full[dataCollection.firstIndex] = dataCollection.name
    # Construct the top header using colspans for the number of columns
    # they should cover
    for header, index in row1_full
      if !!header
        row1.push title: @renderFreeText(header), noSpaceTitle: header.replace(' ', ''), colspan: 1, width: @patientDashboard.dataInfo[@patientDashboard.dataIndices[index]].width
      else if row1[row1.length - 1]? and !!row1[row1.length - 1].title
        row1[row1.length - 1].colspan = row1[row1.length - 1].colspan + 1
        row1[row1.length - 1].width = row1[row1.length - 1].width + @patientDashboard.dataInfo[@patientDashboard.dataIndices[index]].width
    [row1, row2]

  ###
  @returns {object} the column numbers that have children criteria and the dataCriteriaKey
  ###
  detectChildrenCriteria: (columns) =>
    columnWithChildrenCriteria = {}
    for header, columnNumber in columns
      dataCriteria = @patientDashboard.dataIndices[columnNumber] # Formatted "PopulationKey_DataCriteriaKey"
      dataCriteriaKey = @patientDashboard.stripLeadingToken(dataCriteria)
      if @patientDashboard.hasChildrenCriteria dataCriteriaKey
        columnWithChildrenCriteria[columnNumber] = dataCriteriaKey
    columnWithChildrenCriteria

  ###
  @returns {Object} the results for a given patient given that patient's id
  ###
  getPatientResultsById: (patient_id) =>
    endResult = null
    patientResults = @results.where({patient_id: patient_id})
    for result in patientResults
      if result.measure.get('hqmf_set_id') == @measure.get('hqmf_set_id')
        endResult = result
        break

    patient = endResult.toJSON() if endResult?

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
    @results.add currentResult # Note: After a result is updated, the old result is automatically removed.

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
    @patientData = _.without(@patientData, _.findWhere(@patientData, id: currentPatient.id))
