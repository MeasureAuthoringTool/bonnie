class Thorax.Models.MeasureDataCriteria extends Thorax.Model
  toPatientDataCriteria: ->
    # FIXME: Temporary approach
    new Thorax.Models.PatientDataCriteria
      id: @get('source_data_criteria')
      oid: @get('code_list_id')
      negation: @get('negation')
      definition: @get('definition')
      status: @get('status')
      title: @get('title')
      start_date: new Date().getTime()
      end_date: new Date().getTime()

class Thorax.Collections.MeasureDataCriteria extends Thorax.Collection
  model: Thorax.Models.MeasureDataCriteria

# Used for patient encounters. idAttribute is null, as the model itself
# isn't responsible for persisting itself, and the collection must support
# multiple criteria with the same ID.
class Thorax.Models.PatientDataCriteria extends Thorax.Model
  idAttribute: null
  parse: (attrs) ->
    attrs.value = new Thorax.Collection(attrs.value)
    attrs

class Thorax.Collections.PatientDataCriteria extends Thorax.Collection
  model: Thorax.Models.PatientDataCriteria
