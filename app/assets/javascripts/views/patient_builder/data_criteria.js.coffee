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

    # view that allows for editing new attribute values
    @attributeEditorView = new Thorax.Views.DataCriteriaAttributeEditorView(model: @model)
    @listenTo @attributeEditorView, 'attributesModified', @attributesModified

    # view that allows for negating the data criteria, will not display on non-negateable data criteria
    @negationRationaleView = new Thorax.Views.InputCodeView({ cqmValueSets: @measure.get('cqmValueSets'), codeSystemMap: @measure.codeSystemMap(), attributeName: 'negationRationale', initialValue: @model.get('qdmDataElement').negationRationale })
    @listenTo @negationRationaleView, 'valueChanged', @updateAttributeFromInputChange

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
    'change .negation-select': 'toggleNegationSelect'

  updateAttributeFromInputChange: (inputView) ->
    @model.get('qdmDataElement')[inputView.attributeName] = inputView.value
    @triggerMaterialize()

  attributesModified: ->
    @attributeDisplayView.render()
    @triggerMaterialize()

  isDuringMeasurePeriod: ->
    timingAttribute = @model.get('qdmDataElement')[@model.getPrimaryTimingAttribute()]
    if !timingAttribute?
      return false

    if timingAttribute.isInterval
      timingAttribute.low?.year is timingAttribute.high?.year is @model.measure().getMeasurePeriodYear()
    else
      timingAttribute.year is @model.measure().getMeasurePeriodYear()

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
    droppedCriteria.setNewId()

    targetCriteria = $(e.target).model()
    @copyTimingAttributes(droppedCriteria, targetCriteria)
    @trigger 'bonnie:dropCriteria', droppedCriteria
    return false

  isExpanded: -> @$('form').is ':visible'

  toggleNegationSelect: (e) ->
    if $(e.target).is(":checked")
      @$('.negationRationaleCodeEntry').removeClass('hidden')
    else
      @$('.negationRationaleCodeEntry').addClass('hidden')
      @model.get('qdmDataElement').negationRationale = null
      @model.set('negation', false, {silent: true})
    @negationRationaleView.resetCodeSelection()

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
