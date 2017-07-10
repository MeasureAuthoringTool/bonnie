class Thorax.Views.CqlClauseView extends Thorax.Views.BonnieView
  template: JST['cql/cql_clause']
  tagName: 'span'
  
  events:
    rendered: -> 
      @$el.attr('data-ref-id', @element.ref_id) if @element.ref_id?
      @$el.attr('data-define-name', @element.define_name) if @element.define_name?
  
  initialize: ->
    if (@element.children)
      @childClauses = []
      for child in @element.children
        @childClauses.push(new Thorax.Views.CqlClauseView(element: child))
        
  showRationale: (results) ->
    if @childClauses?
      for clause in @childClauses
        clause.showRationale(results)

    if @element.ref_id?
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
