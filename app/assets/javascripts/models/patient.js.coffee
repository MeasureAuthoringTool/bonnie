class Thorax.Models.Patient extends Thorax.Model
  idAttribute: '_id'
  urlRoot: '/patients'
  
  initialize: ->
    # unsets calc results on change so that a new calculation can be made based on
    # the changes.
    # unsets calc results on materialize which happens when you clone the patient. the
    # calculation on the cloned patients needs to be recalculated.
    # made 'silent' so this doesn't trigger another change event.
    # This is done on the cloned patient in the patient builder and doesn't affect 
    # the underlying patient in the database unless the edits are saved, and then
    # the database cached results will be updated with the new results.
    @on 'change materialize', => @unset 'calc_results', silent: true

  parse: (attrs) ->
    dataCriteria = _(attrs.source_data_criteria).reject (c) -> c.id is 'MeasurePeriod'
    attrs.source_data_criteria = new Thorax.Collections.PatientDataCriteria(dataCriteria, parse: true)

    attrs.expected_values = new Thorax.Collections.ExpectedValues(attrs.expected_values)

    # This section is a bit unusual: we map from server side values to a more straight forward client
    # side representation; the reverse mapping would usually happen in toJSON(), but in this case it
    # happens on the server in the controller
    # extract demographics from hash, or use extracted values when cloning
    attrs.ethnicity = attrs.ethnicity?.code || attrs.ethnicity
    attrs.race = attrs.race?.code || attrs.race
    attrs.payer = attrs.insurance_providers?[0]?.type || 'OT'

    attrs

  # Create a deep clone of the patient, optionally omitting the id field
  # When cloning to create a new patient clear the measure history flag
  deepClone: (options = {}) ->
    # Clone by fully serializing and de-derializing; we need to stringify to have recursive JSONification happen
    data = if options.omit_id then _(@toJSON()).omit('_id') else @toJSON() # Don't use @omit in case toJSON is overwritten

    # Removes all of the information relating to calc results
    data.calc_results = null
    data.condensed_calc_results = null
    data.results_exceed_storage = false
    data.results_size = 0

    # If createPatient = true, then a new patient is being created from the deep clone rather than
    # a clone used to facilitate editing as is done in the patient builder view.
    # Since we are making a new patient, this patient will not have any prior measure upload history
    if options.createPatient
      data.has_measure_history = false

    if options.dedupName
       data['first'] = bonnie.patients.dedupName(data)

    json = JSON.stringify data

    new @constructor JSON.parse(json), parse: true

  getBirthDate: -> new Date(@get('birthdate'))
  getPayerName: -> @get('insurance_providers')[0].name
  getValidMeasureIds: (measures) ->
    validIds = {}
    @get('measure_ids').map (m) ->
      validIds[m] = {key: m, value: _.contains(measures.pluck('hqmf_set_id'), m)}
    validIds
  getEntrySections: ->
    s for s in Thorax.Models.Patient.sections when @has(s)
  ### Patient HTML Header values ###
  getGender: ->
    if @get('gender') == 'M'
      "Male"
    else
      "Female"
  getBirthdate: -> @printDate @get('birthdate')
  getExpirationDate: -> if @get('expired') then @printDate(@get('deathdate')) else ''
  getRace: ->
    unless @get('race')? then "Unknown"
    else unless @get('race').name? then "CDC-RE: #{@get('race').code}"
    else @get('race').name
  getEthnicity: ->
    unless @get('ethnicity')? then "Unknown"
    else unless @get('ethnicity').name? then "CDC-RE: #{@get('ethnicity').code}"
    else @get('ethnicity').name
  getInsurance: ->
    insurances = @get('insurance_providers')?.map (ip) -> ip.name
    insurances?.join(", ") or ''
  getAddresses: ->
    address = ""
    if @get('addresses')
      for addr in @get('addresses')
        for street in addr.street
          address += street + "\n"
        address += addr.city + ", " + addr.state + ", " + addr.zip + "\n"
        if addr.use
          address += addr.use + "\n"
    if @get('telecoms')
      for telecom in @get('telecoms')
        address += telecom.value + "\n"
        if telecom.use
          address += telecom.use + "\n"
  printDate: (date) ->
    fullDate = new Date(date * 1000)
    (fullDate.getMonth() + 1) + '/' + fullDate.getDay() + '/' + fullDate.getYear()

  materialize: (callback) ->

    # Keep track of patient state and don't materialize if unchanged; we can't rely on Backbone's
    # "changed" functionality because that doesn't capture new sub-models
    patientJSON = JSON.stringify @omit(Thorax.Models.Patient.sections)
    if @previousPatientJSON == patientJSON
      callback() if callback?
      return
    @previousPatientJSON = patientJSON
    
    $.ajax
      url:         "#{@urlRoot}/materialize"
      type:        'POST'
      dataType:    'json'
      contentType: 'application/json'
      data:        JSON.stringify @toJSON()
      processData: false
    .done (data) =>
      # We only want to overwrite certain fields; if the server doesn't provide them, we want them emptied
      defaults = {}
      defaults[section] = [] for section in Thorax.Models.Patient.sections
      @set _(data).chain().pick(_(defaults).keys()).defaults(defaults).value(), silent: true
      for criterium, i in @get('source_data_criteria').models
        criterium.set 'coded_entry_id', data['source_data_criteria'][i]['coded_entry_id'], silent: true
        # if we already have codes, then we know we're up to date; no change is necessary
        if criterium.get('codes').isEmpty()
          criterium.get('codes').reset data['source_data_criteria'][i]['codes'], parse: true
      @previousPatientJSON = JSON.stringify @omit(Thorax.Models.Patient.sections) # Capture post-materialize changes too
      @trigger 'materialize' # We use a new event rather than relying on 'change' because we don't want to automatically re-render everything
      callback() if callback?
      $('#ariaalerts').html "This patient has been updated" #tell SR something changed
    .fail ->
      bonnie.showError({title: "Patient Data Error", summary: 'There was an error handling the data associated with this patient.', body: 'One of the data elements associated with the patient is causing an issue.  Please review the elements associated with the patient to verify that they are all constructed properly.'})

  getExpectedValue: (population) ->
    measure = population.collection.parent
    expectedValue = @get('expected_values').findWhere(measure_id: measure.get('hqmf_set_id'), population_index: population.index())
    unless expectedValue
      expectedValue = new Thorax.Models.ExpectedValue measure_id: measure.get('hqmf_set_id'), population_index: population.index()
      @get('expected_values').add expectedValue
    # We don't want to set a value for OBSERV, it should already exist or be created in the builder
    for populationCriteria in Thorax.Models.Measure.allPopulationCodes when population.has(populationCriteria) and populationCriteria != 'OBSERV'
      expectedValue.set populationCriteria, 0 unless expectedValue.has populationCriteria

    if !_(@get('measure_ids')).contains measure.get('hqmf_set_id') # if patient wasn't made for this measure
      expectedValue.set _.object(_.keys(expectedValue.attributes), []) # make expectations undefined instead of 0/fail

    expectedValue

  getExpectedValues: (measure) ->
    expectedValues = new Thorax.Collections.ExpectedValues()
    measure.get('populations').each (population) =>
      expectedValues.add @getExpectedValue(population)
    expectedValues
    
  # Expose the stored value for the last time that actual results where calculated for the patient. 
  getCalculatedResultsValues: (population) ->
    measure = population.collection.parent
    _(this.get('calc_results')).find (result) -> result.measure_id == measure.get('hqmf_set_id') && result.population_index == population.index()
    
  # Sort criteria by any number of attributes, first given highest priority
  sortCriteriaBy: (attributes...) ->
    originalComparator = @get('source_data_criteria').comparator
    @get('source_data_criteria').comparator = (crit) -> _(attributes).map((attr) -> crit.get(attr))
    @get('source_data_criteria').sort()
    @get('source_data_criteria').comparator = originalComparator

  validate: ->
    errors = []
    birthdate = if @get('birthdate') then moment(@get('birthdate'), 'X') else null
    deathdate = if @get('deathdate') then moment(@get('deathdate'), 'X') else null

    unless @get('first').length > 0
      errors.push [@cid, 'first', 'Name fields cannot be blank']
    unless @get('last').length > 0
      errors.push [@cid, 'last', 'Name fields cannot be blank']
    unless birthdate
      errors.push [@cid, 'birthdate', 'Date of birth cannot be blank']
    if @get('expired') && !deathdate
      errors.push [@cid, 'deathdate', 'Deceased patient must have date of death']
    if birthdate && birthdate.year() < 100
      errors.push [@cid, 'birthdate', 'Date of birth must have four digit year']
    if deathdate && deathdate.year() < 100
      errors.push [@cid, 'deathdate', 'Date of death must have four digit year']
    if deathdate && birthdate && deathdate.isBefore birthdate
      errors.push [@cid, 'deathdate', 'Date of death cannot be before date of birth']

    @get('source_data_criteria').each (sdc) =>
      start_date = if sdc.get('start_date') then moment(sdc.get('start_date') / 1000, 'X') else null
      end_date = if sdc.get('end_date') then moment(sdc.get('end_date') / 1000, 'X') else null
      # Note that birth and death dates are stored in seconds, data criteria dates in milliseconds
      unless start_date
        errors.push [sdc.cid, 'start_date', "#{sdc.get('title')} must have start date"]
      if end_date && start_date && end_date.isBefore start_date
        errors.push [sdc.cid, 'end_date', "#{sdc.get('title')} stop date cannot be before start date"]
      if start_date && start_date.year() < 100
        errors.push [sdc.cid, 'start_date', "#{sdc.get('title')} start date must have four digit year"]
      if end_date && end_date.year() < 100
        errors.push [sdc.cid, 'end_date', "#{sdc.get('title')} stop date must have four digit year"]
      # Start date *can* be before patient birth, if the encounter is when the patient is being born!
      # if sdc.get('start_date') && @get('birthdate') && sdc.get('start_date') < @get('birthdate') * 1000
      #   errors.push [sdc.cid, 'start_date', "#{sdc.get('title')} start date must be after patient date of birth"]
      if start_date && deathdate && start_date.isAfter deathdate
        errors.push [sdc.cid, 'start_date', "#{sdc.get('title')} start date must be before patient date of death"]
      if end_date && birthdate && end_date.isBefore birthdate
        errors.push [sdc.cid, 'end_date', "#{sdc.get('title')} stop date must be after patient date of birth"]
      # Stop date *can* be after patient death, if the patient has died during an encounter or procedure
      # if end_date && deathdate && end_date.isAfter deathdate
      #   errors.push [sdc.cid, 'end_date', "#{sdc.get('title')} stop date must be before patient date of death"]

    return errors if errors.length > 0

  ###*
  # Pulls out only the needed parts of a result from the calculation engine to create the structure needed
  # to save the calc_results for the specific population set.
  # @private
  # @param {Thorax.Models.Result} result - The result from the calculation engine.
  # @retun {object} The result objet that will be saved.
  ###
  _filterResult: (result) ->
    filteredResult = {}
    for populationName in Thorax.Models.Measure.allPopulationCodes
      filteredResult[populationName] = result.get(populationName) if result.get(populationName)?
    filteredResult['rationale'] = result.get('rationale') if result.get('rationale')?
    filteredResult['finalSpecifics'] = result.get('finalSpecifics') if result.get('finalSpecifics')?
    # this is for continuous variable measures. OBSERV actuals are stored in 'values'.
    filteredResult['values'] = result.get('values') if result.get('values')?

    filteredResult['measure_id'] = result.measure.get('hqmf_set_id')
    filteredResult['population_index'] = result.population.get('index')
    return filteredResult
  
  ###*
  # Makes changes to the patient, materializes, calculates results for this patient for each
  # measure they belong to, then saves using the backbone save function.
  # @param {object} attributes - The attributes to be changed.
  # @param {object} options - The options. These are passed to backbone's save function. `silent`
  #   option is obeyed for setting attribute changes. `success` option is useful to know when the
  #   save has been completed.
  # @return {Deferred} a promise object that completes when the calculation and save are completely
  #   processed.
  ###
  calculateAndSave: (attributes, options) ->
    deferred = $.Deferred()

    # make the changes
    @set(attributes, if options?.silent then { silent: true } else null)

    # validate the changes made
    @validationError = @validate()

    # return false if there are any validation errors
    if @validationError?.length > 0
      deferred.reject(@)
      return deferred.promise()

    # make sure that materialize happens
    @materialize( =>
      measuresToCalculate = []

      # fetch all measures that this patient belongs to if they exist
      for hqmfSetId in @get('measure_ids')
        if hqmfSetId != null
          measure = bonnie.measures.findWhere(hqmf_set_id: hqmfSetId)
          measuresToCalculate.push(measure) if measure

      # start all calculations and collect all the deferreds
      allCalculations = []
      for measure in measuresToCalculate
        allCalculations.push(measure.get('populations').map((populationSet) => populationSet.calculate(@).calculation)...)

      # wait for all calculation deferreds to complete
      $.when.apply(@, allCalculations)
        .done( (results...) =>
          # Pull out only the result parts we need to save and replace them on the patient
          @set({ calc_results: _.map(results, @_filterResult) }, { silent: true })

          # only resolve the method promise once the save has been completely processed
          savePromise = @save(null, options)
          $.when(savePromise).then =>
            deferred.resolve(@)
        )
      )

    deferred.promise()

class Thorax.Collections.Patients extends Thorax.Collection
  url: '/patients'
  model: Thorax.Models.Patient
  dedupName: (patient) ->
    return patient.first if !(patient.first && patient.last)
    #matcher to find all of the records that have the same last name and the first name starts with the first name of the
    #patient data being duplicated
    matcher =  (record) ->
      return false if !(record.get('first') && record.get('last')) || record.get('last') != patient.last
      return record.get('first').substring( 0, patient.first.length ) == patient.first;

    matches = @.filter(matcher)
    index = 1
    #increment the index for any copy index that may have been previously used
    index++ while _.find(matches, (record) -> record.get("first") == patient.first + " ("+index+")")
    patient.first + " (" + index + ")"

  toOids: ->
    patientToOids = {} # patient medical_record_number : valueSet oid
    @each (p) => patientToOids[p.get('medical_record_number')] = p.get('source_data_criteria').pluck('oid')
    patientToOids

  toSdc: ->
    patientToSdc = {} # patient medical_record_number : source_data_criteria
    @each (p) => patientToSdc[p.get('medical_record_number')] = p.get('source_data_criteria').models
    patientToSdc
