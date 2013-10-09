class Thorax.Views.Matrix extends Thorax.View
  template: JST['matrix']
  context: ->
    measureIds: @measures.map (m) -> m.id
