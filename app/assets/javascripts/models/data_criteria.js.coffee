# Used for patient encounters. idAttribute is null, as the model itself
# isn't responsible for persisting itself, and the collection must support
# multiple criteria with the same ID.
class Thorax.Models.SourceDataCriteria extends Thorax.Model
  idAttribute: null
  dataElement: null
  initialize: ->
    @set('codes', new Thorax.Collections.Codes) unless @has 'codes'
    if !@isPeriodType() then @set('end_date', undefined)

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

  toJSON: ->
    # Transform fieldValues back to an object from a collection
    fieldValues = {}
    @get('field_values').each (fv) -> fieldValues[fv.get('key')] = _(fv.toJSON()).omit('key')
    _(super).extend(field_values: fieldValues)

  faIcon: ->
    # FIXME: Do this semantically in stylesheet
    icons =
      characteristic:           'fa-user'
      communication:            'fa-files-o'
      allergies_intolerance:    'fa-exclamation-triangle'
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
    criteriaType = @getCriteriaType()
    # in QDM 5.0, these are all things that are *not* considered 'authored' - and thus have a time interval.
    criteriaType in ['adverse_event', 'care_goal', 'device_applied', 'diagnostic_study_performed',
                     'encounter_active', 'encounter_performed', 'intervention_performed', 'laboratory_test_performed',
                     'medication_active', 'medication_ordered', 'medication_dispensed', 'medication_administered',
                     'physical_exam_performed', 'procedure_performed', 'substance_administered', 'allergy_intolerance',
                     'diagnosis', 'symptom', 'patient_characteristic_payer', 'participation']

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
    criteriaType = @get('definition')
    if @get('status')?
      criteriaType = "#{criteriaType}_#{@get('status')}"
    else if @get('sub_category')?
      criteriaType = "#{criteriaType}_#{@get('sub_category')}"
    criteriaType

  @PRIMARY_TIMING_ATTRIBUTES = ['relevantPeriod', 'prevalencePeriod', 'participationPeriod', 'authorDatetime']
  # Use the mongoose schema to look at the fields for this element
  getPrimaryTimingAttribute: ->
    schema = @get('qdmDataElement').schema
    if schema.path('relevantPeriod')?
      'relevantPeriod'
    else if schema.path('prevalencePeriod')?
      'prevalencePeriod'
    else if schema.path('participationPeriod')? 
      'participationPeriod'
    else
      undefined

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

  # TODO: Complete this or find a more appropiate location for this
  @ATTRIBUTE_TITLE_MAP:
    'relevantPeriod': 'Relevant Period'
    'prevalencePeriod': 'Prevalence Period'
    'participationPeriod': 'Participation Period'
    'authorDatetime': 'Author DateTime'

  getAttributeType: (attributeName) ->
    attrInfo = @get('qdmDataElement').schema.path(attributeName)
    return attrInfo.instance

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
                  "QDM::PatientCharacteristicPayer",
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
