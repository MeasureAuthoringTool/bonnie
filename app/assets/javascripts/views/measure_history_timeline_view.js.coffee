class Thorax.Views.MeasureHistoryTimelineView extends Thorax.Views.BonnieView
  template: JST['measure_history_timeline']
  
  initialize: ->
    @populationIndex = @model.get('displayedPopulation').index()
    @measureDiffView = new Thorax.Views.MeasureHistoryDiffView(model: @model)
    @loadHistory()

  events:
    'rendered': ->
      # makes sure the diff information is cleared when the modal is closed.
      @$('#measure-diff-view-dialog').on 'hidden.bs.modal', @clearDiff

  loadHistory: =>
    @patientIndex = [];

    # if there are no upload_summaries then there is no history.
    if @upload_summaries.size() < 1
      @hasHistory = false
    # if there is only one upload summary yet it has no 'measure_db_id_pre_upload', it is a new measure and has no history
    else if @upload_summaries.size() == 1 && !@upload_summaries.at(0).has('measure_db_id_pre_upload')
      @hasHistory = false
    # Otherwise there is history
    else
      @hasHistory = true

    # add all patients that exist (even deleted ones) to the patientIndex array.
    # store the patient id, patient name, and pointer to the patient.
    @upload_summaries.each (upload_summary) =>
      for population_set in upload_summary.get('population_set_summaries')
        for patientId, patient of population_set.patients
          if _.findWhere(@patientIndex, {id: patientId}) == undefined
            patient = @patients.findWhere({_id: patientId})
            if patient
              @patientIndex.push {
                id: patientId
                name: "#{patient.get('first')} #{patient.get('last')}"
                patient: patient
              }

  # changes the displayed timeline data to align with the selected population tab
  updatePopulation: (population) ->
    @populationIndex = population.index()
    @render()

  # displays the diff view between two measures for a particular upload that occurred.
  showDiff: (e) ->
    uploadID = $(e.target).data('uploadId')
    upload = @upload_summaries.findWhere({_id: uploadID})
    @measureDiffView.loadDiff upload.get('measure_db_id_pre_upload'), upload.get('measure_db_id_post_upload')
    @$('#measure-diff-view-dialog').modal('show');

  # clear's out the diff information from the sub view.
  clearDiff: =>
    @measureDiffView.clearDiff()
