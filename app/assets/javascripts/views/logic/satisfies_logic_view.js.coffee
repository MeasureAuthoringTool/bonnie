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

  translate_operator: (definition) =>
    @operator_map[definition]

