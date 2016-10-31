class Thorax.Views.MeasureUploadSummary extends Thorax.Views.BonnieView
  template: JST['measure_upload_summary']

  events:
    'click .patient-link': -> @trigger "patient:selected" # Event for if the link on the modal is clicked

  context: ->
    populationInformation = [] # One element per population
    populationTitles = @measure.get('populations').map ((eachPopulation) -> eachPopulation.get('title'))
    for eachPopulation, populationIndex in @model.get('population_set_summaries')
      patientsWhoChanged = [] # One hash per patient who changed
      totalChanged = 0
      totalPatients = @measure.get('patients').length
      populationSummary = eachPopulation.summary
      # toFixed(1) trims decimal to 1 decimal point, but converts to string. parseFloat converts to float, because the Knob requires input as float
      percentPassedBefore = parseFloat(((populationSummary.pass_before/totalPatients) * 100).toFixed(1))
      percentPassedAfter = parseFloat(((populationSummary.pass_after/totalPatients) * 100).toFixed(1))
      for patientOID, patientInformation of eachPopulation.patients
        if patientInformation.pre_upload_status != patientInformation.post_upload_status
          totalChanged++
          patient = @measure.get('patients').findWhere(_id: patientOID)
          patientsWhoChanged.push({name: "#{patient.get('first')} #{patient.get('last')}", patientID: patient.id, post_upload_status: patientInformation.post_upload_status})
      populationInformation[populationIndex] = {
        totalPatients: totalPatients,
        totalChanged: totalChanged,
        percentageDialBeforeMeasureUpload: {done: true, percent: percentPassedBefore, status: if percentPassedBefore == 100 then 'pass' else 'fail'}
        percentageDialAfterMeasureUpload: {done: true, percent: percentPassedAfter, status: if percentPassedAfter == 100 then 'pass' else 'fail'}
        patientsWhoChanged: patientsWhoChanged
        populationTitle: populationTitles[populationIndex]
        }
    _(super).extend(populationInformation: populationInformation, numberOfPopulations: @measure.get('populations').size(), hqmfSetId: @measure.get('hqmf_set_id'))
