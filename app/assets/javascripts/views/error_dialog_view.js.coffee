class Thorax.Views.ErrorDialog extends Thorax.Views.BonnieView
  template: JST['error_dialog']

  display: ->
    @$('#errorDialog').modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true)
