class Thorax.Views.PatientBuilder extends Thorax.Views.BonnieView
  className: 'patient-builder'

  template: JST['patient_builder/patient_builder']

  options:
    serialize: { children: false }
    populate: { context: true, children: false }

  initialize: ->
    @originalModel = @model # When we're done editing we want to update the original model
    @cqmMeasure = @measure.get('cqmMeasure')
    @setModel @model.deepClone() # Working on a clone allows cancel to easily drop any changes we make
    @model.get('source_data_criteria').on 'remove', => @materialize()
    @race_codes = @model.getConceptsForDataElement('race', @measure)
    @ethnicity_codes = @model.getConceptsForDataElement('ethnicity', @measure)
    @gender_codes = @model.getConceptsForDataElement('gender', @measure)
    @payer_codes = @model.getConceptsForDataElement('payer', @measure)
    @first = @model.getFirstName()
    @last = @model.getLastName()
    @birthdate = @model.getBirthDate()
    @birthtime = @model.getBirthTime()
    @deathdate = @model.getDeathDate()
    @deathtime = @model.getDeathTime()
    @race = @model.getRace().code
    @gender = @model.getGender().code
    @ethnicity = @model.getEthnicity().code
    @payer = @model.getPayer().code
    @notes = @model.getNotes()
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
    @populationLogicView.setPopulation @measure.get('displayedPopulation')
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
    unless @cqmMeasure.component
      @valueSetCodeCheckerView = new Thorax.Views.ValueSetCodeChecker(patient: @model, measure: @measure)
    if @cqmMeasure.component or @cqmMeasure.composite
      @compositeSharingWarningView = new Thorax.Views.CompositeSharingWarning()
    @patientCharacteristicCheckerView = new Thorax.Views.PatientCharacteristicChecker(patient: @model, measure: @measure)

  dataCriteriaCategories: ->
    categories = {}
    @measure?.get('source_data_criteria').each (criteria) ->
      type = criteria.get('qdmCategory').replace(/_/g, ' ')
      # Filter out negations, certain patient characteristics, and specific occurrences
      # Note: we previously filtered out patient_characteristic_payer, but that was needed on the elements list
      # because a payer can have a start and stop date in QDM 5
      filter_criteria = criteria.get('negation') or
      ( ( criteria.get('qdmCategory') is 'patient_characteristic' ) && criteria.get('_type') != 'QDM::PatientCharacteristicPayer')
      unless filter_criteria
        categories[type] ||= new Thorax.Collection
        categories[type].add criteria unless categories[type].any (c) -> c.get('description').replace(/,/g , '') == criteria.get('description').replace(/,/g , '') && c.get('code_list_id') == criteria.get('code_list_id')
    categories = _(categories).omit('transfers','derived')
    # Pass a sorted array to the view so ordering is consistent
    categoriesArray = ({ type: type, criteria: criteria } for type, criteria of categories)
    _(categoriesArray).sortBy (entry) -> entry.type

  events:
    'blur :text': (e) -> @materialize()
    'change select': (e) -> @materialize()
    'click .deceased-checkbox': 'toggleDeceased'
    # hide date-picker if it's still visible and focus is not on a .date-picker input (occurs with JAWS SR arrow-key navigation)
    'focus .form-control': (e) -> if not @$(e.target).hasClass('date-picker') and $('.datepicker').is(':visible') then @$('.date-picker').datepicker('hide')
    # toggle showing the measure description
    'click .expand.opened': ->
      @$('.description').animate 'max-height': parseInt(@$('.description').css('line-height')) * 3 # contract
      @$('.expand').toggleClass('closed opened').html 'Show more <i class="fa fa-caret-down"></i>'
    'click .expand.closed': ->
      if @$('.description')[0].scrollHeight > @$('.description').height()
        @$('.description').animate 'max-height': @$('.description')[0].scrollHeight # expand
        @$('.expand').toggleClass('closed opened').html 'Show less <i class="fa fa-caret-up"></i>'
      else
        # FIXME: remove this toggle if the description is too short on render rather than on this click.
        @$('.expand').html('Nothing more to show...').fadeOut 2000, -> $(@).remove()

    rendered: ->
      @$('.draggable').draggable revert: 'invalid', helper: 'clone', appendTo: '.patient-builder', zIndex: 10

      # Make criteria list a drop target
      @$('.criteria-container.droppable').droppable greedy: true, accept: '.ui-draggable', activeClass: 'active-drop', drop: _.bind(@drop, this)
      @$('#deathdate.date-picker, #birthdate.date-picker').datepicker('orientation': 'bottom left').on 'changeDate', _.bind(@materialize, this)
      @$('#deathtime.time-picker, #birthtime.time-picker').timepicker(template: false).on 'changeTime.timepicker', _.bind(@materialize, this)

      metadataFields = ['gender', 'race', 'ethnicity']
      for field in metadataFields
        select = @$("##{field}")
        unless select.val()?
          select.find('option:first').prop('selected', true)

      unless @inPatientDashboard
        @$('#criteriaElements, #populationLogic') #these get affixed when user scrolls past a defined offset
          .on 'affix.bs.affix', _.bind(@setAffix, this) # when applying affix
          .on 'affix-top.bs.affix', _.bind(@unsetAffix, this) # when removing affix
          .on 'affixed.bs.affix affixed-top.bs.affix', _.bind(@logicPagingUpdate, this) # right after affixing or unaffixing
          .affix offset:
            top: => return @$('.criteria-container').parent().offset().top # always apply affix at the top of the patient history

      # setup to effectively page through the logic section
      @$('.measure-viz').on 'shown.bs.collapse hidden.bs.collapse', (e) => @logicPagingUpdate()
      @$('.logic-pager').hide()
      $logic = @$("#populationLogic").find('.scrolling')
        .on 'scroll', _.bind(@logicPagingUpdate, this) # update the up/down arrows
      @$('.logic-pager.up').on 'click', ->
        $logic.animate scrollTop: $logic.scrollTop() - $logic.height()
      @$('.logic-pager.down').on 'click', ->
        $logic.animate scrollTop: $logic.scrollTop() + $logic.height()

    serialize: (attr) ->
      @model.setCqmPatientFirstName(attr.first)if attr.first
      @model.setCqmPatientLastName(attr.last) if attr.last
      @model.setCqmPatientGender(attr.gender, @measure) if attr.gender
      birthdate = attr.birthdate if attr.birthdate
      birthdate += " #{attr.birthtime}" if attr.birthdate && attr.birthtime
      @model.setCqmPatientBirthDate(birthdate, @measure) if birthdate
      deathdate = attr.deathdate if attr.deathdate
      deathdate += " #{attr.deathtime}" if attr.deathdate && attr.deathtime
      @model.setCqmPatientDeathDate(deathdate, @measure) if deathdate
      @model.setCqmPatientRace(attr.race, @measure) if attr.race
      @model.setCqmPatientEthnicity(attr.ethnicity, @measure) if attr.ethnicity
      @model.setCqmPatientNotes(attr.notes) if attr.notes

  # When we create the form and populate it, we want to convert some values to those appropriate for the form
  context: ->
    _(super).extend
      measureTitle: @cqmMeasure.title
      measureDescription: @cqmMeasure.description

  serializeWithChildren: ->
    # Serialize the main view and the child collection views separately because otherwise Thorax wants
    # to put attributes from the child views on the parent object
    @serialize(children: false)
    childView.serialize(children: false) for cid, childView of @editCriteriaCollectionView.children
    @expectedValuesView.serialize(children: false)

  drop: (e, ui) ->
    patientDataCriteria = $(ui.draggable).model().clone()
    patientDataCriteria.set('criteria_id', Thorax.Models.SourceDataCriteria.generateCriteriaId())

    # create default values for all primary timing attributes
    for timingAttr in patientDataCriteria.getPrimaryTimingAttributes()
      if timingAttr.type == 'Interval'
        patientDataCriteria.get('qdmDataElement')[timingAttr.name] = @createDefaultInterval()
      else if timingAttr.type == 'DateTime'
        patientDataCriteria.get('qdmDataElement')[timingAttr.name] = @createDefaultInterval().low

    @addCriteria patientDataCriteria
    return false

  registerChild: (child) ->
    child.on 'bonnie:materialize', @materialize, this
    child.on 'bonnie:dropCriteria', @addCriteria, this
    child.on 'bonnie:loadPopulation', @loadPopulation, this

  materialize: ->
    @serializeWithChildren()
    @model.materialize()

  createDefaultInterval: ->
    todayInMP = new Date()
    todayInMP.setYear(@measure.getMeasurePeriodYear())

    # create CQL DateTimes
    start = new cqm.models.CQL.DateTime(todayInMP.getFullYear(), todayInMP.getMonth() + 1, todayInMP.getDate(), 8, 0, 0, 0, 0)
    end = new cqm.models.CQL.DateTime(todayInMP.getFullYear(), todayInMP.getMonth() + 1, todayInMP.getDate(), 8, 15, 0, 0, 0)
    return new cqm.models.CQL.Interval(start, end)

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
    bonnie.navigate "measures/#{@measure.get('cqmMeasure').hqmf_set_id}/patients/#{@model.id}/edit"

  save: (e, callback) ->
    e.preventDefault()
    @$('.has-error').removeClass('has-error')
    $(e.target).button('saving').prop('disabled', true)
    @serializeWithChildren()
    @model.sortCriteriaBy 'start_date', 'end_date'
    status = @originalModel.save {cqmPatient: @model.get('cqmPatient'), expired: @model.get('expired')},
      success: (model) =>
        @patients.add model # make sure that the patient exist in the global patient collection
        @measure?.get('cqmMeasure').patients.push model.get('cqmPatient') # and the measure's patient collection
        # If this patient was newly created, and it's in a component measure, the backend will populate the measure_ids
        # field with the ids of the sibling and composite measures, so we need to add this patient to those models.
        for measure_id in model.get('cqmPatient').measure_ids
          measure = (bonnie.measures.filter (m) -> m.get('cqmMeasure').hqmf_set_id == measure_id)[0]
          measure.get('patients').add(model)
        if @inPatientDashboard # Check that is passed in from PatientDashboard, to Route back to patient dashboard.
          route = if @measure then Backbone.history.getFragment() else "patients" # Go back to the current route, either "patient_dashboard" or "508_patient_dashboard"
        else
          route = if @measure then "measures/#{@measure.get('cqmMeasure').hqmf_set_id}" else "patients"
        bonnie.navigate route, trigger: true
        callback.success(model) if callback?.success
    unless status
      $(e.target).button('reset').prop('disabled', false)
      messages = []
      for [cid, field, message] in @originalModel.validationError
        # Location holds the cid of the model with the error, only toplevel (data criteria no longer handled in Thorax Patient model's validate)
        @$(":input[name=#{field}]").closest('.form-group').addClass('has-error')
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
    @model.set 'expired', false
    @model.set 'deathtime', undefined
    @model.set 'deathdate', undefined
    expiredElement = (@model.get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'expired')?[0]
    if expiredElement
      @model.get('cqmPatient').qdmPatient.dataElements.remove(expiredElement)
    @materialize()
    @$('#expired').focus()

  setAffix: ->
    @$('.criteria-container').css 'min-height': $(window).height() # in case patient history is too short to scroll, set height
    @logicPagingUpdate()
    @$('#criteriaElements, #populationLogic').each ->
      # assign current width explicitly to affixed element $(@)
      $(@).css width: $(@).width()
      # the inner scrolling part - shift down so header can show.
      # assumes unknown number of visible elements above the scrolling section
      shiftDown = 0
      $(@).find('.scrolling').prevAll(':visible').each -> shiftDown += $(@).outerHeight(true)
      $(@).find('.scrolling').css
        top: shiftDown
        bottom: $(@).find('.logic-pager.down:visible').height() || 0 # leave room for button to scroll down

  unsetAffix: ->
    #revert each affixed element to default css styling
    @$('.affix, .affix .scrolling').removeAttr('style').animate scrollTop: 0

  logicPagingUpdate: ->
    # we need to toggle the visibility and state of the up/down buttons, and adjust height if appropriate
    $logic = @$("#populationLogic").find('.scrolling')
    # hide arrows if not enough logic to scroll or if the logic is not affixed
    if $logic.children().height() < $(window).height() or @$("#populationLogic").hasClass('affix-top')
      @$('.logic-pager').removeClass('disabled').hide()
    else
      @$('.logic-pager').show()
      # update the up/down arrows to show current state
      if $logic.scrollTop() == 0
        @$('.logic-pager.up').addClass('disabled')
        @$('.logic-pager.down').removeClass('disabled')
      else if $logic.scrollTop() >= $logic.prop('scrollHeight') - $logic.height()
        @$('.logic-pager.down').addClass('disabled')
        @$('.logic-pager.up').removeClass('disabled')
      else
        @$('.logic-pager').removeClass('disabled')
    # change top/bottom position of the scrolling logic in case pagers got added/removed
    shiftDown = 0
    $logic.prevAll(':visible').each -> shiftDown += $(@).outerHeight(true)
    $logic.css
      top: shiftDown
      bottom: $logic.nextAll(':visible').height() || 0


class Thorax.Views.BuilderPopulationLogic extends Thorax.LayoutView
  template: JST['patient_builder/population_logic']
  setPopulation: (population) ->
    population.measure().set('displayedPopulation', population)
    @setModel(population)
    @setView new Thorax.Views.CqlPatientBuilderLogic(model: population.measure(), population: population)

  showRationale: (patient) ->
    @getView().showRationale(@model.calculate(patient))
  context: ->
    _(super).extend
      title: if @model.collection.parent.get('populations').length > 1 then (@model.get('title') || @model.get('sub_id')) else ''
      cms_id: @model.collection.parent.get('cqmMeasure').cms_id
