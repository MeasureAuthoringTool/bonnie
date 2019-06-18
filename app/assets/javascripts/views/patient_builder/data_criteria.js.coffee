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

  parseDataElementDescription: (description) ->
    # dataelements such as birthdate do not have descriptions
    if !description
      ""
    else
      description.split(/, (.*:.*)/)?[1] or description


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

  faIcon: -> @collection.first()?.faIcon()


class Thorax.Views.SelectCriteriaItemView extends Thorax.Views.BuilderChildView
  addCriteriaToPatient: -> @trigger 'bonnie:dropCriteria', @model
  context: ->
    desc = @parseDataElementDescription @model.get('description')
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
    codes = @model.get('codes')
    code_list_id = @model.get('codeListId')
    concepts = (@measure.get('cqmValueSets').find (vs) => vs.oid is code_list_id)?.concepts
    @editCodeSelectionView = new Thorax.Views.CodeSelectionView codes: codes
    @editCodeSelectionView.updateConcepts(concepts) if concepts

    # There shouldn't be a dataElement saved without codes, but if there is, add default
    if !(@model.get('qdmDataElement').dataElementCodes?.length)
      @addDefaultCodeToDataElement()
    else
      # Add existing codes onto view
      for code in @model.get('qdmDataElement').dataElementCodes
        codes.add({codeset: @measure.codeSystemMap()[code.system] || code.system, code: code.code})

    @timingAttributeViews = []
    for timingAttr in @model.getPrimaryTimingAttributes()
      switch timingAttr.type
        when 'Interval'
          intervalView = new Thorax.Views.InputIntervalDateTimeView(
            initialValue: @model.get('qdmDataElement')[timingAttr.name],
            attributeName: timingAttr.name, attributeTitle: timingAttr.title,
            showLabel: true, defaultYear: @measure.getMeasurePeriodYear())
          @timingAttributeViews.push intervalView
          @listenTo intervalView, 'valueChanged', @updateAttributeFromInputChange
        when 'DateTime'
          dateTimeView = new Thorax.Views.InputDateTimeView(
            initialValue: @model.get('qdmDataElement')[timingAttr.name],
            attributeName: timingAttr.name, attributeTitle: timingAttr.title,
            showLabel: true, defaultYear: @measure.getMeasurePeriodYear())
          @timingAttributeViews.push dateTimeView
          @listenTo dateTimeView, 'valueChanged', @updateAttributeFromInputChange

    # view that shows all the currently set attributes
    @attributeDisplayView = new Thorax.Views.DataCriteriaAttributeDisplayView(model: @model)
    @listenTo @attributeDisplayView, 'attributesModified', @attributesModified

    @model.on 'highlight', (type) =>
      @$('.criteria-data').addClass(type)
      @$('.highlight-indicator').attr('tabindex', 0).text 'matches selected logic, '

  # When we create the form and populate it, we want to convert times to moment-formatted dates
  context: ->
    desc = @parseDataElementDescription(@model.get('description'))
    definition_title = @model.get('qdmCategory').replace(/_/g, ' ').replace(/(^|\s)([a-z])/g, (m,p1,p2) -> return p1+p2.toUpperCase())
    if desc.split(": ")[0] is definition_title
      desc = desc.substring(desc.indexOf(':')+2)
    primaryTimingAttributeName = @model.getPrimaryTimingAttribute()
    primaryTimingValue = @model.get('qdmDataElement')[primaryTimingAttributeName]
    _(super).extend
      start_date: moment.utc(primaryTimingValue.low.toJSDate()).format('L') if primaryTimingValue?.low?
      start_time: moment.utc(primaryTimingValue.low.toJSDate()).format('LT') if primaryTimingValue?.low?
      start_date: moment.utc(primaryTimingValue.toJSDate()).format('L') if primaryTimingValue?.isDateTime
      start_time: moment.utc(primaryTimingValue.toJSDate()).format('LT') if primaryTimingValue?.isDateTime
      end_date: moment.utc(primaryTimingValue.high.toJSDate()).format('L') if primaryTimingValue?.high?
      end_time: moment.utc(primaryTimingValue.high.toJSDate()).format('LT') if primaryTimingValue?.high?
      end_date_is_undefined: !primaryTimingValue?.high?
      description: desc
      value_sets: @model.measure()?.valueSets() or []
      faIcon: @model.faIcon()
      definition_title: definition_title
      canHaveNegation: @model.canHaveNegation()
      isPeriod: @model.isPeriodType() && !@model.get('negation') # if something is negated, it didn't happen so is not a period

  # When we serialize the form, we want to convert formatted dates back to times
  events:
    serialize: (attr) ->
    rendered: ->
      @$('.criteria-data.droppable').droppable greedy: true, accept: '.ui-draggable', hoverClass: 'drop-target-highlight', drop: _.bind(@dropCriteria, this)
      @$el.toggleClass 'during-measurement-period', @isDuringMeasurePeriod()
    # hide date-picker if it's still visible and focus is not on a .date-picker input (occurs with JAWS SR arrow-key navigation)
    'focus .form-control': (e) -> if not @$(e.target).hasClass('date-picker') and $('.datepicker').is(':visible') then @$('.date-picker').datepicker('hide')

  updateAttributeFromInputChange: (inputView) ->
    @model.get('qdmDataElement')[inputView.attributeName] = inputView.value
    @triggerMaterialize()

  attributesModified: ->
    @attributeDisplayView.render()
    @triggerMaterialize()

  isDuringMeasurePeriod: ->
    moment.utc(@model.get('start_date')).year() is moment.utc(@model.get('end_date')).year() is moment.utc(@model.measure().get('cqmMeasure').measure_period.low.value).year()

  # Copy timing attributes (relevantPeriod, prevelancePeriod etc..) onto the criteria being dragged from the criteria it is being dragged ontop of
  copyTimingAttributes: (droppedCriteria, targetCriteria) ->
    droppedCriteriaTiming = droppedCriteria.getPrimaryTimingAttributes()
    targetCriteriaTiming = targetCriteria.getPrimaryTimingAttributes()

    # do a pairwise copy from target timing attributes to dropped timing attributes
    for timingIndex, droppedTimingAttr of droppedCriteriaTiming
      # if there is a corresponding pair, then copy it
      if timingIndex < targetCriteriaTiming.length
        @_copyTimingAttribute(droppedCriteria, targetCriteria, droppedTimingAttr, targetCriteriaTiming[timingIndex])
      # otherwise, copy the first one in target
      else
        @_copyTimingAttribute(droppedCriteria, targetCriteria, droppedTimingAttr, targetCriteriaTiming[0])

  # Helper function to copy a timing value from targetCriteria to droppedCriteria. The last two arguments are obejcts from the
  # timing attributes structure that comes from the SourceDataCriteria.getPrimaryTimingAttributes() method. This has the attribute name and type.
  _copyTimingAttribute: (droppedCriteria, targetCriteria, droppedAttr, targetAttr) ->
    # clone if they are of the same type
    if targetAttr.type == droppedAttr.type
      if targetCriteria.get('qdmDataElement')[targetAttr.name]?
        droppedCriteria.get('qdmDataElement')[droppedAttr.name] = targetCriteria.get('qdmDataElement')[targetAttr.name].copy()
      else
        droppedCriteria.get('qdmDataElement')[droppedAttr.name] = null

    # turn Interval into DateTime
    else if targetAttr.type == 'Interval' && droppedAttr.type == 'DateTime'
      if targetCriteria.get('qdmDataElement')[targetAttr.name]?.low?
        droppedCriteria.get('qdmDataElement')[droppedAttr.name] = targetCriteria.get('qdmDataElement')[targetAttr.name].low.copy()
      else
        droppedCriteria.get('qdmDataElement')[droppedAttr.name] = null

    # turn DateTime into Interval. use start + 15 mins for end. if target is null, use Interval[null, null]
    else if targetAttr.type == 'DateTime' && droppedAttr.type == 'Interval'
      if targetCriteria.get('qdmDataElement')[targetAttr.name]?
        droppedCriteria.get('qdmDataElement')[droppedAttr.name] = new cqm.models.CQL.Interval(
          targetCriteria.get('qdmDataElement')[targetAttr.name].copy(),
          targetCriteria.get('qdmDataElement')[targetAttr.name].add(15, cqm.models.CQL.DateTime.Unit.MINUTE)
          )
      else
        droppedCriteria.get('qdmDataElement')[droppedAttr.name] = new cqm.models.CQL.Interval(null, null)

  dropCriteria: (e, ui) ->
    # When we drop a new criteria on an existing criteria
    droppedCriteria = $(ui.draggable).model().clone()
    targetCriteria = $(e.target).model()
    @copyTimingAttributes(droppedCriteria, targetCriteria)
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

  removeCriteria: (e) ->
    e.preventDefault()
    @model.destroy()

  removeCode: (e) ->
    e.preventDefault()
    code_to_delete = $(e.target).model().get("code")
    @model.get('qdmDataElement').dataElementCodes.pop({code: code_to_delete})
    $(e.target).model().destroy()
    @addDefaultCodeToDataElement()

  addDefaultCodeToDataElement: ->
    if !(@model.get('qdmDataElement').dataElementCodes?.length)
      code_list_id = @model.get('codeListId')
      concepts = (@measure.get('cqmValueSets').find (vs) => vs.oid is code_list_id)?.concepts
      # Make sure there is a default code that can be added
      if concepts?.length
        @model.get('qdmDataElement').dataElementCodes = [{system: concepts[0].code_system_oid, code: concepts[0].code}]
        cql_code = new cqm.models.CQL.Code(concepts[0].code, concepts[0].code_system_oid)
        @model.get('codes').add({codeset: @measure.codeSystemMap()[cql_code.system] || cql_code.system, code: cql_code.code})


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
      for concept in @concepts when concept.code_system_name is codeSet
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
    duplicate_exists = @codes.any (c) => c.get('codeset') is @model.get('codeset') and c.get('code') is @model.get('code')
    if !duplicate_exists
      @codes.add @model.clone()
      code_system_name = this.model.get('codeset')
      # Try to resolve code system name to an oid, if not (probably a custom code) default to the name
      code_system_oid = (@concepts.find (concept) -> concept.code_system_name is code_system_name)?.code_system_oid || code_system_name
      cql_code = new cqm.models.CQL.Code(this.model.get('code'), code_system_oid)
      @parent.model.get('qdmDataElement').dataElementCodes.push(cql_code)

    # Reset model to default values
    @model.clear()
    @$('select').val('')
    # Let the selectBoxIt() select box know that its value may have changed
    @$('select[name=codeset]').change()
    @triggerMaterialize()
    @$(':focusable:visible:first').focus()

class Thorax.Views.EditCriteriaValueView extends Thorax.Views.BuilderChildView
  className: -> "#{if @fieldValue then 'field-' else ''}value-formset"

  template: JST['patient_builder/edit_value']

  initialize: ->
    @model.set('type', 'CD')
    @model.set('type_cmp', 'CD')
    @fieldValueCodesCollection = new Thorax.Collections.Codes {}, parse: true
    @showAddCodesButton = false
    @showAddCodes = false
    @fields = Thorax.Models.Measure.logicFieldsFor(@criteriaType)
    @showDateTimeSelection = @fieldValue || @fullCriteriaType in ['assessment_performed']
    # TODO: for QDM 5.0, assessment performed should also have a percentage selection.
    # We need to see what this would look like to determine best implementation path.
    # Until then, PQ (Scalar) can be used with "%" as the unit

  context: ->
    codes_list = @measure?.valueSets() or []
    unique_codes = []
    # remove duplicate direct reference code value sets
    direct_reference_codes = []
    codes_list.forEach (code) ->
      if code.oid
        if ValueSetHelpers.isDirectReferenceCode(code.oid) # direct reference code
          unless code.display_name in direct_reference_codes
            direct_reference_codes.push(code.display_name)
            unique_codes.push(code)
        else
          unique_codes.push(code)

    _(super).extend
      codes: unique_codes
      # QDM say that per instance of a data criteria there can be only 1 Result
      # The function Thorax.Models.SourceDataCriteria.canHaveResult determines which criteria those are
      hideEditValueView: @values.models.length > 0

  # When we serialize the form, we want to put the description for any CD codes into the submission
  events:
    serialize: (attr) ->
      if attr.key == 'FACILITY_LOCATION'
        # Facility Locations care about start and end dates/times
        if startDate
          attr.locationPeriodLow = startDate 
        if endDate = attr.end_date 
            endDate += " #{attr.end_time}" if attr.end_time
            attr.locationPeriodHigh = endDate
            attr.end_value = moment.utc(endDate, 'L LT').format('X') * 1000
            
      if attr.key == 'COMPONENT'
        title_cmp = @measure?.valueSets().findWhere(oid: attr.code_list_id_cmp)?.get('display_name')
        attr.title = title_cmp if title_cmp
        attr.title_cmp = @measure?.valueSets().findWhere(oid: attr.code_list_id)?.get('display_name')
      else
        title = @measure?.valueSets().findWhere(oid: attr.code_list_id)?.get('display_name')
        attr.title = title if title
      attr.codes = @fieldValueCodesCollection.toJSON() unless jQuery.isEmptyObject(@fieldValueCodesCollection.toJSON())
      # gets the pretty printed title (e.g., "Result Date/Time" instead of "RESULT_DATETIME")
      attr.field_title = (field for field in @fields when field.key == attr.key)[0]?.title
    rendered: ->
      @codeSelectionViewForFieldValues = new Thorax.Views.CodeSelectionView codes: @fieldValueCodesCollection
      @$("select[name=type]").selectBoxIt('native': true)
      @$("select[name=type_cmp]").selectBoxIt('native': true)
      @$('.date-picker').datepicker().on 'changeDate', _.bind(@validateForAddition, this)
      @$('.time-picker').timepicker(template: false).on 'changeTime.timepicker', _.bind(@validateForAddition, this)
    'change select[name=type_cmp]': (e) ->
      @model.set type_cmp: $(e.target).val()
      @toggleAddCodesButton()
      @validateForAddition()
      @advanceFocusToInput()
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
      key = @serialize().key
      if key != 'COMPONENT'
        # clear extra values from component
        @model.unset 'type_cmp'
        @model.unset 'title_cmp'
        @model.unset 'code_list_id_cmp'
      if key == 'COMPONENT'
        @model.set type: 'CMP'
        @model.set type_cmp: 'CD'
      else if key == 'FACILITY_LOCATION'
        @model.set type: 'FAC'
      else
        # Default drop down to 'coded'
        @model.set type: 'CD'
      @toggleAddCodesButton()
      @validateForAddition()
      @advanceFocusToInput()
    'keyup input': 'validateForAddition'
    'change input': 'validateForAddition'
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
      when 'RT'
        @$('input[name="numerator_scalar"]').focus()
      when 'ID'
        @$('input[name="root"]').focus()
      when 'CMP'
        switch @model.get('type_cmp')
          when 'PQ'
            @$('input[name="value"]').focus()
          when 'CD'
            @$('select[name="code_list_id"]').focus()
          when 'TS'
            @$('input[name="start_date"]').focus()
    @$('.btn').focus() # advances the focus to the add Button

  validateForAddition: ->
    attributes = @serialize(set: false) # Gets copy of attributes from form without setting model
    isDisabled = ((attributes.type == 'PQ' || attributes.type_cmp == 'PQ') && !attributes.value) ||
                 ((attributes.type == 'CD' || attributes.type_cmp == 'CD') && !attributes.code_list_id) ||
                 ((attributes.type == 'TS' || attributes.type_cmp == 'TS') && !attributes.value) ||
                 ((attributes.type == 'RT' || attributes.type_cmp == 'RT') && (!attributes.denominator_scalar || !attributes.numerator_scalar)) ||
                 ((attributes.type == 'ID' || attributes.type_cmp == 'ID') && (!attributes.root || !attributes.extension)) ||
                 (attributes.key == 'COMPONENT' && (!attributes.code_list_id_cmp)) ||
                 (attributes.key == 'FACILITY_LOCATION' && !attributes.code_list_id) ||
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
        @model.get('type') == "FAC" ||
        model_key == 'FACILITY_LOCATION' ||
        model_key  == 'DIAGNOSIS'   ||
        model_key  == 'RELATED_TO')

      compare_collection = @values.findWhere(key: model_key)

      # component code was put into another field to reuse the Thorax View
      # Therefore we have to swap code_list_id_cmp with code_list_id when saving
      if (@model.get('type') == "CMP")
        tmp = @model.get('code_list_id_cmp')
        @model.set code_list_id_cmp: @model.get('code_list_id')
        @model.set code_list_id: tmp

      if compare_collection
        col = compare_collection
        # We remove the collection and then re add it to trigger the UI to update
        @values.remove compare_collection
      if !col
        # Create a thorax model collection
        col = new Thorax.Model()
        col.set('key', model_key)
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

    # Set the drop downs back to empty.
    @$('select[name=reference_type]').val('')
    @$('select[name=reference_id]').val('')
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
