# Used for patient encounters. idAttribute is null, as the model itself
# isn't responsible for persisting itself, and the collection must support
# multiple criteria with the same ID.
class Thorax.Models.SourceDataCriteria extends Thorax.Model
  idAttribute: null
  dataElement: null
  initialize: ->
    @set('codes', new Thorax.Collections.Codes) unless @has 'codes'
    if !@isPeriodType() then @set('end_date', undefined)
    # TODO negation
#    @set('negation', @get('dataElement').negationRationale?)

  clone: ->
    # Clone the DataElement
    dataElementClone = @get('dataElement').clone()
    # build the initial attributes object similar to how it is done in the collection parse.
    # Create data elements attribus as plain object
    # Keep TS model object in dataElement field
    dataElementAsObject = dataElementClone.toJSON()
    dataElementAsObject.description = @get('description')
    dataElementAsObject.dataElement = dataElementClone
    dataElementAsObject.dataElement.description = dataElementAsObject.description

    # make and return the new SDC
    return new Thorax.Models.SourceDataCriteria(dataElementAsObject)

  setNewId: ->
    # Create and set a new id for the data element
    new_id = cqm.ObjectID().toHexString()
    @get('dataElement').id = new_id
    @set 'id', new_id

  measure: -> bonnie.measures.findWhere set_id: @get('set_id')

  valueSet: -> _(@measure().get('cqmValueSets')).find (vs) => vs.id is @get('codeListId')

  icon: ->
    icons =
      'clinical summary': 'clinical-summary'
      'financial support': 'financial-support'
      'diagnostics': 'diagnostics'
      'care provision': 'care-provision'
      'billing': 'billing'
      'request response': 'request-response'
      'providers entities': 'providers-entities'
      'material entities': 'material-entities'
      'management': 'management'
      'medications': 'medications'
      'individuals': 'individuals'
      'workflow': 'workflow'

    element_category = DataCriteriaHelpers.DATA_ELEMENT_CATEGORIES[@get('fhir_resource').resourceType]
    icons[element_category] || 'question'

  canHaveNegation: ->
#    TODO FHIR negation
#    @get('dataElement').schema.path('negationRationale')?
    false

  # determines if a data criteria has a time period associated with it: it potentially has both
  # a start and end date.
  isPeriodType: ->
    @getPrimaryTimingAttribute() not in ['authorDatetime', 'resultDatetime']

  # determines if a data criteria describes an issue or problem with a person
  # allergy/intolerance, diagnosis, and symptom fall into this
  isIssue: ->
    criteriaType = @getCriteriaType()
    criteriaType in ['allergy_intolerance', 'diagnosis', 'symptom']

  # returns the criteria type including the status or subtype
  # e.g., for "Encounter, Performed", returns "encounter_performed"
  # TODO: (LDY 10/6/2016) this is a helper function. does it belong somewhere else? should it be used in
  # other places?
  getCriteriaType: ->
    criteriaType = @get('dataElement')?.fhir_resource?.resourceType
    criteriaType

  # TODO: update this while working on attribute story
  # the attributes to skip in user attribute view and editing fields
  # @SKIP_ATTRIBUTES = ['dataElementCodes', 'codeListId', 'description', 'id', 'qrdaOid', 'qdmTitle', 'hqmfOid', 'qdmCategory', 'qdmVersion', 'qdmStatus', 'negationRationale', '_type']
  #  .concat(@PRIMARY_TIMING_ATTRIBUTES)

  # Use the mongoose schema to look at the fields for this element
  getPrimaryTimingAttribute: ->
    timingAttributes = @getPrimaryTimingAttributes()
    for attr in timingAttributes
      return attr if @get('dataElement').fhir_resource[attr.name]?.start? ||
        @get('dataElement').fhir_resource[attr.name]?.end? ||
        @get('dataElement').fhir_resource[attr.name]?.value?
    # Fall back to returning the first primary timing attribute if none of the timing attributes have values
    return timingAttributes[0]

  # Gets a list of the names, titles and types of the primary timing attributes for this SDC.
  getPrimaryTimingAttributes: ->
    primaryTimingAttributes = []
    elementType = @get('dataElement').fhir_resource?.resourceType
    timingAttributes = DataCriteriaHelpers.PRIMARY_TIMING_ATTRIBUTES[elementType]
    for attribute of timingAttributes
      primaryTimingAttributes.push(
        name: attribute
        title: attribute?.replace(/(?=[A-Z])/g, ' ')
        type: timingAttributes[attribute]
      )
    return primaryTimingAttributes

  # Mapping of attribute name to human friendly titles. This is globally acessible and used by view classes for labels.
  @ATTRIBUTE_TITLE_MAP:
    'admissionSource': 'Admission Source'
    'anatomicalLocationSite': 'Anatomical Location Site'
    'category': 'Category'
    'cause': 'Cause'
    'birthDatetime': 'Birth DateTime'
    'code': 'Code'
    'components': 'Components'
    'expiredDatetime': 'Expiration DateTime'
    'daysSupplied': 'Days Supplied'
    'diagnoses': 'Diagnoses'
    'dischargeDisposition': 'Discharge Disposition'
    'dispenser': 'Dispenser'
    'dosage': 'Dosage'
    'facilityLocations': 'Facility Locations'
    'facilityLocation': 'Facility Location'
    'frequency': 'Frequency'
    'identifier': 'Identifier'
    'incisionDatetime': 'Incision DateTime'
    'lengthOfStay': 'Length of Stay'
    'locationPeriod': 'Location Period'
    'medium': 'Medium'
    'method': 'Method'
    'namingSystem': 'Naming System'
    'negationRationale': 'Negation Rationale'
    'ordinality': 'Ordinality'
    'participant': 'Participant'
    'performer': 'Performer'
    'prescriber': 'Prescriber'
    'presentOnAdmissionIndicator': 'Present on Admission Indicator'
    'principalDiagnosis': 'Principal Diagnosis'
    'priority': 'Priority'
    'qualification': 'Qualification'
    'rank': 'Rank'
    'reason': 'Reason'
    'receivedDatetime': 'Received DateTime'
    'recipient': 'Recipient'
    'referenceRange': 'Reference Range'
    'refills': 'Refills'
    'relatedTo': 'Related To'
    'relationship': 'Relationship'
    'result': 'Result'
    'resultDatetime': 'Result DateTime'
    'requester': 'Requester'
    'recorder': 'Recorder'
    'role': 'Role'
    'route': 'Route'
    'sender': 'Sender'
    'sentDatetime': 'Sent DateTime'
    'setting': 'Setting'
    'severity': 'Severity'
    'statusDate': 'Status Date'
    'specialty': 'Specialty'
    'status': 'Status'
    'supply': 'Supply'
    'targetOutcome': 'Target Outcome'
    'type': 'Type'
    'value': 'Value'

  # return the human friendly title for an attribute, if it exists, otherwise return the name.
  getAttributeTitle: (attributeName) ->
    Thorax.Models.SourceDataCriteria.ATTRIBUTE_TITLE_MAP[attributeName] || attributeName

Thorax.Models.SourceDataCriteria.generateCriteriaId = ->
    chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    today = new Date()
    result = today.valueOf().toString 16
    result += chars.substr Math.floor(Math.random() * chars.length), 1
    result += chars.substr Math.floor(Math.random() * chars.length), 1
    result

class Thorax.Collections.SourceDataCriteria extends Thorax.Collection
  # List of types to exclude from SourceDataCriteria collection because they are managed by the header of the patient builder.
  @SKIP_TYPES = [ ]

  model: Thorax.Models.SourceDataCriteria
  initialize: (models, options) ->
    @parent = options?.parent
    # set up add remove events to handle syncing of data elements if the parent is a patient
    if @parent instanceof Thorax.Models.Patient
      @on 'add', @addSourceDataCriteriaToPatient, this
      @on 'remove', @removeSourceDataCriteriaFromPatient, this

  # FIXME sortable: commenting out due to odd bug in droppable
  # comparator: (m) -> [m.get('start_date'), m.get('end_date')]

  # event listener for add SDC event. if this collection belongs to a patient the
  # DataElement will be added to the DataElements array.
  addSourceDataCriteriaToPatient: (criteria) ->
    cqmPatient = @parent?.get('cqmPatient')
    cqmPatient.data_elements = [] unless cqmPatient.data_elements
    cqmPatient.data_elements.push(criteria.get('dataElement'));

  # event listener for remove SDC event. if this collection belongs to a patient the
  # DataElement will be removed from the DataElements array.
  removeSourceDataCriteriaFromPatient: (criteria) ->
    @parent?.get('cqmPatient').data_elements = @parent?.get('cqmPatient').data_elements.filter (el) -> el != criteria.get('dataElement')

  # Expect a array of DataElements to be passed in. We want to turn it into an array
  # of plain objects that will become the attributes for each SourceDataCriteria.
  parse: (dataElements, options) ->
    dataElementsAsObjects = []

    dataElements.forEach (dataElement) ->
      if !Thorax.Collections.SourceDataCriteria.SKIP_TYPES.includes(dataElement.fhir_resource?.resourceType)
        # Create data elements attribus as plain object
        # Keep TS model object in dataElement field
        dataElementAsObject = dataElement.toJSON()
        dataElementAsObject.dataElement = dataElement
        dataElementsAsObjects.push(dataElementAsObject)

    return dataElementsAsObjects

class Thorax.Collections.Codes extends Thorax.Collection
  parse: (results, options) ->
    codes = for codeSystem, codes of results
      {codeSystem, code} for code in codes
    _(codes).flatten()

  toJSON: ->
    json = {}
    for codeSystem, codes of @groupBy 'codeSystem'
      json[codeSystem] = _(codes).map (c) -> c.get('code')
    json
