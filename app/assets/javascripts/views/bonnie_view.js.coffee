class Thorax.Views.BonnieView extends Thorax.View
  events:
    rendered: ->
      @$('input, textarea').placeholder()
