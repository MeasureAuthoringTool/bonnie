class Thorax.Views.Patient extends Thorax.View
  
  template: JST['patients/patient_html']
  htmlHeader: JST['patients/patient_html_header']

  initialize: ->
    @headerView = new Thorax.Views.PatientHtmlHeader(model: @model)
    @sectionViews = []
    for es in @entrySections()
      if es != 'results' and es != 'insurance_providers'
        @sectionViews.push(new Thorax.Views.PatientHtmlSection(model: @model, section: es, idMap: @idMap)) if es? and @model.attributes[es]? and @model.attributes[es].length

  birthDate: -> @model.getBirthDate()
  payerName: -> @model.getPayerName()
  validMeasureIds: -> @model.getValidMeasureIds(@measures)
  entrySections: -> @model.getEntrySections(@sections)