class Thorax.Views.ExpectedValuesView extends Thorax.Views.BonnieView

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

  hasMultipleTabs: -> @collection.length > 1

  populationContext: (expectedValue) ->
    population = @measure.get('populations').at expectedValue.get('population_index')
    populationTitle: population.get('title') || population.get('sub_id')
    population_index: expectedValue.get('population_index')

  refresh: (population, expectedValues) ->
    @measure = population.collection.parent
    @setCollection expectedValues
    @expectedValueCollectionView.remove()
    @initialize()
    @render()
    @$("a[data-toggle=tab]:eq(#{population.collection.indexOf(population)})").tab('show')


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

class Thorax.Views.ExpectedValueView extends Thorax.Views.BonnieView

  template: JST['patient_builder/expected_value']

  initialize: ->
    @criteriaMap =
      IPP:      'IPP'
      STRAT:    'STRAT'
      DENOM:    'DEN'
      NUMER:    'NUM'
      DENEXCEP: 'EXCP'
      DENEX:    'EXCL'
      MSRPOPL:  'MSRPOPL'
      OBSERV:   'OBSERV'
    @isNumbers = @measure.get('episode_of_care')
    @isMultipleObserv = @measure.get('continuous_variable')
    @isCheckboxes = not @isNumbers and not @isMultipleObserv
    @parseValues()
    @model.on 'change', => @parseValues() # parse model changes -- needed for CV render triggers

  parseValues: ->
    @parsedValues = []
    population = @measure.get('populations').at @model.get('population_index')
    for pc in @measure.populationCriteria() when population.has(pc)
      @parsedValues.push
        key: pc
        displayName: @criteriaMap[pc]
        value: @model.get(pc)
    if not @isNumbers then @parsedValues = _(@parsedValues).filter( (pc) => pc.value )

  # FIXME: this is required to serialize popovers that are left open when saving the patient
  serialize: (attr) ->

  togglePopover: (e) ->
    @popoverVisible = @$('.btn-expected-value').hasClass('btn-primary')
    @$('.btn-expected-value').toggleClass('btn-default btn-primary')
    if @popoverVisible
      @popover.serialize(set: true)
      @$('.btn-expected-value').popover('hide')
      @parseValues()
      @render()
      $("a[href=\"#expected-#{@model.get('population_index')}\"]").parent().addClass('active') # reset the active tab
    else
      @popover = new Thorax.Views.ExpectedValuePopoverView
        model: @model
        measure: @measure
      @popover.parent = @
      @$('.btn-expected-value').popover({title: 'Edit'})
      @$('.btn-expected-value').popover('show')
      @$('.popover > .arrow').css('left', "#{if @isMultipleObserv then '18' else '25'}%") # hack for fixing the arrow after rendering form
      @popover.appendTo(@$('.popover-content'))
      @popover.toggleUnits()
      @popover.setObservs()
      @popover.$('input[name="MSRPOPL"]').focus() if e == 'MSRPOPL'
      @popover.$(".#{e}").focus() if e == 'btn-observ-unit-mins' or e == 'btn-observ-unit-perc'
      $("a[href=\"#expected-#{@model.get('population_index')}\"]").parent().addClass('active') # reset active tab

class Thorax.Views.ExpectedValuePopoverView extends Thorax.Views.BuilderChildView

  template: JST['patient_builder/expected_value_popover']

  options:
    populate: { context: true }

  events:
    serialize: (attr) ->
      population = @measure.get('populations').at @model.get('population_index')
      for pc in @measure.populationCriteria() when population.has(pc)
        if @isNumbers || (@isMultipleObserv && (pc == 'OBSERV'))
          # Only parse existing values
          if attr[pc]
            if pc == 'OBSERV'
              attr[pc] = [].concat(attr[pc])
              attr[pc] = (parseFloat(o) for o in attr[pc])
            else
              attr[pc] = parseFloat(attr[pc])
            # if we're dealing with OBSERV or MSRPOPL, set to undefined for empty value
          else attr[pc] = undefined if pc == 'OBSERV'
        else
          attr[pc] = if attr[pc] then 1 else 0 # Convert from check-box true/false to 0/1
    'change input': 'selectPopulations'
    'rendered': -> 'setObservs'

  context: ->
    context = super
    for pc in @measure.populationCriteria()
      unless @isNumbers || (@isMultipleObserv && (pc == 'OBSERV'))
        context[pc] = (context[pc] == 1)
    context

  initialize: ->
    @currentCriteria = []
    # get population criteria from the measure to include OBSERV
    population = @measure.get('populations').at @model.get('population_index')
    @isNumbers = @measure.get('episode_of_care')
    @isMultipleObserv = @measure.get('continuous_variable')
    @isCheckboxes = not @isNumbers and not @isMultipleObserv
    for pc in @measure.populationCriteria() when population.has(pc)
      @currentCriteria.push
        key: pc
        displayName: pc
        isEoC: @isNumbers
    unless @model.has('OBSERV_UNIT') or not @isMultipleObserv then @model.set 'OBSERV_UNIT', ' mins', {silent:true}

  updateObserv: ->
    popoverVisible = $('.popover').is(':visible')
    if @isMultipleObserv and @model.has('MSRPOPL') and @model.get('MSRPOPL')?
      values = @model.get('MSRPOPL')
      if @model.get('OBSERV')
        current = @model.get('OBSERV').length
        if values > current
          @model.set 'OBSERV', @model.get('OBSERV').concat(0 for n in [(current+1)..values])
        else if values < current
          @model.set 'OBSERV', _(@model.get('OBSERV')).first(values)
      else
        @model.set 'OBSERV', (0 for n in [1..values]) if values
      @setObservs()
    @parent.togglePopover('MSRPOPL') if popoverVisible

  setObservs: ->
    if @model.get('OBSERV')?.length
        for val, index in @model.get('OBSERV')
          @$("#OBSERV_#{index}").val(val)
    @toggleUnits()

  toggleUnits: (e) ->
    if @model.has('OBSERV_UNIT') and @model.get('OBSERV')?.length
      if @model.get('OBSERV_UNIT') == '%'
        @$('.btn-observ-unit-perc').removeClass('btn-default').addClass('btn-primary').prop('disabled',true)
        @$('.btn-observ-unit-mins').addClass('btn-default').removeClass('btn-primary').prop('disabled',false)
      else
        @$('.btn-observ-unit-mins').removeClass('btn-default').addClass('btn-primary').prop('disabled',true)
        @$('.btn-observ-unit-perc').addClass('btn-default').removeClass('btn-primary').prop('disabled',false)
    else
      @$('.btn-observ-unit-mins').removeClass('btn-default btn-primary').prop('disabled',true)
      @$('.btn-observ-unit-perc').removeClass('btn-default btn-primary').prop('disabled',true)

  setPerc: (e) ->
    popoverVisible = $('.popover').is(':visible')
    @model.set 'OBSERV_UNIT', '%'
    @parent.togglePopover('btn-observ-unit-mins') if popoverVisible

  setMins: (e) ->
    popoverVisible = $('.popover').is(':visible')
    @model.set 'OBSERV_UNIT', ' mins'
    @parent.togglePopover('btn-observ-unit-perc') if popoverVisible

  selectPopulations: (e) ->
    @attrs ?= @model.attributes
    populationCode = @$(e.target).attr('name')
    if @isCheckboxes or not @isNumbers and @isMultipleObserv
      currentValue = @$(e.target).prop('checked')
      @handleSelect(populationCode, currentValue, currentValue)
    else if @isNumbers
      currentValue = @$(e.target).val()
      increment = currentValue > @attrs[populationCode]
      @handleSelect(populationCode, currentValue, increment)
    @attrs = @serialize(set: true)
    if @isMultipleObserv and populationCode == 'MSRPOPL' then @updateObserv()
    $("a[href=\"#expected-#{@model.get('population_index')}\"]").parent().addClass('active') # reset active tab

  handleSelect: (population, value, increment) ->
    if increment
      switch population
        when 'IPP'
          @setPopulation('STRAT', value) unless @isNumbers and @attrs['STRAT'] >= value
        when 'DENOM', 'MSRPOPL'
          @setPopulation('IPP', value) unless @isNumbers and @attrs['IPP'] >= value
          @handleSelect('IPP', value, increment)
        when 'DENEX', 'DENEXCEP', 'NUMER'
          @setPopulation('DENOM', value) unless @isNumbers and @attrs['DENOM'] >= value
          @handleSelect('DENOM', value, increment)
    else
      switch population
        when 'STRAT'
          @setPopulation('IPP', value) unless @isNumbers and @attrs['IPP'] < value
          @handleSelect('IPP', value, increment)
        when 'IPP'
          @setPopulation('DENOM', value) unless @isNumbers and @attrs['DENOM'] < value
          @setPopulation('MSRPOPL', value) unless @isNumbers and @attrs['MSRPOPL'] < value or not @isMultipleObserv
          @handleSelect('DENOM', value, increment)
        when 'DENOM', 'MSRPOPL'
          @setPopulation('DENEX', value) unless @isNumbers and @attrs['DENEX'] < value
          @setPopulation('DENEXCEP', value) unless @isNumbers and @attrs['DENEXCEP'] < value
          @setPopulation('NUMER', value) unless @isNumbers and @attrs['NUMER'] < value

  setPopulation: (population, value) ->
    if @model.has(population) and @model.get(population)?
      if @isCheckboxes or not @isNumbers and @isMultipleObserv
        @$("input[name=\"#{population}\"]").prop('checked', value)
      else if @isNumbers
        @$("input[name=\"#{population}\"]").val(value)
    if @isMultipleObserv
      @serialize()
      @updateObserv() if @isMultipleObserv and population == 'MSRPOPL'
