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
    desc = @model.get('description').split(/, (.*)/)?[1] or @model.get('description')
    _(super).extend
      type: desc.split(": ")[0]
      detail: desc.split(": ")[1]


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
    @editFieldValueView = new Thorax.Views.EditCriteriaValueView
      model: new Thorax.Model
      measure: @model.measure()
      fieldValue: true
      values: @model.get('field_values')
      criteriaType: @model.get('type')
    @editCodeSelectionView = new Thorax.Views.CodeSelectionView criteria: @model
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
    desc = @model.get('description').split(/, (.*)/)?[1] or @model.get('description')
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
      definition_title: @model.get('definition').replace(/_/g, ' ').replace(/(^|\s)([a-z])/g, (m,p1,p2) -> return p1+p2.toUpperCase())

  # When we serialize the form, we want to convert formatted dates back to times
  events:
    serialize: (attr) ->
      if startDate = attr.start_date
        startDate += " #{attr.start_time}" if attr.start_time
        attr.start_date = moment.utc(startDate, 'L LT').format('X') * 1000
      delete attr.start_time
      if attr.end_date_is_undefined
        attr.end_date = undefined
      else if endDate = attr.end_date
        endDate += " #{attr.end_time}" if attr.end_time
        attr.end_date = moment.utc(endDate, 'L LT').format('X') * 1000
      attr.negation = !!attr.negation && !_.isEmpty(attr.negation_code_list_id)
      delete attr.end_date_is_undefined
      delete attr.end_time
    rendered: ->
      @$('.criteria-data.droppable').droppable greedy: true, accept: '.ui-draggable', hoverClass: 'drop-target-highlight', drop: _.bind(@dropCriteria, this)
      @$('.date-picker').datepicker().on 'changeDate', _.bind(@triggerMaterialize, this)
      @$('.time-picker').timepicker(template: false).on 'changeTime.timepicker', _.bind(@triggerMaterialize, this)
      @$el.toggleClass 'during-measurement-period', @model.isDuringMeasurePeriod()
    'change .negation-select':                    'toggleNegationSelect'
    'change :input[name=end_date_is_undefined]':  'toggleEndDateDefinition'
    'blur :text':                                 'triggerMaterialize'
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
      @$('input[name=end_date]').datepicker('setDate', endDate.format('L')) if endDate
      @$('input[name=end_date]').datepicker('update')
      @$('input[name=end_time]').timepicker('setTime', endDate.format('LT')) if endDate
    $endDateTime.prop 'disabled', $cb.is(':checked')
    @triggerMaterialize()

  toggleNegationSelect: (e) ->
    @$('.negation-code-list').prop('selectedIndex',0).toggleClass('hide')
    @triggerMaterialize()

  removeCriteria: (e) ->
    e.preventDefault()
    @model.destroy()

  removeValue: (e) ->
    e.preventDefault()
    $(e.target).model().destroy()
    @triggerMaterialize()

  highlightError: (e, field) ->
    @toggleDetails(e) unless @isExpanded()
    @$(":input[name=#{field}]").closest('.form-group').addClass('has-error')

  jumpToSelectCriteria: (e) ->
    e.preventDefault()
    type = @$(e.target).model().get('type')
    $(".#{type}-elements").focus()

class Thorax.Views.CodeSelectionView extends Thorax.Views.BuilderChildView
  template: JST['patient_builder/edit_codes']
  events:
    'change select':           'validateForAddition'
    'change .codeset-control': 'changeConcepts'
    rendered: ->
      @$('select.codeset-control').selectBoxIt('native': true)

  initialize: ->
    @model = new Thorax.Model
    @codes = @criteria.get('codes')
    @codes.on 'add remove', => @criteria.set 'code_source', (if @codes.isEmpty() then 'DEFAULT' else 'USER_DEFINED'), silent: true
    @codeSets = _(concept.code_system_name for concept in @criteria.valueSet()?.get('concepts') || []).uniq()

  validateForAddition: ->
    attributes = @serialize(set: false) # Gets copy of attributes from form without setting model
    @$('.btn[data-call-method=addCode]').prop 'disabled', attributes.codeset is '' or attributes.code is ''
    @$('.btn').focus() #  advances the focus too the add Button

  changeConcepts: (e) ->
    codeSet = $(e.target).val()
    $codeList = @$('.codelist-control').empty()
    blankEntry = if codeSet is '' then '--' else "Choose a #{codeSet} code"
    $codeList.append("<option value>#{blankEntry}</option>")
    for concept in @criteria.valueSet().get('concepts') when concept.code_system_name is codeSet and !concept.black_list
      $('<option>').attr('value', concept.code).text("#{concept.code} (#{concept.display_name})").appendTo $codeList
    @$('.codelist-control').focus()

  addCode: (e) ->
    e.preventDefault()
    @serialize()
    # add the code unless there is a pre-existing code with the same codeset/code
    @codes.add @model.clone() unless @codes.any (c) => c.get('codeset') is @model.get('codeset') and c.get('code') is @model.get('code')
    # Reset model to default values
    @model.clear()
    @$('select').val('')
    # # Let the selectBoxIt() select box know that its value may have changed
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
      offset = ( latest_fulfillment.get('quantity_dispensed_value') / @criteria.get('dose_value') / dosesPerDay ) * 60 * 60 * 24 * 1000
    offset ?= 15 * 60 * 1000 # otherwise use a default offset of 15 mins
    # use the latest date, starting with the start_date
    date = moment.utc( @criteria.get('start_date') + offset ) if @criteria.has('start_date')
    if latest_fulfillment?.get('dispense_datetime') * 1000 > @criteria.get('start_date')
      date = moment.utc( latest_fulfillment.get('dispense_datetime') * 1000 + offset )
    @$('input[name=dispense_date]').datepicker('setDate', date.format('L')) if date
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

  context: ->
    _(super).extend
      codes: @measure?.valueSets().map((vs) -> vs.toJSON()) or []
      fields: Thorax.Models.Measure.logicFieldsFor(@criteriaType)

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
    rendered: ->
      @$("select[name=type]").selectBoxIt('native': true)
      @$('.date-picker').datepicker().on 'changeDate', _.bind(@validateForAddition, this)
      @$('.time-picker').timepicker(template: false).on 'changeTime.timepicker', _.bind(@validateForAddition, this)
    'change select[name=type]': (e) ->
      @model.set type: $(e.target).val()
      @validateForAddition()
      @advanceFocusToInput()
    'change select': -> 
      @validateForAddition()
      @advanceFocusToInput()
    'keyup input': 'validateForAddition'
    'change select[name=key]': 'changeFieldValueKey'
    # hide date-picker if it's still visible and focus is not on a .date-picker input (occurs with JAWS SR arrow-key navigation)
    'focus .form-control': (e) -> if not @$(e.target).hasClass('date-picker') and $('.datepicker').is(':visible') then @$('.date-picker').datepicker('hide')

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
                          'FACILITY_LOCATION_DEPARTURE_DATETIME', 'INCISION_DATETIME', 'REMOVAL_DATETIME', 'TRANSFER_TO_DATETIME', 'TRANSFER_FROM_DATETIME']
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
