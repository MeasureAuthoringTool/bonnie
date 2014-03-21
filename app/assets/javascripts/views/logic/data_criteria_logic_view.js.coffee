class Thorax.Views.DataCriteriaLogic extends Thorax.Views.BonnieView

  template: JST['logic/data_criteria']
  operator_map:
    'XPRODUCT':'AND'
    'UNION':'OR'

  events:
    'mouseover .highlight-target': 'highlightEntry'
    'mouseout .highlight-target': 'clearHighlightEntry'
    'click .toggle-highlight-target': 'toggleHighlightEntry'

  initialize: ->
    @dataCriteria = @measure.get('data_criteria')[@reference]
    # we need to do this because the view helper doesn't seem to be available in an #each.
    if @dataCriteria.field_values
      for key, field of @dataCriteria.field_values
        # timing fields can have a null value
        unless field?
          field = {}
          @dataCriteria.field_values[key] = field
        field['key'] = key
        field['key_title'] = @translate_field(key)

  translate_operator: (conjunction) =>
    @operator_map[conjunction]

  translate_field: (field_key) =>
    Thorax.Models.Measure.logicFields[field_key]?['title']

  translate_oid: (oid) =>
    @measure.valueSets().findWhere({oid: oid})?.get('display_name')

  highlightEntry: (e) ->
    dataCriteriaKey = @dataCriteria.key
    populationView = @populationCriteriaView()
    populationCriteriaKey = populationView.population.type
    populationView.parent.highlightPatientData(dataCriteriaKey, populationCriteriaKey)

  clearHighlightEntry: (e) ->
    @populationCriteriaView().parent.clearHighlightPatientData()

  toggleHighlightEntry: (e) ->
    @clearHighlightEntry()
    if $(e.target).is(':checked') then @highlightEntry()

  populationCriteriaView: ->
    parent = @parent
    until parent instanceof Thorax.Views.PopulationCriteriaLogic
      parent = parent.parent
    parent
