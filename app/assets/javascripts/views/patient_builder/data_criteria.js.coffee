# Abstract base class for children of the patient builder that need to communicate with the top-level via events
class Thorax.Views.BuilderChildView extends Thorax.Views.BonnieView
  events:
    ready: -> @patientBuilder().registerChild this
    
  patientBuilder: ->
    parent = @parent
    until parent instanceof Thorax.Views.PatientBuilder
      parent = parent.parent
    parent
  triggerMaterialize: ->
    @trigger 'bonnie:materialize'


class Thorax.Views.SelectCriteriaView extends Thorax.Views.BonnieView
  template: JST['patient_builder/select_criteria']
  events:
    rendered: ->
      # FIXME: We'd like to do this via straight thorax events, doesn't seem to work...
      @$('.collapse').on 'show.bs.collapse hide.bs.collapse', (e) =>
        $('a.panel-title[data-toggle="collapse"]').toggleClass('closed').find('.panel-icon').toggleClass('fa-3x fa-1x') #shrink others
        @$('.panel-expander').toggleClass('fa-angle-right fa-angle-down')
        @$('.panel-icon').toggleClass('fa-3x fa-2x')
        @$('a.panel-title[data-toggle="collapse"]').toggleClass('closed')
        if e.type is 'show' then $('a.panel-title[data-toggle="collapse"]').next('div.in').not(e.target).collapse('hide') # hide open ones

  faIcon: -> @collection.first()?.toPatientDataCriteria()?.faIcon()


class Thorax.Views.SelectCriteriaItemView extends Thorax.Views.BuilderChildView
  addCriteriaToPatient: -> @trigger 'bonnie:dropCriteria', @model.toPatientDataCriteria()
  context: ->
    desc = @model.get('description').split(/, (.*:.*)/)?[1] or @model.get('description')
    _(super).extend
      type: desc.split(": ")[0]
      # everything after the data criteria type is the detailed description
      detail: desc.substring(desc.indexOf(':')+2)

class Thorax.Views.EditCriteriaView extends Thorax.Views.BuilderChildView
  className: 'patient-criteria'

  @highlight:
    partial: 'highlight-partial'
    valid: 'highlight-valid'

  template: JST['patient_builder/edit_criteria']

  options:
    serialize: { children: false }
    populate: { context: true, children: false }

  initialize: ->
    if @model.canHaveResult()
      @editValueView = new Thorax.Views.EditCriteriaValueView
        model: new Thorax.Model
        measure: @model.measure()
        fieldValue: false
        values: @model.get('value')
        criteriaType: @model.get('type')
        # TODO: (LDY 10/6/2016) should this be rewritten so criteriaType works with what @model.getCriteriaType returns?
        # this would move us towards having more directed field drop downs for each criteria type
        fullCriteriaType: @model.getCriteriaType() # includes the full type information. e.g., instead of 'encounters' it's 'encounter_performed'
    @editFieldValueView = new Thorax.Views.EditCriteriaValueView
      model: new Thorax.Model
      measure: @model.measure()
      fieldValue: true
      values: @model.get('field_values')
      criteriaType: @model.get('type')
      fullCriteriaType: @model.getCriteriaType() # includes the full type information. e.g., instead of 'encounters' it's 'encounter_performed'
    @editReferenceView = new Thorax.Views.EditCriteriaReferenceView
      model: new Thorax.Model
      measure: @model.measure()
      fieldValue: false
      reference: true
      values: @model.get('references')
      criteriaType: @model.get('type')
      vals: JSON.stringify(@model.get('references'))
    codes = @model.get('codes')
    concepts = @model.valueSet()?.get('concepts')
    codes.on 'add remove', => @model.set 'code_source', (if codes.isEmpty() then 'DEFAULT' else 'USER_DEFINED'), silent: true
    @editCodeSelectionView = new Thorax.Views.CodeSelectionView codes: codes
    @editCodeSelectionView.updateConcepts(concepts) if concepts
    @editFulfillmentHistoryView = new Thorax.Views.MedicationFulfillmentsView
      model: new Thorax.Model
      criteria: @model

    @model.on 'highlight', (type) =>
      @$('.criteria-data').addClass(type)
      @$('.highlight-indicator').attr('tabindex', 0).text 'matches selected logic, '

  valueWithDateContext: (model) ->
    _(model.toJSON()).extend
      start_date: moment.utc(model.get('value')).format('L') if model.get('type') == 'TS'
      start_time: moment.utc(model.get('value')).format('LT') if model.get('type') == 'TS'


  # When we create the form and populate it, we want to convert times to moment-formatted dates
  context: ->
    cmsIdParts = @model.get("cms_id").match(/CMS(\d+)(V\d+)/i)
    
    desc = @model.get('description').split(/, (.*:.*)/)?[1] or @model.get('description')
    definition_title = @model.get('definition').replace(/_/g, ' ').replace(/(^|\s)([a-z])/g, (m,p1,p2) -> return p1+p2.toUpperCase())
    if desc.split(": ")[0] is definition_title
      desc = desc.substring(desc.indexOf(':')+2)
    
    _(super).extend
      start_date: moment.utc(@model.get('start_date')).format('L') if @model.get('start_date')
      start_time: moment.utc(@model.get('start_date')).format('LT') if @model.get('start_date')
      end_date: moment.utc(@model.get('end_date')).format('L') if @model.get('end_date')
      end_time: moment.utc(@model.get('end_date')).format('LT') if @model.get('end_date')
      end_date_is_undefined: !@model.has('end_date')
      description: desc
      value_sets: @model.measure()?.valueSets().map((vs) -> vs.toJSON()) or []
      cms_id_number: cmsIdParts[1] if cmsIdParts
      cms_id_version: cmsIdParts[2] if cmsIdParts
      faIcon: @model.faIcon()
      definition_title: definition_title
      canHaveNegation: @model.canHaveNegation()
      startLabel: @startLabel(@model.get('negation'))
      stopLabel: @stopLabel()
      periodLabel: @periodLabel()
      isPeriod: @model.isPeriodType() && !@model.get('negation') # if something is negated, it didn't happen so is not a period

  # When we serialize the form, we want to convert formatted dates back to times
  events:
    serialize: (attr) ->
      if startDate = attr.start_date
        startDate += " #{attr.start_time}" if attr.start_time
        attr.start_date = moment.utc(startDate, 'L LT').format('X') * 1000
      delete attr.start_time
      # If the user indicates that there is no end date, or if this is a criteria with a single "Authored"
      # time (ie negated, or not a period type) then the end date should always be undefined
      if attr.end_date_is_undefined || @model.get('negation') || !@model.isPeriodType()
        attr.end_date = undefined
      else if endDate = attr.end_date
        endDate += " #{attr.end_time}" if attr.end_time
        attr.end_date = moment.utc(endDate, 'L LT').format('X') * 1000
      attr.negation = !!attr.negation && !_.isEmpty(attr.negation_code_list_id)
      delete attr.end_date_is_undefined
      delete attr.end_time
    rendered: ->
      @$('.criteria-data.droppable').droppable greedy: true, accept: '.ui-draggable', hoverClass: 'drop-target-highlight', drop: _.bind(@dropCriteria, this)
      @$('.date-picker').datepicker('orientation': 'bottom left').on 'changeDate', _.bind(@triggerMaterialize, this)
      @$('.time-picker').timepicker(template: false).on 'changeTime.timepicker', _.bind(@triggerMaterialize, this)
      @$el.toggleClass 'during-measurement-period', @model.isDuringMeasurePeriod()
    'change .negation-select':                    'toggleNegationSelect'
    'change :input[name=end_date_is_undefined]':  'toggleEndDateDefinition'
    'blur :text':                                 'triggerMaterialize'
    'blur :input[type=number]':                   'triggerMaterialize'
    'change select':                              'triggerMaterialize'
    # hide date-picker if it's still visible and focus is not on a .date-picker input (occurs with JAWS SR arrow-key navigation)
    'focus .form-control': (e) -> if not @$(e.target).hasClass('date-picker') and $('.datepicker').is(':visible') then @$('.date-picker').datepicker('hide')

  dropCriteria: (e, ui) ->
    # When we drop a new criteria on an existing criteria
    droppedCriteria = $(ui.draggable).model().toPatientDataCriteria()
    targetCriteria = $(e.target).model()
    droppedCriteria.set start_date: targetCriteria.get('start_date'), end_date: targetCriteria.get('end_date')
    @trigger 'bonnie:dropCriteria', droppedCriteria
    return false

  isExpanded: -> @$('form').is ':visible'

  toggleDetails: (e) ->
    e.preventDefault()
    @$('.criteria-details, form').toggleClass('hide')
    @$('.criteria-type-marker').toggleClass('open')
    unless @isExpanded()
      @serialize(children: false)
      # FIXME sortable: commenting out due to odd bug in droppable
      # @model.trigger 'close', @model
      @render() # re-sorting the collection will re-render this view, remove this if we use above approach
    @$(':focusable:visible:first').focus()

  showDelete: (e) ->
    e.preventDefault()
    $btn = $(e.currentTarget)
    $btn.toggleClass('btn-danger btn-danger-inverse').next().toggleClass('hide')

  toggleEndDateDefinition: (e) ->
    $cb = $(e.target)
    $endDateTime = @$('input[name=end_date], input[name=end_time]')
    $endDateTime.val('') if $cb.is(':checked')
    unless $cb.is(':checked') # set to 15 minutes after start
      endDate = moment.utc(@model.get('start_date') + (15 * 60 * 1000)) if @model.has('start_date')
      @$('input[name=end_date]').datepicker('orientation': 'bottom left').datepicker('setDate', endDate.format('L')) if endDate
      @$('input[name=end_date]').datepicker('update')
      @$('input[name=end_time]').timepicker('setTime', endDate.format('LT')) if endDate
    $endDateTime.prop 'disabled', $cb.is(':checked')
    @triggerMaterialize()

  toggleNegationSelect: (e) ->
    @$('.negation-code-list').prop('selectedIndex',0).toggleClass('hide')

    # the following code changes the timing display if a period data type
    # is negated. If it is negated, author date time should be used. If it's
    # not, then the start/stop date time should be used.
    if @model.isPeriodType()
      @$('#periodLabel, #stopControl').toggleClass('hide', $(e.target).is(':checked'))
      @$('#startLabel').text(@startLabel($(e.target).is(':checked')))

      # make it so end date is always undefined if negation is toggled
      $end_date_is_undefined = @$('[name="end_date_is_undefined"]')
      $end_date_is_undefined.prop('checked', true)
      @toggleEndDateDefinition({target: $end_date_is_undefined})

    @triggerMaterialize()

  removeCriteria: (e) ->
    e.preventDefault()
    @model.destroy()

  removeValue: (e) ->
    e.preventDefault()
    # If the value being removed is part of a collection type, the data will include the index of said value within the collection
    # col-item-index is the index of the item that we want to remove within the collection
    if $(e.target).data('col-item-index')?
      # Clone the model and remove from the clone and then add the cloned model to the collection so that the UI change event is triggered
      clone = $(e.target).model().clone()
      clone.get('values').splice($(e.target).data('col-item-index'), 1)
      # Add the collection if the collection still contains values
      if clone.get('values').length > 0
        $(e.target).model().collection.add clone
      
    $(e.target).model().destroy()
    @triggerMaterialize()
    @editValueView?.render() # Re-render edit view, if used

  highlightError: (e, field) ->
    @toggleDetails(e) unless @isExpanded()
    @$(":input[name=#{field}]").closest('.form-group').addClass('has-error')

  jumpToSelectCriteria: (e) ->
    e.preventDefault()
    type = @$(e.target).model().get('type')
    $(".#{type}-elements").focus()


  startLabel: (negated) ->
    # if the data criteria is a period type and has not been negated, then the
    # period time labels should be used. Otherwise, "authored" should be used.
    if @model.isPeriodType() && !negated
      if @model.isIssue()
        'Onset'
      else
        'Start'
    else
      # authored used for instances or negations
      'Authored'

  stopLabel: ->
    if @model.isPeriodType()
      if @model.isIssue()
        'Abatement'
      else
        'Stop'

  periodLabel: ->
    if @model.isPeriodType()
      if @model.isIssue()
        'Prevalence Period'
      else
        'Relevant Period'

class Thorax.Views.CodeSelectionView extends Thorax.Views.BuilderChildView
  template: JST['patient_builder/edit_codes']
  events:
    'change select[name=codeset]': (e) ->
      @model.set codeset: $(e.target).val()
      @changeConcepts(e)
      @validateForAddition()
    'change select[name=code]' : ->
      @validateForAddition()
    'keyup input[name=custom_code]': 'validateForAddition'
    'keyup input[name=custom_codeset]': 'validateForAddition'
    rendered: ->
      @$('select.codeset-control').selectBoxIt('native': true)

  initialize: ->
    @model = new Thorax.Model

  validateForAddition: ->
    attributes = @serialize(set: false) # Gets copy of attributes from form without setting model
    if attributes.codeset is 'custom'
      @$('.btn[data-call-method=addCode]').prop 'disabled', attributes.custom_codeset is '' or attributes.custom_code is ''
      # focusing on the button causes an interruption in typing, so no focus for custom code entry
    else
      @$('.btn[data-call-method=addCode]').prop 'disabled', attributes.codeset is '' or attributes.code is ''
      @$('.btn').focus() #  advances the focus too the add Button

  changeConcepts: (e) ->
    codeSet = $(e.target).val()
    $codeList = @$('.codelist-control').empty()
    if codeSet isnt 'custom'
      blankEntry = if codeSet is '' then '--' else "Choose a #{codeSet} code"
      $codeList.append("<option value>#{blankEntry}</option>")
      for concept in @concepts when concept.code_system_name is codeSet and !concept.black_list
        $('<option>').attr('value', concept.code).text("#{concept.code} (#{concept.display_name})").appendTo $codeList
    @$('.codelist-control').focus()

  updateConcepts: (concepts) ->
    @concepts = concepts
    @codeSets = _(concept.code_system_name for concept in @concepts || []).uniq()
    @render()

  addCode: (e) ->
    e.preventDefault()
    @serialize()
    # add the code unless there is a pre-existing code with the same codeset/code
    if @model.get('codeset') is 'custom'
      @model.set('codeset', @model.get('custom_codeset'))
      @model.set('code', @model.get('custom_code'))
    @codes.add @model.clone() unless @codes.any (c) => c.get('codeset') is @model.get('codeset') and c.get('code') is @model.get('code')
    # Reset model to default values
    @model.clear()
    @$('select').val('')
    # Let the selectBoxIt() select box know that its value may have changed
    @$('select[name=codeset]').change()
    @triggerMaterialize()
    @$(':focusable:visible:first').focus()


class Thorax.Views.MedicationFulfillmentsView extends Thorax.Views.BuilderChildView
  template: JST['patient_builder/edit_fulfillments']

  events:
    'blur input': 'validateForAddition'
    'keyup input': 'validateForAddition'
    'change input': 'validateForAddition'
    serialize: (attr) ->
      if dispenseDate = attr.dispense_date
        dispenseDate += " #{attr.dispense_time}" if attr.dispense_time
        attr.dispense_datetime = moment.utc(dispenseDate, 'L LT').format('X')
    rendered: -> @setDefaultDate()

  initialize: ->
    @model = new Thorax.Model
    @fulfillments = @criteria.get('fulfillments')

  validateForAddition: ->
    attributes = @serialize(set: false)
    isDisabled = !attributes.dispense_date || !attributes.dispense_time || !attributes.quantity_dispensed_value
    @$('button[data-call-method=addFulfillment]').prop 'disabled', isDisabled

  setDefaultDate: ->
    # use the latest fulfillment as a template
    latest_fulfillment = @fulfillments.max((f) -> f.get('dispense_datetime')) if @fulfillments.length
    # if dosage and frequency are specified then compute a CMD offset (derived from HQMF2JS Patient API Extension)
    if @criteria.get('dose_value') and @criteria.get('frequency_value')
      switch @criteria.get('frequency_unit')
        when 'h' then dosesPerDay = 24 / @criteria.get('frequency_value')
        when 'd' then dosesPerDay = 1 / @criteria.get('frequency_value')
      if latest_fulfillment
        offset = ( latest_fulfillment.get('quantity_dispensed_value') / @criteria.get('dose_value') / dosesPerDay ) * 60 * 60 * 24 * 1000
    offset ?= 15 * 60 * 1000 # otherwise use a default offset of 15 mins
    # use the latest date, starting with the start_date
    date = moment.utc( @criteria.get('start_date') + offset ) if @criteria.has('start_date')
    if latest_fulfillment?.get('dispense_datetime') * 1000 > @criteria.get('start_date')
      date = moment.utc( latest_fulfillment.get('dispense_datetime') * 1000 + offset )
    @$('input[name=dispense_date]').datepicker('orientation': 'bottom left').datepicker('setDate', date.format('L')) if date
    @$('input[name=dispense_date]').datepicker('update')
    @$('input[name=dispense_time]').timepicker('setTime', date.format('LT')) if date

  addFulfillment: (e) ->
    e.preventDefault()
    @serialize()
    @fulfillments.add @model.clone()
    @model.clear()
    @triggerMaterialize()


class Thorax.Views.EditCriteriaValueView extends Thorax.Views.BuilderChildView
  className: -> "#{if @fieldValue then 'field-' else ''}value-formset"

  template: JST['patient_builder/edit_value']

  initialize: ->
    @model.set('type', 'CD')
    @fieldValueCodesCollection = new Thorax.Collections.Codes {}, parse: true
    @showAddCodesButton = false
    @showAddCodes = false
    @fields = Thorax.Models.Measure.logicFieldsFor(@criteriaType)
    @showDateTimeSelection = @fieldValue || @fullCriteriaType in ['assessment_performed']
    # TODO: for QDM 5.0, assessment performed should also have a percentage selection.
    # We need to see what this would look like to determine best implementation path.
    # Until then, PQ (Scalar) can be used with "%" as the unit

  context: ->
    _(super).extend
      codes: @measure?.valueSets().map((vs) -> vs.toJSON()) or []
      hideEditValueView: @criteriaType == 'risk_category_assessments' && @values.models.length > 0

  # When we serialize the form, we want to put the description for any CD codes into the submission
  events:
    serialize: (attr) ->
      if startDate = attr.start_date
        startDate += " #{attr.start_time}" if attr.start_time
        attr.value = moment.utc(startDate, 'L LT').format('X') * 1000
      delete attr.start_date
      delete attr.start_time
      title = @measure?.valueSets().findWhere(oid: attr.code_list_id)?.get('display_name')
      attr.title = title if title
      attr.codes = @fieldValueCodesCollection.toJSON() unless jQuery.isEmptyObject(@fieldValueCodesCollection.toJSON())
      # gets the pretty printed title (e.g., "Result Date/Time" instead of "RESULT_DATETIME")
      attr.field_title = (field for field in @fields when field.key == attr.key)[0]?.title
    rendered: ->
      @codeSelectionViewForFieldValues = new Thorax.Views.CodeSelectionView codes: @fieldValueCodesCollection
      @$("select[name=type]").selectBoxIt('native': true)
      @$('.date-picker').datepicker().on 'changeDate', _.bind(@validateForAddition, this)
      @$('.time-picker').timepicker(template: false).on 'changeTime.timepicker', _.bind(@validateForAddition, this)
    'change select[name=type]': (e) ->
      @model.set type: $(e.target).val()
      @toggleAddCodesButton()
      @validateForAddition()
      @advanceFocusToInput()
    'change select[name=code_list_id]': ->
      @toggleAddCodesButton()
      @validateForAddition()
    'change select': ->
      # @serialize.key is the selected item set to the model.key so the view can change accordingly
      if(@serialize().key == 'COMPONENT')
        @model.set type: 'CMP'
      else
        # Default drop down to 'coded'
        @model.set type: 'CD'
      @toggleAddCodesButton()
      @validateForAddition()
      @advanceFocusToInput()
    'keyup input': 'validateForAddition'
    'change select[name=key]': 'changeFieldValueKey'
    # hide date-picker if it's still visible and focus is not on a .date-picker input (occurs with JAWS SR arrow-key navigation)
    'focus .form-control': (e) -> if not @$(e.target).hasClass('date-picker') and $('.datepicker').is(':visible') then @$('.date-picker').datepicker('hide')
    'click #addCodes': (e) ->
      @showFieldValueCodeSelection(e)
      @validateForAddition()

  canSelectFieldValueCode: (concepts, key) ->
    return bonnie.isPortfolio and @fieldValue and key in ['PRINCIPAL_DIAGNOSIS', 'DIAGNOSIS'] and concepts and @$("select[name=type]").val() == "CD"

  getConcepts: (code_list_id) ->
    return @measure?.valueSets().findWhere(oid: code_list_id)?.get('concepts')

  toggleAddCodesButton: ->
    attributes = @serialize(set: false)
    if @canSelectFieldValueCode(@getConcepts(attributes.code_list_id), attributes.key)
      # Show code selection for field value
      @showAddCodesButton = true
      @fieldValueCodesCollection.reset()
    else
      @showAddCodesButton = false
    @showAddCodes = false
    @render()

  showFieldValueCodeSelection: (e) ->
    attributes = @serialize(set: false)
    @codeSelectionViewForFieldValues.updateConcepts(@getConcepts(attributes.code_list_id))
    e.preventDefault()
    @showAddCodesButton = false
    @showAddCodes = true
    @render()

  removeFieldValueCode: (e) ->
    e.preventDefault()
    codeSet = $(e.target).model()?.attributes['codeset']
    codeToRemove = $(e.target).model()?.attributes['code']
    codeModel = @fieldValueCodesCollection.find (model) -> model.get('code') is codeToRemove and model.get('codeset') is codeSet
    @fieldValueCodesCollection.remove(codeModel) if codeModel

  advanceFocusToInput: ->
    switch @model.get('type')
      when 'PQ'
        @$('input[name="value"]').focus()
      when 'CD'
        @$('select[name="code_list_id"]').focus()
      when 'TS'
        @$('input[name="start_date"]').focus()
    @$('.btn').focus() # advances the focus to the add Button

  validateForAddition: ->
    attributes = @serialize(set: false) # Gets copy of attributes from form without setting model
    isDisabled = (attributes.type == 'PQ' && !attributes.value) ||
                 (attributes.type == 'CD' && !attributes.code_list_id) ||
                 (attributes.type == 'TS' && !attributes.value) ||
                 (@fieldValue && !attributes.key)
    @$('button[data-call-method=addValue]').prop 'disabled', isDisabled

  changeFieldValueKey: (e) ->
    # If it's a date/time field, automatically chose the date type and pre-enter a date
    attributes = @serialize(set: false) # Gets copy of attributes from form without setting model
    if attributes.key in ['ADMISSION_DATETIME', 'DISCHARGE_DATETIME', 'FACILITY_LOCATION_ARRIVAL_DATETIME',
                          'FACILITY_LOCATION_DEPARTURE_DATETIME', 'INCISION_DATETIME', 'REMOVAL_DATETIME',
                          'TRANSFER_TO_DATETIME', 'TRANSFER_FROM_DATETIME', 'RESULT_DATETIME']
      @$('select[name=type]').val('TS').change()
      criteria = @parent.model
      switch attributes.key
        when 'ADMISSION_DATETIME', 'FACILITY_LOCATION_ARRIVAL_DATETIME', 'INCISION_DATETIME', 'TRANSFER_FROM_DATETIME'
          date = moment.utc(criteria.get('start_date')) if criteria.has('start_date')
        when 'DISCHARGE_DATETIME', 'FACILITY_LOCATION_DEPARTURE_DATETIME', 'REMOVAL_DATETIME', 'TRANSFER_TO_DATETIME'
          date = moment.utc(criteria.get('end_date')) if criteria.has('end_date')
          date ?= moment.utc(criteria.get('start_date') + (15 * 60 * 1000)) if criteria.has('start_date')
      @$('input[name=start_date]').datepicker('setDate', date.format('L')) if date
      @$('input[name=start_date]').datepicker('update')
      @$('input[name=start_time]').timepicker('setTime', date.format('LT')) if date
    else if @$('select[name=type]').val() == 'TS'
      @$('select[name=type]').val('CD').change()

  addValue: (e) ->
    e.preventDefault()
    @serialize()
    # This will process CMP, a collection type attribute
    # If extending for use with other collection based attributes, add OR logic here
    model_key = @model.get('key')
    if (@model.get('type') == "CMP" ||
        model_key  == 'DIAGNOSIS'   ||
        model_key  == 'RELATED_TO')
        # TODO: Add OR logic for Facilities when implemening the cardinality for them

      compare_collection = @values.findWhere(key: @model.get('key'))
      if compare_collection
        col = compare_collection
        # We remove the collection and then re add it to trigger the UI to update
        @values.remove compare_collection
      if !col
        # Create a thorax model collection
        col = new Thorax.Model()
        col.set('key', @model.get('key'))
        col.set('type', 'COL')
        col.set('values', [])
      col.get('values').push @model.toJSON()
      @values.add col
    else
      @values.add @model.clone()
    # Reset model to default values
    @model.clear()
    @model.set type: 'CD'
    # clear() removes fields (which we want), but then populate() doesn't clear the select; clear it
    @$('select[name=key]').val('')
    # Let the selectBoxIt() select box know that its value may have changed
    @$('select[name=type]').change()
    @triggerMaterialize()
    @$(':focusable:visible:first').focus()
    @fieldValueCodesCollection.reset()
    @showAddCodes = false
    @render()

class Thorax.Views.EditCriteriaReferenceView extends Thorax.Views.EditCriteriaValueView
  className: -> "#{if @fieldValue then 'field-' else ''}value-formset"

  template: JST['patient_builder/edit_reference']

  addValue: (e) ->
    e.preventDefault()
    @serialize()
    ref = @find_reference(@model.get("reference_id"))
    @model.set description: ref?.get("description")
    start_date = ref?.get("start_date")
    end_date = ref?.get("end_date")
    if start_date
      @model.set start_date: moment.utc(start_date).format('L')
    if end_date
      @model.set end_date: moment.utc(end_date).format('L')
    @values.add @model.clone()
    # Reset model to default values
    @model.clear()

    # clear() removes fields (which we want), but then populate() doesn't clear the select; clear it
    @$('select[name=key]').val('')
    # Let the selectBoxIt() select box know that its value may have changed
    @$('select[name=type]').change()
    @triggerMaterialize()
    @$(':focusable:visible:first').focus()

  find_reference: (reference_id) ->
    for c in this.parent.model.collection.models
      if c.get("criteria_id") == reference_id
        return c
  #pulls all of the other data criteria on the page
  #todo -- needs to be able to update the list when items are added to the builder
  otherCriteria: ->
    crit = []
    for c in this.parent.model.collection.models
      if c.get("criteria_id")!= this.parent.model.get("criteria_id")
        crit.push { cid: c.get("criteria_id"), "description" : c.get("description")}
    crit

  context: ->
    _(super).extend
      references: Thorax.Models.Measure.referencesFor(@criteriaType)
