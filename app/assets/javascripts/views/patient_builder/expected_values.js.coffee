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


class Thorax.Views.ExpectedValueView extends Thorax.Views.BuilderChildView

  template: JST['patient_builder/expected_value']

  options:
    populate: { context: true }

  events:
    serialize: (attr) ->
      population = @measure.get('populations').at @model.get('population_index')
      for pc in @measure.populationCriteria() when population.has(pc) and _(attr).size()
        if @measure.get('episode_of_care') || (@measure.get('continuous_variable') && (pc == 'OBSERV' || pc == 'MSRPOPL'))
          # Only parse existing values
          if attr[pc]
            if pc == 'OBSERV'
              attr[pc] = [].concat(attr[pc])
              attr[pc] = (parseFloat(o) for o in attr[pc])
            else
              attr[pc] = parseFloat(attr[pc])
            # if we're dealing with OBSERV or MSRPOPL, set to undefined for empty value
          else attr[pc] = undefined if pc == 'OBSERV' or pc == 'MSRPOPL'
        else
          attr[pc] = if attr[pc] then 1 else 0 # Convert from check-box true/false to 0/1
    'change input[name="MSRPOPL"]': 'updateObserv'
    'click .btn-expected-value': ->
      @popoverVisible = not @popoverVisible
      if @popoverVisible
        @$('.popover-title').remove()
        @populate()
        @setObservs()
      else
        @triggerMaterialize()
        @parseValues()
        @render()
    rendered: -> 
      @$(".btn-expected-value.ev-#{@model.get('population_index')}").popover(content: @$('.popover-tmpl').text())
      @setObservs()

  context: ->
    context = super
    for pc in @measure.populationCriteria()
      unless @measure.get('episode_of_care') || (@measure.get('continuous_variable') && (pc == 'OBSERV' || pc == 'MSRPOPL'))
        context[pc] = (context[pc] == 1)
    context

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
    @filter = not @measure.get('episode_of_care') and not @measure.get('continuous_variable')
    @popoverVisible ?= false
    @parseValues()

  parseValues: ->
    @currentCriteria = []
    # get population criteria from the measure to include OBSERV
    population = @measure.get('populations').at @model.get('population_index')
    for pc in @measure.populationCriteria() when population.has(pc)
      @currentCriteria.push
        key: pc
        displayName: @criteriaMap[pc]
        isEoC: @measure.get('episode_of_care')
        value: @model.get(pc)
    unless @model.has('OBSERV_UNIT') or not @measure.get('continuous_variable') then @model.set 'OBSERV_UNIT', ' mins', {silent:true}
    if @filter then @setValues = _(@currentCriteria).filter( (pc) => pc.value ) else @setValues = @currentCriteria

  updateObserv: ->
    @model.set @serialize() if @popoverVisible
    focusIndex = 0
    if @measure.get('continuous_variable') and @model.has('MSRPOPL') and @model.get('MSRPOPL')?
      values = @model.get('MSRPOPL')
      if @model.get('OBSERV')
        current = @model.get('OBSERV').length
        if values > current
          @model.set 'OBSERV', @model.get('OBSERV').concat(0 for n in [(current+1)..values])
          focusIndex = current
        else if values < current
          @model.set 'OBSERV', _(@model.get('OBSERV')).first(values)
      else
        @model.set 'OBSERV', (0 for n in [1..values]) if values
      @setObservs()
    if @popoverVisible
      @popoverVisible = not @popoverVisible
      @triggerMaterialize()
      @parseValues()
      @render()
      # open the popover and re-focus on the correct OBSERV input
      @$(".btn-expected-value.ev-#{@model.get('population_index')}").click()
      @$("#OBSERV_#{focusIndex}").focus()

  setObservs: ->
    if @model.get('OBSERV')?.length
      for val, index in @model.get('OBSERV')
        @$("#OBSERV_#{index}").val(val)
    if @model.get('OBSERV_UNIT') == '%'
      @$('.btn-observ-unit-perc').removeClass('btn-default').addClass('btn-primary').prop('disabled',true)
      @$('.btn-observ-unit-mins').addClass('btn-default').removeClass('btn-primary').prop('disabled',false)
    else
      @$('.btn-observ-unit-mins').removeClass('btn-default').addClass('btn-primary').prop('disabled',true)
      @$('.btn-observ-unit-perc').addClass('btn-default').removeClass('btn-primary').prop('disabled',false)

  setPerc: (e) ->
    @model.set 'OBSERV_UNIT', '%'
    @updateObserv()

  setMins: (e) ->
    @model.set 'OBSERV_UNIT', ' mins'
    @updateObserv()

