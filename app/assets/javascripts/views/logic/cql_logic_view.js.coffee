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

  events:
    "ready": ->

  ###*
  # Initializes the view. Creates the CqlStatement views.
  # Expects model to be a Measure model object of a CQL measure.
  ###
  initialize: ->
    @isOutdatedUpload = false
    @hasCqlErrors = false
    @statementViews = []
    
    # Look through all elm library structures, and check for CQL errors noted by the translation service.
    if Array.isArray @model.get('elm')
      _.each @model.get('elm'), (elm, elm_index) =>
        _.each elm.library.annotation, (annotation) =>
          if (annotation.errorSeverity == "error")
            @hasCqlErrors = true

    # Check to see if this measure was uploaded with an older version of the loader code that did not get the 
    # clause level annotations.
    # TODO: Update this check as needed. Remove these checks when CQL has settled for production.
    if @model.get('elm_annotations')?
      for libraryName, annotationLibrary of @model.get('elm_annotations')
        for statement in annotationLibrary.statements
          # skip if this is a statement the user doesn't need to see
          if !Thorax.Models.Measure.cqlSkipStatements.includes(statement.define_name) && statement.define_name?
            popNames = []
            popName = null
            # if a population (population set) was provided for this view it should mark the statment if it is a population defining statement  
            if @population
              for pop, popStatements of @model.get('populations_cql_map')
                index = @population.getPopIndexFromPopName(pop)
                # There may be multiple populations that it defines. Only push population name if @population has a pop ie: not all populations will have STRAT
                popNames.push(pop) if statement.define_name == popStatements[index] && @population.get(pop)?

              # Mark if it is in an OBSERV if there are any and we are looking at the main_cql_library
              if @model.get('observations')? && libraryName == @model.get('main_cql_library')
                for observ, observIndex in @model.get('observations')
                  popNames.push("OBSERV_#{observIndex+1}") if statement.define_name == observ.function_name

              if popNames.length > 0
                popName = popNames.join(', ')
            @statementViews.push new Thorax.Views.CqlStatement(statement: statement, libraryName: libraryName, highlightPatientDataEnabled: @highlightPatientDataEnabled, cqlPopulation: popName, logicView: @)

    # Since we dont have elm_annotations we should mark this as an outdated upload. Do not create any statement views.
    else
      @isOutdatedUpload = true

  ###*
  # Shows the coverage information.
  ###
  showCoverage: ->
    @clearRationale()
    rationaleCriteria = @population.coverage().rationaleCriteria
    # If there are no patients, there will be no rationaleCriteria and therefore no coverage
    if rationaleCriteria?
      for statementView in @statementViews
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
    for statementView in @statementViews
      # Do not attempt to show pass/fail for a clause that does not exist possibly due to a calculation error
      if result.get('clause_results')? && result.get('clause_results')[statementView.libraryName]?
        statementView.showRationale(result.get('clause_results')[statementView.libraryName])

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
