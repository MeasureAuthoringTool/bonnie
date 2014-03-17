class Thorax.Views.PopulationsLogic extends Thorax.LayoutView
  template: JST['logic/layout']
  switchPopulation: (e) ->
    population = $(e.target).model()
    @setView new Thorax.Views.PopulationLogic(model: population)
    @trigger 'population:update', population
  showRationale: (result) -> @getView().showRationale(result)
  clearRationale: -> @getView().clearRationale()
  showCoverage: -> @getView().showCoverage()
  clearCoverage: -> @getView().clearCoverage()
  populationContext: (population) ->
    _(population.toJSON()).extend isActive: population is @collection.first()

class Thorax.Views.PopulationLogic extends Thorax.View

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
          for key, value of rationale
            target = @$(".#{code}_children .#{key}")
            if (target.length > 0)
              target.addClass(if updatedRationale[code]?[key] is false then 'eval-bad-specifics' else "eval-#{!!value}")
              target.closest('.panel-heading').addClass(if updatedRationale[code]?[key] is false then 'eval-panel-bad-specifics' else "eval-panel-#{!!value}")
    @expandPopulations()

  highlightPatientData: (dataCriteriaKey, populationCriteriaKey) ->
    if @latestResult?.get('finalSpecifics')?[populationCriteriaKey]
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

  showCoverage: ->
    @clearRationale()
    for criteria in @model.coverage().rationaleCriteria
      @$(".#{criteria}").addClass('eval-coverage')
      @$("rect[precondition=\"#{criteria}\"]").css('stroke','#006cb4').css('fill','#daeaf5') # FIXME: replace with classes, if possible

  clearCoverage: ->
    @$('.rationale .rationale-target').removeClass('eval-coverage')

  expandPopulations: ->
    @$('.panel-population > a[data-toggle="collapse"]').removeClass('collapsed')
    @$('.toggle-icon').removeClass('fa-angle-right').addClass('fa-angle-down')
    @$('.panel-collapse').removeClass('collapse').addClass('in').css('height','auto')
