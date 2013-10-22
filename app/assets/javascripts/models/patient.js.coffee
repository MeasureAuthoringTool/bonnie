class Thorax.Models.Patient extends Thorax.Model
  initialize: ->
    # FIXME: Temporary, don't check in!
    @set 'id', @get('_id')

  parse: (attrs) ->
    dataCriteria = _(attrs.source_data_criteria).reject (c) -> c.id is 'MeasurePeriod'
    attrs.source_data_criteria = new Thorax.Collections.PatientDataCriteria(dataCriteria)
    attrs

  getBirthDate: -> new Date(@attributes.birthdate)

  getPayerName: -> @attributes.insurance_providers[0].name

  getValidMeasureIds: (measures) ->
    validIds = {}
    @attributes.measure_ids.map (m) ->
      validIds[m] = {key: m, value: _.contains(measures.pluck('id'), m)}
    return validIds


class Thorax.Collections.Patients extends Thorax.Collection
  url: '/patients'
  model: Thorax.Models.Patient