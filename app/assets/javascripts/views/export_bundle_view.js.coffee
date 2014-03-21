class Thorax.Views.ExportBundleView extends Thorax.Views.BonnieView
  template: JST['users/export_bundle']
  exporting: -> @$("#exportBundleDialog").modal backdrop: 'static'
  success: -> @$("#exportBundleDialog").modal 'hide'
  fail: ->
    @$("#exportBundleDialog").modal 'hide'
    @$("#exportFailedDialog").modal backdrop: 'static'
