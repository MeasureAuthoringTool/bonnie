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
      population_index = @measure.get('displayedPopulation').index()
      @$('a[href="#expected-'+population_index+'"]').tab('show')
      @$('.tab-pane#expected-'+population_index).addClass('active') # This seems to be necessary because we're not in the DOM yet?
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
      for pc in @measure.populationCriteria() when population.has(pc) or pc == 'OBSERV' and population.has('observations')
        if @isNumbers || (@isMultipleObserv && (pc == 'OBSERV'))
          # Only parse existing values
          if attr[pc]
            if pc == 'OBSERV'
              attr[pc] = [].concat(attr[pc])
              attr[pc] = (Thorax.Models.ExpectedValue.prepareObserv(parseFloat(o)) for o in attr[pc])
            else
              attr[pc] = parseFloat(attr[pc])
            # if we're dealing with OBSERV or MSRPOPL, set to undefined for empty value
          else attr[pc] = undefined if pc == 'OBSERV'
        else
          attr[pc] = if attr[pc] then 1 else 0 # Convert from check-box true/false to 0/1
      if (attr['DENOMOBS'])
        attr['DENOM_OBSERV'] = [attr['DENOMOBS']...].map((o) -> parseFloat(o))
      else
        attr['DENOM_OBSERV'] = []
      if (attr['NUMEROBS'])
        attr['NUMER_OBSERV'] = [attr['NUMEROBS']...].map((o) -> parseFloat(o))
      else
        attr['NUMER_OBSERV'] = []
    'change input': 'selectPopulations'
    'change input[name="MSRPOPL"]': 'updateObserv'
    'change input[name="MSRPOPLEX"]': 'updateObserv'
    'rendered': 'setObservs'

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
    @isNumbers = @measure.get('cqmMeasure').calculation_method == 'EPISODE_OF_CARE'
    @isRatio = @model.get('scoring') == 'RATIO'
    @isMultipleObserv = population.get('observations')?.length > 0
    @isCheckboxes = not @isNumbers and not @isMultipleObserv
    for pc in @measure.populationCriteria() when population.has(pc) or pc == 'OBSERV' and population.has('observations')
      @currentCriteria.push
        key: pc
        displayName: pc
        isEoC: @isNumbers
        isRatio: @isRatio
    unless @model.has('OBSERV_UNIT') or not @isMultipleObserv then @model.set 'OBSERV_UNIT', '', {silent:true}

  updateObserv: ->
    if @isMultipleObserv and @model.has('MSRPOPL') and @model.get('MSRPOPL')?
      values = @model.get('MSRPOPL')
      if @model.has('MSRPOPLEX') and @model.get('MSRPOPLEX')?
        values = values - @model.get('MSRPOPLEX')
      if @model.get('OBSERV')
        current = @model.get('OBSERV').length
        if values < current
          @model.set 'OBSERV', _(@model.get('OBSERV')).first(values)
        else if values > current
          @model.set 'OBSERV', @model.get('OBSERV').concat(0 for n in [(current+1)..values])
      else
        @model.set 'OBSERV', (0 for n in [1..values]) if values
      @setObservs()

  updateDenomObservations: ->
    totalObs = @model.get('DENOM_OBSERV')?.length
    if @model.has('DENEX') and @model.get('DENEX')?
      totalObs = @model.get('DENOM') - @model.get('DENEX')
    else
      totalObs = @model.get('DENOM')
    if @model.get('DENOM_OBSERV')
      current = @model.get('DENOM_OBSERV').length
      if totalObs < current
        @model.set 'DENOM_OBSERV', _(@model.get('DENOM_OBSERV')).first(totalObs)
      else if totalObs > current
        @model.set 'DENOM_OBSERV', [@model.get('DENOM_OBSERV')...].concat(0 for n in [(current + 1)..totalObs])
    else
      @model.set 'DENOM_OBSERV', (0 for n in [1..totalObs]) if totalObs
    @setRatioObservations()

  updateNumeratorObservations: ->
    totalObs = @model.get('NUMER_OBSERV')?.length
    if @model.has('NUMEX') and @model.get('NUMEX')?
      totalObs = @model.get('NUMER') - @model.get('NUMEX')
    else
      totalObs = @model.get('NUMER')
    if @model.get('NUMER_OBSERV')
      current = @model.get('NUMER_OBSERV').length
      if totalObs < current
        @model.set 'NUMER_OBSERV', _(@model.get('NUMER_OBSERV')).first(totalObs)
      else if totalObs > current
        @model.set 'NUMER_OBSERV', [@model.get('NUMER_OBSERV')...].concat(0 for n in [(current + 1)..totalObs])
    else
      @model.set 'NUMER_OBSERV', (0 for n in [1..totalObs]) if totalObs
    @setRatioObservations()

  setRatioObservations: ->
    if @model.get('DENOM_OBSERV')?.length
      for val, index in @model.get('DENOM_OBSERV')
        @$("#DENOM_OBSERV_#{index}").val(val)
    if @model.get('NUMER_OBSERV')?.length
      for val, index in @model.get('NUMER_OBSERV')
        @$("#NUMER_OBSERV_#{index}").val(val)

  setObservs: ->
    if @model.get('OBSERV')?.length
        for val, index in @model.get('OBSERV')
          @$("#OBSERV_#{index}").val(val)
    @toggleUnits()
    $("a[href=\"#expected-#{@model.get('population_index')}\"]").parent().addClass('active') # reset the active tab for CV measures

  toggleUnits: (e) ->
    if @model.has('OBSERV_UNIT') and @model.get('OBSERV')?.length
      if @model.get('OBSERV_UNIT') == '%'
        @$('.btn-observ-unit-perc').removeClass('btn-default').addClass('btn-primary').prop('disabled',false)
        @$('.btn-observ-unit-mins').addClass('btn-default').removeClass('btn-primary').prop('disabled',false)
      else if @model.get('OBSERV_UNIT') == ' mins'
        @$('.btn-observ-unit-mins').removeClass('btn-default').addClass('btn-primary').prop('disabled',false)
        @$('.btn-observ-unit-perc').addClass('btn-default').removeClass('btn-primary').prop('disabled',false)
      else
        @$('.btn-observ-unit-perc').addClass('btn-default').removeClass('btn-primary').prop('disabled',false)
        @$('.btn-observ-unit-mins').addClass('btn-default').removeClass('btn-primary').prop('disabled',false)

    else
      @$('.btn-observ-unit-mins').removeClass('btn-default btn-primary').prop('disabled',true)
      @$('.btn-observ-unit-perc').removeClass('btn-default btn-primary').prop('disabled',true)

  togglePerc: (e) ->
    # the btn-primary is used for "active" buttons
    # if OBSERV_UNIT is % and % button is already pressed, deactivate it. else activate it
    if this.$('.btn-observ-unit-perc')[0].outerHTML.includes("btn-primary")
      @model.set 'OBSERV_UNIT', ''
    else
      @model.set 'OBSERV_UNIT', '%'
    @updateObserv()

  toggleMins: (e) ->
    if this.$('.btn-observ-unit-mins')[0].outerHTML.includes("btn-primary")
       @model.set 'OBSERV_UNIT', ''
    else
      @model.set 'OBSERV_UNIT', ' mins'
    @updateObserv()

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

  handleSelect: (population, value, increment) ->
    if increment
      switch population
        when 'IPP'
          @setPopulation('STRAT', value) unless @isNumbers and @attrs['STRAT'] >= value
        when 'DENOM', 'MSRPOPL'
          @setPopulation('IPP', value) unless @isNumbers and @attrs['IPP'] >= value
          @handleSelect('IPP', value, increment)
          @updateDenomObservations() if @isRatio
        when 'DENEX', 'DENEXCEP'
          @setPopulation('DENOM', value) unless @isNumbers and @attrs['DENOM'] >= value
          @handleSelect('DENOM', value, increment)
        when 'NUMER'
          if @isRatio
            @setPopulation('IPP', value) unless @isNumbers and @attrs['IPP'] >= value
            @handleSelect('IPP', value, increment)
            @updateNumeratorObservations()
          else
            @setPopulation('DENOM', value) unless @isNumbers and @attrs['DENOM'] >= value
            @handleSelect('DENOM', value, increment)
        when 'NUMEX'
          @setPopulation('NUMER', value) unless @isNumbers and @attrs['NUMER'] >= value
          @handleSelect('NUMER', value, increment)
        when 'MSRPOPLEX'
          @setPopulation('MSRPOPLEX', value) unless @isNumbers and @attrs['MSRPOPLEX'] >= value
          @setPopulation('MSRPOPL', value) unless @isNumbers and @attrs['MSRPOPL'] >= value
          @handleSelect('MSRPOPL', value, increment)
    else
      switch population
        when 'STRAT'
          @setPopulation('IPP', value) unless @isNumbers and @attrs['IPP'] < value
          @handleSelect('IPP', value, increment)
        when 'IPP'
          @setPopulation('DENOM', value) unless @isNumbers and @attrs['DENOM'] < value
          @setPopulation('MSRPOPL', value) unless @isNumbers and @attrs['MSRPOPL'] < value or not @isMultipleObserv
          @handleSelect('DENOM', value, increment)
          if @isRatio
            @setPopulation('NUMER', value) unless @isNumbers and @attrs['NUMER'] < value
            @handleSelect('NUMER', value, increment)
        when 'DENOM', 'MSRPOPL'
          @setPopulation('DENEX', value) unless @isNumbers and @attrs['DENEX'] < value
          @setPopulation('DENEXCEP', value) unless @isNumbers and @attrs['DENEXCEP'] < value
          # Remove expected MSRPOPLEX if MSRPOPL/DENOM less than MSRPOPLEX
          @setPopulation('MSRPOPLEX', value) unless @isNumbers and @attrs['MSRPOPLEX'] < value
          if @isRatio
            @updateDenomObservations()
          else
            @setPopulation('NUMER', value) unless @isNumbers and @attrs['NUMER'] < value
            @handleSelect('NUMER', value, increment)
        when 'NUMER'
          @setPopulation('NUMEX', value) unless @isNumbers and @attrs['NUMEX'] < value
          @updateNumeratorObservations() if @isRatio
        when 'DENEX'
          @setPopulation('DENEX', value) unless @isNumbers and @attrs['DENEX'] < value
          @updateDenomObservations() if @isRatio
        when 'NUMEX'
          @setPopulation('NUMEX', value) unless @isNumbers and @attrs['NUMEX'] < value
          @updateNumeratorObservations() if @isRatio
        when 'MSRPOPLEX'
          @setPopulation('MSRPOPLEX', value) unless @isNumbers and @attrs['MSRPOPLEX'] < value

  setPopulation: (population, value) ->
    if @model.has(population) and @model.get(population)?
      if @isCheckboxes or not @isNumbers and @isMultipleObserv
        @$("input[name=\"#{population}\"]").prop('checked', value)
      else if @isNumbers
        @$("input[name=\"#{population}\"]").val(value)
    if @isMultipleObserv
      @serialize()
      $("a[href=\"#expected-#{@model.get('population_index')}\"]").parent().addClass('active') # reset the active tab for CV measures
      @updateObserv() if @isMultipleObserv and (population == 'MSRPOPL' or population == 'MSRPOPLEX')
