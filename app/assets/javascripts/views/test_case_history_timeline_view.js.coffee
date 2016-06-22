class Thorax.Views.TestCaseHistoryTimelineView extends Thorax.Views.BonnieView
  template: JST['test_case_history_timeline']
  
  initialize: ->
    @populationIndex = @model.get('displayedPopulation').index()
    #$.get('/measures/history?id='+@model.attributes['hqmf_set_id'], @loadHistory)
    @measureDiffView = new Thorax.Views.MeasureHistoryDiffView(model: @model)
    @loadHistory()
    
  loadHistory: (data) =>
    @patientIndex = [];
    
    # pull out all patients that exist, even deleted ones, map id to names
    @upload_summaries.each (upload_summary) =>
      for population in upload_summary.get('measure_upload_population_summaries')
        for patientId, patient of population.patients
          if _.findWhere(@patientIndex, {id: patientId}) == undefined
            patient = @patients.findWhere({_id: patientId})
            @patientIndex.push {
              id: patientId
              name: "#{patient.get('first')} #{patient.get('last')}"
              patient: patient
            }
    return
    
  updatePopulation: (population) ->
    @populationIndex = population.index()
    @render()
    
  showDiffClicked: (e) ->
    uploadID = $(e.target).data('uploadId')
    upload = @upload_summaries.findWhere({_id: uploadID})
    @measureDiffView.loadDiff upload.get('measure_db_id_before'), upload.get('measure_db_id_after')
    @$('#measure-diff-view-dialog').modal('show');
