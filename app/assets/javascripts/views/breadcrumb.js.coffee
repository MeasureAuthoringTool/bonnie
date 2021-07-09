class Thorax.Views.Breadcrumb extends Thorax.Views.BonnieView

  className: 'breadcrumb'

  tagName: 'ol'

  template: JST['breadcrumb']

  initialize: ->
    @setModel new Thorax.Model
    @appendTo('.navbar.breadcrumb-container')

  clear: -> @model.clear()

  addMeasure: (measure) ->
    measureHierarchy = @generateMeasureHierarchy(measure)
    @model.clear silent: true
    @model.set
      measureHierarchy: (measure.toJSON() for measure in measureHierarchy)

  addPatient: (measure, patient) ->
    measureHierarchy = @generateMeasureHierarchy(measure)
    patient_name = if patient.getFirstName() then "#{patient.getLastName()} #{patient.getFirstName()}" else "Create new patient"
    @model.clear silent: true
    @model.set
      patientName: patient_name
      measureHierarchy: (measure.toJSON() for measure in measureHierarchy)

  generateMeasureHierarchy: (measure) ->
    measureHierarchy = [measure]
    if measure.get('cqmMeasure').component
        measureHierarchy.unshift(_.find(bonnie.measures.models, (m) -> m.get('cqmMeasure').hqmf_set_id == measure.get('cqmMeasure').hqmf_set_id.split('&')[0]))
    return measureHierarchy