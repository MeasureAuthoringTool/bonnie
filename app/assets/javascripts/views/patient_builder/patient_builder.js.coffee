class Thorax.Views.PatientBuilder extends Thorax.Views.BonnieView
  className: 'patient-builder'

  template: JST['patient_builder/patient_builder']

  options:
    serialize: { children: false }
    populate: { context: true, children: false }

  initialize: ->
    @originalModel = @model # When we're done editing we want to update the original model
    @setModel @model.deepClone() # Working on a clone allows cancel to easily drop any changes we make
    @model.get('source_data_criteria').on 'remove', => @materialize()
    if bonnie.isPortfolio
      @measureRibbon = new Thorax.Views.MeasureRibbon model: @model
    @editCriteriaCollectionView = new Thorax.CollectionView
      collection: @model.get('source_data_criteria')
      itemView: (item) => new Thorax.Views.EditCriteriaView(model: item.model, measure: @measure)
      events:
        collection:
          close: -> @collection.sort()
    @expectedValuesView = new Thorax.Views.ExpectedValuesView
      collection: @model.getExpectedValues(@measure)
      measure: @measure
    @populationLogicView = new Thorax.Views.BuilderPopulationLogic
    @populationLogicView.setPopulation @measure.get('populations').first()
    @populationLogicView.showRationale @model
    @expectedValuesView.on 'population:select', (population_index) =>
      @populationLogicView.setPopulation @measure.get('populations').at(population_index)
      @populationLogicView.showRationale @model
      @populationLogicView.$('.panel').animate(backgroundColor: '#fcf8e3').animate(backgroundColor: 'inherit')
    @model.on 'materialize', =>
      @populationLogicView.showRationale @model
    @model.on 'clearHighlight', =>
      @$('.criteria-data').removeClass("#{Thorax.Views.EditCriteriaView.highlight.valid} #{Thorax.Views.EditCriteriaView.highlight.partial}")
      @$('.highlight-indicator').removeAttr('tabindex').empty()

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
        categories[type].add criteria unless categories[type].any (c) -> c.get('description').replace(/,/g , "") == criteria.get('description').replace(/,/g , "")
    _(categories).omit('transfers','derived')

  events:
    'blur :text':               'materialize'  
    'change select': (e) ->
      @materialize()
      switch @$(e.target).attr('name') #jquery with focusable next for each select elements change
        when 'payer'
          @$('input[name="birthdate"]').focus()
        when 'race'
          @$('select[name="gender"]').focus()
        when 'gender'
          @$('input[name="expired"]').focus()
        when 'ethnicity'
          '' #where should the next field jump to?
    'click .deceased-checkbox': 'toggleDeceased'
    # hide date-picker if it's still visible and focus is not on a .date-picker input (occurs with JAWS SR arrow-key navigation)
    'focus .form-control': (e) -> if not @$(e.target).hasClass('date-picker') and $('.datepicker').is(':visible') then @$('.date-picker').datepicker('hide')
    rendered: ->
      @$('.draggable').draggable revert: 'invalid', helper: 'clone', zIndex: 10

      # Make criteria list a drop target
      @$('.criteria-container.droppable').droppable greedy: true, accept: '.ui-draggable', drop: _.bind(@drop, this)

      @$('.date-picker').datepicker().on 'changeDate', _.bind(@materialize, this)
      @$('.time-picker').timepicker(template: false).on 'changeTime.timepicker', _.bind(@materialize, this)
      $('.indicator-circle, .navbar-nav > li').removeClass('active')
      $('.indicator-patient-builder').addClass('active')
    serialize: (attr) ->
      birthdate = attr.birthdate if attr.birthdate
      birthdate += " #{attr.birthtime}" if attr.birthdate && attr.birthtime
      attr.birthdate = moment.utc(birthdate, 'L LT').format('X') if birthdate
      deathdate = attr.deathdate if attr.deathdate
      deathdate += " #{attr.deathtime}" if attr.deathdate && attr.deathtime
      attr.deathdate = moment.utc(deathdate, 'L LT').format('X') if deathdate

  # When we create the form and populate it, we want to convert some values to those appropriate for the form
  context: ->
    birthdatetime = moment.utc(@model.get('birthdate'), 'X') if @model.has('birthdate')
    deathdatetime = moment.utc(@model.get('deathdate'), 'X') if @model.get('expired') && @model.has('deathdate')
    _(super).extend
      measureTitle: @measure.get('title')
      measureDescription: @measure.get('description')
      birthdate: birthdatetime?.format('L')
      birthtime: birthdatetime?.format('LT')
      deathdate: deathdatetime?.format('L')
      deathtime: deathdatetime?.format('LT')

  serializeWithChildren: ->
    # Serialize the main view and the child collection views separately because otherwise Thorax wants
    # to put attributes from the child views on the parent object
    @serialize(children: false)
    childView.serialize(children: false) for cid, childView of @editCriteriaCollectionView.children
    @expectedValuesView.serialize(children: false)

  drop: (e, ui) ->
    patientDataCriteria = $(ui.draggable).model().toPatientDataCriteria()
    @addCriteria patientDataCriteria
    return false

  registerChild: (child) ->
    child.on 'bonnie:materialize', @materialize, this
    child.on 'bonnie:dropCriteria', @addCriteria, this
    child.on 'bonnie:loadPopulation', @loadPopulation, this

  materialize: ->
    @serializeWithChildren()
    @model.materialize()

  addCriteria: (criteria) ->
    @model.get('source_data_criteria').add criteria
    @materialize()
    # close any open elements and then open the new element
    @$('button[data-call-method="toggleDetails"] > .fa-angle-down:visible').click()
    @$(".criteria-#{criteria.cid} > button").click()

  loadPopulation: (population) ->
    @measure = population.collection.parent
    @render()
    @expectedValuesView.refresh(population, @model.getExpectedValues(@measure))
    @populationLogicView.setPopulation population
    bonnie.navigate "measures/#{@measure.get('hqmf_set_id')}/patients/#{@model.id}/edit"

  save: (e) ->
    e.preventDefault()
    @$('.has-error').removeClass('has-error')
    $(e.target).button('saving').prop('disabled', true)
    @serializeWithChildren()
    @model.sortCriteriaBy 'start_date', 'end_date'
    status = @originalModel.save @model.toJSON(),
      success: (model) =>
        @patients.add model # make sure that the patient exist in the global patient collection
        @measure?.get('patients').add model # and the measure's patient collection
        if bonnie.isPortfolio
          @measures.each (m) -> m.get('patients').add model
        route = if @measure then "measures/#{@measure.get('hqmf_set_id')}" else "patients"
        bonnie.navigate route, trigger: true
    unless status
      $(e.target).button('reset').prop('disabled', false)
      messages = []
      for [cid, field, message] in @originalModel.validationError
        # Location holds the cid of the model with the error, either toplevel or a data criteria, from whcih we get the view
        if cid == @originalModel.cid
          @$(":input[name=#{field}]").closest('.form-group').addClass('has-error')
        else
          @$("[data-model-cid=#{cid}]").view().highlightError(e, field)
        messages.push message
      @$('.alert').text(_(messages).uniq().join('; ')).removeClass('hidden')

  cancel: (e) ->
    # Go back to wherever the user came from, if possible
    e.preventDefault()
    window.history.back()

  toggleDeceased: (e) ->
    @model.set 'expired', true
    @$('#deathdate').focus()

  removeDeathDate: (e) ->
    e.preventDefault()
    @model.set 'deathdate', null
    @model.set 'expired', false
    @$('#expired').focus()

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
      cms_id: @model.collection.parent.get('cms_id')
