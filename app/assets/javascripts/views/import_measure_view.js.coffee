class Thorax.Views.ImportMeasure extends Thorax.Views.BonnieView
  template: JST['import/import_measure']

  initialize: ->
    @programReleaseNamesCache = {}

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
      # start load of profile names
      @loadProfileNames()
      # enable tooltips
      @$('a[data-toggle="popover"]').popover({ html: true })
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
    'change input[name="vsac_query_type"]': 'changeQueryType'
    'change select[name="vsac_query_program"]': 'changeProgram'
    'click #clearVSACCreds': 'clearCachedVSACTicket'
    'vsac:param-load-error': 'showVSACError'

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
    @$('#vsac-query-settings').removeClass('hidden')
    @$('#vsacCachedMsg').addClass('hidden')
    @$('#loadButton').prop('disabled', true)
    $.post '/vsac_util/auth_expire'

  toggleVSAC: ->
    $.ajax
      url: '/vsac_util/auth_valid'
      success: (data, textStatus, jqXHR) ->
        if data? && data.valid
          $('#vsacSignIn').addClass('hidden')
          $('#vsac-query-settings').removeClass('hidden')
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
          $('#vsac-query-settings').removeClass('hidden')
          $('#vsacCachedMsg').addClass('hidden')

  enableLoad: ->
    @toggleVSAC()

  ###*
  # Loads the program list and release names for the default program and populates the program
  # and release select boxes. This is called when the user switches to releases.
  ###
  loadProgramsAndDefaultProgramReleases: ->
    # only do this is we dont have the programNames list
    if !@programNames?
      programSelect = @$('#vsac-query-program').addClass('disabled')
      @$('#vsac-query-release').addClass('disabled')
      $.getJSON('/vsac_util/program_names')
        .done (data) =>
          @programNames = data.programNames
          @populateSelectBox programSelect, @programNames, Thorax.Views.ImportMeasure.defaultProgram

          # Load the default program if it is found
          if @programNames.indexOf(Thorax.Views.ImportMeasure.defaultProgram) >= 0
            @loadProgramReleaseNames Thorax.Views.ImportMeasure.defaultProgram, => @trigger 'vsac:default-program-loaded'

          # Otherwise load the first in the list
          else
            @loadProgramReleaseNames @programNames[0], => @trigger 'vsac:default-program-loaded'
        .fail => @trigger 'vsac:param-load-error'

  ###*
  # Event handler for program change. This kicks off the change of the release names select box.
  ###
  changeProgram: ->
    @loadProgramReleaseNames(@$('#vsac-query-program').val())

  ###*
  # Loads the VSAC release names for a given profile and populates the select box.
  # This will use the cached release names if we had already loaded them for the given program.
  #
  # @param {String} program - The VSAC program to load.
  # @param {Function} callback - Optional callback for when this is complete.
  ###
  loadProgramReleaseNames: (program, callback) ->
    programSelect = @$('#vsac-query-release').empty().addClass('disabled')
    # if we already have releases for the program loaded we can just populate now
    if @programReleaseNamesCache[program]?
      @populateSelectBox programSelect, @programReleaseNamesCache[program]
      @trigger 'vsac:release-list-updated'
    else
      $.getJSON("/vsac_util/program_release_names/#{program}")
        .done (data) =>
          @programReleaseNamesCache[program] = data.releaseNames
          @populateSelectBox programSelect, @programReleaseNamesCache[program], Thorax.Views.ImportMeasure.defaultRelease
          @trigger 'vsac:release-list-updated'
          callback() if callback
        .fail => @trigger 'vsac:param-load-error'

  ###*
  # Loads the VSAC profile names from the back end and populates the select box.
  ###
  loadProfileNames: ->
    profileSelect = @$('#vsac-query-profile').addClass('disabled')
    $.getJSON("/vsac_util/profile_names")
      .done (data) =>
        @profileNames = data.profileNames
        @populateSelectBox profileSelect, @profileNames, Thorax.Views.ImportMeasure.defaultProfile
        @trigger 'vsac:profiles-loaded'
      .fail => @trigger 'vsac:param-load-error'

  ###*
  # Shows a bonnie error for VSAC parameter loading errors.
  ###
  showVSACError: ->
    bonnie.showError(
      title: "VSAC Error"
      summary: 'There was an error retrieving VSAC options.'
      body: 'Please reload Bonnie and try again.')

  ###*
  # Repopulates a select box with options. Optionally setting a default option.
  #
  # @param {jQuery Element} selectBox - The jQuery element for the select box to refill.
  # @param {Array} options - List of options.
  # @param {String} defaultOption - Optional. Default option to select if found.
  ###
  populateSelectBox: (selectBox, options, defaultOption) ->
    selectBox.empty()
    for option in options
      if option == defaultOption
        selectBox.append("<option value=\"#{option}\" selected=\"selected\">#{option}</option>")
      else
        selectBox.append("<option value=\"#{option}\">#{option}</option>")
    selectBox.removeClass('disabled')

  ###*
  # Event handler for query type selector cange. This changes out the query parameters
  # that the user sees.
  ###
  changeQueryType: ->
    queryType = @$('input[name=vsac_query_type]:checked').val();
    switch queryType
      when 'release'
        @$('#vsac-query-release-params').removeClass('hidden')
        @$('#vsac-query-profile-params').addClass('hidden')
        @loadProgramsAndDefaultProgramReleases()
      when 'profile'
        @$('#vsac-query-release-params').addClass('hidden')
        @$('#vsac-query-profile-params').removeClass('hidden')

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
