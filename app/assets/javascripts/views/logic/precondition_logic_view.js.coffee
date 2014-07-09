class Thorax.Views.PreconditionLogic extends Thorax.Views.BonnieView

  template: JST['logic/precondition']
  conjunction_map:
    'allTrue':'AND'
    'atLeastOneTrue':'OR'

  initialize: ->
    @preconditionKey = "precondition_#{@precondition.id}"
    @parentPreconditionKey = "precondition_#{@parentPrecondition.id}"
    @negation = @precondition.negation
    @unwrapNegation() if @negation
    if @precondition.reference
      dataCriteria = @measure.get('data_criteria')[@precondition.reference]
      @comments = dataCriteria?.comments

  # this gets negation logic display to align with the human readable from the MAT
  unwrapNegation: ->
    if @precondition.preconditions?.length == 1
      @precondition = @precondition.preconditions[0]

  translate_conjunction: (conjunction) ->
    @conjunction_map[conjunction]
