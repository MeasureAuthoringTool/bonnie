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
<<<<<<< HEAD
=======
      value: new Thorax.Collection()
      field_values: new Thorax.Collection()
>>>>>>> develop

class Thorax.Collections.MeasureDataCriteria extends Thorax.Collection
  model: Thorax.Models.MeasureDataCriteria

# Used for patient encounters. idAttribute is null, as the model itself
# isn't responsible for persisting itself, and the collection must support
# multiple criteria with the same ID.
class Thorax.Models.PatientDataCriteria extends Thorax.Model
  idAttribute: null
  parse: (attrs) ->
    attrs.value = new Thorax.Collection(attrs.value)
    # Transform fieldValues object to collection, one element per key/value, with key as additional attribute
    fieldValues = new Thorax.Collection()
    for key, value of attrs.field_values
      fieldValues.add _(value).extend(id: key)
    attrs.field_values = fieldValues
    attrs
  toJSON: ->
    # Transform fieldValues back to an object from a collection
    fieldValues = {}
    @get('field_values').each (fv) -> fieldValues[fv.id] = _(fv.toJSON()).omit('id')
    _(super).extend(field_values: fieldValues)

class Thorax.Collections.PatientDataCriteria extends Thorax.Collection
  model: Thorax.Models.PatientDataCriteria
