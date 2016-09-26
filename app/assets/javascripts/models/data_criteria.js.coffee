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
    if !@hasStopTime() then @set('end_date', null)

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
      care_goals:                'fa-sliders'
      assessments:               'fa-eye'
      care_experiences:          'fa-heartbeat'
      family_history:            'fa-sitemap'
      immunizations:             'fa-medkit'
      preferences:               'fa-comment'
      provider_characteristics:  'fa-user-md'
      substances:                'fa-medkit'
      symptoms:                  'fa-bug'
      system_characteristics:    'fa-tachometer'
      transfers:                 'fa-random'
    icons[@get('type')] || 'fa-question'
  canHaveResult: ->
    criteriaType = @get('definition')
    criteriaType += "_#{@get('status')}" if @get('status')
    # We must support criteria types with results from before V4.0 of the QDM; they all end with "result" except two
    return true if criteriaType.match(/_result$/) || criteriaType == 'laboratory_test' || criteriaType == 'physical_exam'
    # This list is based on V4.0 of the QDM: http://www.healthit.gov/sites/default/files/qdm_4_0_final.pdf
    criteriaType in ['diagnostic_study_performed', 'functional_status_performed', 'intervention_performed', 'laboratory_test_performed',
                     'physical_exam_performed', 'procedure_performed', 'risk_category_assessment', 'assessment_performed']

  canHaveNegation: ->
    #We must support criteria types with "Negation Rational" for QDM 4.2 changes.
    criteriaType = @get('definition')

    #First check to see if criteriaType definition matches any of these (no need to worry about status with these) 
    return true if criteriaType in ['communication_from_patient_to_provider', 'communication_from_provider_to_patient', 
                                    'communication_from_provider_to_provider', 'risk_category_assessment', 'transfer_from', 'transfer_to']

    #If Criteria Definition exists in object
    negationList = 
      assessment:       ['performed', 'recommended']
      device:           ['applied', 'ordered', 'recommended']
      diagnostic_study: ['performed', 'ordered', 'recommended']
      encounter:        ['ordered', 'performed', 'recommended']
      function_status:  ['ordered', 'performed', 'recommended']
      immunization:     ['administered', 'ordered']
      intervention:     ['ordered', 'performed', 'recommended']
      laboratory_test:  ['ordered', 'performed', 'recommended']
      medication:       ['administered', 'discharge', 'dispensed', 'ordered']
      physical_exam:    ['ordered', 'performed', 'recommended']
      procedure:        ['ordered', 'performed', 'recommended']
      substance:        ['administered', 'ordered', 'recommended']

    return negationList[criteriaType] and @get('status') in negationList[criteriaType]

  hasStopTime: ->
    criteriaType = @get('definition')
    return !(criteriaType in ['family_history'])
    
  startLabel: ->
    if @get('definition') in ['diagnosis', 'symptom'] && !@get('status')?
      'Onset'  # If in whitelist and status is empty
    else if @get('definition') in ['family_history']
      'Recorded'
    else
      'Start'

  stopLabel: ->
    # Return the correct end label
    if @get('definition') in ['diagnosis', 'symptom'] && !@get('status')?
      'Abatement'
    else
      'Stop'


    
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
