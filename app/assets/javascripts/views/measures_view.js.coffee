class Thorax.Views.Measures extends Thorax.View
  template: JST['measures']
  context: ->
    collapsedCount: @measures.collapsed().length
