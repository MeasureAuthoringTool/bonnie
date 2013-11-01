class Thorax.Views.Measure extends Thorax.View
  
  template: JST['measure']
  
  initialize: ->
    # FIXME: display calculation and logic for first population only for now, eventually we'll want them selectable
    @measureCalculation = new Thorax.Views.MeasureCalculation(model: @model, patients: @patients, populationIndex: 0)
    @logicView = new Thorax.Views.MeasureLogic(model: @model, allPopulationCodes: @allPopulationCodes, populationIndex: 0)
    @updateMeasureView = new Thorax.Views.ImportMeasure()

  events:
    'click #updateMeasureTrigger': 'updateMeasure'

  updateMeasure: (event) ->
    @updateMeasureView.$('.modal-title').text('Reimport Measure')
    @updateMeasureView.display()
    event.preventDefault()