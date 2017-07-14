###*
# View representing a CQL statement (aka. define).
###
class Thorax.Views.CqlStatement extends Thorax.Views.BonnieView
  template: JST['logic/cql_statement']

  ###*
  # Initializes the CqlStatement view. Expects statement to be the JSON ELM statement that should be shown.
  # highlightPatientDataEnabled can optionally be set to true when constructing to turn on the highlighing patient 
  # data functionality.
  ###
  initialize: ->
    @name = @statement.define_name
    @rootClauseView = new Thorax.Views.CqlClauseView(element: @statement, logicView: @logicView, highlightPatientDataEnabled: @highlightPatientDataEnabled)

  ###*
  # Show the results of this statement's calculation by highlighing appropiately. 
  # @param {boolean|Object[]|Object|cql.Interval} result - The result for this statement. May be a boolean or an array of entries.
  ###
  showRationale: (results) ->
    @rootClauseView.showRationale(results)

  ###*
  # Modifies the class attribute of the code element to highlight the result.
  # @private
  # @param {boolean} evalResult - The result that should be shown.
  ###
  _setResult: (evalResult) ->
    if evalResult == true
      @$('code').attr('class', 'eval-true')
    else
      @$('code').attr('class', 'eval-false')

  ###*
  # Calls the coverage highlighting function for the CQL clauses in the statement
  # @param {hash} rationaleCriteria - LocalId->Result that will be covered
  ###
  showCoverage: (rationaleCriteria) ->
    @rootClauseView.showCoverage(rationaleCriteria)

  ###*
  # Clear the result for this statement.
  ###
  clearRationale: ->
    # Clear out the latestResult. Using undefined because it is different than null which is a valid result.
    @latestResult = undefined
    @$('code').attr('class', '')
    @rootClauseView.clearRationale()
