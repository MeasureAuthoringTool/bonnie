###*
# View that shows a truncated version of a statement. This is used when a statement is too large to be displayed with
# clause level highlighing without being huge performance hit.
###
class Thorax.Views.CqlTruncatedStatementView extends Thorax.Views.BonnieView
  template: JST['cql/cql_truncated_statement']
  tagName: 'span'

  events:
    rendered: ->
      @$el.attr('data-ref-id', @ref_id) if @ref_id?
      @$el.attr('data-define-name', @name) if @name?
    'mouseover': 'highlightEntry'
    'mouseout': 'clearHighlightEntry'

  ###*
  # Expects @element, @libraryName and @name to be set on construction
  ###
  initialize: ->
    # get the root clause ref_id for highlighting use.
    @ref_id = @element.children[0].ref_id

  ###*
  # Highlights the overall view
  # @param {hash} rationaleCriteria - LocalId->Result that will be covered
  ###
  showCoverage: (rationaleCriteria) ->
    if @ref_id?
      if rationaleCriteria? && rationaleCriteria[@ref_id]?
        @$el.attr('class', 'clause-covered')
      else
        @$el.attr('class', 'clause-uncovered')

  showRationale: (results) ->
    if @ref_id? && results?
      result = results[@ref_id]
      @latestResult = result

      if result?.final == 'TRUE'
        @_setResult true
      else if result?.final == 'FALSE'
        @_setResult false
      else
        @$el.attr('class', '')  # Clear the rationale if we can't make sense of the result

  ###*
  # Clear the result for this statement.
  ###
  clearRationale: ->
    @latestResult = null
    @$el.attr('class', '')

  ###*
  # Modifies the class attribute of the code element to highlight the result.
  # @private
  # @param {boolean} evalResult - The result that should be shown.
  ###
  _setResult: (evalResult) ->
    if evalResult == true
      @$el.attr('class', 'clause-true')
    else
      @$el.attr('class', 'clause-false')

  ###*
  # Event handler for the mouseover event. This will report to the CqlPopulationLogic view with the ids of the patient
  # data elements that should be highlighted.
  ###
  highlightEntry: ->
    # only highlight entries if highlighting is enabled
    if @highlightPatientDataEnabled == true
      # we will only have highlightable results if we have a ref_id for this clause
      if @ref_id?
        # if there are results and they are an array, we can highlight!
        if Array.isArray(@latestResult?.raw) && @latestResult?.raw.length > 0
          dataCriteriaIDs = []
          for resultEntry in @latestResult.raw
            if resultEntry?.entry  # if the result is an entry then grab the id so it can be highlighted
              dataCriteriaIDs.push(resultEntry.entry._id)
          # report the id of the data criteria to be highlighted to the CqlPopulationLogic view.
          @logicView?.highlightPatientData(dataCriteriaIDs)
        # Highlight single clause if there was a single result
        else if @latestResult?.raw?.entry?._id
          @logicView?.highlightPatientData([@latestResult.raw.entry._id])

      # if we dont have a ref_id then we may just be a text clause. so we pass this to our parent clause
      else
        @parent.highlightEntry()

  ###*
  # Event handler for the mouseout event. This will report to the CqlPopulationLogic view that highlighting should be cleared.
  ###
  clearHighlightEntry: ->
    if @highlightPatientDataEnabled == true
      @logicView?.clearHighlightPatientData()
