class Thorax.Views.PreconditionLogic extends Thorax.Views.BonnieView

  template: JST['logic/precondition']
  conjunction_map:
    'allTrue':'AND'
    'atLeastOneTrue':'OR'

  initialize: ->
    @preconditionKey = "precondition_#{@precondition.id}"
    @parentPreconditionKey = "precondition_#{@parentPrecondition.id}"
    if @precondition.reference
      dataCriteria = @measure.get('data_criteria')[@precondition.reference]
      @comments = dataCriteria?.comments

  translate_conjunction: (conjunction) ->
    @conjunction_map[conjunction]
