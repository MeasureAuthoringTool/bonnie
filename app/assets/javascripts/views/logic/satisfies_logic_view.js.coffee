class Thorax.Views.SatisfiesLogic extends Thorax.Views.BonnieView

  template: JST['logic/satisfies']

  operator_map:
    'satisfies_all':'SATISFIES ALL'
    'satisfies_any':'SATISFIES ANY'

  # events:
  #   'mouseover .highlight-target': 'highlightEntry'
  #   'mouseout .highlight-target': 'clearHighlightEntry'

  initialize: ->
    @dataCriteria = @measure.get('data_criteria')[@reference]
    @rootCriteria = @measure.get('data_criteria')[@dataCriteria.children_criteria[0]]
    @rootCriteria.field_values = null if _.isEmpty(@dataCriteria.field_values)

  translate_operator: (definition) =>
    @operator_map[definition]

