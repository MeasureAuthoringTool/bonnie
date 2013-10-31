class Thorax.Views.Measure extends Thorax.View
  
  template: JST['measure']
  
  initialize: ->
    # FIXME: Put the measure calculation view directly in the main measure view for now
    @measureCalculation = new Thorax.Views.MeasureCalculation(model: @model, patients: @patients)
    @updateMeasureView = new Thorax.Views.ImportMeasure()
    # create a view for the measure logic passing in population 0
    # the selected submeasure will need to be passed in rather than a hardcoded 0
    @logicView = new Thorax.Views.MeasureLogic(model: @model, allPopulationCodes:@allPopulationCodes, populationIndex: 0)

  events:
    'click #updateMeasureTrigger': 'updateMeasure'

  updateMeasure: (event) ->
    @updateMeasureView.$('.modal-title').text('Reimport Measure')
    @updateMeasureView.display()
    event.preventDefault()