###*
# View representing a CQL statement (aka. define).
###
class Thorax.Views.CqlStatement extends Thorax.Views.BonnieView
  template: JST['logic/cql_statement']

  events:
    'mouseover code': 'highlightEntry'
    'mouseout code': 'clearHighlightEntry'

  ###*
  # Initializes the CqlStatement view. Expects statement to be the JSON ELM statement that should be shown.
  # highlightPatientDataEnabled can optionally be set to true when constructing to turn on the highlighing patient 
  # data functionality.
  ###
  initialize: ->
    @text = @statement.annotation[0].s.value[0]
    @name = @statement.name

  ###*
  # Show the results of this statement's calculation by highlighing appropiately. 
  # @param {boolean|Object[]|Object|cql.Interval} result - The result for this statement. May be a boolean or an array of entries.
  # @param {boolean} highlightResult - If the result should actually be highlighted or not
  ###
  showRationale: (result, highlightResult) ->
    @latestResult = result

    if highlightResult == false  # If the result shouldn't be highlighted
      @$('code').attr('class', '')
    else if result == true  # Specifically a boolean true
      @_setResult true
    else if result == false  # Specifically a boolean false
      @_setResult false
    else if Array.isArray(result)  # Check if result is an array
      @_setResult result.length > 0  # Result is true if the array is not empty
      if result.length == 1 && result[0] == null # But if the array has one element that is null. Then we should make it red.
        @_setResult false
    else if result instanceof cql.Interval  # make it green if and Interval is returned
      @_setResult true
    else if result == null  # Specifically no result
      @_setResult false
    else
      @$('code').attr('class', '')  # Clear the highlighting if we can't make sense of the result

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

  ###*
  # Event handler for the mouseover event. This will report to the CqlPopulationLogic view with the ids of the patient
  # data elements that should be highlighted.
  ###
  highlightEntry: ->
    # only highlight entries if highlighting is enabled and there are results in the form of an array.
    if @highlightPatientDataEnabled == true && Array.isArray(@latestResult) && @latestResult.length > 0
      dataCriteriaIDs = []
      for resultEntry in @latestResult
        if resultEntry?.entry  # if the result is an entry then grab the id so it can be highlighted
          dataCriteriaIDs.push(resultEntry.entry._id)
      @parent?.highlightPatientData(dataCriteriaIDs)  # report the id of the data criteria to be highlighted to the CqlPopulationLogic view.

  ###*
  # Event handler for the mouseout event. This will report to the CqlPopulationLogic view that highlighting should be cleared.
  ###
  clearHighlightEntry: ->
    if @highlightPatientDataEnabled == true
      @parent?.clearHighlightPatientData()
