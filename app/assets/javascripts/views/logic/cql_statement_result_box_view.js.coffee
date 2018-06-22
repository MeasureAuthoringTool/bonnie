class Thorax.Views.CqlStatementResultBox extends Thorax.Views.BonnieView
  template: JST['cql/cql_statement_result_box']

  initialize: ->
   @resultView = new Thorax.Views.CqlStatementResult

  updateResult: (resultString) ->
    @resultView.updateResult(resultString)

  clearResult: ->
    @resultView.clearResult()

  hideResult: ->
    @resultView.hide()
    @$('#result-hide-' + this.cid).text('Show Result')
    @$('#result-hide-' + this.cid).attr('data-call-method', 'showResult')
    @$('#result-hide-' + this.cid).addClass('show-result')
    @$('#result-hide-' + this.cid).attr('id', 'result-show-' + this.cid)

  showResult: ->
    @resultView.show()
    @$('#result-show-' + this.cid).text('Hide Result')
    @$('#result-show-' + this.cid).attr('data-call-method', 'hideResult')
    @$('#result-show-' + this.cid).removeClass('show-result')
    @$('#result-show-' + this.cid).attr('id', 'result-hide-' + this.cid)


