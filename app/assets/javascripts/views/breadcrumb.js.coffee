class Thorax.Views.Breadcrumb extends Thorax.Views.BonnieView

  className: 'breadcrumb'

  tagName: 'ol'

  template: JST['breadcrumb']

  initialize: ->
    @setModel new Thorax.Model
    @appendTo('.navbar.breadcrumb-container')

  clear: -> @model.clear()

  addMeasurePeriod: ->
    @model.clear silent: true
    @model.set
      period: bonnie.measurePeriod

  addMeasure: (measure) ->
    measureHierarchy = @generateMeasureHierarchy(measure)
    @model.clear silent: true
    @model.set
      period: bonnie.measurePeriod
      measureHierarchy: (m.toJSON() for m in measureHierarchy)

  addPatient: (measure, patient) ->
    measureHierarchy = @generateMeasureHierarchy(measure)
    patient_name = if patient.get('first') then "#{patient.get('last')} #{patient.get('first')}" else "Create new patient"
    @model.clear silent: true
    @model.set
      period: bonnie.measurePeriod
      patientName: patient_name
      measureHierarchy: (m.toJSON() for m in measureHierarchy)

  addBank: (measure) ->
    measureHierarchy = @generateMeasureHierarchy(measure)
    @model.clear silent: true
    @model.set
      period: bonnie.measurePeriod
      bankView: true
      measureHierarchy: (m.toJSON() for m in measureHierarchy)

  generateMeasureHierarchy: (measure) ->
    measureHierarchy = [measure]
    if measure.get('component')
        measureHierarchy.unshift(bonnie.measures.findWhere({ hqmf_set_id: measure.get('hqmf_set_id').split('&')[0] }))
    return measureHierarchy