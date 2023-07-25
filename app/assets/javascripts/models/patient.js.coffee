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
    thoraxPatient.source_data_criteria = new Thorax.Collections.SourceDataCriteria(thoraxPatient.cqmPatient.qdmPatient.dataElements, parent: this, parse: true)
    thoraxPatient.expected_values = new Thorax.Collections.ExpectedValues(thoraxPatient.cqmPatient.expectedValues, parent: this, parse: true)
    thoraxPatient

  # Create a deep clone of the patient, optionally omitting the id field
  deepClone: (options = {}) ->
    clonedPatient = @.clone()
    # clone the cqmPatient and make a new source_data_criteria collection for it
    clonedPatient.set 'cqmPatient', new cqm.models.Patient(mongoose.utils.clone(clonedPatient.get('cqmPatient')))
    if options.new_id then clonedPatient.get('cqmPatient')._id = new mongoose.Types.ObjectId()
    clonedPatient.set '_id', clonedPatient.get('cqmPatient')._id.toString()
    clonedPatient.set 'source_data_criteria', new Thorax.Collections.SourceDataCriteria(clonedPatient.get('cqmPatient').qdmPatient.dataElements, parent: clonedPatient, parse: true)
    clonedPatient.set 'expected_values', new Thorax.Collections.ExpectedValues(clonedPatient.get('cqmPatient').expectedValues, parent: clonedPatient, parse: true)
    if options.dedupName
      clonedPatient.get('cqmPatient')['givenNames'][0] = bonnie.patients.dedupName(clonedPatient)
    clonedPatient.set 'expired', (clonedPatient.get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'expired').length > 0
    clonedPatient

  getValidMeasureIds: (measures) ->
    validIds = {}
    @get('cqmPatient')['measure_ids'].map (m) ->
      validIds[m] = {key: m, value: _.contains(measures.pluck('hqmf_set_id'), m)}
    validIds
  getEntrySections: ->
    s for s in Thorax.Models.Patient.sections when @has(s)
  ### Patient HTML Header values ###
  getBirthDate: -> @printDate @get('cqmPatient').qdmPatient.birthDatetime
  getBirthTime: -> @printTime @get('cqmPatient').qdmPatient.birthDatetime
  getDeathDate: -> if @get('expired') then @printDate((@get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'expired')[0].expiredDatetime)
  getDeathTime: -> if @get('expired') then @printTime((@get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'expired')[0].expiredDatetime)

  # Next 4 methods return the Code object since some calls to them need the code while others need the display name
  getGender: ->
    genderElement = (@get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'gender')[0]
    unless genderElement? then return {code: "Unknown", display: "Unknown"}
    genderElement?.dataElementCodes[0]
  getRace: ->
    raceElement = (@get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'race')[0]
    unless raceElement? then return {code: "Unknown", display: "Unknown"}
    else unless raceElement.dataElementCodes[0].display? then "CDC-RE: #{raceElement.dataElementCodes[0].code}"
    else raceElement.dataElementCodes[0]
  getEthnicity: ->
    ethnicityElement = (@get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'ethnicity')[0]
    unless ethnicityElement? then return {code: "Unknown", display: "Unknown"}
    else unless ethnicityElement.dataElementCodes[0].display? then "CDC-RE: #{ethnicityElement.dataElementCodes[0].code}"
    else ethnicityElement.dataElementCodes[0]
  getPayer: ->
    payerElement = (@get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'payer')[0]
    unless payerElement? then return {code: "Unknown", display: "Unknown"}
    else unless payerElement.dataElementCodes[0].display? then "CDC-RE: #{payerElement.dataElementCodes[0].code}"
    else payerElement.dataElementCodes[0]

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
    @get('cqmPatient').qdmPatient.birthDatetime = @createCQLDate(moment.utc(birthdate, 'L LT').toDate())
    sourceElement = @removeElementAndGetNewCopy('birthdate', measure.get('cqmMeasure'))
    if !sourceElement
      sourceElement = new cqm.models.PatientCharacteristicBirthdate() # Patient characteristic birthdate was not found on the measure, so its created without a code
    sourceElement.birthDatetime = @get('cqmPatient').qdmPatient.birthDatetime.copy()
    if sourceElement.codeListId?
      birthdateConcept = @getConceptsForDataElement('birthdate', measure)[0]
      sourceElement.dataElementCodes[0] = @conceptToCode(birthdateConcept)
    @get('cqmPatient').qdmPatient.dataElements.push(sourceElement)
  setCqmPatientDeathDate: (deathdate, measure) ->
    sourceElement = @removeElementAndGetNewCopy('expired', measure.get('cqmMeasure'))
    if !sourceElement
      sourceElement = new cqm.models.PatientCharacteristicExpired() # Patient characteristic expired was not found on the measure, so its created without a code
    expiredElement = @get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'expired'
    if expiredElement and expiredElement.expiredDatetime
      sourceElement.expiredDatetime = expiredElement.expiredDatetime.copy()
    if !sourceElement.expiredDatetime
      sourceElement.expiredDatetime = @createCQLDate(moment.utc(deathdate, 'L LT').toDate())
    if sourceElement.codeListId?
      deathdateConcept = @getConceptsForDataElement('expired', measure)[0]
      sourceElement.dataElementCodes[0] = @conceptToCode(deathdateConcept)
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

  removeElementAndGetNewCopy: (elementType, cqmMeasure) ->
    element = (@get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == elementType)[0]
    if element
      elementIndex = @get('cqmPatient').qdmPatient.dataElements.indexOf(element)
      @attributes.cqmPatient.qdmPatient.dataElements.splice(elementIndex, 1)
    # return copy of dataElement off the measure if one exists
    sdcDataElement = (cqmMeasure.source_data_criteria.filter (elem) -> elem.qdmStatus == elementType )[0]
    if (sdcDataElement)
      dataElementType = sdcDataElement._type.replace(/QDM::/, '')
      return new cqm.models[dataElementType](mongoose.utils.clone(sdcDataElement))
    else
      return null

  getConceptsForDataElement: (qdmStatus, measure) ->
    dataCriteria = (measure.get('cqmMeasure').source_data_criteria.filter (elem) -> elem.qdmStatus == qdmStatus)[0]
    return [] unless dataCriteria?
    valueSet = (measure.valueSets()?.filter (elem) -> elem.oid == dataCriteria.codeListId)?[0]
    valueSet?.concepts || []

  createCQLDate: (date) ->
    cqm.models.CQL.DateTime.fromJSDate(date, 0)

  conceptToCode: (concept) ->
    new cqm.models.CQL.Code(concept.code, concept.code_system_oid, null, concept.display_name || null)

  printDate: (date) ->
    (date.month.toString().padStart(2, '0') + '/' + date.day.toString().padStart(2, '0') + '/' + date.year) if date

  printTime: (dateTime) ->
    moment(dateTime).format('h:mm A') if dateTime

  materialize: ->
    @trigger 'materialize'

  getExpectedValue: (population) ->
    measure = population.collection.parent
    expectedValue = @get('expected_values').findWhere(measure_id: measure.get('cqmMeasure').hqmf_set_id, population_index: population.index())
    unless expectedValue
      expectedValue = new Thorax.Models.ExpectedValue measure_id: measure.get('cqmMeasure').hqmf_set_id, population_index: population.index()
      @get('expected_values').add expectedValue
    # We don't want to set a value for OBSERV, it should already exist or be created in the builder
    for populationCriteria in Thorax.Models.Measure.allPopulationCodes when population.has(populationCriteria) and populationCriteria != 'OBSERV'
      expectedValue.set populationCriteria, 0 unless expectedValue.has populationCriteria

    if !_(@get('cqmPatient')['measure_ids']).contains measure.get('cqmMeasure').hqmf_set_id # if patient wasn't made for this measure
      expectedValue.set _.object(_.keys(expectedValue.attributes), []) # make expectations undefined instead of 0/fail
    expectedValue.set("scoring", measure.get('cqmMeasure').measure_scoring)
    expectedValue.set("isEpisodeBased", measure.get('cqmMeasure').calculation_method == 'EPISODE_OF_CARE')
    expectedValue

  getExpectedValues: (measure) ->
    expectedValues = new Thorax.Collections.ExpectedValues([], parent: this)
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
    deathdate = if @get('expired') && expiredElement?.expiredDatetime then moment(expiredElement.expiredDatetime, 'X') else null

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
