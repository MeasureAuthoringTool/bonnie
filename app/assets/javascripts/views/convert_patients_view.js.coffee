class Thorax.Views.ConvertPatientsView extends Thorax.Views.BonnieView
  template: JST['measure/convert_patients']

  converting: -> @$("#convertPatientsDialog").modal backdrop: 'static'

  success: ->
    @$("#convertPatientsDialog").modal 'hide'
    @$("#convertSucceededDialog").modal backdrop: 'static'

  fail: ->
    @$("#convertPatientsDialog").modal 'hide'
    @$("#convertFailedDialog").modal backdrop: 'static'

  close: -> ''
