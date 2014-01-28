class Thorax.Views.PopulationsLogic extends Thorax.LayoutView
  template: JST['logic/layout']
  switchPopulation: (e) ->
    population = $(e.target).model()
    @setView new Thorax.Views.PopulationLogic(model: population)
    @trigger 'population:update', population
  showRationale: (result) -> @getView().showRationale(result)
  clearRationale: -> @getView().clearRationale()
  populationContext: (population) ->
    _(population.toJSON()).extend isActive: population is @collection.first()

class Thorax.Views.PopulationLogic extends Thorax.View

  template: JST['logic/logic']

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
  events:
    rendered: ->
      @$('.highlight-target').mouseover(_.bind(@highlightEntry, this))
      @$('.highlight-target').mouseout(_.bind(@clearHighlightEntry, this))

  highlightEntry: (e) ->
    return unless $(e.target).hasClass('highlight-target')
    view = $(e.target).view()
    dataCriteriaKey = view?.dataCriteria?.key
    populationCriteriaKey = view.populationCriteriaKey?()
    @latestResult.highlightPatientData(dataCriteriaKey, populationCriteriaKey) if @latestResult

  clearHighlightEntry: (e) ->
    # picked up by PatientBuilder
    @latestResult.patient.trigger 'clearHighlight'

  clearRationale: ->
    @$('.rationale .rationale-target').removeClass('eval-false eval-true eval-bad-specifics')
