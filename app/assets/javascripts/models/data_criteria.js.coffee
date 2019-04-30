# class Thorax.Models.MeasureDataCriteria extends Thorax.Model
#   @satisfiesDefinitions: ['satisfies_all', 'satisfies_any']

#   toPatientDataCriteria: ->
#     # FIXME: Temporary approach
#     attr = _(@pick('negation', 'definition', 'status', 'title', 'description', 'code_list_id', 'type')).extend
#              id: @get('source_data_criteria')
#              start_date: @getDefaultTime()
#              end_date: @getDefaultTime() + (15 * 60 * 1000) # Default 15 minute duration
#              value: new Thorax.Collection()
#              references: new Thorax.Collection()
#              field_values: new Thorax.Collection()
#              hqmf_set_id: @collection.parent.get('hqmf_set_id')
#              cms_id: @collection.parent.get('cms_id')
#              criteria_id: @get("criteria_id") || Thorax.Models.MeasureDataCriteria.generateCriteriaId()
#     new Thorax.Models.PatientDataCriteria attr

#   getDefaultTime: ->
#     time = moment.utc().set({'year': bonnie.measurePeriod, 'hour': 8, 'minute': 0, 'second': 0})
#     parseInt(time.format('X')) * 1000

# Thorax.Models.MeasureDataCriteria.generateCriteriaId = ->
#     chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#     today = new Date()
#     result = today.valueOf().toString 16
#     result += chars.substr Math.floor(Math.random() * chars.length), 1
#     result += chars.substr Math.floor(Math.random() * chars.length), 1
#     result

# class Thorax.Collections.MeasureDataCriteria extends Thorax.Collection
#   model: Thorax.Models.MeasureDataCriteria
#   initialize: (models, options) -> @parent = options?.parent

# Used for patient encounters. idAttribute is null, as the model itself
# isn't responsible for persisting itself, and the collection must support
# multiple criteria with the same ID.
class Thorax.Models.PatientDataCriteria extends Thorax.Model
  idAttribute: null
  dataElement: null
  initialize: ->
    @set('codes', new Thorax.Collections.Codes) unless @has 'codes'
    if !@isPeriodType() then @set('end_date', undefined)

  parse: (attrs) ->
    fieldValueBlacklist = ['_id', 'relevantPeriod', 'dataElementCodes', 'description', 'hqmfOid', 'id', 'prevalencePeriod', 'qdmCategory', 'qdmVersion', 'qrdaOid', '_type', 'criteria_id', 'value', 'qdmStatus', 'negationRationale']
    fieldValuesOnDataElement = _.difference(Object.keys(attrs), fieldValueBlacklist)
    attrs.criteria_id ||= Thorax.Models.PatientDataCriteria.generateCriteriaId()
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
  valueSet: -> _(bonnie.measures.valueSets()).detect (vs) => vs.get('oid') is @get('code_list_id')
  toJSON: ->
    # Transform fieldValues back to an object from a collection
    fieldValues = {}
    @get('field_values').each (fv) -> fieldValues[fv.get('key')] = _(fv.toJSON()).omit('key')
    _(super).extend(field_values: fieldValues)

  faIcon: ->
    # FIXME: Do this semantically in stylesheet
    icons =
      characteristic:            'fa-user'
      communications:            'fa-files-o'
      allergies_intolerances:    'fa-exclamation-triangle'
      adverse_events:            'fa-exclamation'
      conditions:                'fa-stethoscope'
      devices:                   'fa-medkit'
      diagnostic_studies:        'fa-stethoscope'
      encounters:                'fa-user-md'
      functional_statuses:       'fa-stethoscope'
      interventions:             'fa-comments'
      laboratory_tests:          'fa-flask'
      medications:               'fa-medkit'
      physical_exams:            'fa-user-md'
      procedures:                'fa-scissors'
      risk_category_assessments: 'fa-user'
      care_goals:                'fa-sliders'
      assessments:               'fa-eye'
      care_experiences:          'fa-heartbeat'
      family_history:            'fa-sitemap'
      immunizations:             'fa-medkit'
      participations:            'fa-shield'
      preferences:               'fa-comment'
      provider_characteristics:  'fa-user-md'
      substances:                'fa-medkit'
      symptoms:                  'fa-bug'
      system_characteristics:    'fa-tachometer'
      transfers:                 'fa-random'
    icons[@get('type')] || 'fa-question'
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

Thorax.Models.PatientDataCriteria.getTimingInterval = (criteria) ->
  if criteria.attributes.hasOwnProperty('relevantPeriod')
    'relevantPeriod'
  else if criteria.attributes.hasOwnProperty('prevalencePeriod')
    'prevalencePeriod'
  else if criteria.attributes.hasOwnProperty('participationPeriod')
    'participationPeriod'
  else
    undefined

Thorax.Models.PatientDataCriteria.generateCriteriaId = ->
    chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    today = new Date()
    result = today.valueOf().toString 16
    result += chars.substr Math.floor(Math.random() * chars.length), 1
    result += chars.substr Math.floor(Math.random() * chars.length), 1
    result

class Thorax.Collections.PatientDataCriteria extends Thorax.Collection
  model: Thorax.Models.PatientDataCriteria
  initialize: (models, options) -> @parent = options?.parent
  # FIXME sortable: commenting out due to odd bug in droppable
  # comparator: (m) -> [m.get('start_date'), m.get('end_date')]

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
