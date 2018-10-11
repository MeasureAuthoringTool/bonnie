class Thorax.Views.CqlClauseView extends Thorax.Views.BonnieView
  template: JST['cql/cql_clause']
  tagName: 'span'
  
  events:
    rendered: -> 
      @$el.attr('data-ref-id', @ref_id) if @ref_id?
      @$el.attr('data-define-name', @statementName) if @statementName?
    'mouseover': 'highlightEntry'
    'mouseout': 'clearHighlightEntry'
  
  initialize: ->
    @statementName = @element.define_name if @element.define_name?
    @ref_id = @element.ref_id if @element.ref_id?
    if (@element.children)
      @childClauses = []
      for child in @element.children
        @childClauses.push(new Thorax.Views.CqlClauseView(element: child, highlightPatientDataEnabled: @highlightPatientDataEnabled, logicView: @logicView))

  ###*
  # Highlights the clause views in the rationaleCriteria, indicating coverage
  # @param {hash} rationaleCriteria - LocalId->Result that will be covered
  ###
  showCoverage: (rationaleCriteria) ->
    if @childClauses?
      for clause in @childClauses
        clause.showCoverage(rationaleCriteria)
        
    if @ref_id?
      if rationaleCriteria? && rationaleCriteria[@ref_id]?
        @$el.attr('class', 'clause-covered')
      else
        @$el.attr('class', 'clause-uncovered')

      
  showRationale: (results) ->
    if @childClauses?
      for clause in @childClauses
        clause.showRationale(results)

    if @ref_id? && results?
      result = results[@ref_id]
      @latestResult = result
      
      if result?.final == 'TRUE'
        @_setResult true
      else if result?.final == 'FALSE'
        @_setResult false
      else
        @$el.attr('class', '')  # Clear the rationale if we can't make sense of the result

    # if this is a let keyword then we should make it green if the localId it belongs in was hit
    else if @element.text == 'let '
      # navigate up to the parent view with a ref_id. Stop if element doesn't exist because we hit the statement.
      clauseView = @
      while clauseView.element? && !clauseView.element.ref_id?
        clauseView = clauseView.parent

      # if we found the parent clause view with a ref_id
      if clauseView.element?
        result = results[clauseView.element.ref_id]?.final
        # make this clause green if it was 'FALSE' or 'TRUE'. 'UNHIT' and 'NA' shouldn't color.
        if result == 'FALSE' || result == 'TRUE'
          @_setResult true

  ###*
  # Clear the result for this statement.
  ###
  clearRationale: ->
    @latestResult = null
    @$el.attr('class', '')
    if @childClauses?
      for clause in @childClauses
        clause.clearRationale()
    
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
            if resultEntry?._id  # if the result is an qdm datatype then grab the id so it can be highlighted
              dataCriteriaIDs.push(resultEntry._id)
          # report the id of the data criteria to be highlighted to the CqlPopulationLogic view.
          @logicView?.highlightPatientData(dataCriteriaIDs)
        # Highlight single clause if there was a single result
        else if @latestResult?.raw?._id
          @logicView?.highlightPatientData([@latestResult.raw._id])

      # if we dont have a ref_id then we may just be a text clause. so we pass this to our parent clause
      else
        @parent.highlightEntry()

  ###*
  # Event handler for the mouseout event. This will report to the CqlPopulationLogic view that highlighting should be cleared.
  ###
  clearHighlightEntry: ->
    if @highlightPatientDataEnabled == true
      @logicView?.clearHighlightPatientData()
