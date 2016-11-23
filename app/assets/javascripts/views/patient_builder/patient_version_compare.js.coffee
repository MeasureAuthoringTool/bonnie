class Thorax.Views.PatientBuilderCompare extends Thorax.Views.BonnieView
  className: 'patient-compare'

  template: JST['patient_builder/patient_version_compare']

  options:
    serialize: { children: false }
    populate: { context: true, children: false }

  initialize: =>
    @patient = @mostRecentUploadSummary.get('population_set_summaries')[@measure.get('displayedPopulation').get('index')].patients[@model.id]

    # @postuploadmeasureversion and @preuploadmeasureversion are parameters when viewing the comparsion from the the measure page
    # When they are not present it means that the comparison has been called from patient builder
    if @postuploadmeasureversion is undefined && @preuploadmeasureversion is undefined
      @fromPatientBuilder = true
      populationToShow = @measure.get('displayedPopulation')
      if !@patient.results_exceeds_storage_post_upload
        rationaleToShow = @patient.post_upload_results.rationale
    else
      populationToShow = @preuploadmeasureversion.get('populations').at(@measure.get('displayedPopulation').get('index'))
      if !@patient.results_exceeds_storage_pre_upload
        rationaleToShow = @patient.pre_upload_results.rationale

    if rationaleToShow isnt undefined
      @cachedBeforeResult = new Thorax.Models.CachedResult({
        rationale: rationaleToShow
        finalSpecifics: @patient.pre_upload_results.finalSpecifics}
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

    if @postuploadmeasureversion is undefined || @measure.id == @postuploadmeasureversion.id
      @populationLogicViewAfter = new Thorax.Views.BuilderPopulationLogic(isCompareView: true)
      @populationLogicViewAfter.setPopulation @measure.get('displayedPopulation')
      @populationLogicViewAfter.showRationale @model
      @populationPresentAfterUpload = true
    else if @patient.post_upload_results? # is not undefined
      @cachedAfterResult = new Thorax.Models.CachedResult({
        rationale: @patient.post_upload_results.rationale
        finalSpecifics: @patient.post_upload_results.finalSpecifics}
        , {
          population: @postuploadmeasureversion.get('displayedPopulation')
          patient: @model
        }
      )
      @populationLogicViewAfter = new Thorax.Views.ComparePopulationLogic
      @populationLogicViewAfter.setPopulation @postuploadmeasureversion.get('displayedPopulation')
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
