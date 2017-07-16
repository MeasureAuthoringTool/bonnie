class Thorax.Views.CqlClauseView extends Thorax.Views.BonnieView
  template: JST['cql/cql_clause']
  tagName: 'span'
  
  events:
    rendered: -> 
      @$el.attr('data-ref-id', @element.ref_id) if @element.ref_id?
      @$el.attr('data-define-name', @element.define_name) if @element.define_name?
    'mouseover': 'highlightEntry'
    'mouseout': 'clearHighlightEntry'
  
  initialize: ->
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
        
    if @element.ref_id?
      if rationaleCriteria? && rationaleCriteria[@element.ref_id]?
        @$el.attr('class', 'clause-covered')
      else
        @$el.attr('class', 'clause-uncovered')

      
  showRationale: (results) ->
    if @childClauses?
      for clause in @childClauses
        clause.showRationale(results)

    if @element.ref_id? && results?
      result = results[@element.ref_id]
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
      if @element.ref_id?
        # if there are results and they are an array, we can highlight!
        if Array.isArray(@latestResult?.raw) && @latestResult?.raw.length > 0
          dataCriteriaIDs = []
          for resultEntry in @latestResult.raw
            if resultEntry?.entry  # if the result is an entry then grab the id so it can be highlighted
              dataCriteriaIDs.push(resultEntry.entry._id)
          # report the id of the data criteria to be highlighted to the CqlPopulationLogic view.
          @logicView?.highlightPatientData(dataCriteriaIDs)
        else if @latestResult.raw?.entry?._id
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
