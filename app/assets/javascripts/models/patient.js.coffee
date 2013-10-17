class Thorax.Models.Patient extends Thorax.Model
  initialize: ->
    @set 'source_data_criteria', new Thorax.Collection()

  getBirthDate: -> new Date(@attributes.birthdate)

  getPayerName: -> @attributes.insurance_providers[0].name

  getValidMeasureIds: (measures) ->
    validIds = {}
    @attributes.measure_ids.map (m) ->
      validIds[m] = {key: m, value: _.contains(measures.pluck('id'), m)}
    return validIds


class Thorax.Collections.Patients extends Thorax.Collection
  model: Thorax.Models.Patient