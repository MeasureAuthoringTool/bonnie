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

    # Look through all elm library structures, and check for CQL errors noted by the translation service.
    # Also finds if using old versions of QDM
    if Array.isArray @cqmMeasure.cql_libraries
      _.each @cqmMeasure.cql_libraries, (lib) =>
        _.each lib.elm.library.usings.def, (id) =>
          if id?.localIdentifier == "QDM"
            if !CompareVersion.equalToOrNewer id.version, bonnie.support_qdm_version
              @hasOutdatedQDM = true
        _.each lib.elm.library.annotation, (annotation) =>
          if annotation.errorSeverity == "error"
            @hasCqlErrors = true

    # build a statement_relevance map for this population set, disregarding results
    if @population
      @statementRelevance = CQLMeasureHelpers.getStatementRelevanceForPopulationSet(@cqmMeasure, @population)

    # Check to see if this measure was uploaded with an older version of the loader code that did not get the
    # clause level annotations.
    # TODO: Update this check as needed. Remove these checks when CQL has settled for production.
    if @cqmMeasure.cql_libraries?
      for library in @cqmMeasure.cql_libraries
        for statement in library.elm_annotations.statements
          # skip if this is a statement the user doesn't need to see
          # skip doesn't happen when we are calculating SDEs
          continue unless statement.define_name?
          continue if _.indexOf(Thorax.Models.Measure.cqlSkipStatements, statement.define_name) >= 0 && !@cqmMeasure.calculate_sdes
          popNames = []
          popName = null
          # if a population (population set) was provided for this view it should mark the statment if it is a population defining statement
          if @population
            for popCode, popStatements of @population.get('populations')
              # There may be multiple populations that it defines. Only push population name if @population has a pop ie: not all populations will have STRAT
              popNames.push(popCode) if statement.define_name == popStatements.statement_name && library.is_main_library

            # Mark if it is in an OBSERV if there are any and we are looking at the main_cql_library
            if @cqmMeasure.population_sets[0].observations? && library.is_main_library
              for observ, observIndex in @cqmMeasure.population_sets[0].observations
                popNames.push("OBSERV_#{observIndex+1}") if statement.define_name == observ.observation_function.statement_name

            # create the view for this statement and add it to the list of all views.
            if CQLMeasureHelpers.isStatementFunction(library, statement.define_name)
              # Function statements don't show results
              statementView = new Thorax.Views.CqlStatement(statement: statement, libraryName: library.library_name, highlightPatientDataEnabled: @highlightPatientDataEnabled, cqlPopulations: popNames, logicView: @)
            else
              statementView = new Thorax.Views.CqlResultStatement(statement: statement, libraryName: library.library_name, highlightPatientDataEnabled: @highlightPatientDataEnabled, cqlPopulations: popNames, logicView: @)
              @allStatementResultViews.push statementView
            @allStatementViews.push statementView

            # figure out which section of the page it belongs in and add it to the proper list.
            if popNames.length > 0
              @populationStatementViews.push statementView   # if it is a population defining statement.
            else if CQLMeasureHelpers.isStatementFunction(library, statement.define_name)
              @functionStatementViews.push statementView   # if it is a function
            else if CQLMeasureHelpers.isSupplementalDataElementStatement(@population.get('supplemental_data_elements'), statement.define_name)
              # only display SDEs if calculate_sdes flag set
              if @cqmMeasure.calculate_sdes
                @supplementalDataElementViews.push statementView
            else if !@population? || @statementRelevance[library.library_name][statement.define_name] == 'TRUE'
              @defineStatementViews.push statementView   # if it is a plain old supporting define
            else
              @unusedStatementViews.push statementView   # otherwise it is a statement that isn't relevant

      # Sort the population statements
      @populationStatementViews.sort(@_statementComparator)
    # Since we dont have elm_annotations we should mark this as an outdated upload. Do not create any statement views.
    else
      @isOutdatedUpload = true

  ###*
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
