class Thorax.Models.MeasureDataCriteria extends Thorax.Model
  @satisfiesDefinitions: ['satisfies_all', 'satisfies_any']

  toPatientDataCriteria: ->
    # FIXME: Temporary approach
    attr = _(@pick('negation', 'definition', 'status', 'title', 'description', 'code_list_id', 'type')).extend
             id: @get('source_data_criteria')
             start_date: @getDefaultTime()
             end_date: @getDefaultTime() + (15 * 60 * 1000) # Default 15 minute duration
             value: new Thorax.Collection()
             references: new Thorax.Collection()
             field_values: new Thorax.Collection()
             hqmf_set_id: @collection.parent.get('hqmf_set_id')
             cms_id: @collection.parent.get('cms_id')
             criteria_id: @get("criteria_id") || Thorax.Models.MeasureDataCriteria.generateCriteriaId()
    new Thorax.Models.PatientDataCriteria attr

  getDefaultTime: ->
    parseInt(moment.utc().set('year', bonnie.measurePeriod).set('hour',8).set('minute',0).set('second',0).format('X'))*1000

Thorax.Models.MeasureDataCriteria.generateCriteriaId = ->
    chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    today = new Date()
    result = today.valueOf().toString 16
    result += chars.substr Math.floor(Math.random() * chars.length), 1
    result += chars.substr Math.floor(Math.random() * chars.length), 1
    result

class Thorax.Collections.MeasureDataCriteria extends Thorax.Collection
  model: Thorax.Models.MeasureDataCriteria
  initialize: (models, options) -> @parent = options?.parent

# Used for patient encounters. idAttribute is null, as the model itself
# isn't responsible for persisting itself, and the collection must support
# multiple criteria with the same ID.
class Thorax.Models.PatientDataCriteria extends Thorax.Model
  idAttribute: null
  initialize: ->
    @set('codes', new Thorax.Collections.Codes) unless @has 'codes'
    if @get('type') == "medications" then @set('fulfillments', new Thorax.Collection()) unless @has 'fulfillments'

  parse: (attrs) ->
    attrs.criteria_id ||= Thorax.Models.MeasureDataCriteria.generateCriteriaId()
    attrs.value = new Thorax.Collection(attrs.value)
    # Transform fieldValues object to collection, one element per key/value, with key as additional attribute
    fieldValues = new Thorax.Collection()
    references = new Thorax.Collection()
    for key, value of attrs.field_values
      fieldValues.add _(value).extend(key: key)
    if attrs.references?
      references.add value for value in attrs.references

    attrs.field_values = fieldValues
    attrs.references = references
    if attrs.codes
      attrs.codes = new Thorax.Collections.Codes attrs.codes, parse: true
    if attrs.type == "medications" and attrs.fulfillments
      attrs.fulfillments = new Thorax.Collection attrs.fulfillments
    attrs
  measure: -> bonnie.measures.findWhere hqmf_set_id: @get('hqmf_set_id')
  valueSet: -> _(bonnie.measures.valueSets()).detect (vs) => vs.get('oid') is @get('code_list_id')
  isDuringMeasurePeriod: ->
    moment.utc(@get('start_date')).year() is moment.utc(@get('end_date')).year() is bonnie.measurePeriod
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
    icons[@get('type')] || 'fa-question'
  canHaveResult: ->
    criteriaType = @get('definition')
    criteriaType += "_#{@get('status')}" if @get('status')
    # We must support criteria types with results from before V4.0 of the QDM; they all end with "result" except two
    return true if criteriaType.match(/_result$/) || criteriaType == 'laboratory_test' || criteriaType == 'physical_exam'
    # This list is based on V4.0 of the QDM: http://www.healthit.gov/sites/default/files/qdm_4_0_final.pdf
    criteriaType in ['diagnostic_study_performed', 'functional_status_performed', 'intervention_performed', 'laboratory_test_performed',
                     'physical_exam_performed', 'procedure_performed', 'risk_category_assessment']

class Thorax.Collections.PatientDataCriteria extends Thorax.Collection
  model: Thorax.Models.PatientDataCriteria
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
