class Thorax.Views.CqlPopulationsLogic extends Thorax.LayoutView

  template: JST['logic/cql_layout']

  events:
    "ready": ->

  initialize: ->
    @switchToGivenPopulation(@model.get('populations').models[0])

  switchPopulation: (e) ->
    population = $(e.target).model()
    @switchToGivenPopulation(population)

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

  # List of statements added by the MAT that are not useful to the user.
  @SKIP_STATEMENTS = ["SDE Ethnicity", "SDE Payer", "SDE Race", "SDE Sex"]

  events:
    "ready": ->

  ###*
  # Initializes the view. Creates the CqlStatement views.
  # Expects model to be a Measure model object of a CQL measure.
  ###
  initialize: ->
    @isOutdatedUpload = false
    @statementViews = []
    _.each @model.get('elm')?.library.statements?.def, (statement) =>
      if statement.annotation

        # Check to see if this measure was uploaded with an older version of the translation service that had clause level
        # annotations enabled. This checks if the first annotation is just the define keyword and its delimiting space.
        # TODO: Update this check as needed. Remove these checks when CQL has settled for production.
        if (statement.annotation[0]?.s.value[0] == "define ")
          @isOutdatedUpload = true  # if the annotation only has "define" then this measure upload may be out of date.

        # skip if this is a statement the user doesn't need to see
        return if Thorax.Views.CqlPopulationLogic.SKIP_STATEMENTS.includes(statement.name)

        popNames = []
        # if a population (population set) was provided for this view it should mark the statment if it is a population defining statement  
        if @population
          for pop, popStatements of @model.get('populations_cql_map')
            index = @population.get('index')
            # The STRAT populations array does not contain the population data criteria object, which causes
            # an off by one mismatch between the populations cql map and the popStatements[STRAT] array
            popNames.push(pop) if statement.name == popStatements[@population.get('index')]  # note that there may be multiple populations that it defines
            index = @population.get('index')
            # If displaying a stratification, we need to set the index to the associated populationCriteria
            # that the stratification is on so that the correct (IPOP, DENOM, NUMER..) are retrieved
            index = @population.get('population_index') if @population.get('stratification')?
            # If retrieving the STRAT, set the index to the correct STRAT in the cql_map
            index = @population.get('stratification_index') if pop == "STRAT" && @population.get('stratification')?
            popNames.push(pop) if statement.name == popStatements[index]  # note that there may be multiple populations that it defines
          if popNames.length > 0
            popName = popNames.join(', ')

        @statementViews.push new Thorax.Views.CqlStatement(statement: statement, highlightPatientDataEnabled: @highlightPatientDataEnabled, cqlPopulation: popName)

  ###*
  # Shows the coverage information.
  ###
  showCoverage: ->
    @clearRationale()

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
    for statementView in @statementViews
      statementView.showRationale result.get('statement_results')[statementView.name]

  ###*
  # Clears the rationale hightlighting on all CqlStatement views.
  ###
  clearRationale: ->
    for statementView in @statementViews
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
