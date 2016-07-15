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
      itemView: (item) => new Thorax.Views.EditCriteriaView(model: item.model, measure: @measure, builderView: @)
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
    @valueSetCodeCheckerView = new Thorax.Views.ValueSetCodeChecker(patient: @model, measure: @measure)
    @sortButton = buttonLastClicked: null, secondsSinceLastClick: 0
    @timeSinceInfoPreviewClick = 0 # Keeps track of last Preview/Hide button click to prevent accidental double clicking.
    @patientStatus = # Hash for tracking Patient Info when calculating their age
      patientIsAlive: true
      patientAge: "NA"

  dataCriteriaCategories: ->
    categories = {}
    @measure?.get('source_data_criteria').each (criteria) ->
      type = criteria.get('type').replace(/_/g, ' ')
      # Filter out negations and specific occurrences
      filter_criteria = criteria.get('negation') or
      ( criteria.get('definition') is 'patient_characteristic_birthdate' ) or
      ( criteria.get('definition') is 'patient_characteristic_gender' ) or
      ( criteria.get('definition') is 'patient_characteristic_expired' ) or
      ( criteria.get('definition') is 'patient_characteristic_race' ) or
      ( criteria.get('definition') is 'patient_characteristic_ethnicity' ) or
      ( criteria.get('definition') is 'patient_characteristic_payer' ) or
      ( criteria.has('specific_occurrence') )
      unless filter_criteria
        categories[type] ||= new Thorax.Collection
        categories[type].add criteria unless categories[type].any (c) -> c.get('description').replace(/,/g , '') == criteria.get('description').replace(/,/g , '') && c.get('code_list_id') == criteria.get('code_list_id')
    categories = _(categories).omit('transfers','derived')
    # Pass a sorted array to the view so ordering is consistent
    categoriesArray = ({ type: type, criteria: criteria } for type, criteria of categories)
    _(categoriesArray).sortBy (entry) -> entry.type

  events:
    'blur :text': 'materialize'
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
      @setPatientAge() #Clicking the button that removes Death Date doesn't trigger materialize, it triggers "render"
      # Make criteria list a drop target
      @$('.criteria-container.droppable').droppable greedy: true, accept: '.ui-draggable', activeClass: 'active-drop', drop: _.bind(@drop, this)
      @$('.date-picker').datepicker('orientation': 'bottom left').on 'changeDate', _.bind(@materialize, this)
      @$('.time-picker').timepicker(template: false).on 'changeTime.timepicker', _.bind(@materialize, this)

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
      birthdate = attr.birthdate if attr.birthdate
      birthdate += " #{attr.birthtime}" if attr.birthdate && attr.birthtime
      attr.birthdate = moment.utc(birthdate, 'L LT').format('X') if birthdate
      deathdate = attr.deathdate if attr.deathdate
      deathdate += " #{attr.deathtime}" if attr.deathdate && attr.deathtime
      attr.deathdate = moment.utc(deathdate, 'L LT').format('X') if deathdate

  # When we create the form and populate it, we want to convert some values to those appropriate for the form
  context: ->
    birthdatetime = moment.utc(@model.get('birthdate'), 'X') if @model.has('birthdate') && !!@model.get('birthdate')
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
    @setPatientAge() # When a birthdate or deathdate is selected, materialize() is called and sets the Patient's Age
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
    # revert each affixed element to default css styling
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

  sortPatientEventsBy: (e) ->
    # if the user accidentally clicks on DATE or ELEMENTS multiple times, it will sort multiple times
    # even if everything is already sorted. By tracking sortButton, we can prevent the user from
    # accidentally double clicking and waiting the extra few seconds that sorting takes.
    loadingSpinnerSelector = @$('#loading_spinner')
    sortByElementsSelector = @$('#sort_by_elements')
    sortByDateSelector = @$('#sort_by_date')
    if e.target.id?
      switch e.target.id
        when "sort_by_elements"
          if @sortButton.buttonLastClicked != "Elements Button" || @sortButton.secondsSinceLastClick + 1000 < e.timeStamp
            # only proceed if the last button they clicked wasn't Elements OR it has been 1 second since the last click
            loadingSpinnerSelector.removeClass('hidden')
            sortByElementsSelector.addClass('active')
            sortByElementsSelector.html('<i class="fa fa-chevron-right"></i> <b>ELEMENTS</b>') # add bold tag and arrow to more visibly show which button is selected
            sortByDateSelector.removeClass('active')
            sortByDateSelector.html('DATE') # Remove the chevon arrow and bold tag from the other button, leave just the text
            # Force these previous lines to occur before the sorting begins by waiting 0 seconds
            setTimeout( =>
              @model.sortCriteriaBy 'type'
              loadingSpinnerSelector.addClass('hidden')
              @sortButton.buttonLastClicked = "Elements Button" # arbitrary string
              @sortButton.secondsSinceLastClick = e.timeStamp
            , 0)
        when "sort_by_date"
          if @sortButton.buttonLastClicked != "Date Button" || @sortButton.secondsSinceLastClick + 1000 < e.timeStamp
            # only proceed if the last button they clicked wasn't Date OR it has been 1 second since the last click
            loadingSpinnerSelector.removeClass('hidden')
            sortByDateSelector.addClass('active')
            sortByDateSelector.html('<i class="fa fa-chevron-right"></i> <b>DATE</b>') # add bold tag and arrow to more visibly show which button is selected
            sortByElementsSelector.removeClass('active')
            sortByElementsSelector.html('ELEMENTS') # Remove the chevon arrow and bold tag from the other button, leave just the text
            # Force these previous lines to occur before the sorting begins by waiting 0 seconds
            setTimeout( =>
              @model.sortCriteriaBy 'start_date'
              loadingSpinnerSelector.addClass('hidden')
              @sortButton.buttonLastClicked = "Date Button" # arbitrary string
              @sortButton.secondsSinceLastClick = e.timeStamp
            , 0)

  previewInformation: (e) ->
  # Just like with the "Order By" buttons, if you spam/double click the "Preview/Hide Information"
  # button it performs the action for each click. On patients with many events this can
  # easily mean 20-30 seconds of "lag" if the user has clicked 5+ times
  # Only allow the previewing/hiding to occur if they haven't clicked in .75 seconds
  # TODO: The previewing/hiding button shares the same loading_spinner as the "Order By" buttons
  # Maybe give it its own loading spinner?
    if @timeSinceInfoPreviewClick + 750 < e.timeStamp
      loadingSpinnerSelector = @$('#loading_spinner')
      @timeSinceInfoPreviewClick = e.timeStamp # Overwrite previous timestamp with new one
      loadingSpinnerSelector.removeClass('hidden')

      if @previousStateWasHideInfo()
        @$('#preview_information').text('Preview Information') # sets the button's new text
        # Force these previous lines to occur before previewing patient info by waiting 0 seconds
        setTimeout( =>
          @trigger "hide_information_in_patient_builder"
          loadingSpinnerSelector.addClass('hidden')
        , 0)
      else
        @$('#preview_information').text('Hide Information') # sets the button's new text
        # Force these previous lines to occur before hiding patient info by waiting 0 seconds
        setTimeout( =>
          @trigger "show_information_in_patient_builder"
          loadingSpinnerSelector.addClass('hidden')
        , 0)

  openAllDataCriteria: (e) ->
    previousScrollLocation = $(window).scrollTop()
    @$('#loading_spinner').removeClass('hidden')
    setTimeout( =>
      @trigger "open_all_data_criteria", e # Opening all the data criteria scrolls down ~half the page
      @$('#loading_spinner').addClass('hidden')
      window.scrollTo(0, previousScrollLocation) # Scroll back to original location
      # Opening shifts focus off "Open All" button,
      # shift it back for 508 compliance, and easy keyboard navigation
      @$('#open_all').focus()
    , 0)

  closeAllDataCriteria: ->
    @$('#loading_spinner').removeClass('hidden')
    setTimeout( =>
      @trigger "close_all_data_criteria"
      @$('#loading_spinner').addClass('hidden')
    , 0)

  # Displays or hides the two buttons "Close All" and "Open All"
  showOrHidePatientBuilderUtilities: (e) ->
    e.preventDefault()
    @$('#open_all').toggleClass('hidden')
    @$('#close_all').toggleClass('hidden')

  previousStateWasHideInfo: ->
    # Checks the text on the button to determine previous state
    if @$('#preview_information').text() == "Hide Information"
      return true
    else
      return false

  # Formats duration between a start_date and an end_date and returns that value as a string (e.g. "2 years, 3 months")
  # (both start and end date must be moments from Moment.js)
  getDuration: (start_date, end_date) ->
    if end_date.diff(start_date) > 0 # End Date must follow Start Date
      durationInformation = years: 0, months: 0, days: 0, hours: 0, minutes: 0
      elementDurationAsString = ""
      displayTwoValues = 0 # For durations, only display largest 2 times categories
      # e.g. "12 years, 3 months", not "12 years, 3 months, 2 days, 3 hours, 14 minutes"
      if end_date.diff(start_date, 'minutes', true) >= 60
        if end_date.diff(start_date, 'hours', true) >= 24
          if end_date.diff(start_date, 'days', true) >= 31
            if end_date.diff(start_date, 'months', true) >= 12
              durationInformation.years = end_date.diff(start_date, 'years')
              end_date = end_date.subtract(durationInformation.years, 'years')
            durationInformation.months = end_date.diff(start_date, 'months')
            end_date = end_date.subtract(durationInformation.months, 'months')
          durationInformation.days = end_date.diff(start_date, 'days')
          end_date = end_date.subtract(durationInformation.days, 'days')
        durationInformation.hours = end_date.diff(start_date, 'hours')
        end_date = end_date.subtract(durationInformation.hours, 'hours')
      durationInformation.minutes = end_date.diff(start_date, 'minutes')
      for durationInformationKey, durationInformationValue of durationInformation
        if displayTwoValues != 2
          if durationInformationValue > 0
            if durationInformationValue > 1
              durationInformation.durationInformationKey = "#{durationInformationValue} #{durationInformationKey}"
            else
              durationInformation.durationInformationKey = "#{durationInformationValue} #{durationInformationKey.slice(0, -1)}" # if necessary, remove "s" for non-plural
            elementDurationAsString += "#{durationInformation.durationInformationKey}, "
            displayTwoValues++
      elementDurationAsString = elementDurationAsString.slice(0,-2) # Chop off the trailing ", " from the string
    else
      elementDurationAsString = null # meaning the end date preceded the start date
    return elementDurationAsString

  getPatientAge: ->
    if @model.get('birthdate')
      if @model.get('deathdate')
        @patientStatus.patientIsAlive = false
        # Since both birthdate and deathdate are off by 5 hours, they will calculate correctly without the ".add(5, 'hours')". However, better to account for it
        @patientStatus.patientAge = @getDuration(moment(parseInt(@model.get('birthdate')) * 1000).add(5, 'hours'), moment(parseInt(@model.get('deathdate')) * 1000).add(5, 'hours'))
      else
        @patientStatus.patientIsAlive = true
        if parseInt(moment(@model.get('birthdate') * 1000).format("YYYY")) == bonnie.measurePeriod
          @patientStatus.patientAge = "Born during Measure Period" #Patient born during Measure Period
        else
          # Time picker wants to offset birthdate by 5 hours - not sure if problem with timepicker or Moment.js
          # either way, adding 5 hours to birthdate fixes problem
          @patientStatus.patientAge = @getDuration(moment(@model.get('birthdate') * 1000).add(5, 'hours'), moment(new Date(bonnie.measurePeriod, 0,1,0,0,0,0)))

  setPatientAge: ->
    @getPatientAge() # Determines Patient Age and stores results in instanced hash @patientStatus
    patientAgeLabelSelector = @$('.patient-age-label')
    patientAgeSelector = @$('.patient-age')

    if @patientStatus.patientAge == null # Meaning the Birthdate came after the deathdate or the measurePeriod
      if @patientStatus.patientIsAlive # Changes Warning Message based on whether the patient is alive or not
        patientAgeLabelSelector.removeClass('fail fa fa-fw fa-times-circle')
        patientAgeLabelSelector.addClass('fa fa-fw fa-exclamation-circle')
        patientAgeSelector.html("Measure Period precedes <br> &emsp;&nbsp; Birthdate") # Formats the text to fit properly
      else
        patientAgeLabelSelector.removeClass('fa fa-fw fa-exclamation-circle')
        patientAgeLabelSelector.addClass('fail fa fa-fw fa-times-circle')
        patientAgeSelector.addClass('fail')
        patientAgeSelector.text("Death Date precedes Birthdate")
      patientAgeLabelSelector.text("") # Clear Age Label Text
    else # Meaning the birthdate comes before deathdate
      patientAgeLabelSelector.removeClass('fa fa-fw fa-exclamation-circle')
      patientAgeLabelSelector.removeClass('fail fa fa-fw fa-times-circle')
      patientAgeSelector.removeClass('fail')

      if @patientStatus.patientIsAlive
        patientAgeLabelSelector.text("Age at Start of Measure Period:")
      else
        patientAgeLabelSelector.text("Age at Time of Death: ")
      patientAgeSelector.html("<br> #{@patientStatus.patientAge}") # Patient Age now displays all on one line (looks cleaner)

class Thorax.Views.BuilderPopulationLogic extends Thorax.LayoutView
  template: JST['patient_builder/population_logic']
  setPopulation: (population) ->
    population.measure().set('displayedPopulation', population)
    @setModel(population)
    @setView new Thorax.Views.PopulationLogic(model: population)
  showRationale: (patient) ->
    @getView().showRationale(@model.calculate(patient))
  context: ->
    _(super).extend
      title: if @model.collection.parent.get('populations').length > 1 then (@model.get('title') || @model.get('sub_id')) else ''
      cms_id: @model.collection.parent.get('cms_id')
