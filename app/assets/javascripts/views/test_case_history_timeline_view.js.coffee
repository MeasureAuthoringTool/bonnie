class Thorax.Views.TestCaseHistoryTimelineView extends Thorax.Views.BonnieView
  template: JST['test_case_history_timeline']
  
  initialize: ->
    @populationIndex = @model.get('displayedPopulation').index()
    $.get('/measures/history?id='+@model.attributes['hqmf_set_id'], @loadHistory)
    
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
