class Thorax.Views.MeasureUploadSummaryDialog extends Thorax.Views.BonnieView
  template: JST['measure_upload_summary_dialog']

  initialize: ->
    #TODO: Load measure summary using the @summaryId
    console.log(@summaryId)

  display: ->
    @$('#measureUploadSummaryDialog').modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true)
  events:
    rendered: -> 
      @$el.on 'hidden.bs.modal', -> @remove()
