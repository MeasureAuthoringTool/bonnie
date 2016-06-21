class Thorax.Views.TestCaseHistoryTimelineView extends Thorax.Views.BonnieView
  template: JST['test_case_history_timeline']
  
  initialize: ->
    @populationIndex = @model.get('displayedPopulation').index()
    $.get('/measures/history?id='+@model.attributes['hqmf_set_id'], @loadHistory)
    @measureDiffView = new Thorax.Views.MeasureHistoryDiffView(model: @model)
    
  loadHistory: (data) =>
    @measureHistory = data
    console.log 'RETRIEVED MEASURE DATA - '
    console.log @measureHistory
    
    @patientIndex = [];
    
    # pull out all patients that exist, even deleted ones, map id to names
    for measureUpdate in @measureHistory
      for population in measureUpdate.populations
        for patientId, patient of population
          if patientId != 'summary' && _.findWhere(@patientIndex, {id: patientId}) == undefined
            @patientIndex.push {
              id: patientId
              name: "#{patient.first} #{patient.last}"
            }
    
    
    @render()
    return
    
  updatePopulation: (population) ->
    @populationIndex = population.index()
    @render()
    
  showDiffClicked: (e) ->
    uploadID = $(e.target).data('uploadId')
    upload = _.findWhere(@measureHistory, {upload_id: uploadID})
    @measureDiffView.loadDiff upload.measure_db_id_before, upload.measure_db_id_after
    @$('#measure-diff-view-dialog').modal('show');
