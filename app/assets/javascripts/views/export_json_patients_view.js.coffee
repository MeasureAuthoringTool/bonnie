class Thorax.Views.ExportJsonPatientsView extends Thorax.Views.BonnieView
  template: JST['measure/export_json_patients']

  export: -> @$("#exportJsonPatientsDialog").modal backdrop: 'static'

  success: ->
    @$("#exportJsonPatientsDialog").modal 'hide'
    @$("#exportJsonSucceededDialog").modal backdrop: 'static'

  fail: ->
    @$("#exportJsonPatientsDialog").modal 'hide'
    @$("#exportJsonFailedDialog").modal backdrop: 'static'

  close: -> ''
