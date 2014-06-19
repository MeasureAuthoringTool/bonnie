class Thorax.Views.ImportMeasure extends Thorax.Views.BonnieView
  template: JST['import/import_measure']
  context: ->
    hqmfSetId = @model.get('hqmf_set_id') if @model?
    measureTypeLabel = if @model?
      if @model.get('type') is 'eh' then 'Eligible Hospital (EH)'
      else if @model.get('type') is 'ep' then 'Eligible Professional (EP)'
    calculationTypeLabel = if @model?
      if @model.get('episode_of_care') is false and @model.get('continuous_variable') is false then 'Patient Based'
      else if @model.get('episode_of_care') is true then 'Episode of Care'
      else if @model.get('continuous_variable') is true then 'Continuous Variable'
    currentRoute = Backbone.history.fragment
    _(super).extend
      titleSize: 4
      dataSize: 8
      token: $("meta[name='csrf-token']").attr('content')
      dialogTitle: if @model? then @model.get('title') else "New Measure"
      isUpdate: @model?
      showLoadInformation: !@model? && @firstMeasure
      measureTypeLabel: measureTypeLabel
      calculationTypeLabel: calculationTypeLabel
      hqmfSetId: hqmfSetId
      redirectRoute: currentRoute

  events:
    rendered: -> 
      @$("option[value=\"#{eoc}\"]").attr('selected','selected') for eoc in @model.get('episode_ids') if @model? && @model.get('episode_of_care') && @model.get('episode_ids')?
      @$el.on 'hidden.bs.modal', -> @remove() unless $('#pleaseWaitDialog').is(':visible')
      @$('.nice_input').bootstrapFileInput()
    'ready': 'setup'
    'change input:file':  'enableLoad'
    'keypress input:text': 'enableLoadVsac'
    'keypress input:password': 'enableLoadVsac'

  enableLoadVsac: ->
    username = @$('#vsacUser')
    password = @$('#vsacPassword')
    if (username.val().length > 0) 
      username.closest('.form-group').removeClass('has-error')
      hasUser = true
    if (password.val().length > 0) 
      password.closest('.form-group').removeClass('has-error')
      hasPassword = true
    @$('#loadButton').prop('disabled', !(hasUser && hasPassword)) 

  enableLoad: ->
    if @$('input:file').val().match /xml$/i
      @$('#vsacSignIn').removeClass('hidden')
    else
      @$('#vsacSignIn').addClass('hidden')
      @$('#loadButton').prop('disabled', !@$('input:file').val().length > 0)

  setup: ->
    @importDialog = @$("#importMeasureDialog")
    @importWait = @$("#pleaseWaitDialog")
    @finalizeDialog = @$("#finalizeMeasureDialog")

  display: ->
    @importDialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true)

  submit: ->
    @importWait.modal(
      "backdrop" : "static",
      "keyboard" : false,
      "show" : true)
    @importDialog.modal('hide')
    @$('form').submit()

  # FIXME: Is anything additional required for cleaning up this view on close?
  close: -> ''
