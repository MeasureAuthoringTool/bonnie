class Thorax.Views.ExportBundleView extends Thorax.Views.BonnieView
  # The export bundle button removed from the measures_view as part of BONNIE-1107
  template: JST['users/export_bundle']
  exporting: -> @$("#exportBundleDialog").modal backdrop: 'static'
  success: -> @$("#exportBundleDialog").modal 'hide'
  fail: ->
    @$("#exportBundleDialog").modal 'hide'
    @$("#exportFailedDialog").modal backdrop: 'static'
