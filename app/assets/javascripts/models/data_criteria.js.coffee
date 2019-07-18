# Used for patient encounters. idAttribute is null, as the model itself
# isn't responsible for persisting itself, and the collection must support
# multiple criteria with the same ID.
class Thorax.Models.SourceDataCriteria extends Thorax.Model
  idAttribute: null
  dataElement: null
  initialize: ->
    @set('codes', new Thorax.Collections.Codes) unless @has 'codes'
    if !@isPeriodType() then @set('end_date', undefined)
    @set('negation', @get('qdmDataElement').negationRationale?)

  clone: ->
    # Clone the QDM::DataElement
    dataElementType = @get('qdmDataElement')._type.replace(/QDM::/, '')
    clonedDataElement = new cqm.models[dataElementType](mongoose.utils.clone(@get('qdmDataElement')))

    # build the initial attributes object similar to how it is done in the collection parse.
    dataElementAsObject = clonedDataElement.toObject()
    dataElementAsObject.description = @get('description')
    dataElementAsObject.qdmDataElement = clonedDataElement

    # make and return the new SDC
    return new Thorax.Models.SourceDataCriteria(dataElementAsObject)

  measure: -> bonnie.measures.findWhere hqmf_set_id: @get('hqmf_set_id')

  valueSet: -> _(@measure().get('cqmValueSets')).find (vs) => vs.oid is @get('codeListId')

  faIcon: ->
    # FIXME: Do this semantically in stylesheet
    icons =
      patient_characteristic:   'fa-user'
      communication:            'fa-files-o'
      allergy:                  'fa-exclamation-triangle'
      adverse_event:            'fa-exclamation'
      condition:                'fa-stethoscope'
      device:                   'fa-medkit'
      diagnostic_study:         'fa-stethoscope'
      encounter:                'fa-user-md'
      functional_status:        'fa-stethoscope'
      intervention:             'fa-comments'
      laboratory_test:          'fa-flask'
      medication:               'fa-medkit'
      physical_exam:            'fa-user-md'
      procedure:                'fa-scissors'
      risk_category_assessment: 'fa-user'
      care_goal:                'fa-sliders'
      assessment:               'fa-eye'
      care_experience:          'fa-heartbeat'
      family_history:           'fa-sitemap'
      immunization:             'fa-medkit'
      participation:            'fa-shield'
      preference:               'fa-comment'
      provider_characteristic:  'fa-user-md'
      substance:                'fa-medkit'
      symptom:                  'fa-bug'
      system_characteristic:    'fa-tachometer'
      transfer:                 'fa-random'
    icons[@get('qdmCategory')] || 'fa-question'

  canHaveNegation: ->
    @get('qdmDataElement').schema.path('negationRationale')?

  # determines if a data criteria has a time period associated with it: it potentially has both
  # a start and end date.
  isPeriodType: ->
    @getPrimaryTimingAttribute() != 'authorDatetime'

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
    criteriaType = @get('qdmDataElement').qdmCategory
    if @get('qdmDataElement').qdmStatus?
      criteriaType = "#{criteriaType}_#{@get('qdmDataElement').qdmStatus}"
    criteriaType

  @PRIMARY_TIMING_ATTRIBUTES = ['relevantPeriod', 'relevantDatetime', 'prevalencePeriod', 'participationPeriod', 'authorDatetime']

  # the attributes to skip in user attribute view and editing fields
  @SKIP_ATTRIBUTES = ['dataElementCodes', 'codeListId', 'description', 'id', '_id', 'qrdaOid', 'qdmTitle', 'hqmfOid', 'qdmCategory', 'qdmVersion', 'qdmStatus', 'negationRationale', '_type']
    .concat(@PRIMARY_TIMING_ATTRIBUTES)

  # Use the mongoose schema to look at the fields for this element
  getPrimaryTimingAttribute: ->
    return @getPrimaryTimingAttributes()[0].name

  # Gets a list of the names, titles and types of the primary timing attributes for this SDC.
  getPrimaryTimingAttributes: ->
    primaryTimingAttributes = []
    for timingAttr in Thorax.Models.SourceDataCriteria.PRIMARY_TIMING_ATTRIBUTES
      if @get('qdmDataElement').schema.path(timingAttr)?
        primaryTimingAttributes.push(
          name: timingAttr
          title: Thorax.Models.SourceDataCriteria.ATTRIBUTE_TITLE_MAP[timingAttr]
          type: @getAttributeType(timingAttr)
        )
    return primaryTimingAttributes

  # Mapping of attribute name to human friendly titles. This is globally acessible and used by view classes for labels.
  @ATTRIBUTE_TITLE_MAP:
    'relevantPeriod': 'Relevant Period'
    'relevantDatetime': 'Relevant DateTime'
    'prevalencePeriod': 'Prevalence Period'
    'participationPeriod': 'Participation Period'
    'authorDatetime': 'Author DateTime'
    'locationPeriod': 'Location Period'
    'activeDatetime': 'Active DateTime'
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

  getAttributeType: (attributeName) ->
    attrInfo = @get('qdmDataElement').schema.path(attributeName)
    return attrInfo.instance

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
  # List of QDM types to exclude from SourceDataCriteria collection because they are managed by the header of the patient builder.
  @SKIP_TYPES = [ "QDM::PatientCharacteristicSex",
                  "QDM::PatientCharacteristicBirthdate",
                  "QDM::PatientCharacteristicRace",
                  "QDM::PatientCharacteristicEthnicity",
                  "QDM::PatientCharacteristicExpired"
                ]

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
  # QDM::DataElement will be added to the DataElements array.
  addSourceDataCriteriaToPatient: (criteria) ->
    @parent?.get('cqmPatient').qdmPatient.dataElements.push(criteria.get('qdmDataElement'));

  # event listener for remove SDC event. if this collection belongs to a patient the
  # QDM::DataElement will be removed from the DataElements array.
  removeSourceDataCriteriaFromPatient: (criteria) ->
    @parent?.get('cqmPatient').qdmPatient.dataElements.remove(criteria.get('qdmDataElement'));

  # Expect a array of QDM::DataElements to be passed in. We want to turn it into an array
  # of plain objects that will become the attributes for each SourceDataCriteria.
  parse: (dataElements, options) ->
    dataElementsAsObjects = []

    # TODO: Replace quick and dirty option
    dataElements.forEach (dataElement) ->
      if !Thorax.Collections.SourceDataCriteria.SKIP_TYPES.includes(dataElement._type)
        dataElementAsObject = dataElement.toObject()
        dataElementAsObject.qdmDataElement = dataElement
        dataElementsAsObjects.push(dataElementAsObject)

    return dataElementsAsObjects

class Thorax.Collections.Codes extends Thorax.Collection
  parse: (results, options) ->
    codes = for codeset, codes of results
      {codeset, code} for code in codes
    _(codes).flatten()

  toJSON: ->
    json = {}
    for codeset, codes of @groupBy 'codeset'
      json[codeset] = _(codes).map (c) -> c.get('code')
    json
