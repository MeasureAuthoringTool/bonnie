###*
# View representing a CQL statement (aka. define).
###
class Thorax.Views.CqlStatement extends Thorax.Views.BonnieView
  template: JST['logic/cql_statement']

  #events:
    # TODO: figureout if hightlighting makes sense at this level
    #'mouseover code': 'highlightEntry'
    #'mouseout code': 'clearHighlightEntry'

  ###*
  # Initializes the CqlStatement view. Expects statement to be the JSON ELM statement that should be shown.
  # highlightPatientDataEnabled can optionally be set to true when constructing to turn on the highlighing patient 
  # data functionality.
  ###
  initialize: ->
    @name = @statement.define_name
    @rootClauseView = new Thorax.Views.CqlClauseView(element: @statement)

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
  # Clear the result for this statement.
  ###
  clearRationale: ->
    # Clear out the latestResult. Using undefined because it is different than null which is a valid result.
    @latestResult = undefined
    @$('code').attr('class', '')
    @rootClauseView.clearRationale()

  ###*
  # Event handler for the mouseover event. This will report to the CqlPopulationLogic view with the ids of the patient
  # data elements that should be highlighted.
  ###
  highlightEntry: ->
    # TODO: figure out if highlighting makes sense at this level.
    # only highlight entries if highlighting is enabled and there are results in the form of an array.
    #if @highlightPatientDataEnabled == true && Array.isArray(@latestResult.raw) && @latestResult.raw.length > 0
    #  dataCriteriaIDs = []
    #  for resultEntry in @latestResult.raw
    #    if resultEntry?.entry  # if the result is an entry then grab the id so it can be highlighted
    #      dataCriteriaIDs.push(resultEntry.entry._id)
    #  @parent?.highlightPatientData(dataCriteriaIDs)  # report the id of the data criteria to be highlighted to the CqlPopulationLogic view.

  ###*
  # Event handler for the mouseout event. This will report to the CqlPopulationLogic view that highlighting should be cleared.
  ###
  clearHighlightEntry: ->
    if @highlightPatientDataEnabled == true
      @parent?.clearHighlightPatientData()
