class Thorax.Views.Measures extends Thorax.View
  template: JST['measures']
  context: ->
    collapsedCount: @measures.collapsed().length

  initialize: ->
  	@importMeasureView = new Thorax.Views.ImportMeasure()

  events: {
   'click #importMeasureTrigger': 'importMeasure'
  }

  importMeasure: ->
    @importMeasureView.display()
    false

