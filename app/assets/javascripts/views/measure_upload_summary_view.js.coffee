class Thorax.Views.MeasureUploadSummary extends Thorax.Views.BonnieView
  template: JST['measure_upload_summary']

  events:
    'click .patient-link': 'patientSelected'

  context: ->
    populationInformation = [] # One element per population
    populationTitles = @measure.get('populations').map ((eachPopulation) -> eachPopulation.get('title'))
    for eachPopulation, populationIndex in @model.get('measure_upload_population_summaries')
      patientsWhoChanged = [] # One hash per patient who changed
      totalChanged = 0
      totalPatients = @measure.get('patients').length
      populationSummary = eachPopulation.summary
      percentPassedBefore = parseFloat(((populationSummary.pass_before/totalPatients) * 100).toFixed(1)) # toFixed converts to string
      percentPassedAfter = parseFloat(((populationSummary.pass_after/totalPatients) * 100).toFixed(1))
      for patientOID, patientInformation of eachPopulation.patients
        if patientInformation.before_status != patientInformation.after_status
          totalChanged++
          @measure.get('patients').each((thisPatient, arrayIndex) ->
            if thisPatient.get('_id') == patientOID
              patientsWhoChanged[arrayIndex] = {name: "#{thisPatient.get('first')} #{thisPatient.get('last')}", patientID: thisPatient.id, after_status: patientInformation.after_status}
            )
      populationInformation[populationIndex] = {
        totalPatients: totalPatients,
        totalChanged: totalChanged,
        jQueryKnobBefore: {done: true, percent: percentPassedBefore, status: if percentPassedBefore == 100 then 'pass' else 'fail'}
        jQueryKnobAfter: {done: true, percent: percentPassedAfter, status: if percentPassedAfter == 100 then 'pass' else 'fail'}
        patientsWhoChanged: patientsWhoChanged
        populationTitle: populationTitles[populationIndex]
        }
    _(super).extend(populationInformation: populationInformation, numberOfPopulations: @measure.get('populations').size(), hqmfSetId: @measure.get('hqmf_set_id'))

  #Event for if the link on the modal is clicked
  patientSelected: =>
    @trigger "patient:selected"
