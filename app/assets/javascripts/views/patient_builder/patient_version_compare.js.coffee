class Thorax.Views.PatientBuilderCompare extends Thorax.Views.BonnieView
  className: 'patient-compare'

  template: JST['patient_builder/patient_version_compare']

  options:
    serialize: { children: false }
    populate: { context: true, children: false }

  initialize: =>
    @patientResultsSummary = @uploadSummary.get('population_set_summaries')[@measure.get('displayedPopulation').get('index')].patients[@model.id]

    # if the @preUploadMeasureVersion parameter exists, it means we're comparing snapshots.
    # comparing snapshots means we're comparing the patient pre-upload and post-upload.
    # not comparing snapshots means we're comparing the patient right after the measure
    # loaded with its current state.
    @compareSnapshots = @preUploadMeasureVersion?
    
    # get the information for the before view
    # if it's not set, it means the cached results are too big
    @populationLogicViewBefore = null
    if @compareSnapshots
      unless @patientResultsSummary.results_exceeds_storage_pre_upload
        @populationLogicViewBefore = @_getSnapshotView(@preUploadMeasureVersion.get('displayedPopulation'), @patientResultsSummary.pre_upload_results)
    else
      unless @patientResultsSummary.results_exceeds_storage_post_upload
        @populationLogicViewBefore = @_getSnapshotView(@measure.get('displayedPopulation'), @patientResultsSummary.post_upload_results)
    
    # get the information for the after view
    # if it's not set, it means the cached results are too big
    @populationLogicViewAfter = null
    if @compareSnapshots
      unless @patientResultsSummary.results_exceeds_storage_post_upload
        # if @postUploadMeasureVersion doesn't exist, then we're comparing the snapshot
        # after the current version of the measure loaded.
        if @postUploadMeasureVersion
          population = @postUploadMeasureVersion.get('displayedPopulation')
        else
          population = @measure.get('displayedPopulation')
        @populationLogicViewAfter = @_getSnapshotView(population, @patientResultsSummary.post_upload_results)
    else
      @populationLogicViewAfter = @_getLiveView(@measure)

    @render()
  
  # creates a patient logic view based off of a patient snapshot rather than the current
  # patient state.
  _getSnapshotView: (population, summaryCachedResult) =>
    cachedResult = new Thorax.Models.CachedResult({
      rationale: summaryCachedResult.rationale
      finalSpecifics: summaryCachedResult.finalSpecifics
    } , {
        population: population
      }
    )
    populationLogicView = new Thorax.Views.ComparePopulationLogic(isCompareView: true, suppressDataCriteriaHighlight: true)
    populationLogicView.setPopulation cachedResult.population
    populationLogicView.showRationale cachedResult
    populationLogicView
  
  # creates a patient logic view based off of the current patient state.
  _getLiveView: (measure) =>
    populationLogicView = new Thorax.Views.BuilderPopulationLogic(isCompareView: true, suppressDataCriteriaHighlight: true)
    populationLogicView.setPopulation measure.get('displayedPopulation')
    populationLogicView.showRationale @model
    populationLogicView
  
# Modified Thorax.Views.BuilderPopulationLogic that accepts new Thorax.Models.cachedResult
class Thorax.Views.ComparePopulationLogic extends Thorax.Views.BuilderPopulationLogic
  showRationale: (result) ->
    @getView().showRationale(result)
