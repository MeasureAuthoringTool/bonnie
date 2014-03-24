class Thorax.Views.ExportPatientsView extends Thorax.Views.BonnieView
  template: JST['measure/export_patients']
  exporting: -> @$("#exportPatientsDialog").modal backdrop: 'static'
  success: -> @$("#exportPatientsDialog").modal 'hide'
  fail: ->
    @$("#exportPatientsDialog").modal 'hide'
    @$("#exportFailedDialog").modal backdrop: 'static'
