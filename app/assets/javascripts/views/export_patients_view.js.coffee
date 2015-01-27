class Thorax.Views.ExportPatientsView extends Thorax.Views.BonnieView
  template: JST['measure/export_patients']
  exporting: -> @$("#exportPatientsDialog").modal backdrop: 'static'
  success: ->
    @$("#exportPatientsDialog").modal 'hide'
    @$("#exportSucceededDialog").modal backdrop: 'static'
  fail: ->
    @$("#exportPatientsDialog").modal 'hide'
    @$("#exportFailedDialog").modal backdrop: 'static'
  banksuccess: ->
    @$("#exportPatientsDialog").modal 'hide'
    @$("#exportBankSucceededDialog").modal backdrop: 'static'
  # FIXME: Is anything additional required for cleaning up this view on close?
  close: -> ''
