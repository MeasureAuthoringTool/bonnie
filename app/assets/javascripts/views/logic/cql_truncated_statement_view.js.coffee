###*
# View that shows a truncated version of a statement. This is used when a statement is too large to be displayed with
# clause level highlighing without being huge performance hit.
###
class Thorax.Views.CqlTruncatedStatementView extends Thorax.Views.CqlClauseView
  template: JST['cql/cql_truncated_statement']

  ###*
  # Expects @element, @libraryName and @statementName to be set on construction
  ###
  initialize: ->
    # get the root clause ref_id for highlighting use.
    @ref_id = @element.children[0].ref_id
