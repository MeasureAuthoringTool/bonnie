class Thorax.Models.Patient extends Thorax.Model
  idAttribute: '_id'
  urlRoot: '/patients'

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
  deepClone: (options = {}) ->
    # Clone by fully serializing and de-derializing; we need to stringify to have recursive JSONification happen
    data = if options.omit_id then _(@toJSON()).omit('_id') else @toJSON() # Don't use @omit in case toJSON is overwritten
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

  materialize: ->

    # Keep track of patient state and don't materialize if unchanged; we can't rely on Backbone's
    # "changed" functionality because that doesn't capture new sub-models
    patientJSON = JSON.stringify @omit(Thorax.Models.Patient.sections)
    return if @previousPatientJSON == patientJSON
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
      if end_date && deathdate && end_date.isAfter deathdate
        errors.push [sdc.cid, 'end_date', "#{sdc.get('title')} stop date must be before patient date of death"]

    return errors if errors.length > 0

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
