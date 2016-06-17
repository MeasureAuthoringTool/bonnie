class Thorax.Views.PatientBuilderCompare extends Thorax.Views.BonnieView
  className: 'patient-compare'

  template: JST['patient_builder/patient_version_compare']

  options:
    serialize: { children: false }
    populate: { context: true, children: false }

  initialize: ->
    # TODO: need to handle scenario where current patient wasn't part of last upload
    @thePatient = @latestupsum.get('measure_upload_population_summaries')[@measure.get('displayedPopulation').get('index')].patients[@model.id]
    
    @cachedresult = new Thorax.Models.CachedResult({
      rationale: @thePatient.before.rationale
      finalSpecifics: @thePatient.before.finalSpecifics}
      , {
        population: @beforemeasure.get('displayedPopulation')
        patient: @model
      }
    )
    
    @populationLogicViewBefore = new Thorax.Views.ComparePopulationLogic
    @populationLogicViewBefore.setPopulation @beforemeasure.get('displayedPopulation')
    @populationLogicViewBefore.showRationale @cachedresult

    @populationLogicViewAfter = new Thorax.Views.BuilderPopulationLogic
    @populationLogicViewAfter.setPopulation @measure.get('displayedPopulation')
    @populationLogicViewAfter.showRationale @model
    
# Modified Thorax.Views.BuilderPopulationLogic that accepts new Thorax.Models.CachedResult
class Thorax.Views.ComparePopulationLogic extends Thorax.LayoutView
  template: JST['patient_builder/population_logic']
  setPopulation: (population) ->
    population.measure().set('displayedPopulation', population)
    @setModel(population)
    @setView new Thorax.Views.PopulationLogic(model: population)
  showRationale: (result) ->
    @getView().showRationale(result)
  context: ->
    _(super).extend
      title: if @model.collection.parent.get('populations').length > 1 then (@model.get('title') || @model.get('sub_id')) else ''
      cms_id: @model.collection.parent.get('cms_id')
