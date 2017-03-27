class Thorax.Views.DataCriteriaLogic extends Thorax.Views.BonnieView

  template: JST['logic/data_criteria']
  logic_operator_map:
    'XPRODUCT':'AND'
  set_operator_map:
    'INTERSECT':'Intersection of'
    'UNION':'Union of'

  satisfiesDefinitions: Thorax.Models.MeasureDataCriteria.satisfiesDefinitions
  events:
    'mouseover .highlight-target': 'highlightEntry'
    'mouseout .highlight-target': 'clearHighlightEntry'
    # TODO: Find a better way than logic in the template to disable highlighting when called from code other than patient builder.

  initialize: ->
    # Capture logic view building errors that may arise and handle them using Costanza
    Costanza.run 'data-criteria-logic-view-creation', {reference: @reference, cms_id: @measure.get('cms_id')}, () =>
      @dataCriteria = @measure.get('data_criteria')[@reference]
      # handle reference to source data criteria (this is used for displaying variables)
      unless @dataCriteria
        @dataCriteria = @measure.get('source_data_criteria').findWhere({'source_data_criteria': @reference}).attributes
        @dataCriteria.key = @reference

      # we need to do this because the view helper doesn't seem to be available in an #each.
      if @dataCriteria.field_values
        for key, field of @dataCriteria.field_values
          # timing fields can have a null value
          unless field?
            field = {}
            @dataCriteria.field_values[key] = field
          field['key'] = key
          field['key_title'] = @translate_field(key)

      if @dataCriteria.references
        for key, field of @dataCriteria.references
          field['key'] = @translate_reference_type(key)
          field["key_title"] = @translate_reference_to_title(field.referenced_criteria)
      @dataCriteria.references = null if @dataCriteria && _.isEmpty(@dataCriteria.references)
      @dataCriteria.field_values = null if @dataCriteria && _.isEmpty(@dataCriteria.field_values)
      @isSatisfies = @dataCriteria.definition in @satisfiesDefinitions
      @isDerived = @dataCriteria.type == 'derived'
      @hasChildren = @isDerived && (!@dataCriteria.variable || @expandVariable)

  isSetOp: => @dataCriteria.derivation_operator in _(@set_operator_map).keys()

  translate_logic_operator: (conjunction) => @logic_operator_map[conjunction]

  translate_set_operator: (conjunction) => @set_operator_map[conjunction]

  translate_field: (field_key) =>
    Thorax.Models.Measure.logicFields[field_key]?['title']

  translate_reference_type: (type) ->
    type = 'fulfills' if type == 'FLFS'
    type
  translate_reference_to_title: (ref) ->
    if ref.specific_occurrence?
      "Occurrence " + ref.specific_occurrence + ": " + ref.description
    else
      ref.description
  translate_oid: (oid) =>
    @measure.valueSets().findWhere({oid: oid})?.get('display_name')

  highlightEntry: (e) ->
    dataCriteriaKey = @dataCriteria.key
    populationView = @populationCriteriaView()
    return unless populationView
    populationCriteriaKey = populationView.population.type  # IPP, DEN, etc. including VAR(iables)
    populationView.parent.highlightPatientData(dataCriteriaKey, populationCriteriaKey)

  clearHighlightEntry: (e) ->
    if view = @populationCriteriaView()
      view.parent.clearHighlightPatientData()

  populationCriteriaView: ->
    parent = @parent
    until !parent || parent instanceof Thorax.Views.PopulationCriteriaLogic || parent instanceof Thorax.Views.VariablesLogic
      parent = parent.parent
    parent
