class Thorax.Views.CqlStatementResult extends Thorax.Views.BonnieView
  template: JST['cql/cql_statement_result']

  initialize: ->
    @defaultResultString = "Select a patient to display results."
    @result = @defaultResultString

  updateResult: (resultString) ->
    @result = resultString
    @_refreshView()

  clearResult: ->
    @result = @defaultResultString
    @_refreshView()

  hide: ->
    @$('#cql-result-' + this.cid).hide()

  show: ->
    result = @$('#cql-result-' + this.cid)
    @_autoFitResult(result)
    result.show()


  _refreshView: ->
    result = @$('#cql-result-' + this.cid)
    result.text(@result)
    @_autoFitResult(result)
  
  _autoFitResult: (result) ->
    # remove this class so that if the result has become shorter, it won't stay at the fixed height
    if result.hasClass('result-fixed-height')
      result.removeClass('result-fixed-height')

    # Display a scrollbar if results are too long.
    if result.height()? && result.height() >= 200
      result.addClass('result-fixed-height')


