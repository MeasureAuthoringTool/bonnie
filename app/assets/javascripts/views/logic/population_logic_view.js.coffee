class Thorax.Views.PopulationsLogic extends Thorax.LayoutView
  template: JST['logic/layout']
  switchPopulation: (e) ->
    population = $(e.target).model()
    @setView new Thorax.Views.PopulationLogic(model: population)
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
      dataCriteriaMap: measure.get 'data_criteria'
      sourceDataCriteria: measure.get 'source_data_criteria'

  showRationale: (result) ->
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
            target.addClass(if updatedRationale[code][key] is false then 'bad_specifics' else "#{!!value}_eval")

  clearRationale: ->
    @$('.rationale .rationale_target').removeClass('false_eval true_eval bad_specifics')
