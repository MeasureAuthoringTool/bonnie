class Thorax.Views.Measure extends Thorax.View
  
  template: JST['measure']
  
  initialize: ->
    # FIXME: Put the measure calculation view directly in the main measure view for now
    @measureCalculation = new Thorax.Views.MeasureCalculation(model: @model, patients: @patients)
    @updateMeasureView = new Thorax.Views.ImportMeasure()

  events:
    'click #updateMeasureTrigger': 'updateMeasure'

  updateMeasure: (event) ->
    @updateMeasureView.$('.modal-title').text('Reimport Measure')
    @updateMeasureView.display()
    event.preventDefault()