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
      for pc in @measure.populationCriteria()
        if @measure.get('episode_of_care') || (@measure.get('continuous_variable') && (pc == 'OBSERV' || pc == 'MSRPOPL'))
          # Only parse existing values
          if attr[pc]
            attr[pc] = parseFloat(attr[pc])
            # if we're dealing with OBSERV or MSRPOPL, set to undefined for empty value
          else attr[pc] = undefined if pc == 'OBSERV' or pc == 'MSRPOPL'
        else
          attr[pc] = if attr[pc] then 1 else 0 # Convert from check-box true/false to 0/1

  context: ->
    context = super
    for pc in @measure.populationCriteria()
      unless @measure.get('episode_of_care') || (@measure.get('continuous_variable') && (pc == 'OBSERV' || pc == 'MSRPOPL'))
        context[pc] = (context[pc] == 1)
    context

  initialize: ->
    criteriaMap =
      IPP: 'IPP'
      DENOM: 'DENOM'
      NUMER: 'NUMER'
      DENEXCEP: 'EXCEPTION'
      DENEX: 'EXCLUSION'
      MSRPOPL: 'MEASURE POP.'
      OBSERV: 'OBSERV'
    @currentCriteria = []
    # get population criteria from the measure to include OBSERV
    for pc in @measure.populationCriteria()
      @currentCriteria.push
        key: pc
        displayName: criteriaMap[pc]
        isEoC: @measure.get('episode_of_care')
    unless @model.has('OBSERV_UNIT') then @model.set 'OBSERV_UNIT', ' mins'

  setObservMins: ->
    @model.set 'OBSERV_UNIT', ' mins'

  setObservPerc: ->
    @model.set 'OBSERV_UNIT', '%'
