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
    @model.clear silent: true
    @model.set
      period: bonnie.measurePeriod
      measure: measure.toJSON()

  addPatient: (measure, patient) ->
    patient_name = if patient.get('first') then "#{patient.get('last')} #{patient.get('first')}" else "Create new patient"
    @model.clear silent: true
    @model.set
      period: bonnie.measurePeriod
      patientName: patient_name
      measure: measure.toJSON()

  addBank: (measure) ->
    @model.clear silent: true
    @model.set
      period: bonnie.measurePeriod
      bankView: true
      measure: measure.toJSON()
