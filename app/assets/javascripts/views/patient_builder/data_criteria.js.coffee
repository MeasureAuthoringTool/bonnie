# Abstract base class for children of the patient builder that need to communicate with the top-level via events
class Thorax.Views.BuilderChildView extends Thorax.View
  events:
    ready: -> @patientBuilder().registerChild this
  patientBuilder: ->
    parent = @parent
    until parent instanceof Thorax.Views.PatientBuilder
      parent = parent.parent
    parent
  triggerMaterialize: ->
    @trigger 'bonnie:materialize'


class Thorax.Views.SelectCriteriaView extends Thorax.View
  template: JST['patient_builder/select_criteria']
  events:
    rendered: ->
      # FIXME: We'd like to do this via straight thorax events, doesn't seem to work...
      @$('.collapse').on 'show.bs.collapse hide.bs.collapse', => @$('.panel-expander').toggleClass('fa-angle-right fa-angle-down')
  faIcon: -> @collection.first()?.toPatientDataCriteria()?.faIcon()


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
    @editValueView = new Thorax.Views.EditCriteriaValueView(model: new Thorax.Model, measure: @measure, fieldValue: false, values: @model.get('value'))
    @editFieldValueView = new Thorax.Views.EditCriteriaValueView
      model: new Thorax.Model
      measure: @measure
      fieldValue: true
      values: @model.get('field_values')
      criteriaType: @model.get('type')

    @model.on 'highlight', (type) =>
      @$('.criteria-data').addClass(type)

  valueWithDateContext: (model) ->
    _(model.toJSON()).extend
      start_date: moment(model.get('value')).format('L') if model.get('type') == 'TS'
      start_time: moment(model.get('value')).format('LT') if model.get('type') == 'TS'


  # When we create the form and populate it, we want to convert times to moment-formatted dates
  context: ->
    cms_id_parts = if @model.get("cms_id") then @model.get("cms_id").match(/CMS(\d+)(V\d+)/i) else []
    _(super).extend
      start_date: moment(@model.get('start_date')).format('L') if @model.get('start_date')
      start_time: moment(@model.get('start_date')).format('LT') if @model.get('start_date')
      end_date: moment(@model.get('end_date')).format('L') if @model.get('end_date')
      end_time: moment(@model.get('end_date')).format('LT') if @model.get('end_date')
      end_date_is_undefined: !@model.has('end_date')
      codes: @measure.get('value_sets').map (vs) -> vs.toJSON()
      cms_id_number: cms_id_parts[1]
      cms_id_version: cms_id_parts[2]
      faIcon: @model.faIcon()

  # When we serialize the form, we want to convert formatted dates back to times
  events:
    serialize: (attr) ->
      if startDate = attr.start_date
        startDate += " #{attr.start_time}" if attr.start_time
        attr.start_date = moment(startDate, 'L LT').format('X') * 1000
      delete attr.start_time
      if attr.end_date_is_undefined
        attr.end_date = undefined
      else if endDate = attr.end_date
        endDate += " #{attr.end_time}" if attr.end_time
        attr.end_date = moment(endDate, 'L LT').format('X') * 1000
      attr.negation = !!attr.negation && !_.isEmpty(attr.negation_code_list_id)
      delete attr.end_date_is_undefined
      delete attr.end_time
    rendered: ->
      @$('.criteria-data.droppable').droppable greedy: true, accept: '.ui-draggable', hoverClass: 'drop-target-highlight', drop: _.bind(@dropCriteria, this)
      @$('.date-picker').datepicker().on 'changeDate', _.bind(@triggerMaterialize, this)
      @$('.time-picker').timepicker().on 'changeTime.timepicker', _.bind(@triggerMaterialize, this)
    'change .negation-select':                    'toggleNegationSelect'
    'change :input[name=end_date_is_undefined]':  'toggleEndDateDefinition'
    'blur :text':                                 'triggerMaterialize'
    'change select':                              'triggerMaterialize'

  dropCriteria: (e, ui) ->
    # When we drop a new criteria on an existing criteria
    droppedCriteria = $(ui.draggable).model().toPatientDataCriteria()
    targetCriteria = $(e.target).model()
    droppedCriteria.set start_date: targetCriteria.get('start_date'), end_date: targetCriteria.get('end_date')
    @trigger 'bonnie:dropCriteria', droppedCriteria
    return false

  toggleDetails: (e) ->
    e.preventDefault()
    @$('.criteria-details, form').toggleClass('hide')
    @$('.criteria-type-marker').toggleClass('open')
    unless @$('form').is ':visible'
      @serialize(children: false)
      # FIXME sortable: commenting out due to odd bug in droppable
      # @model.trigger 'close', @model
      @render() # re-sorting the collection will re-render this view, remove this if we use above approach

  showDelete: (e) ->
    e.preventDefault()
    $btn = $(e.currentTarget)
    $btn.toggleClass('btn-danger btn-danger-inverse').prev().toggleClass('hide')

  toggleEndDateDefinition: (e) ->
    $cb = $(e.target)
    $endDateTime = @$('input[name=end_date], input[name=end_time]')
    $endDateTime.val('') if $cb.is(':checked')
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


class Thorax.Views.EditCriteriaValueView extends Thorax.Views.BuilderChildView
  className: -> "#{if @fieldValue then 'field-' else ''}value-formset"

  template: JST['patient_builder/edit_value']

  initialize: ->
    @model.set('type', 'PQ')

  context: ->
    _(super).extend
      codes: @measure.get('value_sets').map (vs) -> vs.toJSON()
      fields: Thorax.Models.Measure.logicFieldsFor(@criteriaType)

  # When we serialize the form, we want to put the description for any CD codes into the submission
  events:
    serialize: (attr) ->
      if startDate = attr.start_date
        startDate += " #{attr.start_time}" if attr.start_time
        attr.value = moment(startDate, 'L LT').format('X') * 1000
      delete attr.start_date
      delete attr.start_time
      title = @measure.get('value_sets').findWhere(oid: attr.code_list_id)?.get('display_name')
      attr.title = title if title
    rendered: ->
      @$("select[name=type]").selectBoxIt()
      @$('.date-picker').datepicker().on 'changeDate', _.bind(@validateForAddition, this)
      @$('.time-picker').timepicker().on 'changeTime.timepicker', _.bind(@validateForAddition, this)
    'change select[name=type]': (e) ->
      @model.set type: $(e.target).val()
      @validateForAddition()
    'change select': 'validateForAddition'
    'keyup input': 'validateForAddition'

  validateForAddition: ->
    attributes = @serialize(set: false) # Gets copy of attributes from form without setting model
    isDisabled = (attributes.type == 'PQ' && !attributes.value) ||
                 (attributes.type == 'CD' && !attributes.code_list_id) ||
                 (attributes.type == 'TS' && !attributes.value) ||
                 (@fieldValue && !attributes.key)
    @$('button[data-call-method=addValue]').prop 'disabled', isDisabled

  addValue: (e) ->
    e.preventDefault()
    @serialize()
    @values.add @model.clone()
    # Reset model to default values
    @model.clear()
    @model.set type: 'PQ'
    # clear() removes fields (which we want), but then populate() doesn't clear the select; clear it
    @$('select[name=key]').val('')
    # Let the selectBoxIt() select box know that its value may have changed
    @$('select[name=type]').change()
    @triggerMaterialize()
