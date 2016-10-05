class Thorax.Views.PatientBuilderCompare extends Thorax.Views.BonnieView
  className: 'patient-compare'

  template: JST['patient_builder/patient_version_compare']

  options:
    serialize: { children: false }
    populate: { context: true, children: false }

  initialize: ->
    @selectedPopulation = @measure.get('displayedPopulation').get('index')
    @thePatient = @latestupsum.get('population_summaries')[@measure.get('displayedPopulation').get('index')].patients[@model.id]

    if @viaRoute == "fromEdit"
      @fromEdit = true
      if !@thePatient.after_too_big
        if @thePatient.after?
          @populationPresentBeforeUpload = true
          @cachedBeforeResult = new Thorax.Models.CachedResult({
            rationale: @thePatient.after.rationale
            finalSpecifics: @thePatient.after.finalSpecifics}
            , {
              population: @measure.get('displayedPopulation')
              patient: @model
            }
          )
          @populationLogicViewBefore = new Thorax.Views.ComparePopulationLogic(isCompareView: true)
          @populationLogicViewBefore.setPopulation @cachedBeforeResult.population
          @populationLogicViewBefore.showRationale @cachedBeforeResult
        else
          @populationPresentBeforeUpload = false
      else
        @beforeTooBig = true
      

    if @viaRoute == "fromTimeline"
      if !@thePatient.before_too_big
        if @beforemeasure.get('populations').at(@selectedPopulation)
          @populationPresentBeforeUpload = true
          @cachedBeforeResult = new Thorax.Models.CachedResult({
            rationale: @thePatient.before.rationale
            finalSpecifics: @thePatient.before.finalSpecifics}
            , {
              population: @beforemeasure.get('populations').at(@selectedPopulation)
              patient: @model
            }
          )
          
          @populationLogicViewBefore = new Thorax.Views.ComparePopulationLogic(isCompareView: true)
          @populationLogicViewBefore.setPopulation @cachedBeforeResult.population
          @populationLogicViewBefore.showRationale @cachedBeforeResult
        else
          @populationPresentBeforeUpload = false
      else
        @beforeTooBig = true

    if @aftermeasure is undefined || @measure.id == @aftermeasure.id
      @populationLogicViewAfter = new Thorax.Views.BuilderPopulationLogic(isCompareView: true)
      @populationLogicViewAfter.setPopulation @measure.get('displayedPopulation')
      @populationLogicViewAfter.showRationale @model
      @populationPresentAfterUpload = true
    else if @thePatient.after? # is not undefined
      @cachedAfterResult = new Thorax.Models.CachedResult({
        rationale: @thePatient.after.rationale
        finalSpecifics: @thePatient.after.finalSpecifics}
        , {
          population: @aftermeasure.get('displayedPopulation')
          patient: @model
        }
      )
      @populationLogicViewAfter = new Thorax.Views.ComparePopulationLogic
      @populationLogicViewAfter.setPopulation @aftermeasure.get('displayedPopulation')
      @populationLogicViewAfter.showRationale @cachedAfterResult
      @populationPresentAfterUpload = true
    else
      @populationPresentAfterUpload = false

    @render()  
  
# Modified Thorax.Views.BuilderPopulationLogic that accepts new Thorax.Models.cachedResult
class Thorax.Views.ComparePopulationLogic extends Thorax.LayoutView
  template: JST['patient_builder/population_logic']
  # This view will take a arguement of isCompareView (boolean) that when true will disable the scrolling arrows.
  setPopulation: (population) ->
    population.measure().set('displayedPopulation', population)
    @setModel(population)
    @setView new Thorax.Views.PopulationLogic(model: population, suppressDataCriteriaHighlight: true)
  showRationale: (result) ->
    @getView().showRationale(result)
  context: ->
    _(super).extend
      title: if @model.collection.parent.get('populations').length > 1 then (@model.get('title') || @model.get('sub_id')) else ''
      cms_id: @model.collection.parent.get('cms_id')
