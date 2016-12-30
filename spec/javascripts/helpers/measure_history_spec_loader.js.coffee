@MeasureHistorySpecLoader = class MeasureHistorySpecLoader

  # TODO: still need to manage archived measures

  ###*
  # Loads all of the historical context for a measure. This included the patients,
  # the upload summaries, and the measure.
  # Populates `measure`, `patients`, and `uploadSummaries` on `testSuite`.
  # NOTE: this does not yet manage archived measures.
  # @param {String} testSet - The name of the test set for the measure. E.g., 'measure_history_set/single_population_set/CMS68'
  # @param {String} loadState - The snapshot state being loaded. E.g. 'initalLoad', 'update1', 'update2'
  # @param {String} cmsId - the CMS ID for the measure. E.g., 'CMS68v6'
  # @param {Object} testSuite - the jasmine test suite calling this function
  ###
  load: (testSet, loadState, cmsId, testSuite) ->
    path = testSet + '/' + loadState + '/' + cmsId

    try
      window.bonnieRouterCache.load(path)
    catch
      throw('Error retrieving ' + path + ' from router cache. Check to ensure
        that you have the following files in your fixtures directory:\n
        * json/measure_data/' + path + '/measures.json\n
        * json/measure_data/' + path + '/value_sets.json\n')

    measure = bonnie.measures.findWhere(cms_id: cmsId)

    unless measure
      throw('Unable to retrieve measure ' + cmsId + '. Check to ensure that the
        measure contained in \'json/measure_data/' + path + '/measures.json\' is
        actually ' + cmsId)

    patients = new Thorax.Collections.Patients()
    try
      patients.add(new Thorax.Models.Patient patientFixture) for patientFixture in getJSONFixture('records/' + path + '/patients.json')
    catch
      throw('Error retrieving patients. Check to ensure that you have the following
        file in your fixtures directory:\n
        * json/records/' + path + '/patients.json\n')

    uploadSummaries= new Thorax.Collections.UploadSummaries([], {measure_id: measure.id, _fetched: true})

    # add in reverse order so latest upload is first
    if loadState == 'update2'
      uploadSummaries.add(@_getUploadSummary(testSet, 'update2'))
    if loadState == 'update2' || loadState == 'update1'
      uploadSummaries.add(@_getUploadSummary(testSet, 'update1'))
    if loadState == 'update2' || loadState == 'update1' || loadState == 'initialLoad'
      uploadSummaries.add(@_getUploadSummary(testSet, 'initialLoad'))

    measure.set('upload_summaries', uploadSummaries)

    testSuite.measure = measure
    testSuite.patients = patients
    testSuite.uploadSummaries = uploadSummaries

  # loadVersion should be one of the following:
  #  - 'initialLoad'
  #  - 'update1'
  #  - 'update2'
  _getUploadSummary: (path, loadVersion) ->
    try
      jsonFixture = getJSONFixture('upload_summaries/' + path + '/' + loadVersion + '.json')
    catch
      throw('Error retriving upload summary \'' + loadVersion + '\'. Check to ensure that you have the following
        file in your fixtures directory:\n
        * json/upload_summaries/' + path + '/initialLoad.json\n
        * json/upload_summaries/' + path + '/update1.json\n
        * json/upload_summaries/' + path + '/update2.json\n')

    uploadSummary = new Thorax.Models.UploadSummary jsonFixture, parse: true
    uploadSummary._fetched = true

    uploadSummary
