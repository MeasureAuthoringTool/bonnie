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
      collection: @model.getExpectedValues(@measure)
      measure: @measure
    @populationLogicView = new Thorax.Views.BuilderPopulationLogic
    @populationLogicView.setPopulation @measure.get('populations').first()
    @populationLogicView.showRationale @model
    @expectedValuesView.on 'population:select', (population_index) =>
      @populationLogicView.setPopulation @measure.get('populations').at(population_index)
      @materialize()
    @model.on 'materialize', =>
      @populationLogicView.showRationale @model

  dataCriteriaCategories: ->
    categories = {}
    @measure?.get('source_data_criteria').each (criteria) ->
      type = criteria.get('type').replace(/_/g, ' ')
      # Filter out negations
      filter_criteria = criteria.get('negation') or
      ( criteria.get('definition') is 'patient_characteristic_birthdate' ) or
      ( criteria.get('definition') is 'patient_characteristic_gender' ) or
      ( criteria.get('definition') is 'patient_characteristic_expired' ) or
      ( criteria.get('definition') is 'patient_characteristic_race' ) or
      ( criteria.get('definition') is 'patient_characteristic_ethnicity' ) or
      ( criteria.get('definition') is 'patient_characteristic_payer' )
      unless filter_criteria
        categories[type] ||= new Thorax.Collection
        categories[type].add criteria unless categories[type].any (c) -> c.get('description') == criteria.get('description')
    _(categories).omit('transfers')

  events:
    rendered: ->
      @$('.draggable').draggable revert: 'invalid', helper: 'clone', zIndex: 10

      # Make parent droppable
      @$('.patient-data-list.droppable').droppable greedy: true, accept: '.ui-draggable', drop: _.bind(@drop, this)
      # Make current and future data criteria children droppable
      @$('.patient-data-list').on 'drop', '.patient-data.droppable', _.bind(@drop, this)

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
    patientDataCriteria = $(ui.draggable).model().toPatientDataCriteria()
    dropTargetModel = $(e.target).model()
    if dropTargetModel instanceof Thorax.Models.PatientDataCriteria
      patientDataCriteria.set('start_date', dropTargetModel.get('start_date'))
      patientDataCriteria.set('end_date', dropTargetModel.get('end_date'))
    @model.get('source_data_criteria').add patientDataCriteria
    @materialize()
    false

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


class Thorax.Views.EditCriteriaView extends Thorax.View

  template: JST['patient_builder/edit_criteria']

  options:
    serialize: { children: false }
    populate: { context: true, children: false }

  initialize: ->
    @editValueView = new Thorax.Views.EditCriteriaValueView(model: new Thorax.Model, measure: @measure, fieldValue: false, values: @model.get('value'))
    @editFieldValueView = new Thorax.Views.EditCriteriaValueView(model: new Thorax.Model, measure: @measure, fieldValue: true, values: @model.get('field_values'))

  valueWithDateContext: (model) ->
    _(model.toJSON()).extend
      start_date: moment(model.get('value')).format('L') if model.get('type') == 'TS'
      start_time: moment(model.get('value')).format('LT') if model.get('type') == 'TS'


  # When we create the form and populate it, we want to convert times to moment-formatted dates
  context: ->
    _(super).extend
      start_date: moment(@model.get('start_date')).format('L') if @model.get('start_date')
      start_time: moment(@model.get('start_date')).format('LT') if @model.get('start_date')
      end_date: moment(@model.get('end_date')).format('L') if @model.get('end_date')
      end_time: moment(@model.get('end_date')).format('LT') if @model.get('end_date')
      codes: @measure.get('value_sets').map (vs) -> vs.toJSON()
      faIcon: @model.faIcon()

  # When we serialize the form, we want to convert formatted dates back to times
  events:
    serialize: (attr) ->
      if startDate = attr.start_date
        startDate += " #{attr.start_time}" if attr.start_time
        attr.start_date = moment(startDate, 'L LT').format('X') * 1000
      delete attr.start_time
      if endDate = attr.end_date
        endDate += " #{attr.end_time}" if attr.end_time
        attr.end_date = moment(endDate, 'L LT').format('X') * 1000
      delete attr.end_time
    rendered: ->
      @$('.patient-data.droppable').droppable greedy: true, accept: '.ui-draggable', hoverClass: 'drop-target-highlight'
    'change .negation-select': 'toggleNegationSelect'

  toggleDetails: (e) ->
    e.preventDefault()
    @$('.concise').toggle()
    @$('.details').toggle()
    @$('.circle-icon').toggleClass('active-icon')

  toggleNegationSelect: (e) ->
    @$('.negation-code-list').toggleClass('hide')

  closeDetails: ->
    @serialize(children: false)
    @render()

  removeCriteria: (e) ->
    e.preventDefault()
    @model.destroy()

  removeValue: (e) ->
    e.preventDefault()
    $(e.target).model().destroy()


class Thorax.Views.EditCriteriaValueView extends Thorax.View

  template: JST['patient_builder/edit_value']

  initialize: ->
    @model.set('type', 'PQ')

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
      if startDate = attr.start_date
        startDate += " #{attr.start_time}" if attr.start_time
        attr.value = moment(startDate, 'L LT').format('X') * 1000
      delete attr.start_date
      delete attr.start_time
      attr.title = @measure.get('value_sets').findWhere(oid: attr.code_list_id)?.get('display_name')

  # Below need to work for any value, not just first
  setScalarValue: (e) ->
    e.preventDefault()
    @model.set 'type', 'PQ'

  setCodedValue: (e) ->
    e.preventDefault()
    @model.set 'type', 'CD'

  setTimeValue: (e) ->
    e.preventDefault()
    @model.set 'type', 'TS'

  addValue: (e) ->
    e.preventDefault()
    @serialize()
    @values.add @model.clone()
    # Reset model to default value (as described in initialize), then reset form (unfortunately not re-rendered automatically)
    @model.clear()
    @model.set('type', 'PQ') # TODO unify this line with setting the type in `initialize`
    @$('select').val ''


class Thorax.Views.ExpectedValuesView extends Thorax.View

  template: JST['patient_builder/expected_values']

  initialize: ->
    @expectedValueCollectionView = new Thorax.CollectionView
      className: 'tab-content expected-value'
      collection: @collection
      itemView: (item) => new Thorax.Views.ExpectedValueView
        model: item.model
        measure: @measure
        className: "tab-pane"
        id: "expected-#{item.model.get('population_index')}"

  serialize: ->
    childView.serialize() for cid, childView of @expectedValueCollectionView.children
    super

  hasMultipleTabs: ->
    if @collection.length > 1 then true else false

  populationContext: (expectedValue) ->
    population = @measure.get('populations').at expectedValue.get('population_index')
    populationTitle: population.get('title') || population.get('sub_id')
    population_index: expectedValue.get('population_index')

  # When we serialize the form, we want to update the expected_values hash
  events:
    rendered: ->
      # We set the active tabs when rendered rather than trying to do it in the template
      # because changes to the ExpectdValueView that happen when serializing (for materialization)
      # drive the individual tabs to be re-rendered
      @$('a[data-toggle="tab"]:first').tab('show')
      @$('.tab-pane:first').addClass('active') # This seems to be necessary because we're not in the DOM yet?
      # When the tabs are toggled, we want to send a message over to another view, use an event
      @$el.on 'shown.bs.tab', 'a[data-toggle="tab"]', (e) =>
        expectedValue = $(e.target).model()
        @trigger 'population:select', expectedValue.get('population_index')

class Thorax.Views.ExpectedValueView extends Thorax.View

  template: JST['patient_builder/expected_value']

  options:
    populate: { context: true }

  events:
    serialize: (attr) ->
      for pc in @model.populationCriteria()
        if @measure.get('episode_of_care') || (@measure.get('continuous_variable') && pc == 'OBSERV')
          attr[pc] = parseFloat(attr[pc])
        else
          attr[pc] = if attr[pc] then 1 else 0 # Convert from check-box true/false to 0/1

  context: ->
    context = super
    for pc in @model.populationCriteria()
      unless @measure.get('episode_of_care') || (@measure.get('continuous_variable') && pc == 'OBSERV')
        context[pc] = (context[pc] == 1)
    context

  initialize: ->
    criteriaMap =
      IPP: 'INITIAL PATIENT POP.'
      DENOM: 'DENOMINATOR'
      NUMER: 'NUMERATOR'
      DENEXCEP: 'EXCEPTION'
      DENEX: 'EXCLUSION'
      MSRPOPL: 'MEASURE POPULATION'
      OBSERV: 'MEASURE OBSERVATIONS'
    @currentCriteria = []
    for pc in @model.populationCriteria()
      @currentCriteria.push
        key: pc
        displayName: criteriaMap[pc]
        isEoC: @measure.get('episode_of_care')
