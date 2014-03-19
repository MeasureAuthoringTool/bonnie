class Thorax.Models.MeasureDataCriteria extends Thorax.Model
  toPatientDataCriteria: ->
    # FIXME: Temporary approach
    attr = _(@pick('negation', 'definition', 'status', 'title', 'description', 'code_list_id', 'type')).extend
             id: @get('source_data_criteria')
             start_date: new Date().getTime()
             end_date: new Date().getTime()
             value: new Thorax.Collection()
             field_values: new Thorax.Collection()
             hqmf_set_id: @collection.parent.get('hqmf_set_id')
             cms_id: @collection.parent.get('cms_id')
    new Thorax.Models.PatientDataCriteria attr

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
  parse: (attrs) ->
    attrs.value = new Thorax.Collection(attrs.value)
    # Transform fieldValues object to collection, one element per key/value, with key as additional attribute
    fieldValues = new Thorax.Collection()
    for key, value of attrs.field_values
      fieldValues.add _(value).extend(key: key)
    attrs.field_values = fieldValues
    if attrs.codes
      attrs.codes = new Thorax.Collections.Codes attrs.codes, parse: true
    attrs
  measure: -> bonnie.measures.findWhere hqmf_set_id: @get('hqmf_set_id')
  valueSet: -> _(bonnie.measures.valueSets()).detect (vs) => vs.get('oid') is @get('code_list_id')
  isDuringMeasurePeriod: ->
    moment(@get('start_date')).year() is moment(@get('end_date')).year() is bonnie.measurePeriod
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
