class Thorax.Views.FinalizeMeasures extends Thorax.Views.BonnieView
  template: JST['import/finalize_measures']
  context: ->
    titleSize: 4
    dataSize: 8
    token: $("meta[name='csrf-token']").attr('content')

  events:
    'click #finalizeMeasureSubmit': 'submit'
    'ready': 'setup'
    'change select':  'enableDone'

  enableDone: ->
    selects = (@$(s).val()?.length > 0 for s in @$('select'))
    @$('#finalizeMeasureSubmit').prop('disabled', false in selects)

  setup: ->
    # if we have no measures to finalize than there's nothing to do
    if @measures.length > 0
      _.each(@measures.models, (measure) =>
        measure.get('source_data_criteria').comparator = (m) -> m.get('description')
        measure.get('source_data_criteria').sort()
      )
      @finalizeDialog = @$("#finalizeMeasureDialog")
      @pleaseWaitDialog = @$("#pleaseWaitDialog")
      @display()

  display: ->
    @$('#finalizeMeasureSubmit').prop('disabled', @$('select').length > 0)
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

