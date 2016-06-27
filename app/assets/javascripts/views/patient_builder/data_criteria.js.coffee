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
    @editFieldValueView = new Thorax.Views.EditCriteriaValueView
      model: new Thorax.Model
      measure: @model.measure()
      fieldValue: true
      values: @model.get('field_values')
      criteriaType: @model.get('type')
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
    @myConcepts = concepts #instance version of concepts
    codes.on 'add remove', => @model.set 'code_source', (if codes.isEmpty() then 'DEFAULT' else 'USER_DEFINED'), silent: true
    @editCodeSelectionView = new Thorax.Views.CodeSelectionView codes: codes
    @editCodeSelectionView.updateConcepts(concepts) if concepts
    @editFulfillmentHistoryView = new Thorax.Views.MedicationFulfillmentsView
      model: new Thorax.Model
      criteria: @model
    @booleanShowOrHidePatientInformation = if @builderView.previousStateWasHideInfo() then 1 else 0
    #builderView refers to parent (patient_builder.js.coffee)
    #Convert the true/false to an integer, because our Handlebars {{#ifCond}} helper can't handle true/false

    @listenTo(@builderView, "show_information_in_patient_builder", -> 
      @booleanShowOrHidePatientInformation = 1
      @render()
    )
    @listenTo(@builderView, "hide_information_in_patient_builder", -> 
      @booleanShowOrHidePatientInformation = 0
      @render()
    )

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
    field_value_information_array = []
    results_information_array = []
    references_information_array = []
    fulfillments_information_array = []
    @code_information_array = [[],[]]
    #The indexes of @code_information_array[0] and @code_information_array[1] "line up" 
    #so, for example, @code_information_array[0][2] stores properties for @code_information_array[1][2] and vice versa
    #[1] only exists for those description strings longer than 100 characters, otherwise it'll be null
    #[0] contains the string to be displayed next to each code (originally). If this string is less than 100 chars, then [1] at the same index will be null
    #otherwise, if over 100 chars, [1] will contain the un-trimmed string, and [0] will contain the trimmed string
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    if @model.attributes.codes?
      for index in [0..Object.keys(@myConcepts).length-1]#Get indexes for the "master list" of codes and codesets (@myConcepts)
        for eachCode in @model.get('codes').models #Loop through each code within our model
          if eachCode.get('code') == @myConcepts[index].code && eachCode.get('codeset') == @myConcepts[index].code_system_name
            if @myConcepts[index].display_name.length > 100 #If the code description is longer than 100 chars
              trimmedString = (@myConcepts[index].display_name).substr(0,100) + "..." #trim it
              @code_information_array[0].push(@myConcepts[index].code_system_name + ": " + trimmedString)
              @code_information_array[1].push(@myConcepts[index].code_system_name + ": " + @myConcepts[index].display_name)
            else #Otherwise store the description string in [0] and null in [1]. Handlebars checks to see if [1][whatever_index] exists,
                #and if it does, it will display the button to show/hide the longer description
              @code_information_array[0].push(@myConcepts[index].code_system_name + ": " + @myConcepts[index].display_name)
              @code_information_array[1].push(null)
          else
            existspreviously = 0 #reset this each time
            for index_of_each_possible_code in [0..Object.keys(@myConcepts).length-1] #Get an index for the "master list" of codes and codesets (@myConcepts)
              if eachCode.get('code') == @myConcepts[index_of_each_possible_code].code && eachCode.get('codeset') == @myConcepts[index_of_each_possible_code].code_system_name
                  existspreviously++ #If our code and codeset exist within the list of codes and codesets, then it must existspreviously
                  break #Prevents us from having to traverse the entire master list if we find it early
            for eachValue in @code_information_array[0] #Checks our array[0]
              if eachValue == eachCode.get('codeset') + ": " + eachCode.get('code') #If the string is longer than 100 chars
                existspreviously++ #it will be found here, and will existspreviously
            for eachValue in @code_information_array[1] #otherwise, check the array[1]-aka the codes with descriptions longer than 100 chars
              if eachValue == eachCode.get('codeset') + ": " + eachCode.get('code') 
                existspreviously++ #And if it matches, it must existspreviously
            if existspreviously == 0 #If it wasn't found previously, add it
              regularString = eachCode.get('codeset') + ": " + eachCode.get('code')
              if regularString.length > 100 #Same trim system as above
                 trimmedString = regularString.substr(0,100) + "..." 
                 @code_information_array[0].push(trimmedString)
                 @code_information_array[1].push(regularString)
              else
                @code_information_array[0].push(regularString)
                @code_information_array[1].push(null)
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    if @model.attributes.fulfillments?
      fulfillments_information_array = @model.attributes.fulfillments.map((ful) ->
         # using .get to retreive attributes since ful is a Thorax object
           return ((ful.get('quantity_dispensed_value') + " " + ful.get('quantity_dispensed_unit') + " " + ful.get('dispense_date') + " ").replace(/_/g, ' ').replace(/\w\S*/g, (txt) ->  txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()) + ful.get('dispense_time')))
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    if @model.attributes.field_values?
      that_model = @model #store this.model to be used inside the map
      field_value_information_array = @model.attributes.field_values.map((field_val) ->
          # using .get to retreive attributes since field_val is a Thorax object
         switch field_val.get('type') #CD = Coded, PQ = Scalar, TS = Date Entry. This switch statement is just for formatting the different entry methods
           when "CD" then return (((field_val.get('key')) + ": ").replace(/_/g, ' ').replace(/\w\S*/g, (txt) ->  txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase())+ (field_val.get('title')))
           when "PQ" then return ((field_val.get('key') + ": " + field_val.get('value') + " ").replace(/_/g, ' ').replace(/\w\S*/g, (txt) ->  txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase())+ (field_val.get('unit')))
           when "TS" then return ((field_val.get('key') + ": ").replace(/_/g, ' ').replace(/\w\S*/g, (txt) ->  txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase())+ moment.utc(that_model.get('value')).format('L')))
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    if @model.attributes.references?
      references_information_array = @model.attributes.references.map((ref) ->
         # using .get to retreive attributes since ref is a Thorax object
         if ref.get('reference_type')
           return ref.get('reference_type').replace(/_/g, ' ').replace(/\w\S*/g, (txt) ->  txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()) + ": " + ref.get('description') + ": " + ref.get('start_date')
         else
           return ref.get('description') + ": " + ref.get('start_date'))
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    if @model.attributes.value?
      results_information_array = @model.attributes.value.map((val) ->
         # using .get to retreive attributes since val is a Thorax object
         switch val.get('type') #CD = Coded, PQ = Scalar. This switch statement is just for formatting the different entry methods
           when "CD" then return val.get('title').replace(/_/g, ' ').replace(/\w\S*/g, (txt) ->  txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase())
           when "PQ" then return (val.get('value') + " ").replace(/_/g, ' ').replace(/\w\S*/g, (txt) ->  txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase())+ (val.get('unit')))

    if @model.get('end_date')? #Calculate Duration Between Start and End Dates
      start_date = moment(@model.get('start_date'))
      end_date = moment(@model.get('end_date'))
      #getDuration is within the parent (@builderView - patient_builder.js.coffee)
      element_duration =  @builderView.getDuration(start_date,end_date)


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
      hasStopTime: @model.hasStopTime()
      startLabel: @model.startLabel()
      stopLabel: @model.stopLabel()
      showPatientInfo: @booleanShowOrHidePatientInformation
      code_information: @code_information_array
      field_value_information: field_value_information_array
      references_information: references_information_array
      result_information: results_information_array
      fulfillment_information: fulfillments_information_array
      duration_between_element_start_and_finish: element_duration


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
      @$('.date-picker').datepicker('orientation': 'bottom left').on 'changeDate', _.bind(@triggerMaterialize, this)
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
      @$('input[name=end_date]').datepicker('orientation': 'bottom left').datepicker('setDate', endDate.format('L')) if endDate
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
    @editValueView?.render() # Re-render edit view, if used

  highlightError: (e, field) ->
    @toggleDetails(e) unless @isExpanded()
    @$(":input[name=#{field}]").closest('.form-group').addClass('has-error')

  jumpToSelectCriteria: (e) ->
    e.preventDefault()
    type = @$(e.target).model().get('type')
    $(".#{type}-elements").focus()
  
  displayCode: (e) ->
    index_of_string = e.target.id.substr(-1)
    textForEachCode = "text-to-be-expanded-" + index_of_string
    buttonText = "hide-long-code-" + index_of_string
    buttonFontAwesomeClass = "font-awesome-caret-" + index_of_string
    if @$("##{buttonText}").text()  == "Show More"
      @$("##{textForEachCode}").text(@code_information_array[1][index_of_string])
      @$("##{buttonText}").text("Show Less")
      @$("##{buttonFontAwesomeClass}").removeClass("fa fa-fw fa-caret-down")
      @$("##{buttonFontAwesomeClass}").addClass("fa fa-fw fa-caret-up")
    else
      @$("##{textForEachCode}").text(@code_information_array[0][index_of_string])
      @$("##{buttonText}").text("Show More")
      @$("##{buttonFontAwesomeClass}").removeClass("fa fa-fw fa-caret-up")
      @$("##{buttonFontAwesomeClass}").addClass("fa fa-fw fa-caret-down")

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

  context: ->
    _(super).extend
      codes: @measure?.valueSets().map((vs) -> vs.toJSON()) or []
      fields: Thorax.Models.Measure.logicFieldsFor(@criteriaType)
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
      