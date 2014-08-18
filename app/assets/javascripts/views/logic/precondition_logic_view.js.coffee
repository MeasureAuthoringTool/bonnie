class Thorax.Views.PreconditionLogic extends Thorax.Views.BonnieView

  template: JST['logic/precondition']
  conjunction_map:
    'allTrue':'AND'
    'atLeastOneTrue':'OR'
  flip_conjunction_map:
    'AND': 'OR'
    'OR': 'AND'

  initialize: ->
    @preconditionKey = "precondition_#{@precondition.id}"
    @parentPreconditionKey = "precondition_#{@parentPrecondition.id}"
    @conjunction = @translate_conjunction(@parentPrecondition.conjunction_code)

    @suppress = true if @precondition.negation && @precondition.preconditions?.length == 1
    @conjunction = @flip_conjunction_map[@conjunction] if @parentNegation

    @comments = @precondition.comments
    if @precondition.reference
      dataCriteria = @measure.get('data_criteria')[@precondition.reference]
      @comments = _(@comments || []).union(dataCriteria?.comments || [])

  translate_conjunction: (conjunction) ->
    @conjunction_map[conjunction]
