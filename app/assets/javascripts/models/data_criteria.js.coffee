# Used for patient encounters. idAttribute is null, as the model itself
# isn't responsible for persisting itself, and the collection must support
# multiple criteria with the same ID.
class Thorax.Models.SourceDataCriteria extends Thorax.Model
  idAttribute: null
  dataElement: null
  initialize: ->
    @set('codes', new Thorax.Collections.Codes) unless @has 'codes'
    if !@isPeriodType() then @set('end_date', undefined)

  parse: (attrs) ->
    fieldValueBlacklist = ['_id', 'relevantPeriod', 'dataElementCodes', 'description', 'hqmfOid', 'id', 'prevalencePeriod', 'qdmCategory', 'qdmVersion', 'qrdaOid', '_type', 'criteria_id', 'value', 'qdmStatus', 'negationRationale']
    fieldValuesOnDataElement = _.difference(Object.keys(attrs), fieldValueBlacklist)
    attrs.criteria_id ||= Thorax.Models.SourceDataCriteria.generateCriteriaId()
    attrs.value = new Thorax.Collection(attrs.value)
    # Transform fieldValues object to collection, one element per key/value, with key as additional attribute
    fieldValues = new Thorax.Collection()
    references = new Thorax.Collection()
    for fieldValueKey in fieldValuesOnDataElement
      # TODO: Add human readable version of title, need map somewhere
      fieldValue = attrs[fieldValueKey]
      if fieldValue?
        if typeof fieldValue != 'object'
          fieldValue = {fieldValueKey: fieldValue}
        fieldValue = _(fieldValue).extend(field_title: fieldValueKey)
        fieldValues.add fieldValue

    if attrs.references?
      references.add value for value in attrs.references

    attrs.field_values = fieldValues
    attrs.references = references
    if attrs.dataElementCodes
      attrs.codes = new Thorax.Collections.Codes attrs.dataElementCodes, parse: true
    attrs

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

  canHaveResult: ->
    ['result', 'resultDatetime'] in Object.keys(@attributes)

  canHaveNegation: ->
    'negationRationale' in Object.keys(@attributes)

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

Thorax.Models.SourceDataCriteria.generateCriteriaId = ->
    chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    today = new Date()
    result = today.valueOf().toString 16
    result += chars.substr Math.floor(Math.random() * chars.length), 1
    result += chars.substr Math.floor(Math.random() * chars.length), 1
    result

class Thorax.Collections.SourceDataCriteria extends Thorax.Collection
  model: Thorax.Models.SourceDataCriteria
  initialize: (models, options) -> @parent = options?.parent
  # FIXME sortable: commenting out due to odd bug in droppable
  # comparator: (m) -> [m.get('start_date'), m.get('end_date')]

  # Expect a array of QDM::DataElements to be passed in. We want to turn it into an array
  # of plain objects that will become the attributes for each SourceDataCriteria.
  parse: (dataElements, options) ->
    # TODO: Replace quick and dirty option
    dataElements.map (dataElement) ->
      dataElementAsObject = dataElement.toObject()
      dataElementAsObject.qdmDataElement = dataElement
      return dataElementAsObject

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
