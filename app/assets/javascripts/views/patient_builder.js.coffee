class Thorax.Views.PatientBuilder extends Thorax.View
  className: 'patient-builder'

  template: JST['patient_builder/patient_builder']

  options:
    serialize: { children: false }
    populate: { context: true, children: false }

  initialize: ->
    @originalModel = @model # When we're done editing we want to update the original model
    @setModel @model.deepClone() # Working on a clone allows cancel to easily drop any changes we make
    @model.get('source_data_criteria').on 'remove', => @materialize()
    @editCriteriaCollectionView = new Thorax.CollectionView
      collection: @model.get('source_data_criteria')
      itemView: (item) => new Thorax.Views.EditCriteriaView(model: item.model, measure: @measure)
    @expectedValuesView = new Thorax.Views.ExpectedValuesView
      model: @model
      measure: @measure
      edit: true
      values: _.extend({}, @model.get('expected_values'))
    @populationLogicView = new Thorax.Views.BuilderPopulationLogic
    @populationLogicView.setPopulation @measure.get('populations').first()
    @populationLogicView.showRationale @model
    @expectedValuesView.on 'population:select', (population) =>
      @populationLogicView.setPopulation population
      @materialize()
    @model.on 'materialize', =>
      @populationLogicView.showRationale @model

  dataCriteriaCategories: ->
    categories = {}
    @measure?.get('source_data_criteria').each (criteria) ->
      type = criteria.get('type').replace(/_/g, ' ')
      categories[type] ||= new Thorax.Collection
      categories[type].add criteria unless categories[type].any (c) -> c.get('description') == criteria.get('description')
    _(categories).omit('characteristic')

  events:
    rendered: ->
      @$('.draggable').draggable revert: 'invalid', helper: 'clone', zIndex: 10
      @$('.droppable').droppable accept: '.ui-draggable'
      # TODO move event handling up into events object, if possible
      @$('.droppable').on 'drop', _.bind(@drop, this)
      # These cannot be handled as a thorax event because we want it to apply to new DOM elements too
      @$el.on 'blur', 'input[type="text"]', => @materialize()
      @$el.on 'change', 'select', => @materialize()
    model:
      sync: (model) ->
        @patients.add model # make sure that the patient exist in the global patient collection
        @measure?.get('patients').add model # and the measure's patient collection
        route = if @measure then "measures/#{@measure.get('hqmf_set_id')}" else "patients"
        bonnie.navigate route, trigger: true
    serialize: (attr) ->
      attr.birthdate = moment(attr.birthdate, 'L LT').format('X') if attr.birthdate

  # When we create the form and populate it, we want to convert some values to those appropriate for the form
  context: ->
    _(super).extend
      measureTitle: @measure.get('title')
      measureDescription: @measure.get('description')
      birthdate: moment(@model.get('birthdate'), 'X').format('L LT') if @model.get('birthdate')
      expired: @model.get('expired')?.toString() # Convert boolean to string

  serializeWithChildren: ->
    # Serialize the main view and the child collection views separately because otherwise Thorax wants
    # to put attributes from the child views on the parent object
    @serialize(children: false)
    childView.serialize(children: false) for cid, childView of @editCriteriaCollectionView.children
    @expectedValuesView.serialize(children: false)

  drop: (e, ui) ->
    measureDataCriteria = $(ui.draggable).model()
    @model.get('source_data_criteria').add measureDataCriteria.toPatientDataCriteria()
    @materialize()

  materialize: ->
    @serializeWithChildren()
    @model.materialize()

  save: (e) ->
    e.preventDefault()
    $(e.target).button('saving').prop('disabled', true)
    @serializeWithChildren()
    @originalModel.save @model.toJSON() # FIXME: The sync event on the model, defined above, only fires because there's a Thorax bug!

  cancel: (e) ->
    # Go back to wherever the user came from, if possible
    e.preventDefault()
    window.history.back()


class Thorax.Views.BuilderPopulationLogic extends Thorax.LayoutView
  template: JST['patient_builder/population_logic']
  setPopulation: (population) ->
    @setModel(population)
    @setView new Thorax.Views.PopulationLogic(model: population)
  showRationale: (patient) ->
    @getView().showRationale(@model.calculate(patient))
  context: ->
    _(super).extend 
      title: if @model.collection.parent.get('populations').length > 1 then (@model.get('title') || @model.get('sub_id')) else ''


class Thorax.Views.SelectCriteriaView extends Thorax.View
  template: JST['patient_builder/select_criteria']
  events:
    rendered: ->
      # FIXME: We'd like to do this via straight thorax events, doesn't seem to work...
      @$('.collapse').on 'show.bs.collapse', (e) => @$('.indicator').removeClass('fa-angle-right').addClass('fa-angle-down')
      @$('.collapse').on 'hide.bs.collapse', (e) => @$('.indicator').removeClass('fa-angle-down').addClass('fa-angle-right')
  faIcon: -> @collection.first()?.toPatientDataCriteria()?.faIcon()


# FIXME: When we get coffeescript scoping working again, don't need to put this in Thorax.Views scope
class Thorax.Views.EditCriteriaView extends Thorax.View

  template: JST['patient_builder/edit_criteria']

  options:
    serialize: { children: false }
    populate: { context: true, children: false }

  initialize: ->
    @editValueCollectionView = new Thorax.CollectionView
      collection: @model.get('value')
      itemView: (item) => new Thorax.Views.EditCriteriaValueView(model: item.model, measure: @measure, fieldValue: false)
    @editFieldValueCollectionView = new Thorax.CollectionView
      collection: @model.get('field_values')
      itemView: (item) => new Thorax.Views.EditCriteriaValueView(model: item.model, measure: @measure, fieldValue: true)

  serialize: ->
    childView.serialize() for cid, childView of @editValueCollectionView.children
    childView.serialize() for cid, childView of @editFieldValueCollectionView.children
    super

  # When we create the form and populate it, we want to convert times to moment-formatted dates
  context: ->
    _(super).extend
      start_date: moment(@model.get('start_date')).format('L LT') if @model.get('start_date')
      end_date: moment(@model.get('end_date')).format('L LT') if @model.get('end_date')
      codes: @measure.get('value_sets').map (vs) -> vs.toJSON()
      faIcon: @model.faIcon()

  # When we serialize the form, we want to convert formatted dates back to times
  events:
    serialize: (attr) ->
      attr.start_date = moment(attr.start_date, 'L LT').format('X') * 1000 if attr.start_date
      attr.end_date = moment(attr.end_date, 'L LT').format('X') * 1000 if attr.end_date
    'change .negation-select': 'toggleNegationSelect'

  toggleDetails: (e) ->
    e.preventDefault()
    @$('.concise').toggle()
    @$('.details').toggle()

  toggleNegationSelect: (e) ->
    @$('.negation-code-list').toggleClass('hide')

  closeDetails: ->
    @serialize(children: false)
    @render()

  removeCriteria: (e) ->
    e.preventDefault()
    @model.destroy()

  newScalarValue: (e) ->
    e.preventDefault()
    @model.get('value').add type: 'PQ'

  newCodedValue: (e) ->
    e.preventDefault()
    @model.get('value').add type: 'CD'

  newScalarFieldValue: (e) ->
    e.preventDefault()
    @model.get('field_values').add type: 'PQ'

  newCodedFieldValue: (e) ->
    e.preventDefault()
    @model.get('field_values').add type: 'CD'

  newTimeFieldValue: (e) ->
    e.preventDefault()
    @model.get('field_values').add type: 'TS'


class Thorax.Views.EditCriteriaValueView extends Thorax.View

  template: JST['patient_builder/edit_value']

  context: ->
    _(super).extend
      typePQ: @model.get('type') is 'PQ'
      typeCD: @model.get('type') is 'CD'
      typeTS: @model.get('type') is 'TS'
      codes: @measure.get('value_sets').map (vs) -> vs.toJSON()
      fields: Thorax.Models.Measure.logicFields

  # When we serialize the form, we want to put the description for any CD codes into the submission
  events:
    serialize: (attr) ->
      attr.title = @measure.get('value_sets').findWhere(oid: attr.code_list_id)?.get('display_name')

  removeValue: (e) ->
    e.preventDefault()
    @model.destroy()


class Thorax.Views.ExpectedValuesView extends Thorax.View

  template: JST['patient_builder/expected_values']

  # FIXME: Needs re-writing for elegance
  initialize: ->
    @populations = @measure.get('populations')
    @popCriteria = @measure.get('population_criteria')
    if not @values? or _.size(@values) is 0
      # if the patient has no expected values, create them
      @values = {}
      evs = @values
      evs[@measure.get('hqmf_set_id')] = {}
      m = @measure
      pc = @popCriteria
      @populations.each (p) ->
        pevHash = {}
        for key in (pop for pop in _.keys(pc) when p.has(pop))
          pevHash[key] = 0
        evs[m.get('hqmf_set_id')][p.get('sub_id')] = pevHash

  hasMultipleTabs: ->
    if @populations.length > 1 then true else false

  # When we serialize the form, we want to update the expected_values hash
  events:
    rendered: ->
      # FIXME: We'd like to do this via straight thorax events, doesn't seem to work...
      @$('a[data-toggle="tab"]').on 'shown.bs.tab', (e) =>
        population = $(e.target).model()
        @trigger 'population:select', population
    serialize: (attr) ->
      # get all the checkboxes: $('.expected-value-tab > div > .expected-values > form > .checkbox > label > input')
      # get checkbox by id: $('.expected-value-tab > div > .expected-values > form > .checkbox > label > #DENEX')
      parsedValues = {}
      parsedValues[@measure.get('hqmf_set_id')] = {}
      # attr.expected_values = _.extend({}, @values)
      pc = @popCriteria
      m = @measure
      @populations.each (p) ->
        pevHash = {}
        for key in (pop for pop in _.keys(pc) when p.has(pop))
        # selections = @$("##{p.get('sub_id')} > div > .expected-values > form > .checkbox > label > input")
          # console.log @$("##{p.get('sub_id')} > div > .expected-values > form > .checkbox > label > ##{key}")
          # checkedValue = @$("#expected-#{p.get('sub_id')} > div > .expected-values > form > .checkbox > label > ##{key}").prop('checked')
          if key is 'OBSERV'
            pevHash[key] = parseFloat(@$(".#{p.get('sub_id')}-#{key} > ##{key}").prop('value'))
          # FIXME If enabling EoC measures, uncomment the following two lines to save values correctly
          # else if m.get('episode_of_care') is true
          #   pevHash[key] = parseFloat(@$(".#{p.get('sub_id')}-#{key} > ##{key}").prop('value'))
          else
            checkedValue = @$(".#{p.get('sub_id')}-#{key} > ##{key}").prop('checked')
            if checkedValue is true then pevHash[key] = 1 else pevHash[key] = 0
        parsedValues[m.get('hqmf_set_id')][p.get('sub_id')] = pevHash
      attr.expected_values = _.extend({}, parsedValues)

class Thorax.Views.ExpectedValueView extends Thorax.View

  template: JST['patient_builder/expected_value']
  # currently supported ev values are 0/1 for unchecked/checked
  evStatus:
    '0': ['unchecked', 'danger', 1]
    '1': ['check', 'success', 0]

  initialize: ->
    c = @criteria
    p = @population
    matchingCriteria = (criteria for criteria in Thorax.Models.Measure.allPopulationCodes when criteria in _.keys(p))
    criteriaMap =
      IPP: 'INITIAL PATIENT POP.'
      DENOM: 'DENOMINATOR'
      NUMER: 'NUMERATOR'
      DENEXCEP: 'EXCEPTION'
      DENEX: 'EXCLUSION'
      MSRPOPL: 'MEASURE POPULATION'
      OBSERV: 'MEASURE OBSERVATIONS'
    @currentCriteria = []
    for mc in matchingCriteria
      # FIXME If enabling EoC measures, replace isEoC with @measure.get('episode_of_care') instead of false
      @currentCriteria.push 
        cid: "#{p.sub_id}-#{mc}"
        key: mc
        displayName: criteriaMap[mc]
        value: @modelValues[@measure.get('hqmf_set_id')]?[@population.sub_id][mc]
        isEoC: false

  events: ->
    'rendered': 'setValues'

  setValues: ->
    for c in _.keys(@currentCriteria)
      criteria = @currentCriteria[c].key
      if @editFlag is false
        @$('#' + criteria).prop('disabled', true)