class Thorax.Views.CqlPopulationsLogic extends Thorax.LayoutView

  template: JST['logic/cql_layout']

  ###*
  # This is a button click event handler. The button being clicked is the population tab in the cql_layout.hbs.
  # This function figures out which population was clicked then updates the view accordingly.
  # @param {Event} e - JS click event.
  ###
  switchPopulation: (e) ->
    population = $(e.target).model()
    @switchToGivenPopulation(population)

  ###*
  # Switches the view to the given population (aka. population set). This creates a new CqlPopulationLogic logic view for the population
  # and updates the displayedPopulation on the measure.
  # @param {Population} pop - The population model to switch to.
  ###
  switchToGivenPopulation: (pop) ->
    pop.measure().set('displayedPopulation', pop)
    @cqlLogicView = new Thorax.Views.CqlPopulationLogic(model: @model, population: pop)
    @setView @cqlLogicView
    @trigger 'population:update', pop

  showRationale: (result) -> @getView().showRationale(result)

  clearRationale: -> @getView().clearRationale()

  showCoverage: -> @getView().showCoverage()

  clearCoverage: -> @getView().clearCoverage()

  showSelectCoverage: (rationaleCriteria) -> @getView().showSelectCoverage(rationaleCriteria)

  populationContext: (population) ->
    _(population.toJSON()).extend
      isActive:  population is population.measure().get('displayedPopulation')
      populationTitle: population.get('title') || population.get('sub_id')

###*
# View for CQL Logic. Contains CqlStatement views.
###
class Thorax.Views.CqlPopulationLogic extends Thorax.Views.BonnieView

  template: JST['logic/cql_logic']

  events:
    # Click events for the collapsable logic sections for the definitions and functions. These toggle the icon in the
    # section headers.
    'click .panel-defines' : -> @$('.panel-defines .toggle-icon').toggleClass('fa-angle-right fa-angle-down')
    'click .panel-unused-defines' : -> @$('.panel-unused-defines .toggle-icon').toggleClass('fa-angle-right fa-angle-down')
    'click .panel-functions' : -> @$('.panel-functions .toggle-icon').toggleClass('fa-angle-right fa-angle-down')
    'click .panel-sde-defines' : -> @$('.panel-sde-defines .toggle-icon').toggleClass('fa-angle-right fa-angle-down')
    "ready": ->

  ###*
  # Initializes the view. Creates the CqlStatement views.
  # Expects model to be a Measure model object of a CQL Based measure.
  ###
  initialize: ->
    @cqmMeasure = @model.get('cqmMeasure')
    @isOutdatedUpload = false
    @hasCqlErrors = false
    @hasOutdatedQDM = false

    @allStatementViews = []
    @allStatementResultViews = []
    @populationStatementViews = []
    @defineStatementViews = []
    @functionStatementViews = []
    @unusedStatementViews = []
    @supplementalDataElementViews = []

    if Array.isArray @cqmMeasure.cql_libraries
      _.each @cqmMeasure.cql_libraries, (lib) =>
        @hasOutdatedQDM = @_hasOutDatedQDM(lib)
        @hasCqlErrors = @_hasCqlErrors(lib)

    if @population?
      @statementRelevance = CQLMeasureHelpers.getStatementRelevanceForPopulationSet(@cqmMeasure, @population)

    # Check to see if this measure was uploaded with an older version of the
    # loader code that did not get the clause level annotations.
    unless @cqmMeasure.cql_libraries?
      # Mark as an outdated and do not create any statement views.
      @isOutdatedUpload = true
      return

    for library in @cqmMeasure.cql_libraries
      for statement in library.elm_annotations.statements
        # skip if this is a statement the user doesn't need to see
        continue unless statement.define_name?
        isSkipStatement = _.indexOf(Thorax.Models.Measure.cqlSkipStatements, statement.define_name) >= 0
        continue if isSkipStatement && !@cqmMeasure.calculate_sdes
        popNames = []
        popName = null
        # if a population (population set) was provided for this view it should
        # mark the statment if it is a population defining statement
        continue unless @population?

        for popCode, popStatements of @population.get('populations')
          continue unless library.is_main_library
          if statement.define_name == popStatements.statement_name
            popNames.push(popCode)

        for observ, observIndex in @population.get('observations')
          continue unless library.is_main_library
          if statement.define_name == observ.observation_function.statement_name
            popNames.push("OBSERV_#{observIndex+1}")

        # Build the statement or result statement view
        statementOrResultStatement =
          statement: statement,
          libraryName: library.library_name,
          highlightPatientDataEnabled: @highlightPatientDataEnabled,
          cqlPopulations: popNames,
          logicView: @

        if CQLMeasureHelpers.isStatementFunction(library, statement.define_name)
          statementView = new Thorax.Views.CqlStatement statementOrResultStatement
        else
          statementView = new Thorax.Views.CqlResultStatement statementOrResultStatement
          @allStatementResultViews.push statementView
        @_categorizeStatementView(statementView, library)

      @populationStatementViews.sort(@_statementComparator)

  _hasOutDatedQDM: (lib) ->
    _.each lib.elm.library.usings.def, (id) =>
      if id?.localIdentifier == "QDM"
        if !CompareVersion.equalToOrNewer id.version, bonnie.support_qdm_version
          return true
    return false

  _hasCqlErrors: (lib) ->
    _.each lib.elm.library.annotation, (annotation) =>
      if annotation.errorSeverity == "error"
        return true
    return false

  _categorizeStatementView: (statementView, library) ->
    @allStatementViews.push statementView
    if @_isPopulationStatementView(statementView)
      @populationStatementViews.push statementView
    else if @_isFunctionStatementView(library, statementView)
      @functionStatementViews.push statementView
    else if @_isSupplementalDataElementView(statementView) && @cqmMeasure.calculate_sdes
      @supplementalDataElementViews.push statementView
    else if @_isDefineStatementView(statementView, library)
      @defineStatementViews.push statementView
    else
      @unusedStatementViews.push statementView


  _isPopulationStatementView: (statementView) ->
    return statementView.cqlPopulations.length > 0

  _isFunctionStatementView: (library, statementView) ->
    return CQLMeasureHelpers.isStatementFunction(library, statementView.statement.define_name)

  _isSupplementalDataElementView: (statementView) ->
    return CQLMeasureHelpers.isSupplementalDataElementStatement(@population.get('supplemental_data_elements'),
                                                                statementView.statement.define_name)
  _isDefineStatementView: (statementView, library) ->
    libraryName = library.library_name
    defineName = statementView.statement.define_name
    isRelevant = @statementRelevance[libraryName][defineName] == 'TRUE'
    return !@population? || isRelevant

  ###
  # Compares two statement views to sort them by the population they define. IPP, DENOM, NUMER, etc..
  # @private
  # @param {Thorax.Views.CqlStatement} a - The left side of the comparison.
  # @param {Thorax.Views.CqlStatement} b - The right side of the comparison.
  # @return {Integer} Less than 0 if 'a' should come first. 0 if they can be in either order. Greater than 0 if 'b' should come first.
  ###
  _statementComparator: (a, b) ->
    aIndex = Object.keys(Thorax.Models.Measure.PopulationMap).indexOf(if a.cqlPopulations[0].match(/OBSERV/) then 'OBSERV' else a.cqlPopulations[0])
    bIndex = Object.keys(Thorax.Models.Measure.PopulationMap).indexOf(if b.cqlPopulations[0].match(/OBSERV/) then 'OBSERV' else b.cqlPopulations[0])

    if aIndex >= 0 && bIndex >= 0
      return aIndex - bIndex
    else if aIndex >= 0 && bIndex < 0
      return -1
    else if aIndex < 0 && bIndex >= 0
      return 1
    return 0

  ###*
  # Shows the coverage information.
  ###
  showCoverage: ->
    @clearRationale()
    rationaleCriteria = @population.coverage().rationaleCriteria
    # If there are no patients, there will be no rationaleCriteria and therefore no coverage
    if rationaleCriteria?
      for statementView in @allStatementViews
        statementView.showCoverage(rationaleCriteria[statementView.libraryName])

  ###*
  # Clears the coverage information from the view.
  ###
  clearCoverage: ->

  ###*
  # Shows the rationale (aka. calculation results) by highlighting the CQL Statements that returned true or with values.
  # This grabs the individual statement results and sends them to the respective CQLStatement views.
  # @param {Result} result - The Result object from the calculator
  ###
  showRationale: (result) ->
    @latestResult = result
    for statementView in @allStatementViews
      # Do not attempt to show pass/fail for a clause that does not exist possibly due to a calculation error
      if result.get('clause_results')? && result.get('clause_results')[statementView.libraryName]?
        statementView.showRationale(
          result.get('clause_results')[statementView.libraryName],
          result.get('statement_results')[statementView.libraryName]?[statementView.name])

  ###*
  # Clears the rationale hightlighting on all CqlStatement views.
  ###
  clearRationale: ->
    for statementView in @allStatementViews
      statementView.clearRationale()

  ###*
  # Handles the patient highlighting in the patient builder. This function is called by the CqlStatement view if its
  # statement is hovered over and has results.
  # @param {string[]} dataCriteriaIDs - A list of the dataCriteriaIDs that should be highlighted.
  ###
  highlightPatientData: (dataCriteriaIDs) ->
    if @highlightPatientDataEnabled == true && @latestResult
      for dataCriteriaID in dataCriteriaIDs
        @latestResult.patient.get('source_data_criteria').findWhere(coded_entry_id: dataCriteriaID).trigger 'highlight', Thorax.Views.EditCriteriaView.highlight.valid
  
  ###*
  # Clears all highlighted patient data. Called by the CqlStatement if its statement is mouseout'd.
  ###
  clearHighlightPatientData: ->
    @latestResult?.patient.trigger 'clearHighlight'

  showAllResults: ->
    for statementView in @allStatementResultViews
      statementView.showResult()
    @$('#show-all-results').text('Hide All Results')
    @$('#show-all-results').attr('data-call-method', 'hideAllResults')
    @$('#show-all-results').attr('id', 'hide-all-results')

  hideAllResults: ->
    for statementView in @allStatementResultViews
      statementView.hideResult()
    @$('#hide-all-results').text('Show All Results')
    @$('#hide-all-results').attr('data-call-method', 'showAllResults')
    @$('#hide-all-results').attr('id', 'show-all-results')
