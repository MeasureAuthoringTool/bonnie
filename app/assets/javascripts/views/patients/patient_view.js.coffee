# FIXME deprecated; remove soon.
class Thorax.Views.Patient extends Thorax.View
  template: JST['patients/record']
  initialize: ->
    @headerView = new Thorax.Views.RecordHeader(model: @model)
    @sectionViews = []
    for es in @entrySections()
      if es != 'results' and es != 'insurance_providers'
        @sectionViews.push(new Thorax.Views.RecordSection(model: @model, section: es)) if es? and @model.get(es)? and @model.get(es).length
    if @model.get('measure_id')? and @measures.get(@model.get('measure_id'))? then @expectedValuesView = new Thorax.Views.ExpectedValuesView
      model: @model
      measure: @measures.get(@model.get('measure_id'))
      edit: false
      values: _.extend({}, @model.get('expected_values'))
  birthDate: -> @model.getBirthDate()
  payerName: -> @model.getPayerName()
  validMeasureIds: -> @model.getValidMeasureIds(@measures)
  entrySections: -> @model.getEntrySections()
  shouldDisplayValues: ->
    if @model.get('measure_id')? and @measures.get(@model.get('measure_id'))? then true else false
