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
      @$("input[type=radio]:checked").next().css("color","white")
    'ready': 'setup'
    'change input:file':  'enableLoad'
    'keyup input:text': 'enableLoadVsac'
    'keyup input:password': 'enableLoadVsac'
    'change input:text': 'enableLoadVsac'
    'change input:password': 'enableLoadVsac'
    'change input[type=radio]': ->
      @$('input[type=radio]').each (index, element) =>
        if @$(element).prop("checked")
          @$(element).next().css("color","white")
        else
          @$(element).next().css("color","")
    'change input[name="include_draft"]': 'toggleDraft'
    'click #clearVSACCreds': 'clearCachedVSACTicket'

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

  clearCachedVSACTicket: ->
    @$('#vsacSignIn').removeClass('hidden')
    @$('#vsacSignInDraft').removeClass('hidden')
    @$('#vsacCachedMsg').addClass('hidden')
    @$('#loadButton').prop('disabled', true)
    $.post '/measures/vsac_auth_expire'

  toggleVSAC: ->
    $.ajax
      url: '/measures/vsac_auth_valid'
      success: (data, textStatus, jqXHR) ->
        if data? && data.valid
          $('#vsacSignIn').addClass('hidden')
          $('#vsacSignInDraft').removeClass('hidden')
          $('#vsacCachedMsg').removeClass('hidden')
          $('#loadButton').prop('disabled', false)
          # If the measure import window is open long enough for the VSAC
          # credentials to expire, we need to reshow the username and
          # password dialog.
          setTimeout ->
            @clearCachedVSACTicket()
          , new Date(data.expires) - new Date()
        else
          $('#vsacSignIn').removeClass('hidden')
          $('#vsacSignInDraft').removeClass('hidden')
          $('#vsacCachedMsg').addClass('hidden')

  enableLoad: ->
    @toggleVSAC()

  toggleDraft: ->
    isDraft = @$('#value_sets_draft').is(':checked')

  setup: ->
    @importDialog = @$("#importMeasureDialog")
    @importWait = @$("#pleaseWaitDialog")
    @finalizeDialog = @$("#finalizeMeasureDialog")

  display: ->
    @importDialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true)
    @$('.nice_input').bootstrapFileInput()

  submit: ->
    @importWait.modal(
      "backdrop" : "static",
      "keyboard" : false,
      "show" : true)
    @importDialog.modal('hide')
    @$('form').submit()

  # FIXME: Is anything additional required for cleaning up this view on close?
  close: -> ''
