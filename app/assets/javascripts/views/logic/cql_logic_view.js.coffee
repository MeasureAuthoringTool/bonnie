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

    _.each @model.get('elm_annotations')?.statements, (statement) =>


      # skip if this is a statement the user doesn't need to see
      return if Thorax.Views.CqlPopulationLogic.SKIP_STATEMENTS.includes(statement.define_name)
      return unless statement.define_name?
      popNames = []
      # if a population (population set) was provided for this view it should mark the statment if it is a population defining statement  
      if @population
        for pop, popStatements of @model.get('populations_cql_map')
          index = @population.get('index')
          # If displaying a stratification, we need to set the index to the associated populationCriteria
          # that the stratification is on so that the correct (IPOP, DENOM, NUMER..) are retrieved
          index = @population.get('population_index') if @population.get('stratification')?
          # If retrieving the STRAT, set the index to the correct STRAT in the cql_map
          index = @population.get('stratification_index') if pop == "STRAT" && @population.get('stratification')?
          # There may be multiple populations that it defines. Only push population name if @population has a pop ie: not all populations will have STRAT
          popNames.push(pop) if statement.define_name == popStatements[index] && @population.get(pop)?
        if popNames.length > 0
          popName = popNames.join(', ')
        @statementViews.push new Thorax.Views.CqlStatement(statement: statement, highlightPatientDataEnabled: @highlightPatientDataEnabled, cqlPopulation: popName)
    
    # TODO: This should be changed when we move to production.
    # We need this if statement to support the old version of cql measure that didn't have ELM in an array.
    if Array.isArray @model.get('elm')
      _.each @model.get('elm'), (elm) =>
        _.each elm.library.statements?.def, (statement) =>
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
                # If displaying a stratification, we need to set the index to the associated populationCriteria
                # that the stratification is on so that the correct (IPOP, DENOM, NUMER..) are retrieved
                index = @population.get('population_index') if @population.get('stratification')?
                # If retrieving the STRAT, set the index to the correct STRAT in the cql_map
                index = @population.get('stratification_index') if pop == "STRAT" && @population.get('stratification')?
                # There may be multiple populations that it defines. Only push population name if @population has a pop ie: not all populations will have STRAT
                popNames.push(pop) if statement.name == popStatements[index] && @population.get(pop)?
              if popNames.length > 0
                popName = popNames.join(', ')

            @statementViews.push new Thorax.Views.CqlStatement(statement: statement, highlightPatientDataEnabled: @highlightPatientDataEnabled, cqlPopulation: popName)
    else
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
              # If displaying a stratification, we need to set the index to the associated populationCriteria
              # that the stratification is on so that the correct (IPOP, DENOM, NUMER..) are retrieved
              index = @population.get('population_index') if @population.get('stratification')?
              # If retrieving the STRAT, set the index to the correct STRAT in the cql_map
              index = @population.get('stratification_index') if pop == "STRAT" && @population.get('stratification')?
              # There may be multiple populations that it defines. Only push population name if @population has a pop ie: not all populations will have STRAT
              popNames.push(pop) if statement.name == popStatements[index] && @population.get(pop)?
            if popNames.length > 0
              popName = popNames.join(', ')

          @statementViews.push new Thorax.Views.CqlStatement(statement: statement, highlightPatientDataEnabled: @highlightPatientDataEnabled, cqlPopulation: popName)

>>>>>>> cql4bonnie

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
    showResultsMap = @_makePopulationResultShownMap result
    for statementView in @statementViews
      # check to see if highlighting should be supressed because "not calculated"
      popName = statementView.cqlPopulation?.split(', ')[0]
      showHighlighting = if showResultsMap[popName]? then showResultsMap[popName] else true
      
      statementView.showRationale(result.get('line_id_results'), showHighlighting)

  ###*
  # Make a map of population to boolean of if the result of the define statement result should be shown or not. This is
  # what determines if we don't highlight the statements that are "not calculated".
  # TODO: This is stop gap solution, should be moved to the calculator.
  # @private
  # @param {Result} result = The result object from the calculator.
  ###
  _makePopulationResultShownMap: (result) ->
    # initialize to true for every population
    resultShown = {}
    _.each(_.without(result.keys(), 'statement_results', 'patient_id'), (population) -> resultShown[population] = true)

    # If STRAT is 0 then everything else is not calculated
    if result.get('STRAT')? && result.get('STRAT') == 0
      resultShown.IPP = false if resultShown.IPP?
      resultShown.NUMER = false if resultShown.NUMER?
      resultShown.NUMEX = false if resultShown.NUMEX?
      resultShown.DENOM = false if resultShown.DENOM?
      resultShown.DENEX = false if resultShown.DENEX?
      resultShown.DENEXCEP = false if resultShown.DENEXCEP?

    # If IPP is 0 then everything else is not calculated
    if result.get('IPP') == 0
      resultShown.NUMER = false if resultShown.NUMER?
      resultShown.NUMEX = false if resultShown.NUMEX?
      resultShown.DENOM = false if resultShown.DENOM?
      resultShown.DENEX = false if resultShown.DENEX?
      resultShown.DENEXCEP = false if resultShown.DENEXCEP?

    # If DENOM is 0 then DENEX, DENEXCEP, NUMER and NUMEX are not calculated
    if result.get('DENOM')? && result.get('DENOM') == 0
      resultShown.NUMER = false if resultShown.NUMER?
      resultShown.NUMEX = false if resultShown.NUMEX?
      resultShown.DENEX = false if resultShown.DENEX?
      resultShown.DENEXCEP = false if resultShown.DENEXCEP?

    # If DENEX is 1 then NUMER, NUMEX and DENEXCEP not calculated
    if result.get('DENEX')? && result.get('DENEX') >= 1
      resultShown.NUMER = false if resultShown.NUMER?
      resultShown.NUMEX = false if resultShown.NUMEX?
      resultShown.DENEXCEP = false if resultShown.DENEXCEP?

    # If NUMER is 0 then NUMEX is not calculated
    if result.get('NUMER')? && result.get('NUMER') == 0
      resultShown.NUMEX = false if resultShown.NUMEX?

    # If NUMER is 1 then DENEXCEP is not calculated
    if result.get('NUMER')? && result.get('NUMER') >= 1
      resultShown.DENEXCEP = false if resultShown.DENEXCEP?

    return resultShown

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
