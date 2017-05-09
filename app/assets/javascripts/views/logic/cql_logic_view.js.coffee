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
    @statementViews = []
    _.each @model.get('elm').library.statements.def, (statement) =>
      if (statement.annotation)
        if (statement.annotation[0].s.value[0] == "define ")
          @isOutdatedUpload = true  # if the annotation only has "define" then this measure upload may be out of date.
        @statementViews.push new Thorax.Views.CqlStatement(statement: statement, highlightPatientDataEnabled: @highlightPatientDataEnabled)

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

###*
# View representing a CQL statement (aka. define).
###
class Thorax.Views.CqlStatement extends Thorax.Views.BonnieView
  template: JST['logic/cql_statement']

  events:
    'mouseover code': 'highlightEntry'
    'mouseout code': 'clearHighlightEntry'

  ###*
  # Initializes the CqlStatement view. Expects statement to be the JSON ELM statement that should be shown.
  # highlightPatientDataEnabled can optionally be set to true when constructing to turn on the highlighing patient 
  # data functionality.
  ###
  initialize: ->
    @text = @statement.annotation[0].s.value[0]
    @name = @statement.name

  ###*
  # Show the results of this statement's calculation by highlighing appropiately. 
  # @param {boolean|Object[]} result - The result for this statement. May be a boolean or an array of entries.
  ###
  showRationale: (result) ->
    @latestResult = result

    if result == true  # Specifically a boolean true
      @_setResult true
    else if result == false  # Specifically a boolean false
      @_setResult false
    else if Array.isArray(result)  # Check if result is an array
      @_setResult result.length > 0  # Result is true if the array is not empty
    else
      @clearRationale()  # Clear the rationale if we can't make sense of the result

  ###*
  # Modifies the class attribute of the code element to highlight the result.
  # @private
  # @param {boolean} evalResult - The result that should be shown.
  ###
  _setResult: (evalResult) ->
    if evalResult == true
      @$('code').attr('class', 'eval-true')
    else
      @$('code').attr('class', 'eval-false')

  ###*
  # Clear the result for this statement.
  ###
  clearRationale: ->
    @latestResult = null
    @$('code').attr('class', '')

  ###*
  # Event handler for the mouseover event. This will report to the CqlPopulationLogic view with the ids of the patient
  # data elements that should be highlighted.
  ###
  highlightEntry: ->
    # only highlight entries if highlighting is enabled and there are results in the form of an array.
    if @highlightPatientDataEnabled == true && Array.isArray(@latestResult) && @latestResult.length > 0
      dataCriteriaIDs = []
      for resultEntry in @latestResult
        if resultEntry.entry  # if the result is an entry then grab the id so it can be highlighted
          dataCriteriaIDs.push(resultEntry.entry._id)
      @parent?.highlightPatientData(dataCriteriaIDs)  # report the id of the data criteria to be highlighted to the CqlPopulationLogic view.

  ###*
  # Event handler for the mouseout event. This will report to the CqlPopulationLogic view that highlighting should be cleared.
  ###
  clearHighlightEntry: ->
    if @highlightPatientDataEnabled == true
      @parent?.clearHighlightPatientData()
