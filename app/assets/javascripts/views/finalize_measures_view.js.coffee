class Thorax.Views.FinalizeMeasures extends Thorax.View
  template: JST['import/finalize_measures']
  context: ->
    titleSize: 3
    dataSize: 9
    token: $("meta[name='csrf-token']").attr('content')

  events:
    'click #finalizeMeasureSubmit': 'submit'
    'ready': 'setup'

  setup: ->
    # if we have no measures to finalize than there's nothing to do
    if @measures.length > 0
      _.each(@measures.models, (measure) =>
        measure.attributes.source_data_criteria.comparator = (m) -> m.get('description')
        measure.attributes.source_data_criteria.sort()
      )
      @finalizeDialog = @$("#finalizeMeasureDialog")
      @pleaseWaitDialog = @$("#pleaseWaitDialog")
      @display()

  display: ->
    @finalizeDialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true).find('.modal-dialog').css('width','650px')

  submit: ->
    @finalizeDialog.modal('hide')
    @pleaseWaitDialog.modal(
      "backdrop" : "static",
      "keyboard" : false,
      "show" : true)
    @$('form').submit()

