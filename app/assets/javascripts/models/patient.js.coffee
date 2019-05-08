class Thorax.Models.Patient extends Thorax.Model
  idAttribute: '_id'
  urlRoot: '/patients'

  parse: (attrs) ->
    thoraxPatient = {}

    # cqmPatient will already exist if we are cloning the thoraxModel
    if attrs.cqmPatient?
      thoraxPatient.cqmPatient = new cqm.models.Patient(attrs.cqmPatient)
      thoraxPatient.cqmPatient.qdmPatient.extendedData = attrs.cqmPatient.qdmPatient.extendedData
    else
      thoraxPatient.cqmPatient = new cqm.models.Patient(attrs)
    # TODO: look into adding this into cqmPatient construction
    if !thoraxPatient.cqmPatient.qdmPatient
      thoraxPatient.cqmPatient.qdmPatient = new cqm.models.QDMPatient()
    thoraxPatient._id = attrs._id
    thoraxPatient.expired = (thoraxPatient.cqmPatient.qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'expired').length > 0
    thoraxPatient.source_data_criteria = new Thorax.Collections.SourceDataCriteria(mongoose.utils.clone(thoraxPatient.cqmPatient.qdmPatient.dataElements), parse: true)
    thoraxPatient.expected_values = new Thorax.Collections.ExpectedValues(attrs.expected_values)
    thoraxPatient

  # Create a deep clone of the patient, optionally omitting the id field
  deepClone: (options = {}) ->
    clonedPatient = @.clone()
    clonedPatient.set 'cqmPatient', new cqm.models.Patient(mongoose.utils.clone(clonedPatient.get('cqmPatient')))
    if options.new_id then clonedPatient.get('cqmPatient')._id = new mongoose.Types.ObjectId()
    if options.dedupName
       clonedPatient.get('cqmPatient')['givenNames'][0] = bonnie.patients.dedupName(clonedPatient)
    clonedPatient

  getPayerName: -> @get('insurance_providers')[0].name
  getValidMeasureIds: (measures) ->
    validIds = {}
    # TODO: Update measure_ids reference once it is on cqmPatient top level
    @get('cqmPatient')['measure_ids'].map (m) ->
      validIds[m] = {key: m, value: _.contains(measures.pluck('hqmf_set_id'), m)}
    validIds
  getEntrySections: ->
    s for s in Thorax.Models.Patient.sections when @has(s)
  ### Patient HTML Header values ###
  getGender: ->
    genderElement = (@get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'gender')[0]
    gender = genderElement?.dataElementCodes[0].code
    if gender == 'M'
      "Male"
    else
      "Female"
  getBirthDate: -> @printDate @get('cqmPatient').qdmPatient.birthDatetime
  getBirthTime: -> @printTime @get('cqmPatient').qdmPatient.birthDatetime
  getDeathDate: -> if @get('expired') then @printDate((thoraxPatient.cqmPatient.qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'expired')[0].expiredDatetime) else ''
  getDeathTime: -> if @get('expired') then @printTime((thoraxPatient.cqmPatient.qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'expired')[0].expiredDatetime) else ''
  getRace: ->
    raceElement = (@get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'race')[0]
    unless raceElement? then "Unknown"
    else unless raceElement.dataElementCodes[0].display? then "CDC-RE: #{raceElement.dataElementCodes[0].code}"
    else raceElement.dataElementCodes[0].display
  getEthnicity: ->
    ethnicityElement = (@get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'ethnicity')[0]
    unless ethnicityElement? then "Unknown"
    else unless ethnicityElement.dataElementCodes[0].display? then "CDC-RE: #{ethnicityElement.dataElementCodes[0].code}"
    else ethnicityElement.dataElementCodes[0].display
  getInsurance: ->
    insurances = @get('insurance_providers')?.map (ip) -> ip.name
    insurances?.join(", ") or ''
  getFirstName: ->
    @get('cqmPatient').givenNames[0]
  getLastName: ->
    @get('cqmPatient').familyName
  getNotes: ->
    @get('cqmPatient').notes
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
  setCqmPatientFirstName: (firstName) ->
    @get('cqmPatient').givenNames[0] = firstName
  setCqmPatientLastName: (lastName) ->
    @get('cqmPatient').familyName = lastName
  setCqmPatientNotes: (notes) ->
    @get('cqmPatient').notes = notes
  setCqmPatientBirthDate: (birthdate, measure) ->
    @get('cqmPatient').qdmPatient.birthDatetime = @createCQLDate(new Date(birthdate))
    sourceElement = @removeElementAndGetNewCopy('birthdate', measure.get('cqmMeasure'))
    if !sourceElement
      sourceElement = new cqm.models.PatientCharacteristicBirthdate()
    sourceElement.birthDatetime = @createCQLDate(new Date(birthdate))
    @get('cqmPatient').qdmPatient.dataElements.push(sourceElement)
  setCqmPatientDeathDate: (deathdate, measure) ->
    sourceElement = @removeElementAndGetNewCopy('expired', measure.get('cqmMeasure'))
    if !sourceElement
      sourceElement = new cqm.models.PatientCharacteristicExpired()
    sourceElement.expiredDatetime = @createCQLDate(new Date(deathdate))
    @get('cqmPatient').qdmPatient.dataElements.push(sourceElement)
  setCqmPatientGender: (gender, measure) ->
    sourceElement = @removeElementAndGetNewCopy('gender', measure.get('cqmMeasure'))
    if !sourceElement
      sourceElement = new cqm.models.PatientCharacteristicSex()
    genderConcept = (@getConceptsForDataElement('gender', measure).filter (elem) -> elem.code == gender)[0]
    sourceElement.dataElementCodes[0] = @conceptToCode(genderConcept)
    @get('cqmPatient').qdmPatient.dataElements.push(sourceElement)
  setCqmPatientRace: (race, measure) ->
    sourceElement = @removeElementAndGetNewCopy('race', measure.get('cqmMeasure'))
    if !sourceElement
      sourceElement = new cqm.models.PatientCharacteristicRace()
    raceConcept = (@getConceptsForDataElement('race', measure).filter (elem) -> elem.code == race)[0]
    sourceElement.dataElementCodes[0] = @conceptToCode(raceConcept)
    @get('cqmPatient').qdmPatient.dataElements.push(sourceElement)
  setCqmPatientEthnicity: (ethnicity, measure) ->
    sourceElement = @removeElementAndGetNewCopy('ethnicity', measure.get('cqmMeasure'))
    if !sourceElement
      sourceElement = new cqm.models.PatientCharacteristicEthnicity()
    ethnicityConcept = (@getConceptsForDataElement('ethnicity', measure).filter (elem) -> elem.code == ethnicity)[0]
    sourceElement.dataElementCodes[0] = @conceptToCode(ethnicityConcept)
    @get('cqmPatient').qdmPatient.dataElements.push(sourceElement)
  setCqmPatientPayer: (payer, measure) ->
    sourceElement = @removeElementAndGetNewCopy('payer', measure.get('cqmMeasure'))
    if !sourceElement
      sourceElement = new cqm.models.PatientCharacteristicPayer()
    payerConcept = (@getConceptsForDataElement('payer', measure).filter (elem) -> elem.code == payer)[0]
    sourceElement.dataElementCodes[0] = @conceptToCode(payerConcept)
    @get('cqmPatient').qdmPatient.dataElements.push(sourceElement)

  removeElementAndGetNewCopy: (elementType, cqmMeasure) ->
    element = (@get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == elementType)[0]
    if element
      elementIndex = @get('cqmPatient').qdmPatient.dataElements.indexOf(element)
      @attributes.cqmPatient.qdmPatient.dataElements.splice(elementIndex, 1)
    # return copy of dataElement off the measure
    mongoose.utils.clone((cqmMeasure.source_data_criteria.filter (elem) -> elem.qdmStatus == elementType )[0])

  getConceptsForDataElement: (qdmStatus, measure) ->
    dataCriteria = (measure.get('cqmMeasure').source_data_criteria.filter (elem) -> elem.qdmStatus == qdmStatus)[0]
    valueSet = (measure.valueSets()?.filter (elem) -> elem.oid == dataCriteria.codeListId)?[0]
    valueSet?.concepts || []

  createCQLDate: (date) ->
    new cqm.models.CQL.DateTime(date.getFullYear(),date.getMonth()+1, date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds(), date.getMilliseconds(), date.getTimezoneOffset())

  conceptToCode: (concept) ->
    new cqm.models.CQL.Code(concept.code, concept.code_system_oid, undefined, concept.display_name)

  printDate: (date) ->
    (date.month + '/' + date.day + '/' + date.year) if date

  printTime: (dateTime) ->
    moment(dateTime).format('h:mm A') if dateTime

  materialize: ->

    # # Keep track of patient state and don't materialize if unchanged; we can't rely on Backbone's
    # # "changed" functionality because that doesn't capture new sub-models
    # patientJSON = JSON.stringify @omit(Thorax.Models.Patient.sections)
    # return if @previousPatientJSON == patientJSON
    # @previousPatientJSON = patientJSON

    # $.ajax
    #   url:         "#{@urlRoot}/materialize"
    #   type:        'POST'
    #   dataType:    'json'
    #   contentType: 'application/json'
    #   data:        JSON.stringify @toJSON()
    #   processData: false
    # .done (data) =>
    #   # We only want to overwrite certain fields; if the server doesn't provide them, we want them emptied
    #   defaults = {}
    #   defaults[section] = [] for section in Thorax.Models.Patient.sections
    #   @set _(data).chain().pick(_(defaults).keys()).defaults(defaults).value(), silent: true
    #   for criterium, i in @get('source_data_criteria').models
    #     criterium.set 'coded_entry_id', data['source_data_criteria'][i]['coded_entry_id'], silent: true
    #     # if we already have codes, then we know we're up to date; no change is necessary
    #     if criterium.get('codes').isEmpty()
    #       criterium.get('codes').reset data['source_data_criteria'][i]['codes'], parse: true
    #   @previousPatientJSON = JSON.stringify @omit(Thorax.Models.Patient.sections) # Capture post-materialize changes too
    #   @trigger 'materialize' # We use a new event rather than relying on 'change' because we don't want to automatically re-render everything
    #   $('#ariaalerts').html "This patient has been updated" #tell SR something changed
    # .fail ->
    #   bonnie.showError({title: "Patient Data Error", summary: 'There was an error handling the data associated with this patient.', body: 'One of the data elements associated with the patient is causing an issue.  Please review the elements associated with the patient to verify that they are all constructed properly.'})

  getExpectedValue: (population) ->
    measure = population.collection.parent
    expectedValue = @get('expected_values').findWhere(measure_id: measure.get('cqmMeasure').hqmf_set_id, population_index: population.index())
    unless expectedValue
      expectedValue = new Thorax.Models.ExpectedValue measure_id: measure.get('cqmMeasure').hqmf_set_id, population_index: population.index()
      @get('expected_values').add expectedValue
    # We don't want to set a value for OBSERV, it should already exist or be created in the builder
    for populationCriteria in Thorax.Models.Measure.allPopulationCodes when population.has(populationCriteria) and populationCriteria != 'OBSERV'
      expectedValue.set populationCriteria, 0 unless expectedValue.has populationCriteria

    # TODO: Update measure_ids reference once it is on cqmPatient top level
    if !_(@get('cqmPatient')['measure_ids']).contains measure.get('cqmMeasure').hqmf_set_id # if patient wasn't made for this measure
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
    birthdate = if @get('cqmPatient').qdmPatient.birthDatetime then moment(@get('cqmPatient').qdmPatient.birthDatetime, 'X') else null
    expiredElement = (@get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'expired')[0]
    deathdate = if @get('expired') && expiredElement.expiredDatetime then moment(expiredElement.expiredDatetime, 'X') else null

    unless @getFirstName()?.length > 0
      errors.push [@cid, 'first', 'Name fields cannot be blank']
    unless @getLastName()?.length > 0
      errors.push [@cid, 'last', 'Name fields cannot be blank']
    unless birthdate
      errors.push [@cid, 'birthdate', 'Date of birth cannot be blank']
    if @get('expired') && !deathdate
      errors.push [@cid, 'deathdate', 'Deceased patient must have date of death']
    if birthdate && birthdate.year() < 1000
      errors.push [@cid, 'birthdate', 'Date of birth must have four digit year']
    if deathdate && deathdate.year() < 1000
      errors.push [@cid, 'deathdate', 'Date of death must have four digit year']
    if deathdate && birthdate && deathdate.isBefore birthdate
      errors.push [@cid, 'deathdate', 'Date of death cannot be before date of birth']

    @get('source_data_criteria').each (sdc) =>
      timingInterval = Thorax.Models.SourceDataCriteria.getTimingInterval(sdc) || 'authorDatetime'
      if sdc.get(timingInterval)?.low
        start_date = moment(sdc.get(timingInterval).low, 'X')
      else if timingInterval == 'authorDatetime' && sdc.get(timingInterval)
        start_date = moment(sdc.get(timingInterval), 'X')
      else
        start_date = null
      end_date = if sdc.get(timingInterval)?.high then moment(sdc.get(timingInterval).high, 'X') else null
      # patient_characteristics do not have start dates
      if !start_date && sdc.get('qdmCategory') != 'patient_characteristic'
        errors.push [sdc.cid, 'start_date', "#{sdc.get('description')} must have start date"]
      if end_date && start_date && end_date.isBefore start_date
        errors.push [sdc.cid, 'end_date', "#{sdc.get('description')} stop date cannot be before start date"]
      if start_date && start_date.year() < 1000
        errors.push [sdc.cid, 'start_date', "#{sdc.get('description')} start date must have four digit year"]
      if end_date && end_date.year() < 1000
        errors.push [sdc.cid, 'end_date', "#{sdc.get('description')} stop date must have four digit year"]
      if start_date && deathdate && start_date.isAfter deathdate
        errors.push [sdc.cid, 'start_date', "#{sdc.get('description')} start date must be before patient date of death"]
      if end_date && birthdate && end_date.isBefore birthdate
        errors.push [sdc.cid, 'end_date', "#{sdc.get('description')} stop date must be after patient date of birth"]

    return errors if errors.length > 0

class Thorax.Collections.Patients extends Thorax.Collection
  url: '/patients'
  model: Thorax.Models.Patient
  dedupName: (patient) ->
    # Can't use patient getters here since patient is not a thorax patient at this point
    patientFirst = patient.getFirstName()
    patientLast = patient.getLastName()
    return patientFirst if !(patientFirst && patientLast)
    # matcher to find all of the records that have the same last name and the first name starts with the first name of the
    # patient data being duplicated
    matcher =  (record) ->
      return false if !(record.getFirstName() && record.getLastName()) || record.getLastName() != patientLast
      return record.getFirstName().substring( 0, patientFirst.length ) == patientFirst;

    matches = @.filter(matcher)
    index = 1
    # increment the index for any copy index that may have been previously used
    index++ while _.find(matches, (record) -> record.getFirstName() == patientFirst + " ("+index+")")
    patientFirst + " (" + index + ")"

  toOids: ->
    patientToOids = {} # patient medical_record_number : valueSet oid
    @each (p) => patientToOids[p.get('medical_record_number')] = p.get('source_data_criteria').pluck('oid')
    patientToOids

  toSdc: ->
    patientToSdc = {} # patient medical_record_number : source_data_criteria
    @each (p) => patientToSdc[p.get('medical_record_number')] = p.get('source_data_criteria').models
    patientToSdc
