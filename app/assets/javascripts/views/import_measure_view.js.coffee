class Thorax.Views.ImportMeasure extends Thorax.Views.BonnieView
  template: JST['import/import_measure']

  initialize: ->
    @programReleaseNamesCache = {}

  context: ->
    hqmfSetId = @model.get('cqmMeasure').hqmf_set_id if @model?
    calculationTypeLabel = if @model?
      if (@model.get('cqmMeasure').calculation_method == 'EPISODE_OF_CARE') is false and @model.get('cqmMeasure').measure_scoring is 'PROPORTION' then 'Patient Based'
      else if (@model.get('cqmMeasure').calculation_method == 'EPISODE_OF_CARE') is true then 'Episode of Care'
      else if @model.get('cqmMeasure').measure_scoring is 'CONTINUOUS_VARIABLE' then 'Continuous Variable'
    calcSDEs = @model.get('cqmMeasure').calculate_sdes if @model?
    currentRoute = Backbone.history.fragment
    _(super).extend
      titleSize: 3
      dataSize: 9
      token: $("meta[name='csrf-token']").attr('content')
      dialogTitle: if @model? then @model.get('cqmMeasure').title else "New Measure"
      isUpdate: @model?
      showLoadInformation: !@model? && @firstMeasure
      calculationTypeLabel: calculationTypeLabel
      calcSDEs: calcSDEs
      hqmfSetId: hqmfSetId
      redirectRoute: currentRoute
      defaultProgram: Thorax.Views.ImportMeasure.defaultProgram

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
    'keyup input:password': 'enableLoadVsac'
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
    vsacApiKey = @$('#vsacApiKey')
    if (vsacApiKey.val().length > 0)
      vsacApiKey.closest('.form-group').removeClass('has-error')
      hasUser = true
    @$('#loadButton').prop('disabled', !hasUser)

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
    # only do this is if we dont have the programNames list
    if !@programNames?
      programSelect = @$('#vsac-query-program').prop('disabled', true)
      releaseSelect = @$('#vsac-query-release').prop('disabled', true)
      @populateSelectBox programSelect, ['Loading...']
      @populateSelectBox releaseSelect, ['Loading...']
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
    releaseSelect = @$('#vsac-query-release')
    programSelect = @$('#vsac-query-program')

    if @programReleaseNamesCache[program]?
      @populateSelectBox releaseSelect, @programReleaseNamesCache[program]
      @trigger 'vsac:release-list-updated'
    else
      # Disable both dropdowns and put "Loading..."" in place.
      programSelect.prop('disabled', true)
      releaseSelect.prop('disabled', true)
      @populateSelectBox releaseSelect, ['Loading...']

      # begin request
      $.getJSON("/vsac_util/program_release_names/#{program}")
        .done (data) =>
          @programReleaseNamesCache[program] = data.releaseNames
          @populateSelectBox releaseSelect, @programReleaseNamesCache[program], Thorax.Views.ImportMeasure.defaultRelease
          releaseSelect.prop('disabled', false)
          programSelect.prop('disabled', false)
          @trigger 'vsac:release-list-updated'
          callback() if callback
        .fail => @trigger 'vsac:param-load-error'

  ###*
  # Loads the VSAC profile names from the back end and populates the select box.
  ###
  loadProfileNames: ->
    profileSelect = @$('#vsac-query-profile').prop('disabled', true)
    @populateSelectBox profileSelect, ['Loading...']
    $.getJSON("/vsac_util/profile_names")
      .done (data) =>
        @profileNames = data.profileNames
        @latestProfile = data.latestProfile
        # Map for changing option text for the latest profile to put the profile in double angle brackets and
        # prefix the option with 'Latest eCQM'.
        optionTextMap = {}
        optionTextMap[@latestProfile] = "Latest eCQM&#x300a;#{@latestProfile}&#x300b;"
        @populateSelectBox profileSelect, @profileNames, @latestProfile, optionTextMap
        @trigger 'vsac:profiles-loaded'
        profileSelect.prop('disabled', false)
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
  # Repopulates a select box with options. Optionally setting a default option or alternate text.
  #
  # @param {jQuery Element} selectBox - The jQuery element for the select box to refill.
  # @param {Array} options - List of options.
  # @param {String} defaultOption - Optional. Default option to select if found.
  # @param {Object} optionTextMap - Optional. For any options that require text to be different than value, this
  #      parameter can be used to define different option text. ex:
  #      { "eCQM Update 2018-05-04": "Latest eCQM - eCQM Update 2018-05-04"}
  ###
  populateSelectBox: (selectBox, options, defaultOption, optionTextMap) ->
    selectBox.empty()
    for option in options
      optionText = if optionTextMap?[option]? then optionTextMap[option] else option
      if option == defaultOption
        selectBox.append("<option value=\"#{option}\" selected=\"selected\">#{optionText}</option>")
      else
        selectBox.append("<option value=\"#{option}\">#{optionText}</option>")

  ###*
  # Event handler for query type selector change. This changes out the query parameters
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
    @$('form').trigger('submit')

  # FIXME: Is anything additional required for cleaning up this view on close?
  close: -> ''
