class Thorax.Views.PatientBuilderCompare extends Thorax.Views.BonnieView
  className: 'patient-compare'

  template: JST['patient_builder/patient_version_compare']

  options:
    serialize: { children: false }
    populate: { context: true, children: false }

  initialize: =>
    @patientResultsSummary = @uploadSummary.get('population_set_summaries')[@measure.get('displayedPopulation').get('index')].patients[@model.id]

    # when comparing snapshots, the "before" is the "pre-upload".
    # when comparing against the most recent patient data, the "before" is the "post-upload"
    if @preUploadMeasureVersion
      @compareSnapshots = true

      # get the information for the "before" view
      beforePopulationSet = @preUploadMeasureVersion.get('displayedPopulation')
      if !@patientResultsSummary.results_exceeds_storage_pre_upload
        beforeRationale = @patientResultsSummary.pre_upload_results.rationale
        beforeFinalSpecifics = @patientResultsSummary.pre_upload_results.finalSpecifics

      # get the information for the "after" view
      if @postUploadMeasureVersion
        afterPopulationSet = @postUploadMeasureVersion.get('displayedPopulation')
      else
        # if the postUploadMeasureVersion doesn't exist, we are comparing against the most
        # recently uploaded measure snapshot
        afterPopulationSet = @measure.get('displayedPopulation')
      if !@patientResultsSummary.results_exceeds_storage_post_upload
        afterRationale = @patientResultsSummary.post_upload_results.rationale
        afterFinalSpecifics = @patientResultsSummary.post_upload_results.finalSpecifics

    else
      @compareSnapshots = false

      # get the information for the "before" view
      beforePopulationSet = @measure.get('displayedPopulation')
      if !@patientResultsSummary.results_exceeds_storage_post_upload
        beforeRationale = @patientResultsSummary.post_upload_results.rationale
        beforeFinalSpecifics = @patientResultsSummary.post_upload_results.finalSpecifics

      # don't need extra information for "after" view

    # setup views

    if beforeRationale
      @cachedBeforeResult = new Thorax.Models.CachedResult({
        rationale: beforeRationale
        finalSpecifics: beforeFinalSpecifics
      } , {
          population: beforePopulationSet
          patient: @model
        }
      )
      @populationLogicViewBefore = new Thorax.Views.ComparePopulationLogic(isCompareView: true)
      @populationLogicViewBefore.setPopulation @cachedBeforeResult.population
      @populationLogicViewBefore.showRationale @cachedBeforeResult
    else
      @preUploadResultsSizeTooBig = true

    if afterRationale
      @cachedAfterResult = new Thorax.Models.CachedResult({
        rationale: afterRationale
        finalSpecifics: afterFinalSpecifics}
        , {
          population: afterPopulationSet
          patient: @model
        }
      )
      @populationLogicViewAfter = new Thorax.Views.ComparePopulationLogic
      @populationLogicViewAfter.setPopulation @cachedAfterResult.population
      @populationLogicViewAfter.showRationale @cachedAfterResult
    else if !@compareSnapshots
      @populationLogicViewAfter = new Thorax.Views.BuilderPopulationLogic(isCompareView: true)
      @populationLogicViewAfter.setPopulation @measure.get('displayedPopulation')
      @populationLogicViewAfter.showRationale @model
    else
      @postUploadResultsSizeTooBig = true

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
