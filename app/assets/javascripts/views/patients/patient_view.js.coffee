# FIXME deprecated; remove soon.
class Thorax.Views.Patient extends Thorax.View
  template: JST['patients/record']
  initialize: ->
    @headerView = new Thorax.Views.RecordHeader(model: @model)
    @sectionViews = []
    for es in @entrySections()
      if es != 'results' and es != 'insurance_providers'
        @sectionViews.push(new Thorax.Views.RecordSection(model: @model, section: es)) if es? and @model.get(es)? and @model.get(es).length
  birthDate: -> @model.getBirthDate()
  payerName: -> @model.getPayerName()
  validMeasureIds: -> @model.getValidMeasureIds(@measures)
  entrySections: -> @model.getEntrySections()
