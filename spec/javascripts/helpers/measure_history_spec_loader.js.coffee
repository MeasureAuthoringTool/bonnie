@MeasureHistorySpecLoader = class MeasureHistorySpecLoader

  # TODO: still need to manage archived measures

  ###*
  # Loads all of the historical context for a measure. This included the patients,
  # the upload summaries, and the measure.
  # NOTE: this does not yet manage archived measures.
  # @param {String} measureHistoryTestSet - The name of the test set for the measure. E.g., 'single_population_set'
  # @param {String} cmsId - the CMS ID for the measure. E.g., 'CMS68v6'
  # @returns {Object} - a hash with the keys 'measure', 'patients', 'uploadSummaries'
  ###
  loadWithHistory: (measureHistoryTestSet, cmsId) ->
    path = 'measure_history_set/' + measureHistoryTestSet + '/' + cmsId
    window.bonnieRouterCache.load(path)
    measure = bonnie.measures.findWhere(cms_id: cmsId)

    patients = new Thorax.Collections.Patients()
    patients.add(new Thorax.Models.Patient patientFixture) for patientFixture in getJSONFixture('records/' + path + '/patients.json')

    patients.each (patient) ->
      patient.set('has_measure_history', true)

    uploadSummaries= new Thorax.Collections.UploadSummaries([], {measure_id: measure.id, _fetched: true})
    initialLoad = new Thorax.Models.UploadSummary getJSONFixture('upload_summaries/' + path + '/initialLoad.json'), parse: true
    initialLoad._fetched = true
    update1 = new Thorax.Models.UploadSummary getJSONFixture('upload_summaries/' + path + '/update1.json'), parse: true
    update1._fetched = true
    update2 = new Thorax.Models.UploadSummary getJSONFixture('upload_summaries/' + path + '/update2.json'), parse: true
    update2._fetched = true
    # add in reverse order so latest upload is first
    uploadSummaries.add(update2)
    uploadSummaries.add(update1)
    uploadSummaries.add(initialLoad)

    measure.set('upload_summaries', uploadSummaries)

    { measure: measure, patients: patients, uploadSummaries: uploadSummaries }

  ###*
  # Loads the measure without historical context. This included the patients,
  # the measure, and an uploadSummarie with just the initial upload.
  # NOTE: this does not yet manage archived measures.
  # @param {String} measureHistoryTestSet - The name of the test set for the measure. E.g., 'single_population_set'
  # @param {String} cmsId - the CMS ID for the measure. E.g., 'CMS68v6'
  # @returns {Object} - a hash with the keys 'measure', 'patients', 'uploadSummaries'
  ###
  loadWithoutHistory: (measureHistoryTestSet, cmsId) ->
    path = 'measure_history_set/' + measureHistoryTestSet + '/' + cmsId
    window.bonnieRouterCache.load(path)
    measure = bonnie.measures.findWhere(cms_id: cmsId)

    patients = new Thorax.Collections.Patients()
    patients.add(new Thorax.Models.Patient patientFixture) for patientFixture in getJSONFixture('records/' + path + '/patients.json')

    uploadSummaries= new Thorax.Collections.UploadSummaries([], {measure_id: measure.id, _fetched: true})
    initialLoad = new Thorax.Models.UploadSummary getJSONFixture('upload_summaries/' + path + '/initialLoad.json'), parse: true
    initialLoad._fetched = true
    uploadSummaries.add(initialLoad)

    measure.set('upload_summaries', uploadSummaries)

    { measure: measure, patients: patients, uploadSummaries: uploadSummaries }
