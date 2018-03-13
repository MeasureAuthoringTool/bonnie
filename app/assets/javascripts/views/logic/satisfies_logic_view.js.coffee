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
    # Sometimes SATISFIES blocks are nested, so make sure the rootCriteria points
    # to the first non-SATISFIES nested child criteria.
    while @rootCriteria.children_criteria && @rootCriteria.definition.indexOf("satisfies") > -1
      @rootCriteria = @measure.get('data_criteria')[@rootCriteria.children_criteria[0]]
    # For each child criteria of this data criteria, record the fact that the
    # child criteria is nested.
    for cc in @dataCriteria.children_criteria
      @measure.get('data_criteria')[cc]['has_parent'] = true

  translate_operator: (definition) =>
    @operator_map[definition]

