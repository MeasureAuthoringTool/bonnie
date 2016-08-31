class Thorax.Views.PopulationsLogic extends Thorax.LayoutView
  template: JST['logic/layout']
  switchPopulation: (e) ->
    population = $(e.target).model()
    population.measure().set('displayedPopulation', population)
    @setView new Thorax.Views.PopulationLogic(model: population, suppressDataCriteriaHighlight: @suppressDataCriteriaHighlight)
    @trigger 'population:update', population
  showRationale: (result) -> @getView().showRationale(result)
  clearRationale: -> @getView().clearRationale()
  showCoverage: -> @getView().showCoverage()
  clearCoverage: -> @getView().clearCoverage()
  showSelectCoverage: (rationaleCriteria) -> @getView().showSelectCoverage(rationaleCriteria)
  populationContext: (population) ->
    _(population.toJSON()).extend
      isActive:  population is population.measure().get('displayedPopulation')
      populationTitle: population.get('title') || population.get('sub_id')

class Thorax.Views.PopulationLogic extends Thorax.Views.BonnieView

  template: JST['logic/logic']

  events:
    rendered: -> @showCoverage()

  initialize: ->
    @submeasurePopulations = []
    for code in Thorax.Models.Measure.allPopulationCodes
      match = @model.get code
      @submeasurePopulations.push(match) if match

  context: ->
    measure = @model.collection.parent
    _(super).extend
      measure: measure

  showRationale: (result) ->
    # Only show the rationale once the result is populated
    result.calculation.done =>
      @latestResult = result
      rationale = result.get('rationale')
      @clearCoverage()
      @clearRationale()
      # rationale only handles the logical true/false values
      # we need to go in and modify the highlighting based on the final specific contexts for each population
      updatedRationale = result.specificsRationale()
      for code in Thorax.Models.Measure.allPopulationCodes
        if rationale[code]?
          # if we are highlighting exceptions, have a numerator but don't qualify for the exceptions, then do not hightlight
          # even if we are in the numerator we have to highlight if we are in the exceptions because we could be in both for EoC
          if !(code == 'DENEXCEP' && result.get('NUMER') && !result.get(code))
            @showRationaleForPopulation(code, rationale, updatedRationale)
      @showRationaleForPopulation('variables', rationale, updatedRationale)

  # This is the code for managing the logic highlighting
  showRationaleForPopulation: (code, rationale, updatedRationale) ->
    for key, value of rationale
      target = @$(".#{code}_children .#{key}")
      targettext = @$(".#{code}_children .#{key}") #text version of logic
      targetrect = @$("rect[precondition=#{key}]") #viz version of logic (svg)
      if (targettext.length > 0)

        [targetClass, targetPanelClass, srTitle] = if updatedRationale[code]?[key] is false
          ['eval-bad-specifics', 'eval-panel-bad-specifics', '(status: bad specifics)']
        else
          bool = !!value
          ["eval-#{bool}", "eval-panel-#{bool}", "(status: #{bool})"]

        targetrect.attr "class", (index, classNames) -> "#{classNames} #{targetClass}" #add styling to svg without removing all the other classes

        targettext.addClass(targetClass)  # This does the actually application of the highlighting to the target
        targettext.closest('.panel-heading').addClass(targetPanelClass)
        targettext.children('.sr-highlight-status').html(srTitle)
        # this second line is there to fix an issue with sr-only in Chrome making text in inline elements not display
        # by having the sr-only span and the DC title wrapped in a criteria-title span, the odd behavior goes away.
        targettext.children('.criteria-title').children('.sr-highlight-status').html(srTitle)

  highlightPatientData: (dataCriteriaKey, populationCriteriaKey) ->
    isVariablePopulation = (populationCriteriaKey == 'VAR')
    # VARiables don't have a specific occurrence so we are letting it through; i.e. we aren't going to look for an entry in finalSpecifics
    if @latestResult?.get('finalSpecifics')?[populationCriteriaKey] || isVariablePopulation
      matchingCodedEntries = @latestResult.codedEntriesForDataCriteria(dataCriteriaKey)
      if matchingCodedEntries
        goodElements = @latestResult.codedEntriesPassingSpecifics(dataCriteriaKey, populationCriteriaKey)
        partial = Thorax.Views.EditCriteriaView.highlight.partial
        valid = Thorax.Views.EditCriteriaView.highlight.valid
        for codedEntry in matchingCodedEntries
          type = (if goodElements?.indexOf(codedEntry.id) < 0 then partial else valid)
          # picked up by EditCriteriaView
          for sourceDataCriterium in @latestResult.patient.get('source_data_criteria').models
            if sourceDataCriterium.get('coded_entry_id') == codedEntry.id
              sourceDataCriterium.trigger 'highlight', type

  clearHighlightPatientData: ->
    # picked up by PatientBuilder
    @latestResult?.patient.trigger 'clearHighlight'

  clearRationale: ->
    @$('.rationale .rationale-target').removeClass('eval-false eval-true eval-bad-specifics')
    @$('.rationale .panel-heading').removeClass('eval-panel-false eval-panel-true eval-panel-bad-specifics')
    @$('.sr-highlight-status').empty()
    @$("rect").attr 'class', (index, classNames) ->
      classNames.replace('eval-true','').replace('eval-false','').replace('eval-bad-specifics','')

  showCoverage: ->
    @clearRationale()
    for criteria in @model.coverage().rationaleCriteria
      @$(".#{criteria}").addClass('eval-coverage')
      @$("rect[precondition=\"#{criteria}\"]").attr 'class', (index, classNames) -> "#{classNames} coverage"
    @coverageScreenReaderStatus()

  showSelectCoverage: (rationaleCriteria) ->
    @clearCoverage()
    @clearRationale()
    for criteria in rationaleCriteria
      @$(".#{criteria}").addClass('eval-coverage')
      @$("rect[precondition=\"#{criteria}\"]").attr 'class', (index, classNames) -> "#{classNames} coverage"
    @coverageScreenReaderStatus()

  coverageScreenReaderStatus: ->
    @$('.rationale .rationale-target').find('.sr-highlight-status').html('(status: not covered)')
    @$('.eval-coverage').children('.sr-highlight-status').html('(status: covered)')
    @$('.eval-coverage').children('.criteria-title').children('.sr-highlight-status').html('(status: covered)')
    @$('.conjunction').children('.sr-highlight-status').empty()
    @$('.population-label').children('.sr-highlight-status').empty()

  clearCoverage: ->
    if @$('.eval-coverage').length > 0
      @$('.rationale .rationale-target').removeClass('eval-coverage')
      @$('.sr-highlight-status').empty()
      @$("rect").attr 'class', (index, classNames) -> classNames.replace('coverage','')
