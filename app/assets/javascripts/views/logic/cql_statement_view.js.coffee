###*
# View representing a CQL statement (aka. define).
###
class Thorax.Views.CqlStatement extends Thorax.Views.BonnieView
  template: JST['logic/cql_statement']

  events:
    # Click events for the collapsable logic sections if this is a population defining statement. This toggles the
    # icon in the section header.
    'click .panel-population' : -> @$('.panel-population .toggle-icon').toggleClass('fa-angle-right fa-angle-down')

  ###*
  # Initializes the CqlStatement view. Expects statement to be the JSON ELM statement that should be shown.
  # highlightPatientDataEnabled can optionally be set to true when constructing to turn on the highlighing patient 
  # data functionality.
  ###
  initialize: ->
    @name = @statement.define_name

    # if this statement defines populations, get their long names
    if @cqlPopulations.length > 0
      @cqlPopulationLongNames = _.map @cqlPopulations, (pop) -> 
        if Thorax.Models.Measure.PopulationMap[pop]?
          return Thorax.Models.Measure.PopulationMap[pop]
        else if pop.match(/OBSERV/)
          return Thorax.Models.Measure.PopulationMap['OBSERV']
        else
          return pop
      @cqlPopulationNames = @cqlPopulationLongNames.join(', ')

    @rootClauseView = new Thorax.Views.CqlClauseView(element: @statement, logicView: @logicView, highlightPatientDataEnabled: @highlightPatientDataEnabled)

  ###*
  # Show the results of this statement's calculation by highlighing appropiately. 
  # @param {Object[]} clauseResults - The clause results for this library.
  # @param {Object} statementResult - The statement result for this statement.
  ###
  showRationale: (clauseResults, statementResult) ->
    @clearRationale()
    @rootClauseView.showRationale(clauseResults)
    @latestResult = statementResult

    # if this statement defines populations, highlight the panel headers.
    # TODO: Figure out how to appropiately highlight OBSERV.
    if @cqlPopulationNames? && !@cqlPopulations[0].match(/OBSERV/)
      if statementResult.final == 'TRUE'
        @$('.panel-heading').addClass('eval-panel-true')
        @$('.rationale-target').addClass('eval-true')
      else if statementResult.final == 'FALSE'
        @$('.panel-heading').addClass('eval-panel-false')
        @$('.rationale-target').addClass('eval-false')

  ###*
  # Calls the coverage highlighting function for the CQL clauses in the statement
  # @param {hash} rationaleCriteria - LocalId->Result that will be covered
  ###
  showCoverage: (rationaleCriteria) ->
    @clearRationale()
    @rootClauseView.showCoverage(rationaleCriteria)

  ###*
  # Clear the result for this statement.
  ###
  clearRationale: ->
    # Clear out the latestResult. Using undefined because it is different than null which is a valid result.
    @latestResult = undefined
    @$('.panel-heading').removeClass('eval-panel-true eval-panel-false')
    @$('.rationale-target').removeClass('eval-true eval-false')
    @rootClauseView.clearRationale()
