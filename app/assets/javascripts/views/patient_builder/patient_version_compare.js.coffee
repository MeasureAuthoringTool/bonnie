class Thorax.Views.PatientBuilderCompare extends Thorax.Views.BonnieView
  className: 'patient-compare'

  template: JST['patient_builder/patient_version_compare']

  options:
    serialize: { children: false }
    populate: { context: true, children: false }

  initialize: =>
    @patientResultsSummary = @uploadSummary.get('population_set_summaries')[@measure.get('displayedPopulation').get('index')].patients[@model.id]

    # @postUploadMeasureVersion and @preUploadMeasureVersion are parameters used when comparing
    # patient calculation snapshots.
    # when comparing snapshots, 
    if @preUploadMeasureVersion
      @compareSnapshots = true
      populationToShow = @preUploadMeasureVersion.get('populations').at(@measure.get('displayedPopulation').get('index'))
      if !@patientResultsSummary.results_exceeds_storage_pre_upload
        rationaleToShow = @patientResultsSummary.pre_upload_results.rationale
    else
      @compareSnapshots = false
      populationToShow = @measure.get('displayedPopulation')
      if !@patientResultsSummary.results_exceeds_storage_post_upload
        rationaleToShow = @patientResultsSummary.post_upload_results.rationale

    if rationaleToShow isnt undefined
      @cachedBeforeResult = new Thorax.Models.CachedResult({
        rationale: rationaleToShow
        finalSpecifics: @patientResultsSummary.pre_upload_results.finalSpecifics}
        , {
          population: populationToShow
          patient: @model
        }
      )
      @populationLogicViewBefore = new Thorax.Views.ComparePopulationLogic(isCompareView: true)
      @populationLogicViewBefore.setPopulation @cachedBeforeResult.population
      @populationLogicViewBefore.showRationale @cachedBeforeResult
    else
      @preUploadResultsSizeTooBig = true

    if @postUploadMeasureVersion is undefined || @measure.id == @postUploadMeasureVersion.id
      @populationLogicViewAfter = new Thorax.Views.BuilderPopulationLogic(isCompareView: true)
      @populationLogicViewAfter.setPopulation @measure.get('displayedPopulation')
      @populationLogicViewAfter.showRationale @model
      @populationPresentAfterUpload = true
    else if @patientResultsSummary.post_upload_results? # is not undefined
      @cachedAfterResult = new Thorax.Models.CachedResult({
        rationale: @patientResultsSummary.post_upload_results.rationale
        finalSpecifics: @patientResultsSummary.post_upload_results.finalSpecifics}
        , {
          population: @postUploadMeasureVersion.get('displayedPopulation')
          patient: @model
        }
      )
      @populationLogicViewAfter = new Thorax.Views.ComparePopulationLogic
      @populationLogicViewAfter.setPopulation @postUploadMeasureVersion.get('displayedPopulation')
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
